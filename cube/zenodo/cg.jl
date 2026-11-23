# Capacitance of the unit cube: the patch system of patches.jl, solved without its matrix.
#
#   julia -t auto cg.jl                  # run A of the post: 27 layers, top degree 14
#   julia -t auto cg.jl 16 6 0.5 16      # layers, top degree, slope, mesh depth T
#
# patches.jl builds the matrix H of the system H C = m and factors it. H has M^2 entries
# for M unknowns: 28 GB for 59 000 unknowns, and this is the limit of that program. Here
# the conjugate gradient method solves the same system. It needs only products of H with
# a trial solution, and one product is a sum over the Gaussians of small matrix products,
#
#   G(C) = sum_t  2 (1 + exp(-t^2)) w_t A_t C A_t  +  4 w_t (A_t C s_t s_t' + s_t s_t' C A_t),
#
# with the tables A_t and s_t of patches.jl. The unknown C is a symmetric N x N matrix,
# the system is G(C) = 2 m m', and kappa = 6 m' C m. The memory is that of the tables.
#
# The steps run in Float64. The last digits come from a residual in double-double:
#   kappa >= 3 (<B, C> + <C, B - G(C)>),   B = 2 m m',
# is a lower bound for each C, and its error is the energy of the error of C.

include(joinpath(@__DIR__, "patches.jl"))                       # mesh, degrees, factors, DD

struct Tables
    N::Int
    A::Array{DD,3}                                              # A[a, c, t]
    s::Matrix{DD}                                               # s[a, t]
    w::Vector{DD}
    w1::Vector{DD}
    A64::Array{Float64,3}
    s64::Matrix{Float64}
    w64::Vector{Float64}
    w164::Vector{Float64}
    B::Matrix{Float64}                                          # the right side, 2 m m'
end

