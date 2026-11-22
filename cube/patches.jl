# Capacitance of the unit cube from polynomial charge patches on the faces.
#
#   julia -t auto patches.jl               # convergence table of the post
#   julia -t auto patches.jl 20 8 0.5      # one run: layers, top degree, slope
#
# Trial charges: on each face, products of Legendre polynomials on a tensor mesh that
# is graded toward the edges. The capacitance is kappa = 6 m' H^-1 m, where H holds
# the Coulomb energies of the trial charges and m their total charges. To get H
# without 4D integrals, 1/r is written as a sum of Gaussians,
#
#   1/r = (2/sqrt(pi)) * integral exp(-t^2 r^2) dt  ~  sum_k w_k exp(-t_k^2 r^2),
#
# and a Gaussian of r is a product of Gaussians of the coordinates. Each entry of H
# is then a sum of products of 1D integrals, and these have closed forms (erf).
#
# The 1D integrals cancel strongly, so they use BigFloat. The linear algebra uses
# Float64, then double-double residuals. No package is necessary.

using LinearAlgebra, Base.Threads, Printf

# ------------------------------------------------------------ arithmetic

const LIB = Base.MPFR.libmpfr
const RN = Base.MPFR.MPFRRoundNearest
const Mode = Base.MPFR.MPFRRoundingMode
# In-place MPFR operations: the inner loops make no garbage.
@inline mul!(z, x, y) = ccall((:mpfr_mul, LIB), Int32, (Ref{BigFloat}, Ref{BigFloat}, Ref{BigFloat}, Mode), z, x, y, RN)
@inline fma!(z, x, y) = ccall((:mpfr_fma, LIB), Int32, (Ref{BigFloat}, Ref{BigFloat}, Ref{BigFloat}, Ref{BigFloat}, Mode), z, x, y, z, RN)
@inline neg!(z) = ccall((:mpfr_neg, LIB), Int32, (Ref{BigFloat}, Ref{BigFloat}, Mode), z, z, RN)
@inline zero!(z) = ccall((:mpfr_set_zero, LIB), Cvoid, (Ref{BigFloat}, Cint), z, 1)
erf(x::BigFloat) = (z = BigFloat(); ccall((:mpfr_erf, LIB), Int32, (Ref{BigFloat}, Ref{BigFloat}, Mode), z, x, RN); z)

# Double-double: about 31 digits from two Float64.
struct DD
    hi::Float64
    lo::Float64
end
DD(x::Float64) = DD(x, 0.0)
DD(x::BigFloat) = (h = Float64(x); DD(h, Float64(x - h)))
@inline function Base.:+(x::DD, y::DD)
    s = x.hi + y.hi
    v = s - x.hi
    e = ((x.hi - (s - v)) + (y.hi - v)) + (x.lo + y.lo)
    h = s + e
    DD(h, e - (h - s))
end
@inline Base.:-(x::DD, y::DD) = x + DD(-y.hi, -y.lo)
@inline function Base.:*(x::DD, y::DD)
    p = x.hi * y.hi
    e = fma(x.hi, y.hi, -p) + (x.hi * y.lo + x.lo * y.hi)
    h = p + e
    DD(h, e - (h - p))
end
@inline Base.:*(x::DD, y::Float64) = x * DD(y)
Base.zero(::Type{DD}) = DD(0.0, 0.0)
Base.big(x::DD) = BigFloat(x.hi) + BigFloat(x.lo)

# ------------------------------------------------------------ mesh

# Nodes of the half edge [0, 1/2]: x_i = tanh(i T / I) / 2, and the last node is 1/2.
# Near the edge each panel is exp(-2T/I) times the panel before it. The smallest
# panel is about exp(-2T).
function mesh(I, T)
    x = [tanh(big(i) * T / I) / 2 for i in 0:I]
    x[end] = big(1) / 2
    x
end
# Degree on half panel e (1 at the centre, I at the edge): it falls toward the edge,
# where the panels are small and carry little charge.
degrees(I, top, slope) = [clamp(round(Int, slope * (I - e)), 0, top) for e in 1:I]

# ------------------------------------------------------------ 1D integrals

