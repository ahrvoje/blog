# Capacitance of the unit cube from uniformly charged spherical shells.
#
#   julia -t auto shells.jl            # tables of the post
#   julia -t auto shells.jl 512        # boundary shells up to the grid n = 512
#
# Every matrix entry is the Coulomb energy of two unit-charge shells, a closed
# formula. The 48 symmetries of the cube reduce the unknowns to one per orbit.
# No package is necessary.

using LinearAlgebra, Base.Threads, Printf

# ------------------------------------------------------------ double-double numbers

# About 31 digits from two Float64. Only +, -, * and 1/sqrt(integer) are necessary.
struct DD
    hi::Float64
    lo::Float64
end
DD(x::Float64) = DD(x, 0.0)
@inline function two_sum(a::Float64, b::Float64)
    s = a + b
    v = s - a
    s, (a - (s - v)) + (b - v)
end
@inline function Base.:+(x::DD, y::DD)
    s, e = two_sum(x.hi, y.hi)
    h, l = two_sum(s, e + x.lo + y.lo)
    DD(h, l)
end
@inline Base.:-(x::DD, y::DD) = x + DD(-y.hi, -y.lo)
@inline function Base.:*(x::DD, y::DD)
    p = x.hi * y.hi
    h, l = two_sum(p, fma(x.hi, y.hi, -p) + (x.hi * y.lo + x.lo * y.hi))
    DD(h, l)
end
@inline Base.:*(x::DD, y::Float64) = x * DD(y)
Base.big(x::DD) = BigFloat(x.hi) + BigFloat(x.lo)

# 1/sqrt(k) for an integer k: one Newton step on the Float64 value, residual by fma.
@inline function invsqrt(k::Float64)
    x = 1 / sqrt(k)
    p = x * x
    q = k * p
    r = ((1 - q) - fma(k, p, -q)) - k * fma(x, x, -p)
    h, l = two_sum(x, 0.5 * x * r)
    DD(h, l)
end

# ------------------------------------------------------------ symmetry

# The 48 symmetries of the cube are the signed permutations of the coordinates.
const PERMS = ((1, 2, 3), (1, 3, 2), (2, 1, 3), (2, 3, 1), (3, 1, 2), (3, 2, 1))
const SIGNS = Tuple((a, b, c) for a in (-1, 1), b in (-1, 1), c in (-1, 1))
@inline image(c, p, s) = (s[1] * c[p[1]], s[2] * c[p[2]], s[3] * c[p[3]])
orbitsize(c) = length(Set(image(c, p, s) for p in PERMS, s in SIGNS))
@inline dist2(a, b) = (a[1] - b[1])^2 + (a[2] - b[2])^2 + (a[3] - b[3])^2

# ------------------------------------------------------------ boundary shells

# Shells in the outer layer of an n x n x n grid, radius 1/(2n). In the integer
# coordinates c = 2k - (n - 1) the Gram matrix is n M, with M = 2 on the diagonal
# and 2/|c - c'| elsewhere. One representative per orbit: 0 <= c1 <= c2 <= c3 = n - 1.
function boundary_orbits(n)
    reps = [(a, b, n - 1) for b in (n-1)%2:2:n-1 for a in (n-1)%2:2:b]
    reps, orbitsize.(reps)
end

@inline function groupsum(a, b)                      # sum of M over the 48 images of b
    acc = 0.0
    for p in PERMS, s in SIGNS
        k = dist2(a, image(b, p, s))
        acc += k == 0 ? 2.0 : 2 / sqrt(Float64(k))
    end
    acc
end
@inline function groupsum_dd(a, b)
    acc = DD(0.0)
    for p in PERMS, s in SIGNS
        k = dist2(a, image(b, p, s))
        acc += k == 0 ? DD(2.0) : invsqrt(Float64(k)) * 2.0
    end
    acc
end

# Q_n = (1/n) 1' M^-1 1. Cholesky in Float64, then refinement of the charges with
# double-double residuals. Returns the value (about 28 digits) and the shell count.
function boundary(n; refinements = 3)
    reps, w = boundary_orbits(n)
    N = length(reps)
    sw = sqrt.(Float64.(w))
    B = Matrix{Float64}(undef, N, N)                  # symmetric form of the reduced matrix
    @threads :dynamic for j in 1:N
        for i in j:N
            B[i, j] = sw[i] * sw[j] / 48 * groupsum(reps[i], reps[j])
        end
    end
    F = cholesky!(Symmetric(B, :L))
    q = fill(DD(0.0), N)                              # charge of one shell of each orbit
    r = Vector{Float64}(undef, N)
    for _ in 1:refinements
        @threads :dynamic for i in 1:N                # r = 48 (1 - A q), exact scaling
            acc = DD(0.0)
            for j in 1:N
                acc += groupsum_dd(reps[i], reps[j]) * q[j] * Float64(w[j])
            end
            d = DD(48.0) - acc
            r[i] = d.hi + d.lo
        end
        d = (F \ (sw .* r ./ 48)) ./ sw
        q .+= DD.(d)
    end
    total = DD(0.0)
    for j in 1:N
        total += q[j] * Float64(w[j])
    end
    big(total) / n, sum(w)