# The Gaussian sum: a smaller step and a wider range than in patches.jl, for more digits.
# The step 1/10 has the error bound 1e-21, and the measured error is far below the bound.
# The sum from exp(ulo) leaves out about exp(ulo) of each energy, and the sum to exp(uhi)
# leaves out about exp(-uhi): 5e-25 and 9e-27 here. The upper end must also be far above
# 1 / (the smallest patch), exp(2T).
function Tables(I, top, slope, T; step = 1 // 10, ulo = -56, uhi = max(60, 2T + 16))
    us = [k * step for k in ceil(Int, ulo / step):floor(Int, uhi / step)]
    A, s, off = factors(mesh(I, T), degrees(I, top, slope), us)
    c = 2 / sqrt(big(pi)) * step
    w = [DD(c * exp(big(u))) for u in us]
    w1 = [DD(c * exp(big(u)) * (1 + exp(-exp(2 * big(u))))) for u in us]
    mass = zeros(off[end])
    mass[off[1:end-1].+1] .= 2.0                                # only degree 0 has charge
    A = permutedims(A, (2, 3, 1)); s = permutedims(s, (2, 1))
    Tables(off[end], A, s, w, w1, map(x -> x.hi, A), map(x -> x.hi, s), map(x -> x.hi, w), map(x -> x.hi, w1), 2 .* mass .* mass')
end

# G(C) in Float64. Each task takes the next Gaussian and adds to its own sum, so the fast
# and the slow cores both work at their own speed. BLAS runs with one thread.
function product!(G, tb::Tables, C)
    N = tb.N; K = length(tb.w64)
    next = Threads.Atomic{Int}(1)
    tasks = map(1:nthreads()) do _
        Threads.@spawn begin
            own = zeros(N, N); X = zeros(N, N); u = zeros(N); au = zeros(N)
            while true
                t = Threads.atomic_add!(next, 1)
                t > K && break
                At = @view tb.A64[:, :, t]; st = @view tb.s64[:, t]
                LinearAlgebra.mul!(X, At, C)
                LinearAlgebra.mul!(own, X, At, 2 * tb.w164[t], 1.0)
                LinearAlgebra.mul!(u, C, st); LinearAlgebra.mul!(au, At, u)
                BLAS.ger!(4 * tb.w64[t], au, st, own); BLAS.ger!(4 * tb.w64[t], st, au, own)
            end
            own
        end
    end
    fill!(G, 0.0)
    for task in tasks
        G .+= fetch(task)
    end
    # Rounding makes A C A slightly non-symmetric. All matrices of the method must be
    # exactly symmetric: the residual in double-double reads only one triangle.
    for k in 1:N, i in 1:k-1
        G[i, k] = G[k, i] = (G[i, k] + G[k, i]) / 2
    end
    G
end

# G(C) in double-double. The threads are over the Gaussians, with no BLAS.
function product(tb::Tables, C::Matrix{DD})
    N = tb.N
    chunks = collect(Iterators.partition(eachindex(tb.w), cld(length(tb.w), nthreads())))
    parts = [zeros(DD, N, N) for _ in chunks]
    @threads :static for n in eachindex(chunks)
        part = parts[n]; X = zeros(DD, N, N); u = zeros(DD, N); au = zeros(DD, N)   # all names are used only here
        for t in chunks[n]
            At = @view tb.A[:, :, t]; st = @view tb.s[:, t]
            @inbounds for k in 1:N, i in 1:N
                acc = zero(DD)
                for j in 1:N
                    acc += At[i, j] * C[j, k]
                end
                X[i, k] = acc
            end
            @inbounds for i in 1:N
                acc = zero(DD)
                for j in 1:N
                    acc += C[i, j] * st[j]
                end
                u[i] = acc
            end
            @inbounds for i in 1:N
                acc = zero(DD)
                for j in 1:N
                    acc += At[i, j] * u[j]
                end
                au[i] = acc
            end
            @inbounds for k in 1:N, i in 1:k
                acc = zero(DD)
                for j in 1:N
                    acc += X[i, j] * At[j, k]
                end
                part[i, k] += tb.w1[t] * 2.0 * acc + tb.w[t] * 4.0 * (au[i] * st[k] + st[i] * au[k])
            end
        end
    end
    G = zeros(DD, N, N)
    for done in parts, k in 1:N, i in 1:k
        G[i, k] += done[i, k]
    end
    for k in 1:N, i in 1:k-1
        G[k, i] = G[i, k]
    end
    G
end

# The diagonal of G in an orthonormal basis of the symmetric matrices: the preconditioner.
# It is the scaling to a unit diagonal of patches.jl.
function diagonal(tb::Tables)
    N = tb.N; P = zeros(N, N)
    A = tb.A64; s = tb.s64
    @threads for j in 1:N
        @inbounds for t in eachindex(tb.w64), i in 1:N
            aii = A[i, i, t]; ajj = A[j, j, t]; aij = A[i, j, t]; si = s[i, t]; sj = s[j, t]
            P[i, j] += 2 * tb.w164[t] * (aii * ajj + aij * aij) +
                       4 * tb.w64[t] * (sj * (aii * sj + aij * si) + si * (aij * sj + ajj * si))
        end
    end
    for i in 1:N
        P[i, i] /= 2
    end
    P
end

# Conjugate gradients for G(X) = R0, from X = 0, until the residual is tol times the first one.
# Each iterate X is a trial charge with its own lower bound of kappa. One step moves X by
# alpha D and increases the bound by 3 alpha <R, Z>, a positive number (gains). The gains
# are small numbers that are known to full relative accuracy, so the sum of the gains
# after step k is the error of step k, also where it is far below the rounding of kappa.
# Do not use 3 <B, X> for the bound of a step: it is the bound only while <X, R> = 0,
# and in floating point the steps lose their orthogonality and <X, R> grows.
# The step sizes also give the Lanczos matrix of the scaled system, and its extreme
# eigenvalues give the condition number.
function conjugate_gradients(tb::Tables, P, R0; tol, maxit = 20000)
    X = zero(R0); R = copy(R0); Z = R ./ P; D = copy(Z); Q = zero(R0)
    rz = dot(R, Z); rz0 = rz
    gains = Float64[]; alphas = Float64[]; betas = Float64[]
    while length(alphas) < maxit
        product!(Q, tb, D)
        alpha = rz / dot(D, Q)
        push!(gains, 3 * alpha * rz)
        X .+= alpha .* D; R .-= alpha .* Q
        Z .= R ./ P
        rznew = dot(R, Z); beta = rznew / rz; rz = rznew
        D .= Z .+ beta .* D
        push!(alphas, alpha); push!(betas, beta)
        sqrt(rz / rz0) < tol && break
    end
    k = length(alphas)
    ev = eigvals(SymTridiagonal([1 / alphas[i] + (i > 1 ? betas[i-1] / alphas[i-1] : 0.0) for i in 1:k],
        [sqrt(betas[i]) / alphas[i] for i in 1:k-1]))
    (; X, gains, condition = ev[end] / ev[1])
end

function dotdd(X, Y)
    acc = zero(DD)
    for i in eachindex(X, Y)
        acc += X[i] * Y[i]
    end
    acc
end

function solve(I, top, slope, T; bits = 1024)
    setprecision(BigFloat, bits)
    BLAS.set_num_threads(1)                                     # the threads are over the Gaussians
    t0 = time()
    seconds = @elapsed tb = Tables(I, top, slope, T)
    N = tb.N
    @printf("layers %d, top degree %d, slope %.2f, T %d: %d edge functions, %d unknowns, %d Gaussians\n",
        I, top, slope, T, N, N * (N + 1) ÷ 2, length(tb.w))
    @printf("tables: %.0f s\n", seconds); flush(stdout)
    P = diagonal(tb)
    Bdd = DD.(tb.B)
    C = zeros(DD, N, N)
    R = copy(tb.B)                                              # the residual B - G(C), here for C = 0
    bound = big(0.0)
    gains = Float64[]
    # Two rounds. The second starts from the residual of the first in double-double,
    # so the steps in Float64 can pass the accuracy of Float64.
    for (round, tol) in enumerate((1e-13, 1e-5))
        seconds = @elapsed r = conjugate_gradients(tb, P, R; tol)
        C .+= DD.(r.X)
        append!(gains, r.gains)
        @printf("conjugate gradients %d: %d steps to %.0e, %.0f s, %.2f s for each product, condition number %.0f\n",
            round, length(r.gains), tol, seconds, seconds / length(r.gains), r.condition)
        seconds = @elapsed Rdd = Bdd .- product(tb, C)
        bound = 3 * (big(dotdd(Bdd, C)) + big(dotdd(C, Rdd)))
        R = map(x -> x.hi + x.lo, Rdd)
        @printf("residual in double-double: %.1e of the right side, %.0f s. Lower bound %.26f\n",
            sqrt(dot(R, R ./ P) / dot(tb.B, tb.B ./ P)), seconds, bound)
        flush(stdout)
    end
    # The history: the bound after step k is the last bound minus the gains of the later steps.
    errors = reverse(cumsum(reverse(gains))) .- gains           # errors[k] = sum of gains[k+1:end]
    @printf("sum of all gains %.15f, last bound %.15f\n", sum(gains), bound)
    println("  step  bound of the step      its error (the sum of the later gains)")
    for k in sort(unique(vcat([1, 2, 3, 5, 10, 20, 30, 50, 75], 100:50:length(gains)-1)))
        k < length(gains) && @printf("  %4d  %.16f  %.2e\n", k, Float64(bound - errors[k]), errors[k])
    end
    @printf("kappa >= %.26f   (total %.0f s, peak memory %.1f GB)\n", bound, time() - t0, Sys.maxrss() / 2^30)
    (; bound, gains)
end

function cg_main()
    I, top, slope, T = isempty(ARGS) ? (27, 14, 0.75, 19) :
                       (parse(Int, ARGS[1]), parse(Int, ARGS[2]), parse(Float64, ARGS[3]), parse(Int, ARGS[4]))
    bits = length(ARGS) >= 5 ? parse(Int, ARGS[5]) : 1024      # optional: bits of the integrals in one variable
    r = solve(I, top, slope, T; bits)
    if length(ARGS) >= 6                                        # optional: a file for the gain of each step
        open(io -> foreach(g -> println(io, g), r.gains), ARGS[6], "w")
    end
end

abspath(PROGRAM_FILE) == (@__FILE__) && cg_main()