# g[k] = k-fold integral from 0 to v of exp(-t^2 s^2), k = 1..K, for v >= 0.
function repeated_integrals!(g, t, v, K)
    z = t * v
    if z < 0.75
        # Power series for the two highest k, then the recurrence downward.
        vp = Vector{BigFloat}(undef, K)                         # v^k / k!
        vp[1] = v
        for k in 2:K
            vp[k] = vp[k-1] * v / k
        end
        for k in max(K - 1, 1):K
            term = vp[k]
            s = term
            n = 0
            while abs(term) > eps(BigFloat) * abs(s)
                n += 1
                term *= -z * z * ((2n - 1) * 2n) / (n * BigFloat(2n + k - 1) * (2n + k))
                s += term
            end
            g[k] = s
        end
        for k in K-1:-1:2
            g[k-1] = vp[k-1] + 2 * t * t * (k * g[k+1] - v * g[k])
        end
    else
        # erf, then the recurrence upward.
        g[1] = sqrt(big(pi)) / (2t) * erf(z)
        K >= 2 && (g[2] = v * g[1] + expm1(-z * z) / (2 * t * t))
        vp = v
        for k in 2:K-1
            g[k+1] = v / k * g[k] + (g[k-1] - vp) / (2 * t * t * k)
            vp *= v / k
        end
    end
end

# Derivatives of the Legendre polynomials at -1 and +1: P[a+1, i+1, end].
function legendre_end_derivatives(p)
    P = zeros(BigFloat, p + 1, p + 1, 2)
    for a in 0:p, i in 0:a
        v = factorial(big(a + i)) / (big(2)^i * factorial(big(i)) * factorial(big(a - i)))
        P[a+1, i+1, 2] = v
        P[a+1, i+1, 1] = iseven(a + i) ? v : -v
    end
    P
end

# The 1D basis is even: psi(x) = phi(x) + phi(-x), phi = (Legendre polynomial on one
# half panel) / (panel length). For each Gaussian t = exp(u) this returns, as DD,
#   A[t, a, c] = double integral of psi_a(x) psi_c(x') exp(-t^2 (x - x')^2)
#   s[t, a]    = integral of psi_a(y) exp(-t^2 (1/2 - y)^2)
# Integration by parts moves all derivatives to the polynomials. What remains are
# the repeated integrals g_k at the differences of the panel ends.
function factors(x, deg, us)
    I = length(x) - 1
    nodes = vcat(-reverse(x[2:end]), x)                         # the full edge, 2I panels
    h = diff(nodes)
    full = vcat(reverse(deg), deg)                              # degree of each full panel
    off = cumsum(vcat(0, deg .+ 1))                             # index offset of each half panel
    top = maximum(deg)
    K = 2top + 2
    P = legendre_end_derivatives(top)
    # D[e][a+1, i+1, end]: i-th derivative of phi_a at the ends of panel e
    D = [[P[a, i, c] * (2 / h[e])^(i - 1) / h[e] for a in 1:top+1, i in 1:top+1, c in 1:2] for e in 1:2I]
    gap(e, f) = e == f ? big(0) : (e > f ? nodes[e] - nodes[f+1] : nodes[f] - nodes[e+1])
    A = Array{DD}(undef, length(us), off[end], off[end])
    s = Array{DD}(undef, length(us), off[end])

    # a[a+1, b+1] = double integral of phi_a (panel e) phi_b (panel f) exp(-t^2 (x - x')^2)
    function pair!(a, tmp, G, t, e, f)
        foreach(zero!, a)
        gap(e, f) * t > 27 && return                            # below exp(-729)
        for ce in 1:2, cf in 1:2, i in 0:full[e], j in 0:full[f]
            k = i + j + 2
            p, q = e + ce - 1, f + cf - 1
            negative = (ce != cf) ⊻ iseven(i)
            p < q && isodd(k) && (negative = !negative)         # g_k(-v) = (-1)^k g_k(v)
            gk = G[k, max(p, q), min(p, q)]
            for aa in i:full[e]
                mul!(tmp, gk, D[e][aa+1, i+1, ce])
                negative && neg!(tmp)
                for bb in j:full[f]
                    fma!(a[aa+1, bb+1], tmp, D[f][bb+1, j+1, cf])
                end
            end
        end
    end

    function one_gaussian(it)
        t = exp(big(us[it]))
        G = Array{BigFloat}(undef, K, 2I + 1, 2I + 1)           # G[k, p, q] for nodes p >= q
        g = Vector{BigFloat}(undef, K)
        for q in 1:2I+1, p in q:2I+1
            repeated_integrals!(g, t, nodes[p] - nodes[q], K)
            G[:, p, q] .= g
        end
        a1 = [BigFloat() for _ in 1:top+1, _ in 1:top+1]
        a2 = [BigFloat() for _ in 1:top+1, _ in 1:top+1]
        tmp = BigFloat()
        for e in 1:I, f in 1:I
            pair!(a1, tmp, G, t, I + e, I + f)                  # panel f
            pair!(a2, tmp, G, t, I + e, I + 1 - f)              # its mirror image
            for aa in 0:deg[e], bb in 0:deg[f]
                mirror = iseven(bb) ? a2[aa+1, bb+1] : -a2[aa+1, bb+1]
                A[it, off[e]+aa+1, off[f]+bb+1] = DD(2 * (a1[aa+1, bb+1] + mirror))
            end
        end
        for e in 1:I, aa in 0:deg[e]
            v = BigFloat(0)
            for (panel, sign) in ((I + e, 1), (I + 1 - e, iseven(aa) ? 1 : -1)), c in 1:2, j in 0:aa
                v += sign * (c == 2 ? -1 : 1) * D[panel][aa+1, j+1, c] * G[j+1, 2I+1, panel+c-1]
            end
            s[it, off[e]+aa+1] = DD(v)
        end
    end

    # Garbage collection runs only between the batches, when no thread is in MPFR.
    # A collection that starts while threads are in MPFR can stop the program.
    for batch in Iterators.partition(eachindex(us), nthreads())
        GC.enable(false)
        try
            @threads :dynamic for it in batch
                one_gaussian(it)
            end
        finally
            GC.enable(true)
        end
        GC.gc(false)
    end
    A, s, off