end

# ------------------------------------------------------------ cumulative shells

# Coulomb energy of two unit-charge shells, radii R and S, centre distance d.
function shell_energy(R, S, d)
    d <= abs(R - S) && return 1 / max(R, S)                    # one inside the other
    d < R + S && return (1 - (R + S - d)^2 / (4R * S)) / d     # partial overlap
    1 / d                                                      # apart
end

# All shells of the grids 1, 2, 4, ..., N. The length unit is 1/(2N), so that centres
# (relative to the cube centre) and radii are integers. Returns the partial sums of
# the series kappa = sum z_j^2 at the end of each level.
function cumulative(levels)
    N = 2^levels
    reps = NTuple{3,Int}[]; rad = Int[]; last = Int[]
    for l in 0:levels
        n = 2^l
        s = N ÷ n                                              # radius; centres are odd multiples
        vals = n == 1 ? (0:0) : (s:2s:N-s)
        for c in vals, b in vals, a in vals
            a <= b <= c && (push!(reps, (a, b, c)); push!(rad, s))
        end
        push!(last, length(reps))
    end
    M = length(reps)
    sw = sqrt.(Float64.(orbitsize.(reps)))
    B = Matrix{Float64}(undef, M, M)
    @threads :dynamic for j in 1:M
        for i in j:M
            acc = 0.0
            for p in PERMS, s in SIGNS
                acc += shell_energy(rad[i], rad[j], sqrt(Float64(dist2(reps[i], image(reps[j], p, s)))))
            end
            B[i, j] = sw[i] * sw[j] / 48 * acc
        end
    end
    z = cholesky!(Symmetric(B, :L)).L \ sw
    [sum(abs2, @view z[1:m]) / 2N for m in last], round.(Int, [sum(abs2, sw[1:m]) for m in last])
end

# The first terms of the series without symmetry: shells in the order of the post.
function first_terms(count)
    c = [(0.5, 0.5, 0.5)]; r = [0.5]
    for x in (0.25, 0.75), y in (0.25, 0.75), z in (0.25, 0.75)
        push!(c, (x, y, z)); push!(r, 0.25)
    end
    G = [shell_energy(r[i], r[j], sqrt(sum(abs2, c[i] .- c[j]))) for i in 1:count, j in 1:count]
    cholesky(Symmetric(G)).L \ ones(count)
end

# ------------------------------------------------------------ extrapolation

# Richardson: remove the error terms n^-p, one exponent for each column.
function richardson(values, exponents)
    R = copy(values)
    for p in exponents
        f = big(2)^big(p)
        R = [(f * R[i+1] - R[i]) / (f - 1) for i in 1:length(R)-1]
    end
    R[end]
end

# ------------------------------------------------------------ tables

function main()
    setprecision(BigFloat, 128)
    nmax = isempty(ARGS) ? 256 : parse(Int, ARGS[1])
    ref = big"0.660678154099568"                               # from patches.jl

    z = first_terms(9)
    println("First terms z_j^2 of the cumulative series:")
    println("  ", join((@sprintf("%.6f", x^2) for x in z), "  "))

    sums, counts = cumulative(6)
    println("\nCumulative shells: partial sums of the series")
    for (l, (s, c)) in enumerate(zip(sums, counts))
        @printf("  grid %3d  terms %7d  sum %.12f  error %.1e\n", 2^(l - 1), c, s, ref - s)
    end

    println("\nBoundary shells Q_n")
    ns = [2^k for k in 0:floor(Int, log2(nmax))]
    Q = BigFloat[]
    for n in ns
        t = @elapsed (v, shells) = boundary(n)
        push!(Q, v)
        @printf("  n %4d  shells %8d  Q %.20f  error %.1e  %5.1f s\n", n, shells, v, ref - v, t)
    end

    println("\nRichardson extrapolation of Q_n, exponents 1, 4/3, 5/3, 2")
    for m in 5:length(ns)
        v = richardson(Q[m-4:m], (1, 4 // 3, 5 // 3, 2))
        @printf("  n up to %4d  %.12f  difference from the reference %+.1e\n", ns[m], v, v - ref)
    end
end

main()