end

# ------------------------------------------------------------ the capacitance

# The face density is sum C[a, b] psi_a(x) psi_b(y) with C symmetric: this has the
# 8 symmetries of the square, and the same density on all faces has the 48 of the
# cube. Unknowns: C[a, b] for a <= b. For one Gaussian, the energy of the six faces is
#   6 * { (1 + exp(-t^2)) tr(C A C A) + 4 u' A u },   u = C s,
# from the face itself, the opposite face and the four adjacent faces.
function capacitance(I, top, slope; T = 16, step = 3 // 25, ulo = -42, uhi = 44, refinements = 2)
    # t = exp(u): trapezoidal rule in u. The nodes are exact rationals: a node rounded
    # to Float64 moves the result in the 16th digit.
    us = [k * step for k in ceil(Int, ulo / step):floor(Int, uhi / step)]
    nt = length(us)
    A, s, off = factors(mesh(I, T), degrees(I, top, slope), us)
    N = off[end]
    w = [DD(2 / sqrt(big(pi)) * step * exp(big(u))) for u in us]
    w1 = [DD(2 / sqrt(big(pi)) * step * exp(big(u)) * (1 + exp(-exp(2 * big(u))))) for u in us]
    mass = zeros(N)
    mass[off[1:end-1].+1] .= 2.0                                # only degree 0 has charge

    # H in Float64, entry by entry
    pairs = [(i, j) for j in 1:N for i in 1:j]
    M = length(pairs)
    Ah = [x.hi for x in A]; sh = [x.hi for x in s]
    wh = [x.hi for x in w]; w1h = [x.hi for x in w1]
    H = Matrix{Float64}(undef, M, M)
    @threads :dynamic for q in 1:M
        k, l = pairs[q]
        for p in q:M
            i, j = pairs[p]
            acc = 0.0
            @inbounds @simd for t in 1:nt
                aik = Ah[t, i, k]; ajl = Ah[t, j, l]; ail = Ah[t, i, l]; ajk = Ah[t, j, k]
                acc += w1h[t] * (aik * ajl + ail * ajk) +
                       2 * wh[t] * (sh[t, j] * (aik * sh[t, l] + ail * sh[t, k]) +
                                    sh[t, i] * (ajk * sh[t, l] + ajl * sh[t, k]))
            end
            H[p, q] = 2 * acc * (i == j ? 0.5 : 1.0) * (k == l ? 0.5 : 1.0)
        end
    end
    m = [mass[i] * mass[j] * (i == j ? 1.0 : 2.0) for (i, j) in pairs]
    d = [1 / sqrt(H[p, p]) for p in 1:M]                        # scale to a unit diagonal
    @threads for q in 1:M
        for p in q:M
            H[p, q] *= d[p] * d[q]
        end
    end
    F = cholesky!(Symmetric(H, :L))
    z = F.L \ (d .* m)
    kappa64 = 6 * sum(abs2, z)                                  # the series of positive terms

    # Refinement: residual m - H c in double-double, from the product form above.
    c = zeros(DD, M)
    chunks = collect(Iterators.partition(1:nt, cld(nt, nthreads())))
    for _ in 1:refinements
        C = zeros(DD, N, N)
        for (p, (i, j)) in enumerate(pairs)
            C[i, j] = C[j, i] = c[p]
        end
        parts = [zeros(DD, N, N) for _ in chunks]
        @threads :static for n in eachindex(chunks)
            X = zeros(DD, N, N); u = zeros(DD, N); au = zeros(DD, N)
            mulsum(f, range) = (acc = zero(DD); for j in range; acc += f(j); end; acc)
            for t in chunks[n]
                At = @view A[t, :, :]; st = @view s[t, :]
                @inbounds for k in 1:N, i in 1:N
                    X[i, k] = mulsum(j -> At[i, j] * C[j, k], 1:N)
                end
                @inbounds for i in 1:N
                    u[i] = mulsum(j -> C[i, j] * st[j], 1:N)
                end
                @inbounds for i in 1:N
                    au[i] = mulsum(j -> At[i, j] * u[j], 1:N)
                end
                @inbounds for k in 1:N, i in 1:k                # gradient: 2 w1 A C A + 4 w (A u s' + s u' A)
                    parts[n][i, k] += w1[t] * 2.0 * mulsum(j -> X[i, j] * At[j, k], 1:N) +
                                      w[t] * 4.0 * (au[i] * st[k] + st[i] * au[k])
                end
            end
        end
        r = Vector{Float64}(undef, M)
        for (p, (i, j)) in enumerate(pairs)
            g = sum(part[i, j] for part in parts) * (i == j ? 0.5 : 1.0)
            e = DD(m[p]) - g
            r[p] = e.hi + e.lo
        end
        c .+= DD.(d .* (F \ (d .* r)))
    end
    total = zero(DD)
    for p in 1:M
        total += c[p] * m[p]
    end
    (float64 = kappa64, refined = 6 * big(total), unknowns = M)
end

function main()
    setprecision(BigFloat, 1024)
    runs = isempty(ARGS) ? [(8, 2, 0.5), (12, 4, 0.5), (16, 6, 0.5), (20, 8, 0.5), (23, 10, 0.75), (23, 12, 0.75)] :
           [(parse(Int, ARGS[1]), parse(Int, ARGS[2]), parse(Float64, ARGS[3]))]
    # optional: T and 1/step of the Gaussian sum, to test that they do not matter
    options = length(ARGS) >= 5 ? (T = parse(Int, ARGS[4]), step = 1 // parse(Int, ARGS[5])) : (;)
    println("layers  degree  slope  unknowns  kappa (Float64)        kappa (refined)             seconds")
    for (I, top, slope) in runs
        t = @elapsed r = capacitance(I, top, slope; options...)
        @printf("%6d  %6d  %5.2f  %8d  %.16f  %.22f  %7.1f\n", I, top, slope, r.unknowns, r.float64, r.refined, t)
        flush(stdout)
    end
end

abspath(PROGRAM_FILE) == (@__FILE__) && main()
