# Electrostatic capacitance of a unit cube

## A review of the mathematical constructions, computations, and provenance investigation in this conversation

**Compiled:** 22 November 2026.  
**Scope:** Retrospective review of the work already developed in this conversation. The detailed literature investigation summarized here belongs to the earlier discussion, principally 7 November 2026. This document does not extend that search or report new mathematical or numerical experiments.

## Contents

1. [Outcome and scope of the review](#1-outcome-and-scope-of-the-review)
2. [Normalization and notation](#2-normalization-and-notation)
3. [How the mathematical question evolved](#3-how-the-mathematical-question-evolved)
4. [The earlier boundary-integral iteration](#4-the-earlier-boundary-integral-iteration)
5. [The variational foundation](#5-the-variational-foundation)
6. [The cumulative family of spherical shells](#6-the-cumulative-family-of-spherical-shells)
7. [The algebraic series and its recurrences](#7-the-algebraic-series-and-its-recurrences)
8. [The first five algebraic coefficients](#8-the-first-five-algebraic-coefficients)
9. [What the convergence argument establishes](#9-what-the-convergence-argument-establishes)
10. [The boundary-only shell sequence](#10-the-boundary-only-shell-sequence)
11. [Recorded raw numerical approximations](#11-recorded-raw-numerical-approximations)
12. [Algebraic convergence acceleration](#12-algebraic-convergence-acceleration)
13. [Accuracy, validation, and the digit-per-term question](#13-accuracy-validation-and-the-digit-per-term-question)
14. [Implementation, tools, and historical artifacts](#14-implementation-tools-and-historical-artifacts)
15. [Actual provenance and the Helsing–Perfekt comparison](#15-actual-provenance-and-the-helsingperfekt-comparison)
16. [Published antecedents of the variational construction](#16-published-antecedents-of-the-variational-construction)
17. [The Serbian papers and unresolved earlier references](#17-the-serbian-papers-and-unresolved-earlier-references)
18. [The exact shell-kernel match in hydrodynamics](#18-the-exact-shell-kernel-match-in-hydrodynamics)
19. [Other relevant cube and spherical-element literature](#19-other-relevant-cube-and-spherical-element-literature)
20. [The novelty assessment and final status ledger](#20-the-novelty-assessment-and-final-status-ledger)
21. [Bibliography and access status](#21-bibliography-and-access-status)

## 1. Outcome and scope of the review

The conversation produced an explicit algebraic approximation to the cube's Newtonian capacity, a positive infinite-series representation associated with that approximation, a cheaper sequence using only shells near the boundary, and numerical acceleration of the latter sequence. It then examined whether these constructions, or their ingredients, had already appeared in the literature.

The central cumulative construction was

$$
\boxed{
\kappa
=
\lim_{N\to\infty}\mathbf 1^{\mathsf T}G_N^{-1}\mathbf 1
=
\sum_{j=0}^{\infty}z_j^2,
\qquad
G_N=L_NL_N^{\mathsf T},
\quad
z=L_N^{-1}\mathbf 1.
}
$$

Here the entries of $G_N$ are explicitly known Coulomb energies between uniform spherical-shell measures. Their centers and radii come from a specified cumulative dyadic grid inside the cube. The entries, finite matrix inverses, and individual Cholesky coefficients are algebraic numbers. The finite-dimensional identities are exact. Passage to the capacity of the whole cube rests on the energy-approximation argument developed in the conversation.

The later boundary-only construction was

$$
\boxed{
Q_n=\frac1n\mathbf 1^{\mathsf T}M_n^{-1}\mathbf 1,
\qquad
(M_n)_{kk}=2,
\qquad
(M_n)_{k\ell}=\frac1{|k-\ell|}\quad(k\ne\ell),
}
$$

where the indices run over the outer layer of cells in an $n\times n\times n$ grid. This is a different approximation sequence. In particular, it does not retain every shell used at earlier resolutions.

Using four boundary-grid values at resolutions $32,64,128,256$, the recorded Richardson–Aitken calculation gave

$$
\mathcal A_{32}=0.6606781627069044.
$$

Its recorded absolute difference from the published numerical reference was approximately $8.61\times10^{-9}$. This was a numerical validation result, not a certified error bound.

The provenance investigation found substantial prior art for the building blocks: the variational capacity principle, inverse-matrix formulas, the complete spherical-shell interaction kernel, sphere-based electrostatic discretizations, Cholesky factorization, and extrapolation. It did not locate an exact publication match for the particular cumulative dyadic ordering and its indexed $z_j$ series. That negative search result did not establish worldwide priority.

### 1.1 What “review” means here

This document organizes the existing discussion and makes its notation consistent. It does not replace missing computations with new ones. In particular:

- All numerical tables below reproduce values recorded earlier.
- The original Python source and intermediate numerical files were no longer present in the current workspace when this review was compiled. Their recorded behavior is described; they were not reconstructed and presented as recovered originals.
- The review does not supply a new table of term counts for one through six decimal places.
- Bibliographic access statements describe what was inspected during the earlier audit. They do not claim a fresh inspection on the compilation date.
- The word “derived” identifies a derivation assembled in the conversation. It does not establish scientific priority.

### 1.2 Levels of mathematical and evidential status

The following distinctions are used throughout:

| Status | Meaning in this review |
|---|---|
| Exact finite identity | An algebraic or variational identity for the explicitly defined finite matrices or trial spaces. |
| Convergence argument / proof sketch | The reasoning recorded for reaching the infinite-dimensional capacity; not a newly completed formal theorem with quantitative error estimates. |
| Numerical observation | A value, timing, or comparison obtained in the earlier implementation. |
| Literature match | A correspondence supported by inspected published equations or text, with the extent of access stated. |
| Unresolved | A claim for which the conversation did not establish the necessary result or obtain the necessary source. |

These distinctions matter because the exactness of a finite matrix formula does not, by itself, establish a fast rate of convergence, and a useful numerical extrapolation does not establish a rigorous decimal-accuracy guarantee.

## 2. Normalization and notation

### 2.1 The capacitance being calculated

Let $s$ be the physical side length of the cube. The normalized geometric constant $\kappa$ is defined by

$$
\boxed{
C_{\mathrm{SI}}=4\pi\varepsilon_0\,s\,\kappa.
}
$$

The geometric calculations use a unit cube and the Coulomb kernel $1/|x-y|$. In this convention the capacity of a sphere of radius $r$ is $r$.

The numerical benchmark used in the conversation was

$$
\kappa_{\mathrm{ref}}=0.66067815409957,
$$

from Helsing and Perfekt, Table 1. Their stated relative error was an estimate of order $10^{-13}$. The number was used as a high-accuracy numerical reference, not as an exact value or a certified enclosing interval. [HP13]

Two coordinate conventions appeared:

$$
K=[0,1]^3
$$

for the shell construction, and

$$
K_{\mathrm c}=[-\tfrac12,\tfrac12]^3
$$

for the earlier integral iteration, whose potential was evaluated at the origin. These are translations of the same conductor.

### 2.2 Notation used consistently in this review

| Symbol | Meaning |
|---|---|
| $\kappa$ | Normalized capacity of a unit cube. |
| $\mu$ | Equilibrium charge measure normalized to potential $1$; total charge $\mu(K)=\kappa$. |
| $p_m$ | Unit-total-charge surface density in the earlier integral iteration. |
| $\sigma_j$ | A uniform spherical-shell measure of total mass $1$. |
| $G_N$ | Coulomb-energy Gram matrix of the first $N$ shells in the cumulative hierarchy. |
| $L_N$ | Lower-triangular Cholesky factor of $G_N$. |
| $z_j$ | Coefficient of $L^{-1}\mathbf1$, indexed here from $j=0$. |
| $\kappa_N$ | Cumulative approximation $\mathbf1^{\mathsf T}G_N^{-1}\mathbf1=\sum_{j=0}^{N-1}z_j^2$. |
| $n$ | Number of cells along one edge at a specified resolution. |
| $P_n$ | Editorial shorthand in this review for the cumulative approximation after all dyadic levels through finest grid $n$ have been included. |
| $\Pi_N$ | Energy-orthogonal projection onto the first $N$ trial measures. |
| $I_n$ | Indices of the outer layer of grid cells. |
| $M_n$, $Q_n$ | Dimensionless matrix and approximation for the boundary-only construction. |
| $\mathcal A_n$ | Richardson–Aitken value based on grids $n,2n,4n,8n$. |

The notation $P_n$ is only a convenient label for an existing sequence, introduced here to keep it distinct from $Q_n$.

The early first-five-coefficient calculation used $z_0,\ldots,z_4$. Some later descriptions used one-based indexing. This review uses zero-based indexing throughout:

$$
\kappa_N=\sum_{j=0}^{N-1}z_j^2.
$$

Neither $n$ nor a resolution-doubling step is the same thing as one scalar term of that sum.

## 3. How the mathematical question evolved

The initial request allowed several forms of answer: a closed one-dimensional integral, a special function, an infinite series, a continued fraction, or a recursive analytic expression for the unit cube's capacitance. Subsequent requests successively tightened the desired form and computational behavior.

| Stage | Request | Result retained in the conversation |
|---|---|---|
| Analytic representation | An expression for cube capacitance, preferably compact. | A layer-potential iteration and subsequently an explicit algebraic construction. |
| Elimination of integrals | An infinite series or recurrence with no integral evaluation. | Spherical-shell Gram matrices with closed algebraic entries and a Cholesky recurrence. |
| Explicit initial coefficients | Algebraic formulas for the first five $z_j$. | The radicals reproduced in Section 8. |
| Accuracy versus work | Number of terms for one through six decimal places. | Slow raw convergence became evident; no complete preserved, certified term-count table resulted. |
| Practical acceleration | Algebraic acceleration of the slow sequence. | Generalized Richardson extrapolation and a Richardson–Aitken combination. |
| Rapid convergence | Approximately one decimal digit per term. | Useful accelerated numerical results, but no proved cheap scalar series with that rate. |
| Verification of the screenshot | Check the boundary-shell matrix and acceleration prescription. | The finite matrix formula and Aitken algebra were confirmed, with qualifications on convergence rates and error bounds. |
| Provenance | Relation to Helsing–Perfekt and possible Serbian predecessors. | A detailed comparison distinguishing exact matches, method-level antecedents, and unread sources. |
| Novelty | Search deeply enough to assess whether the exact series was new. | No exact match located, but established ingredients and unresolved sources prevented a justified novelty claim. |

The final result therefore needs several descriptions at once: an exact algebraic limiting representation; a variational approximation method; a numerical acceleration experiment; and an unresolved priority question. Treating it simply as a newly discovered rapidly convergent closed form would overstate what was obtained.

## 4. The earlier boundary-integral iteration

Before the shell construction, the discussion considered an iteration on the surface $\Gamma=\partial K_{\mathrm c}$ of the centered unit cube.

Let $n_x$ be the outward unit normal at a regular surface point $x$. The recorded kernel was

$$
T(x,y)=
\frac{n_x\cdot(x-y)}
{2\pi|x-y|^3}.
$$

The notation fixes the normal convention explicitly; it avoids ambiguity arising from differing sign conventions for layer-potential operators.

Starting with the uniform unit-charge density

$$
p_0(x)=\frac16,
$$

the recurrence was

$$
p_{m+1}(x)
=
\int_\Gamma T(x,y)p_m(y)\,dS_y.
$$

The cube has surface area $6$. The discussion used positivity of this kernel for the convex cube and preservation of total mass, understood almost everywhere on the faces. The edge and vertex set does not carry surface area.

Define

$$
b_m=\int_\Gamma\frac{p_m(y)}{|y|}\,dS_y.
$$

The proposed limiting expression was

$$
\boxed{
\kappa=\frac1{\lim_{m\to\infty}b_m}.
}
$$

The normalization is important. The stationary density $p_\infty$ has total charge $1$, so its constant potential inside the conductor is $1/\kappa$. By contrast, the equilibrium measure $\mu$ used later has potential $1$ and total charge $\kappa$.

### 4.1 The recorded convergence estimate

The discussion obtained a two-step minorization

$$
T^2(x,y)\ge\frac1{108\pi^2}
$$

and introduced

$$
\delta=\frac1{18\pi^2}.
$$

Because the surface area is $6$, the lower bound is $\delta/6$. The associated contraction statement was

$$
\|T^{2m}p-p_\infty\|_{L^1(\Gamma)}
\le
(1-\delta)^m
\|p-p_\infty\|_{L^1(\Gamma)}
$$

for the normalized densities under discussion.

This supplied a geometric convergence argument, but the contraction factor was too close to $1$ to give a useful rapid numerical estimate. The retained record does not contain a complete historical table of iteration counts for one through six decimal places, and this review does not manufacture one.

### 4.2 Why this did not meet the later request

The iteration is analytic and recursive, but each step still contains a surface integral. It did not satisfy the later demand for a computational recurrence with explicitly algebraic coefficients and no quadrature.

Its method-level provenance was associated with Ramm's layer-potential iterations, including equations (90)–(94) of the 2007 paper. The particular cube-center evaluation and explicit minorization estimate were adaptations developed in the conversation. This stage should not be attributed to Helsing–Perfekt's numerical solver or conflated with the later shell series. [RAM07]

## 5. The variational foundation

### 5.1 Coulomb energy and the equilibrium measure

For finite-energy measures $\nu,\eta$, write

$$
E(\nu,\eta)=
\iint
\frac{d\nu(x)\,d\eta(y)}{|x-y|},
\qquad
E(\nu)=E(\nu,\nu).
$$

Here $E$ denotes the Coulomb quadratic form. It does **not** include the physical electrostatic-energy factor $1/2$. This convention explains the factors in the variational formulas below.

For the cube's equilibrium measure $\mu$, normalized to potential $1$,

$$
\mu(K)=E(\mu)=\kappa.
$$

For admissible finite-energy signed trial measures supported in the conductor,

$$
E(\mu,\nu)=\nu(K).
$$

Expanding the energy of the difference gives

$$
E(\mu-\nu)
=
\kappa-2\nu(K)+E(\nu).
$$

Therefore

$$
\boxed{
2\nu(K)-E(\nu)
=
\kappa-E(\mu-\nu)
\le\kappa.
}
$$

This identity supplies both a variational lower approximation and an exact expression for its error in the energy norm. It is an expression of the classical energy principle for capacity; the later literature audit identified explicit antecedents rather than treating the principle as new. [RAM14], [BHP19]

### 5.2 Restriction to a finite family of unit-mass trial measures

Let

$$
\nu=\sum_{j=0}^{N-1}q_j\sigma_j,
\qquad
\sigma_j(K)=1,
$$

and define

$$
(G_N)_{ij}=E(\sigma_i,\sigma_j).
$$

The total charge and energy are

$$
\nu(K)=\mathbf1^{\mathsf T}q,
\qquad
E(\nu)=q^{\mathsf T}G_Nq.
$$

The finite variational problem becomes

$$
\max_q
\left(
2\mathbf1^{\mathsf T}q-q^{\mathsf T}G_Nq
\right).
$$

For a positive-definite Gram matrix, stationarity gives

$$
G_Nq_*=\mathbf1,
\qquad
q_*=G_N^{-1}\mathbf1,
$$

and hence

$$
\boxed{
\kappa_N=\mathbf1^{\mathsf T}G_N^{-1}\mathbf1.
}
$$

The coefficients $q_j$ are not constrained to be nonnegative in this formulation. Allowing signed trial measures does not invalidate the energy identity or its lower-bound conclusion.

The finite result satisfies

$$
0<\kappa_N\le\kappa.
$$

If the trial spaces are nested, the maxima are nondecreasing. The convergence rate, however, requires information about how well the equilibrium charge can be approximated by those particular spaces.

### 5.3 What the finite matrix means physically

Each $\sigma_j$ is a prescribed uniform charge distribution on a spherical surface. The Gram matrix gives the **exact energies of these trial distributions**.

It is not the exact capacitance matrix of a cluster of independently equilibrated metallic spheres. Such spheres would generally develop nonuniform induced charge. In the construction here, the approximation lies in restricting the charge distributions to a chosen linear span. The energy entries themselves are evaluated exactly for that span.

This distinction is also essential when comparing the construction with equivalent-electrode methods and hydrodynamic bead models.

## 6. The cumulative family of spherical shells

### 6.1 Geometry and ordering

Use $K=[0,1]^3$. At dyadic level $m\ge0$, set

$$
n=2^m.
$$

For every

$$
k=(k_1,k_2,k_3)\in\{0,\ldots,n-1\}^3,
$$

place a shell at the cell center

$$
x_{m,k}
=
\frac{k+(\tfrac12,\tfrac12,\tfrac12)}{n}
$$

with radius

$$
r_m=\frac1{2n}.
$$

The shell is inscribed in its grid cell. Let $\sigma_{m,k}$ be the uniform surface measure on that sphere, normalized to total mass $1$.

The original construction retains **all shells from all preceding levels**. The ordering is by increasing level, and then lexicographically within a level. Thus the first shell is centered at $(1/2,1/2,1/2)$ with radius $1/2$; the next eight belong to grid $n=2$; the next sixty-four belong to grid $n=4$; and so on.

If $n=2^m$ is the finest included grid, the number of shells is

$$
N(n)=\sum_{\ell=0}^{m}8^\ell
=\frac{8^{m+1}-1}{7}.
$$

Consequently, the grid-$2$ cumulative approximation contains nine scalar terms, not two and not five.

### 6.2 Newton's shell potential

For a unit-mass uniform shell of radius $R$ centered at $c$, the potential is

$$
\Phi(x)=\frac1{\max(R,|x-c|)}.
$$

Averaging this potential over a second uniform shell gives the pair energy. If the second radius is $S$ and the center separation is $d$, the recorded closed formula is

$$
\boxed{
G(R,S,d)=
\begin{cases}
\displaystyle\frac1{\max(R,S)},
&0\le d\le|R-S|,\\[8pt]
\displaystyle
\frac{1-(R+S-d)^2/(4RS)}{d},
&|R-S|<d<R+S,\\[10pt]
\displaystyle\frac1d,
&d\ge R+S.
\end{cases}
}
$$

The three cases correspond to containment, partial overlap, and nonoverlap or external tangency.

In particular,

$$
G_{ii}=\frac1{r_i}.
$$

At $d=0$, the first branch applies. There is no division by zero.

At a single grid level, distinct shells have disjoint interiors and may touch. Across levels, shells can overlap. Therefore the simple coefficient $1/d$ cannot be used for every off-diagonal entry in the cumulative construction. The overlap branch is indispensable.

### 6.3 Why the construction is algebraic

The centers and radii are rational. A center separation is a square root of a rational number. Every branch of the interaction formula therefore gives an algebraic number.

For any finite $N$:

- Every entry of $G_N$ is algebraic.
- Its inverse, when written exactly, has algebraic entries.
- Its Cholesky factor is obtained by arithmetic and square roots of positive algebraic quantities.
- Each $z_j$ and each finite approximation $\kappa_N$ is algebraic.

“Integral-free” refers to the computational construction of these coefficients. Integrals remain in the variational definitions and convergence analysis. Also, the algebraicity of every finite approximation does not imply that the limiting number $\kappa$ has been proved algebraic.

## 7. The algebraic series and its recurrences

### 7.1 Cholesky recurrence

Factor the Gram matrix as

$$
G_N=L_NL_N^{\mathsf T},
$$

where $L_N$ is lower triangular with positive diagonal.

The entrywise recurrence is

$$
L_{jj}
=
\sqrt{
G_{jj}-\sum_{k<j}L_{jk}^2
},
$$

and, for $i>j$,

$$
L_{ij}
=
\frac{
G_{ij}-\sum_{k<j}L_{ik}L_{jk}
}{
L_{jj}
}.
$$

Define $z$ by $Lz=\mathbf1$, so

$$
\boxed{
z_j=
\frac{
1-\sum_{k<j}L_{jk}z_k
}{
L_{jj}
}.
}
$$

Then

$$
\begin{aligned}
\kappa_N
&=\mathbf1^{\mathsf T}G_N^{-1}\mathbf1\\
&=\mathbf1^{\mathsf T}L_N^{-\mathsf T}L_N^{-1}\mathbf1\\
&=\|L_N^{-1}\mathbf1\|_2^2\\
&=\sum_{j=0}^{N-1}z_j^2.
\end{aligned}
$$

The cumulative hierarchy ensures that enlarging the leading principal matrix leaves the already computed Cholesky entries and coefficients unchanged. Subject to the energy-density argument in Section 9, this gives

$$
\boxed{\kappa=\sum_{j=0}^{\infty}z_j^2.}
$$

The terms are nonnegative. They need not all be strictly positive.

### 7.2 Equivalent Schur-complement recurrence

Suppose one shell is appended:

$$
G_{N+1}=
\begin{pmatrix}
G_N&g\\
g^{\mathsf T}&a_*
\end{pmatrix}.
$$

The recorded increment identity is

$$
\boxed{
\kappa_{N+1}-\kappa_N
=
\frac{
\bigl(1-g^{\mathsf T}G_N^{-1}\mathbf1\bigr)^2
}{
a_*-g^{\mathsf T}G_N^{-1}g
}.
}
$$

The denominator is the positive Schur complement. This gives another explicit algebraic recursion and displays the nonnegative increment directly.

The numerator measures how much the new trial distribution contributes beyond what is already represented in the existing span. If it vanishes, the increment is zero.

This is a standard block-matrix identity applied to the chosen trial family. The conversation did not establish it as a new cube-specific law.

### 7.3 Energy orthogonalization and Parseval's identity

Let

$$
e_j=\sum_{k\le j}(L^{-1})_{jk}\sigma_k.
$$

Then

$$
E(e_i,e_j)=\delta_{ij}.
$$

Since every $\sigma_k$ has mass $1$,

$$
e_j(K)
=
\sum_{k\le j}(L^{-1})_{jk}
=
z_j.
$$

The equilibrium-potential identity gives

$$
E(\mu,e_j)=e_j(K)=z_j.
$$

If $\Pi_N$ is energy-orthogonal projection onto the first $N$ trial measures, then

$$
\kappa_N=\|\Pi_N\mu\|_E^2
$$

and

$$
\boxed{
\kappa-\kappa_N
=
\|\mu-\Pi_N\mu\|_E^2.
}
$$

This explains the infinite series structurally: it is Parseval's identity for the equilibrium measure in the energy closure of the trial family. The substantive approximation question is whether the chosen shell family can approximate that measure in energy. Cholesky factorization alone does not answer that question.

## 8. The first five algebraic coefficients

The recorded first-five calculation used the central shell followed by the first four shells of grid $n=2$ in lexicographic order:

| Index | Center | Radius |
|---:|---|---:|
| $0$ | $(1/2,1/2,1/2)$ | $1/2$ |
| $1$ | $(1/4,1/4,1/4)$ | $1/4$ |
| $2$ | $(1/4,1/4,3/4)$ | $1/4$ |
| $3$ | $(1/4,3/4,1/4)$ | $1/4$ |
| $4$ | $(1/4,3/4,3/4)$ | $1/4$ |

Introduce

$$
t=\frac1{\sqrt3}-\frac12,
\qquad
\alpha=2\sqrt3-\frac76,
\qquad
D=(4+\sqrt2)\alpha-8.
$$

The auxiliary symbol $\alpha$ is used here to avoid confusing it with a physical side length or a shell radius.

The five recorded coefficients are

$$
\boxed{z_0=\frac1{\sqrt2},}
$$

$$
\boxed{z_1=\frac{t}{\sqrt\alpha},}
$$

$$
\boxed{
z_2=\frac{t}{\sqrt{\alpha(\alpha-1)}},
}
$$

$$
\boxed{
z_3=
t\sqrt{
\frac{4-\sqrt2}{(\alpha-1)D}
},
}
$$

$$
\boxed{
z_4=
t\sqrt{
\frac{4\sqrt2-2}
{D(4\alpha-8+\sqrt2)}
}.
}
$$

These are the results of applying the shell-energy formula and Cholesky recurrence to that ordering. They were independently checked numerically during the earlier work; this review does not generate a new decimal table.

The first partial sum is

$$
z_0^2=\frac12.
$$

Individual $z_j$ depend on the ordering of the trial measures. The finite variational value depends on the span, and the infinite limit depends on its energy closure.

The sum through $z_4^2$ contains only five shells. It is not the full cumulative grid-$2$ value, which includes the central shell and all eight grid-$2$ shells.

## 9. What the convergence argument establishes

### 9.1 The cumulative volume-filling hierarchy

The finite identities establish lower approximations and nonnegative increments. To identify their limit with $\kappa$, the conversation gave an energy-approximation argument with four stages.

1. **Move the equilibrium charge inward.** Apply a slight inward homothety so that the charge lies strictly inside the cube.
2. **Smooth the displaced measure.** Approximate it in Coulomb energy by a smooth density with compact support in the interior.
3. **Replace cell masses by shell masses.** On a sufficiently fine dyadic grid, place each cell's mass on its inscribed uniform shell.
4. **Control the energy.** Use consistency away from the diagonal and control the near-diagonal contribution using the local integrability of $1/|x-y|$.

For a fixed bounded smooth volume density and cell width $h$, cell masses are $O(h^3)$. A shell has radius proportional to $h$, so its self-energy is its squared mass divided by that radius. Summing the self-energies over $O(h^{-3})$ cells gives the recorded estimate

$$
O(h^{-3})\,O(h^6)\,O(h^{-1})=O(h^2).
$$

This estimate concerns an intermediate smooth-density approximation. It is not a proved $O(h^2)$ error estimate for the final capacitance sequence.

The argument supports the approximation of the equilibrium measure in the energy closure of the cumulative trial spaces, and therefore the limit

$$
\kappa_N\uparrow\kappa.
$$

The conversation retained this as a convergence proof sketch. It did not produce a full quantitative theorem controlling all regularization steps, the singular equilibrium density near cube edges and vertices, and the resulting error as an explicit function of $N$.

### 9.2 What positivity does and does not provide

Because

$$
\kappa-\kappa_N=\sum_{j=N}^{\infty}z_j^2
$$

once the limiting identity is established, the tail is nonnegative. Knowing the first several terms does not automatically bound the remaining tail from above.

Thus the positive-series form gives:

- A variational lower approximation.
- Consistent nested partial sums.
- A transparent energy interpretation.
- Explicit algebraic finite terms.

It does not, without an additional estimate, give:

- A prescribed number of terms for a requested decimal accuracy.
- Geometric decay of the individual terms.
- One decimal digit gained per term.
- A small scalar recurrence whose cost stays fixed as $j$ increases.

The stored recurrence carries an expanding Gram matrix or Cholesky factor. Calling it a scalar series should not conceal that growing computational work.

## 10. The boundary-only shell sequence

### 10.1 Why a second sequence was introduced

The cumulative construction fills the volume at every resolution and keeps previous levels. It is useful for an explicit nested-space argument, but expensive as a numerical approximation.

The later construction keeps only one layer of shells next to the boundary at each chosen resolution. It reduces the number of raw trial distributions from a volume count to a surface count. It changes the trial space and therefore changes the finite approximations.

Define

$$
I_n=
\left\{
k\in\{0,\ldots,n-1\}^3:
\min_i k_i=0
\ \text{or}\
\max_i k_i=n-1
\right\}.
$$

For $k\in I_n$, use center

$$
x_k=\frac{k+(\tfrac12,\tfrac12,\tfrac12)}n
$$

and radius

$$
r=\frac1{2n}.
$$

There is one shell when $n=1$. For $n\ge2$,

$$
|I_n|=n^3-(n-2)^3=6n^2-12n+8.
$$

### 10.2 Exact derivation of the displayed matrix

All these shells have the same radius. Distinct centers are at least $1/n$ apart, equal to the diameter. The interiors therefore do not overlap.

The self-energy is

$$
G_{kk}=\frac1r=2n,
$$

and the pair energy is

$$
G_{k\ell}
=
\frac1{|x_k-x_\ell|}
=
\frac n{|k-\ell|}
\qquad(k\ne\ell).
$$

Consequently,

$$
G_n=nM_n,
$$

where

$$
(M_n)_{k\ell}=
\begin{cases}
2,&k=\ell,\\[4pt]
\displaystyle
\frac1{\sqrt{
(k_1-\ell_1)^2+
(k_2-\ell_2)^2+
(k_3-\ell_3)^2
}},
&k\ne\ell.
\end{cases}
$$

Applying the variational formula gives exactly

$$
\boxed{
Q_n=\frac1n\mathbf1^{\mathsf T}M_n^{-1}\mathbf1.
}
$$

This confirms the matrix and scaling in the screenshot discussed by the user.

### 10.3 Exact low-resolution checks

The recorded exact values were

$$
Q_1=\frac12
$$

and

$$
\boxed{
Q_2=
\frac4{5+3/\sqrt2+1/\sqrt3}.
}
$$

For $n=2$, symmetry makes all eight row sums equal. A row contains the diagonal contribution $2$, three neighbors at distance $1$, three at distance $\sqrt2$, and one at distance $\sqrt3$. This gives the denominator in the displayed expression.

The original cumulative construction at finest grid $2$ includes an additional central shell from grid $1$. Therefore its value is different from $Q_2$. The distinction is structural, not a floating-point discrepancy.

### 10.4 Convergence and the absence of a monotonicity theorem

Each individual trial space satisfies the same variational inequality:

$$
0<Q_n\le\kappa.
$$

The boundary-only convergence sketch approximated bounded face densities by masses on the adjacent shells. For a fixed bounded face density, a cell carries mass $O(h^2)$, there are $O(h^{-2})$ such cells, and the summed shell self-energy scales as

$$
O(h^{-2})\,O(h^4)\,O(h^{-1})=O(h).
$$

Off-diagonal interactions converge to those of the corresponding surface distribution. An additional energy-approximation step is needed to reach the cube's actual equilibrium charge, including its edge and corner behavior.

The recorded conclusion was

$$
Q_n\longrightarrow\kappa,
$$

supported by that proof sketch. The $O(h)$ self-energy bookkeeping for bounded face densities does not prove a complete $O(h)$ asymptotic expansion for $\kappa-Q_n$.

The spaces at different $n$ are not nested. Therefore the variational principle alone does not prove

$$
Q_{2n}\ge Q_n.
$$

The computed values did increase, but no general monotonicity theorem for this sequence was established.

### 10.5 Symmetry reduction

The implementation exploited cube symmetry to solve for classes of equivalent shells. For even $n$, writing $m=n/2$, the recorded number of symmetry classes was

$$
\frac{m(m+1)}2.
$$

At $n=256$, the physical construction contains

$$
390{,}152\ \text{shells},
$$

while the reduced linear system has

$$
8{,}256\ \text{unknowns}.
$$

This is the main practical reduction reported for the boundary solver. It does not change the variational quantity being approximated.

## 11. Recorded raw numerical approximations

The following tables reproduce the earlier numerical record. They were not recalculated for this review.

### 11.1 Original cumulative hierarchy

Here $P_n$ includes all shells from all dyadic levels up to finest grid $n$.

| Finest grid $n$ | Recorded $P_n$ |
|---:|---:|
| 1 | 0.5000000000000000 |
| 2 | 0.5269382893267929 |
| 4 | 0.5868409003952925 |
| 8 | 0.6205109846673849 |
| 16 | 0.6393566113407069 |
| 32 | 0.6495471827485280 |
| 64 | 0.6549305528757741 |

These values were stored in the historical implementation's `ORIGINAL_RAW` data.

The monotonicity here has a variational explanation: the cumulative spaces are nested. The rather slow approach to the reference value was the reason to seek acceleration and a cheaper trial family.

### 11.2 Boundary-only hierarchy

| Grid $n$ | Recorded $Q_n$ |
|---:|---:|
| 1 | 0.4999999999999999 |
| 2 | 0.5195702220817006 |
| 4 | 0.5844782582292353 |
| 8 | 0.6186584486151133 |
| 16 | 0.6380748926105578 |
| 32 | 0.6487448305656178 |
| 64 | 0.6544599679744924 |
| 128 | 0.6574687458014177 |
| 256 | 0.6590334428698094 |

The last-digit discrepancy at $n=1$ is a floating-point artifact; the exact value is $1/2$.

The cumulative and boundary-only values should not be combined into a single extrapolation table. They arise from different finite spaces and can have different error structures.

## 12. Algebraic convergence acceleration

Two acceleration routes were retained: a prescribed-power Richardson table and Richardson followed by Aitken's $\Delta^2$ transformation.

### 12.1 Generalized Richardson extrapolation

Let $s_m$ be approximations at successively doubled resolutions. Define

$$
R_{m,0}=s_m
$$

and, for $k\ge1$,

$$
\boxed{
R_{m,k}
=
\frac{
2^{p_{k-1}}R_{m,k-1}
-
R_{m-1,k-1}
}{
2^{p_{k-1}}-1
}.
}
$$

The equivalent implementation form was

$$
R_{m,k}
=
R_{m,k-1}
+
\frac{
R_{m,k-1}-R_{m-1,k-1}
}{
2^{p_{k-1}}-1
}.
$$

The prescribed powers were

$$
(p_0,p_1,p_2,p_3)
=
\left(1,\frac43,2,\frac73\right).
$$

The earlier program used three stages for the original cumulative sequence and four for the boundary-only sequence.

The intended mechanism is cancellation of error terms behaving like fixed powers of the grid width. A $n^{-p}$ contribution changes by the factor $2^{-p}$ when the resolution doubles, which is the factor built into the transformation.

The powers involving thirds were motivated empirically and by expectations concerning singular geometry. The conversation did not establish the complete asymptotic expansion

$$
Q_n=\kappa+c_1n^{-1}+c_{4/3}n^{-4/3}+\cdots
$$

for this particular shell approximation. That expression is an assumed error model used to explain the extrapolation, not a theorem proved during the discussion.

### 12.2 The recorded four-value closed formula

For the first three powers $1,4/3,2$, let

$$
q=2^{1/3}.
$$

Using four consecutive values, with the newest listed first, the retained formula was

$$
\boxed{
\mathcal R_3
=
\frac{
16q\,s_m
-(12q+8)s_{m-1}
+(2q+6)s_{m-2}
-s_{m-3}
}{
3(2q-1)
}.
}
$$

It is an algebraic linear combination. It avoids constructing the intermediate Richardson table if only that three-stage output is wanted.

For any fixed number of Richardson stages, the coefficients sum to $1$. Therefore, if the input sequence converges, the transformed sequence has the same limit. The assertion of a faster rate requires the presumed error structure; limit preservation alone does not prove acceleration.

### 12.3 Error amplification in linear extrapolation

The implementation tracked the worst-case amplification of uniformly bounded raw numerical errors by the factor

$$
\prod_p
\frac{2^p+1}{2^p-1}.
$$

This expresses the cost of canceling leading discretization errors: subtraction can magnify errors already present in the raw values.

No evaluated numerical amplification factor is preserved in the record, so none is supplied here. The formula itself is retained because it explains why raw solves must be more accurate than the desired extrapolated answer.

### 12.4 Richardson followed by Aitken

For the four resolutions in the user's screenshot,

$$
s_0=Q_n,\qquad
s_1=Q_{2n},\qquad
s_2=Q_{4n},\qquad
s_3=Q_{8n},
$$

first form

$$
r_0=2s_1-s_0,\qquad
r_1=2s_2-s_1,\qquad
r_2=2s_3-s_2.
$$

Then apply

$$
\boxed{
\mathcal A_n
=
r_2-
\frac{(r_2-r_1)^2}
{r_2-2r_1+r_0}.
}
$$

The endpoint form in the screenshot is algebraically correct. For a nonzero denominator it equals the conventional initial-point expression

$$
\mathcal A_n
=
r_0-
\frac{(r_1-r_0)^2}
{r_2-2r_1+r_0}
$$

and also

$$
\mathcal A_n
=
\frac{r_0r_2-r_1^2}
{r_2-2r_1+r_0}.
$$

The first stage is intended to cancel a leading $1/n$ contribution. The second stage estimates and removes a remaining approximately geometric error across the doubled grids.

Aitken's transformation is a standard published sequence transformation. Its formula and convergence qualifications are documented in DLMF §3.9, particularly equation (3.9.7) and the associated ratio condition. [DLMF]

### 12.5 Stability checks and limitations

The historical implementation checked finite inputs and formed

$$
d_0=r_1-r_0,\qquad d_1=r_2-r_1.
$$

It rejected a second difference $d_1-d_0$ at the floating-point roundoff scale. The recorded guard compared its magnitude with

$$
64\,\operatorname{ulp}(\text{scale}),
$$

where `scale` was the maximum of the absolute $r$-values and $10^{-300}$.

The returned diagnostics included the transformed estimate, the denominator, and the ratio

$$
d_1/d_0.
$$

When that ratio lay strictly between $0$ and $1$, the code also reported the effective power

$$
-\log_2(d_1/d_0).
$$

A complete numerical table of those ratios and effective powers was not preserved.

The mathematical qualifications are separate from the floating-point guard:

- Aitken is nonlinear and does not preserve the limit of every convergent sequence.
- A small nonzero denominator can cause sensitivity even before it reaches machine roundoff.
- Coarse-grid extrapolation can worsen an approximation.
- Neither Richardson nor Aitken preserves the variational lower-bound property.
- Small changes between extrapolated values do not constitute certified error estimates.
- The correctness of the displayed algebra does not establish the error expansion needed for the desired convergence rate.

These were material qualifications to the earlier confirmation of the screenshot.

## 13. Accuracy, validation, and the digit-per-term question

### 13.1 The recorded extrapolated results

The principal benchmark was

$$
\kappa_{\mathrm{ref}}=0.66067815409957.
$$

The following results were reported earlier:

| Method | Resolutions / largest grid | Recorded result | Recorded absolute difference from the reference |
|---|---|---:|---:|
| Richardson–Aitken | $32,64,128,256$ | 0.6606781627069044 | Approximately $8.61\times10^{-9}$ |
| Prescribed-power Richardson | Through grid $256$ | 0.6606780698461191 | Approximately $8.43\times10^{-8}$ |

The first value is $\mathcal A_{32}$, because the subscript denotes the coarsest of the four resolutions. Calling it $\mathcal A_{256}$ would change the definition.

The more detailed recorded Aitken error was $8.6073344\times10^{-9}$. The rounded value in the table is sufficient for the discussion.

### 13.2 What was validated

The transformations were selected before the grid-$256$ raw value was used as a held-out numerical check. The published benchmark was not inserted into the matrix, the solver, or the extrapolation formula. It was used only by the validation mode to measure the resulting discrepancy.

Agreement among the fixed-power extrapolation variants and the held-out calculation supported approximately six decimal places in the reported numerical interpretation. The particularly small Richardson–Aitken discrepancy could benefit from cancellation between remaining errors.

Therefore the retained conclusion was a useful accelerated numerical approximation, not a certified eight-decimal enclosure and not a proof that the same error behavior persists at arbitrary resolutions.

### 13.3 Why there is no complete one-to-six-decimal term table here

The user explicitly requested the work needed for one through six decimal places. The review preserves that request and the reason it led to acceleration, but the surviving record does not contain a complete original table that can responsibly be reproduced.

There was also no established general tail estimate converting a tolerance into a guaranteed number of $z_j$ terms. A table reconstructed now from new numerical experiments would violate the request to review the existing work without generating new results.

Several meanings of “term” were involved:

| Possible meaning | What it counts | Why the distinction matters |
|---|---|---|
| One $z_j^2$ | One additional trial shell in the cumulative series | Computing it requires the growing factorization or equivalent state. |
| One grid value $P_n$ | All cumulative shells through finest grid $n$ | A single displayed value can include many scalar terms. |
| One boundary value $Q_n$ | An entire boundary-shell linear system | Its cost grows with resolution despite symmetry reduction. |
| One doubling step | Replacement of $n$ by $2n$ | It changes the discretization substantially. |
| One accelerated value | A combination of several raw grid solves | It does not represent a constant-cost scalar series term. |

No proved “one decimal digit per cheap scalar term” representation emerged from the conversation.

### 13.4 Timing and practical scale

The earlier environment recorded approximately:

| Calculation | Recorded time |
|---|---:|
| Boundary grid $128$ | 3.3 seconds |
| Boundary grid $256$ | 93 seconds |
| All levels through $256$ | About 100 seconds |

These are historical measurements in one environment. The record does not support a portable timing guarantee or a controlled performance comparison with an established high-accuracy boundary-integral solver.

The practical achievement was that symmetry reduction and extrapolation made the algebraic shell approach numerically useful at the reported scale. It did not establish that this approach is faster than the specialized methods in the literature.

## 14. Implementation, tools, and historical artifacts

### 14.1 Recorded program structure

The main historical file was `cube_capacitance.py`. Its recorded implementation used:

- Python 3.10 or later.
- NumPy arrays.
- SciPy's `cho_factor` and `cho_solve`.
- Cube symmetry and orbit reduction.
- Separate original-cumulative and boundary-shell modes.
- Cached raw values and a recomputation mode.
- Prescribed-power Richardson extrapolation and an optional Aitken route.
- A validation option comparing against the published reference.
- A self-test entry point.
- Optional `threadpoolctl` support.

Although formulas are written using $G^{-1}$ or $M^{-1}$, the numerical implementation solved linear systems using Cholesky routines rather than explicitly forming a dense inverse.

The exact mathematical coefficients are algebraic. The supplied numerical program nevertheless evaluated them with floating-point arithmetic. It was not an arbitrary-precision symbolic radical evaluator.

No numerical quadrature was required for shell interactions.

### 14.2 Recorded result diagnostics

A `RawResult` record carried the fields

`grid`, `capacity`, `shells`, `orbits`, `seconds`, `residual`, `asymmetry`, and `cached`.

These fields supported checks of the matrix assembly, reduced-system solve, timing, and data provenance. The existence of a diagnostic field should not be confused with preservation of every value: the full historical residual and asymmetry tables are not available in the retained record.

The mathematical boundary construction is defined for positive integer $n$. The implementation's grid checks used dyadic resolutions, consistent with the extrapolation workflow.

### 14.3 Historical command-line examples

The following command forms were recorded for the original program. They document its interface; this review does not supply a reconstructed replacement program.

```bash
python cube_capacitance.py --max-grid 128 --validate
python cube_capacitance.py --max-grid 256 --validate
python cube_capacitance.py --max-grid 256 --method aitken --validate
python cube_capacitance.py --mode original --cached --max-grid 64
python cube_capacitance.py --mode original --max-grid 32 --validate
python cube_capacitance.py --self-test
```

The default workflow recomputed values. The `--cached` option used stored raw numbers. This distinction matters when interpreting whether a displayed run represents new computation or retrieval of a previous result.

### 14.4 Other recorded computational checks

The earlier mathematical and literature audit also used:

- Independent numerical checks of the first five radical coefficients.
- Direct algebraic comparison of the shell kernel with the normalized trace of an RPY hydrodynamic tensor.
- An attempted SymPy check, which could not run because SymPy was unavailable.
- A replacement check using Python's standard-library `fractions.Fraction`.
- Downloading and visually inspecting a published equation image when its text extraction was ambiguous.

The exact-rational overlap check covered **324 cases**: radii chosen as integers from $1$ through $6$, with nine interior partial-overlap separations for each radius pair. The checks passed.

That finite test corroborated the algebraic identity; it was not a proof by exhaustive verification over all real radii and separations. The analytical trace simplification was the mathematical argument.

The equation-image inspection confirmed that the 2024 hydrodynamic formula sums **all entries** of an inverse matrix. It is not the trace of that inverse. The distinction is explained in Section 18.

### 14.5 Historical artifact inventory

| Filename | Recorded role |
|---|---|
| `cube_capacitance.py` | Main implementation, both approximation modes and acceleration. |
| `boundary_shell_solver.py` | Boundary-shell solver work. |
| `symmetric_shell_sums.py` | Symmetry-based shell-sum work. |
| `boundary_shell_results.json` | Recorded raw boundary results. |
| `boundary_shell_256.json` | Finest-grid boundary result. |
| `acceleration_validation_128.json` | Acceleration validation through grid $128$. |
| `acceleration_validation_256.json` | Acceleration validation through grid $256$. |

The main implementation was previously saved with this historical file reference:

[cube_capacitance.py — historical saved artifact](https://chatgpt.com/library?file_id=libfile_ecea104062908191a4d6b586fe50b49d&account_id=personal).

The original scratch files were no longer present when the review was compiled. The historical saved artifact was not reopened during this review, so its current accessibility and contents are not newly verified here.

### 14.6 Research tools and scope

The literature investigation used web searches, retrieval of primary papers and author-hosted PDFs, section and equation searches, backward and forward reference following, institutional publication lists, and English, Serbian Latin, and Serbian Cyrillic queries. Parallel reviews examined the mathematics, numerical record, cube-specific literature, and broader capacity-series antecedents.

The record does not show a systematic search in MathSciNet, zbMATH, Scopus, or Web of Science. No such database coverage is claimed.

One cube-literature search reported 54 targeted queries followed by a focused additional pass. There is no verified aggregate query count for the whole investigation, and a query count would not establish completeness in any case.

The review's bibliography distinguishes full text, accessible abstracts or sections, and bibliography-only verification. Those distinctions set the strength of the corresponding novelty conclusions.

## 15. Actual provenance and the Helsing–Perfekt comparison

### 15.1 What was assembled in the conversation

The cumulative shell hierarchy, its Cholesky series, and the boundary-only alternative were assembled in the conversation from standard mathematical ingredients. The record does not identify a paper from which the complete indexed construction was extracted.

Later discovery of a related formula does not retrospectively change the actual source of the earlier response. The following distinction was central to the provenance correction:

| Item | Actual role in the discussion |
|---|---|
| Newton's shell theorem | Standard ingredient for explicit pair energies. |
| Classical capacity energy principle | Foundation for the lower approximations. |
| Cholesky and Schur-complement identities | Standard linear algebra giving the series and increments. |
| Helsing–Perfekt | Numerical benchmark and boundary-potential background. |
| Ramm's layer-potential iteration | Method-level antecedent for the earlier integral iteration. |
| Serbian equivalent-electrode papers | Related work identified in the subsequent audit. |
| RPY and minimum-dissipation papers | Exact kernel and matrix-functional matches identified subsequently. |
| Read and DLMF | Published precedents for extrapolation and standard acceleration. |
| The precise dyadic dictionary and boundary index selection | Particular choices made in the conversation; no exact publication match located. |

“Constructed in this conversation” describes the local derivation. It does not establish historical independence from all prior work or publication priority.

### 15.2 What Helsing and Perfekt actually do

The paper supplied by the user was:

**Johan Helsing and Karl-Mikael Perfekt, “On the polarizability and capacitance of the cube.”** [HP13]

The earlier audit inspected the full paper and, in particular:

- Section 6, equations (47)–(50), for the capacitance formulation.
- Section 8.3, equation (60), for the recursively compressed inverse construction.
- Section 9, for the treatment of the cube.
- Table 1, for the high-accuracy numerical value.

The capacitance formulation includes

$$
(I+K+Q)\rho=1,
$$

where $K$ is a boundary-integral operator and $Q$ is a rank-one integral operator. These are the paper's operator symbols; $Q$ is unrelated to the scalar boundary-shell approximation $Q_n$ in this review.

The solution is used to evaluate a single-layer potential. In the paper's normalization, the capacitance expression uses

$$
\frac1{4\pi U(r)}
$$

at an interior point $r$. Its equation (60) is a matrix recursion involving discretized operators and prolongation matrices in the recursively compressed inverse framework. [HP13]

That recursion is not the recurrence for $z_j$, and it is not the Richardson–Aitken transformation. The inspected paper does not provide the cumulative spherical-shell dictionary or the positive Cholesky series discussed here.

Accordingly, an earlier citation to Helsing–Perfekt could support the benchmark and general setting, but it could not support attribution of the shell construction or its convergence proof to that paper.

### 15.3 Benchmark status

The distinction between a high-accuracy computation and a rigorous enclosure was retained throughout the audit. Helsing–Perfekt report an estimated relative error of order $10^{-13}$ for the tabulated cube capacitance. That does not supply an exact value or an independently certified interval. [HP13]

Likewise, comparing an extrapolation with that benchmark establishes an observed discrepancy. It does not, by itself, create a rigorous error theorem for the extrapolation.

## 16. Published antecedents of the variational construction

### 16.1 Ramm's trial-space formulation

Ramm's 2005 book contains a directly relevant variational prescription in Section 3.2. On printed page 30, equation (3.32) introduces

$$
\sigma_m=\sum_{j=1}^{m}c_j\varphi_j,
$$

with coefficients chosen to maximize the capacitance quotient in equation (3.29). [RAM05]

Writing the corresponding energy matrix as $G$ and the trial-function masses as $b_j$, the conversation rewrote this prescription as

$$
b^{\mathsf T}G^{-1}b.
$$

This matrix expression is the elementary algebraic interpretation supplied in the comparison. It should not be quoted as the literal printed content of Ramm's equation (3.32).

Ramm's trial functions in that subsection live on the conductor surface. The conversation's shell measures live inside the conductor. The reference is therefore a clear method-level antecedent, while the exact trial dictionary differs.

The book also contains a different iterative construction in Section 3.1, Theorem 3.1, equations (3.12)–(3.15), and a cube example in Section 4.3, Example 4.2. These should not be collapsed into the same method merely because all concern capacitance. [RAM05]

Ramm's 2014 note states the maximum of squared charge divided by Coulomb energy and the reciprocal minimum-energy characterization in equations (1.3)–(1.4). It identifies the latter with the classical Gauss principle. [RAM14]

### 16.2 Betcke, Haberl, and Praetorius

The 2019 paper on adaptive boundary elements for polyhedral capacity contains an explicit inverse-matrix quadratic form and an energy-error identity in Section 2.7, Proposition 4. Its approximate capacities satisfy a lower-bound property. [BHP19]

There is a normalization difference:

- Their single-layer kernel is $1/(4\pi|x-y|)$.
- The shell Gram matrix here uses $1/|x-y|$.

With their matrix $V$ and trial-mass vector $b$, the capacity expression includes

$$
\frac1{4\pi}b^{\mathsf T}V^{-1}b.
$$

For the same trial functions, $V=G/(4\pi)$, yielding the convention used here. Thus the factors of $4\pi$ do not indicate a different variational mechanism.

Their trial spaces are boundary-element spaces, not the spherical-shell family. Nevertheless, their explicit matrix formula and projection-error result are strong antecedents for the general structure of the construction.

### 16.3 What this establishes about novelty

The use of a finite energy matrix, maximization over trial charges, an inverse-matrix scalar, and a projection-error identity is established mathematical machinery. Selecting a particular explicit family can still be useful, but it does not make those general principles new.

The novelty question must therefore be asked at the level of the precise family, its special analysis, or its demonstrated computational properties.

## 17. The Serbian papers and unresolved earlier references

### 17.1 Veličković and Milovanović, 2004

The main identified paper by the Serbian pair was:

**Dragutin M. Veličković and Alenka Milovanović, “Electrostatic Field of Cube Electrodes,” Serbian Journal of Electrical Engineering 1(2), 187–198 (2004).** [VM04]

The complete twelve-page paper was inspected. Section 2 and equations (2)–(4) use spherical equivalent electrodes to represent patches on the cube's faces.

The substantive comparison was:

| Feature | Veličković–Milovanović, 2004 | Construction in the conversation |
|---|---|---|
| Placement | Centers on cube-face patches | Centers of inscribed grid cells, displaced inward by half a cell width at the boundary |
| Radius | Effective radius about $0.368248h$ | Exactly $h/2$ |
| Elementary interactions | Self coefficient $1/r_i$, pair coefficient $1/d_{ij}$, with physical factors and symmetry sums | Coulomb-energy Gram entries of prescribed uniform shell measures |
| Calculation | Match prescribed potentials, solve charges, sum total charge and divide by potential | Maximize the energy functional, yielding an inverse-matrix quadratic form |
| Cumulative hierarchy | Not present | All dyadic levels retained in the original series |
| Positive $z_j$ series | Not present | Cholesky representation of the nested variational values |
| Exact boundary matrix with diagonal $2$ | Not the same construction | Follows from radius $h/2$ |
| Richardson–Aitken prescription | Not the construction identified in that paper | Applied later in the conversation |

The shared inverse-distance structure is a real methodological connection. It does not establish equality of the two discretizations or transfer the variational lower-bound property automatically to a potential-matching approximation.

**Recorded confidence: high** that the exact cumulative series and exact $Q_n$ formula are absent from this inspected 2004 paper.

### 17.2 Why that does not settle the authors' entire publication record

The audit found earlier works relevant enough that their unavailability matters:

| Work | Verified bibliographic information | Inspection status |
|---|---|---|
| D. M. Veličković, *Equivalent Electrodes Method* | Scientific Review, nos. 21–22 (1996), 207–248 | Full text not obtained |
| D. M. Veličković and A. Milovanović, *Approximate Calculation of Capacitance* | VIII IGTE Symposium, Graz (1998), 339–344 | Full text not obtained |
| D. Veličković and A. Milovanović, *Electrostatic Field of Cub Electrodes* | PES 2001, Niš, 193–196 | Full text not obtained |
| Д. М. Величковић and А. Миловановић, *Електрично поље и потенцијал проводне коцке* | XLV ETRAN, Bukovička Banja (2001), 186–189 | Full text not obtained |

The last title means “Electric field and potential of a conducting cube.” The two 2001 entries are separate bibliographic items.

Their existence was checked through the faculty publication list, a university evaluation document, and a later paper's references. The ETRAN item appears on PDF page 5 of the evaluation document. Exact conference-day dates were inconsistent among bibliographic routes, so only the year is retained here. [MIL-BIB], [MIL-EVAL], [MB11]

The 2004 bibliography also points to an earlier EEM proceedings contribution listed there as 1987. Later bibliography dates differed. The conversation did not obtain enough evidence to promote that item into a fully verified foundational reference.

Therefore the correct scope of the negative conclusion is the inspected 2004 paper. It does not establish absence from every earlier paper by either author.

### 17.3 Later work with sources inside a cube

Kolundžija and Milovanović's 2008 paper on fields near a cube electrode with rounded wedges uses simulated sources on an inner cube. The inspected construction included square-patch, line, and point-source representations. [KM08]

That paper does not provide the cumulative shell-capacitance series. It does show that merely moving simulated sources inside a cube is not, on its own, a novel distinction.

## 18. The exact shell-kernel match in hydrodynamics

The strongest exact coefficient match found during the audit came from a different application: hydrodynamic interactions of spherical beads.

### 18.1 The 2014 unequal-radius RPY construction

Zuk, Wajnryb, Mizerski, and Szymczak's 2014 paper gives the Rotne–Prager–Yamakawa approximation for different-sized particles, including overlapping configurations. Equations (2.7)–(2.9) express the tensor through averages over uniform spherical surfaces, and equation (3.1) gives the piecewise interaction formula. [ZUK14]

The Oseen tensor is

$$
T_0(r)=
\frac{I+\widehat r\,\widehat r}{8\pi\eta r},
$$

where $\eta$ is viscosity and the tensor is three-dimensional. Its trace satisfies

$$
2\pi\eta\,\operatorname{tr}T_0(r)=\frac1r.
$$

Taking this normalized trace commutes with the surface averages. Consequently, for the translational mobility tensor used in that construction, the comparison made in the conversation was

$$
\boxed{
G_{ij}
=
2\pi\eta\,\operatorname{tr}\boldsymbol\mu_{ij}^{tt}.
}
$$

This is the Coulomb energy of the same two uniform spherical surfaces.

The identification was the conversation's comparison of the published formulas. The 2014 authors did not present it as a cube-capacitance series.

### 18.2 The partial-overlap algebra

The audit explicitly checked that the correspondence includes partial overlaps, not only the obvious $1/d$ branch.

For radii $a,b$ and separation $|a-b|<d<a+b$, write the two tensor coefficients in the comparison as

$$
u=
\frac{
16d^3(a+b)-\bigl((a-b)^2+3d^2\bigr)^2
}{
32d^3
}
$$

and

$$
v=
\frac{
3\bigl((a-b)^2-d^2\bigr)^2
}{
32d^3
}.
$$

The normalized trace reduces to

$$
\begin{aligned}
\frac{3u+v}{3ab}
&=
\frac{
2d(a+b)-(a-b)^2-d^2
}{
4abd
}\\[4pt]
&=
\frac{
1-(a+b-d)^2/(4ab)
}{
d
}.
\end{aligned}
$$

This is exactly the middle branch of the shell-energy formula.

The containment and nonoverlap branches likewise give

$$
\frac1{\max(a,b)}
\qquad\text{and}\qquad
\frac1d.
$$

Thus the full scalar kernel, including unequal radii and overlap, already appears algebraically in the published RPY construction after taking the specified trace. The earlier rational checks and equation inspection corroborated this comparison.

### 18.3 Equal-radius confirmation

Tworek and Elcock's 2023 orientationally averaged RPY paper independently gives the equal-radius scalar form, after removing its physical prefactor:

$$
\frac1d
\qquad(d>2a),
$$

and

$$
\frac1a-\frac{d}{4a^2}
\qquad(d\le2a).
$$

This is the equal-radius specialization of the same kernel. Their discussion also includes positive definiteness and Cholesky factorization, used for Brownian displacements. It does not contain the cube's cumulative positive capacitance series. [TE23]

### 18.4 The same finite inverse-matrix functional in 2019

Cichocki, Rubin, Niedzwiecka, and Szymczak's 2019 paper defines

$$
(A_{2019})_{ij}
=
\frac13\operatorname{tr}
\langle\boldsymbol\mu_{ij}\rangle
$$

and minimizes a quadratic form with the constraint $\mathbf1^{\mathsf T}x=1$. The published solution and diffusion coefficient include

$$
x_{\min}
=
\frac{
A_{2019}^{-1}\mathbf1
}{
\mathbf1^{\mathsf T}A_{2019}^{-1}\mathbf1
}
$$

and

$$
D_s=
\frac{
k_BT
}{
\mathbf1^{\mathsf T}A_{2019}^{-1}\mathbf1
}.
$$

These are equations within (2.16)–(2.21). [CRNS19]

For a fixed geometry with the relevant RPY model, the comparison gives

$$
A_{2019}=\frac{G}{6\pi\eta}.
$$

Using the associated approximate hydrodynamic radius,

$$
R_h^{\mathrm{approx}}
=
\frac{k_BT}{6\pi\eta D_s},
$$

one obtains the same finite functional:

$$
\boxed{
R_h^{\mathrm{approx}}
=
\mathbf1^{\mathsf T}G^{-1}\mathbf1.
}
$$

This was another exact algebraic match identified in the audit.

### 18.5 The 2024 normalization and the sum of all entries

Waszkiewicz and coauthors' 2024 paper uses a differently normalized matrix:

$$
(A_{2024})_{ij}
=
2\pi\eta\,\operatorname{tr}
\langle\boldsymbol\mu_{ij}\rangle,
\qquad
B=A_{2024}^{-1}.
$$

Its equation (4) gives

$$
R_h^{\mathrm{MDA}}
=
\sum_{i,j}B_{ij}
=
\mathbf1^{\mathsf T}A_{2024}^{-1}\mathbf1.
$$

The original equation image was visually checked because the distinction matters:

$$
\sum_{i,j}B_{ij}
\ne
\operatorname{tr}B
$$

in general. [WAS24]

For a fixed configuration,

$$
A_{2024}=G,
$$

whereas

$$
A_{2019}=\frac{G}{6\pi\eta}.
$$

The two papers' matrices called $A$ must not be equated without the normalization factor.

### 18.6 Scope of the physical correspondence

These matches establish that the finite shell kernel and inverse-matrix functional have published antecedents. They do not prove that the exact electrostatic capacitance of every body equals its exact hydrodynamic radius.

The hydrodynamic quantities belong to specified bead approximations and, in some formulas, conformational averaging. The cube construction uses a geometric family of electrostatic trial measures and then takes a refinement limit. The algebraic overlap is exact at the identified level; the physical models and limiting questions remain distinct.

## 19. Other relevant cube and spherical-element literature

### 19.1 Direct electrostatic spherical-element methods

Brown and Hemingway's 1995 paper treats charge distribution and capacitance of agglomerates of spherical particles. Cao and coauthors' 2015 paper describes a minimum-electrostatic-energy method using spherical elements, extended to arbitrary particle shapes, and identifies Brown–Hemingway as an antecedent. [BH95], [CAO15]

These are direct electrostatic method-level predecessors to using spherical elements and energy minimization.

However, the audit did not obtain their complete mathematical texts. The accessible evidence consisted of publisher abstracts and, for Cao, introductory material. An indexed thesis containing related material also could not be retrieved. Therefore the exact coefficients, radius choices, and limiting hierarchies in those works were not verified to match the present construction.

The existence of a related method is supported. Identity of the complete formulas is unresolved.

### 19.2 Earlier cube calculations

Reitan and Higgins's 1951 paper and van Bladel and Mei's 1961 paper belong to the older cube-capacitance literature. The latter's publisher abstract explicitly compares variational and Maxwell subarea methods. [RH51], [VM61]

The original 1951 full text was not inspected in the retained audit; its bibliography was verified through the literature. The 1961 full text was also unavailable. Those access limits prevent a detailed exclusion of every formula in the original articles.

Wintle's 2004 random-walk paper also discusses variational trial solutions and simulated-charge constructions in accessible publisher material. It was relevant to the wider landscape, but its full mathematical text was not obtained. [WIN04]

### 19.3 Extrapolation was already part of cube-capacitance computation

Read's 1997 paper is explicitly about improved extrapolation in boundary-element calculations of the unit square and cube. Accessible author and publisher descriptions discuss canceling leading discretization errors. The 2004 paper likewise combines boundary-element sequences, empirical extrapolation, and singularity information for several geometries. [READ97], [READ04]

These are clear precedents for accelerating a sequence of cube-capacitance discretizations. They do not establish that the exact boundary-shell plus Richardson–Aitken prescription in this conversation appeared there.

The full papers were not obtained. Moreover, accessible descriptions of the 1997 result gave conflicting numerical error figures, so the audit avoided using those figures. This review preserves that decision.

### 19.4 Other analytic and computational approaches

Yong Su's 2009 thesis investigated particular solutions, domain decomposition, and angular eigenfunctions on a seven-eighths sphere in connection with the cube problem. Its reported exponential-convergence success concerned the two-dimensional square. It did not establish a completed comparably rapid scalar series for the three-dimensional cube. [SU09]

Sarkarati, Tehranchi, and Mehrshahi's 2022 paper analytically evaluates rectangular-panel interactions for a method-of-moments capacitance calculation. It shows that avoiding numerical quadrature in matrix assembly is not itself new. The basis and coefficients differ from the purely algebraic shell construction. [STM22]

Gu and coauthors' arXiv work, in the version dated 23 May 2026 inspected during the audit, treats a high-discretization method of moments for a cube and a hollow cylinder. It uses a surface-subarea construction rather than the cumulative shell hierarchy. The review retains the inspected primary arXiv source instead of relying on journal details encountered secondarily. [GU26]

### 19.5 Other search avenues and their limited evidential role

The search also considered classical variational literature, orthogonal-function approaches associated with Bergman and Schiffer, Pólya and Szegő, Laskar's 1971 thesis on boundary integral equations, and broader kernel-capacity analogies.

These avenues did not yield an exact match in the inspected material. They do not justify an exclusion claim for every uninspected chapter or older publication.

The absence of a result from web retrieval is weaker evidence than inspection of a relevant complete paper. The review therefore gives its greatest weight to the explicit formula comparisons in Sections 16–18 and states the remaining access gaps.

## 20. The novelty assessment and final status ledger

### 20.1 What the research did and did not establish

The final assessment was:

1. No exact publication match was located for the cumulative dyadic cube hierarchy with the stated ordering and indexed $z_j$ series.
2. No exact publication match was located for the precise boundary-only grid combined with the selected acceleration.
3. The complete spherical-shell interaction kernel has an exact published counterpart in the RPY literature.
4. The finite inverse-matrix functional and constrained quadratic minimization have explicit published counterparts.
5. Variational capacity approximation, energy projection, Cholesky factorization, and Richardson/Aitken acceleration are established tools.
6. Earlier related papers remained unread, particularly the 1996 EEM work and the 1998 and 2001 Serbian conference papers.
7. Worldwide priority of the exact construction was not established.

A defensible description retained from the conversation is:

> An explicit algebraic realization of classical variational approximation to the cube's Newtonian capacity, using a cumulative dyadic family of uniform spherical-shell measures and Cholesky orthogonalization.

That is a description of the construction. It is not a novelty claim.

### 20.2 Component-by-component assessment

| Component | Assessment from the conversation | Confidence / status |
|---|---|---|
| Classical capacity energy principle | Established prior mathematics | High |
| Finite variational inverse-matrix formula | Explicit antecedents found | High |
| Full uniform-shell kernel, including overlap | Exact trace correspondence with published RPY formula | High |
| Cholesky sum of squares | Standard linear-algebra identity | High |
| Schur-complement increment | Standard block-matrix identity | High |
| Sphere-based approximation of cube electrostatics | Clear Serbian and broader methodological antecedents | High |
| Exact cumulative dyadic dictionary and indexed series | No exact publication match located | Search finding; worldwide priority unknown |
| Exact boundary-only selection and matrix normalization | No exact publication match located | Search finding; worldwide priority unknown |
| Richardson and Aitken acceleration | Standard transformations | High |
| A new general capacitance method | Not supported by the audit | High confidence in this negative assessment |
| One decimal digit per cheap scalar term | Not established | Unresolved |
| A theorem or error bound strong enough to certify practical accuracy | Not established for the accelerated shell sequence | Unresolved |
| Computational superiority over existing specialized solvers | Not tested in a controlled comparison | Unknown |

Possible originality was confined to the particular explicit realization and any additional theorem, useful error bound, convergence analysis, or demonstrated computational advantage. The conversation did not establish those as novel contributions.

### 20.3 Mathematical and numerical status at the end of the discussion

| Statement | Status retained in the review |
|---|---|
| The piecewise shell-energy formula | Exact finite interaction formula |
| $G_N=L_NL_N^{\mathsf T}$ and $\kappa_N=\sum z_j^2$ | Exact finite identities |
| The first five displayed radicals | Recorded algebraic coefficients, previously checked numerically |
| $\kappa_N\le\kappa$ | Variational lower bound |
| Monotonicity of cumulative $\kappa_N$ | Follows from nested trial spaces |
| $\kappa_N\to\kappa$ | Supported by the recorded energy-approximation proof sketch |
| $Q_n=(1/n)\mathbf1^{\mathsf T}M_n^{-1}\mathbf1$ | Exact formula for the boundary trial space |
| $Q_n\le\kappa$ | Variational lower bound |
| $Q_n\to\kappa$ | Supported by the separate boundary approximation sketch |
| Monotonicity of all $Q_n$ | Not proved |
| Correctness of the screenshot's Aitken expression | Exact algebraic equivalence when the denominator is nonzero |
| Prescribed fractional Richardson powers | Empirical / heuristic for these particular spaces |
| Approximately $8.61\times10^{-9}$ Aitken discrepancy | Recorded benchmark comparison |
| Guaranteed decimal accuracy of the acceleration | Not established |
| A complete one-to-six-decimal scalar-term table | Not available in the retained record |
| Novelty of the exact indexed construction | Unknown |

### 20.4 What remains deliberately absent

This review does not insert a new closed one-dimensional integral, continued fraction, special-function solution, rapid scalar series, asymptotic expansion, or experiment.

It also does not reconstruct missing program files and label them original, turn a numerical reference into a certified interval, turn a proof sketch into a completed quantitative theorem, or turn unsuccessful literature searches into proof of nonpublication.

The coherent outcome of the conversation is the combination of an explicit algebraic variational construction, a practically useful acceleration experiment at the reported resolutions, and a provenance investigation that substantially narrowed the scope of any plausible originality claim.

## 21. Bibliography and access status

The references below identify the sources used in the earlier conversation. “Inspected” refers to that investigation. This review has not performed a new literature search.

### Core capacitance formulations and benchmark

**[HP13] Johan Helsing and Karl-Mikael Perfekt.** “On the polarizability and capacitance of the cube.” *Applied and Computational Harmonic Analysis* **34** (2013), 445–468. DOI: [10.1016/j.acha.2012.07.006](https://doi.org/10.1016/j.acha.2012.07.006).  
Primary text: [arXiv PDF](https://arxiv.org/pdf/1203.5997).  
**Access:** Full text inspected. **Locations used:** §6, equations (47)–(50); §8.3, equation (60); §9; Table 1. **Role:** Capacitance formulation, numerical method, and reference value; not the source of the shell series.

**[RAM07] A. G. Ramm.** “Distribution of Particles Which Produces a ‘Smart’ Material.” *Journal of Statistical Physics* **127** (2007), 915–934. DOI: [10.1007/s10955-007-9303-3](https://doi.org/10.1007/s10955-007-9303-3).  
Primary text: [author-hosted PDF](https://www.math.ksu.edu/~ramm/papers/515j.pdf).  
**Access:** Relevant text inspected. **Locations used:** Equations (90)–(94). **Role:** Antecedent for the earlier integral-operator iteration.

**[RAM05] A. G. Ramm.** *Wave Scattering by Small Bodies of Arbitrary Shapes.* World Scientific, 2005.  
Primary text: [author-hosted PDF](https://www.math.ksu.edu/~ramm/papers/476.pdf).  
**Access:** Full book retrieved; relevant sections inspected, without claiming an exhaustive review of every page. **Locations used:** §3.1, Theorem 3.1 and equations (3.12)–(3.15); §3.2, printed page 30, equations (3.29) and (3.32); §4.3, Example 4.2. **Role:** Iterative and variational antecedents.

**[RAM14] A. G. Ramm.** “A variational principle and its application to estimating electrical capacitance of a perfect conductor” (2014).  
Primary text: [author-hosted PDF](https://www.math.ksu.edu/~ramm/papers/626mo.pdf); [arXiv record](https://arxiv.org/abs/1402.3110).  
**Access:** Full short text inspected. **Locations used:** Equations (1.3)–(1.4). **Role:** Explicit statement of the capacity energy principle.

**[BHP19] Timo Betcke, Alexander Haberl, and Dirk Praetorius.** “Adaptive boundary element methods for the computation of the electrostatic capacity on complex polyhedra.” *Journal of Computational Physics* **397** (2019), 108837. DOI: [10.1016/j.jcp.2019.07.036](https://doi.org/10.1016/j.jcp.2019.07.036).  
Primary text: [UCL PDF](https://discovery.ucl.ac.uk/id/eprint/10079516/1/capacity.pdf).  
**Access:** Full text inspected. **Location used:** §2.7, Proposition 4. **Role:** Published inverse-matrix form, lower approximation, and energy-error identity.

### Serbian equivalent-electrode literature and bibliographic gaps

**[VM04] Dragutin M. Veličković and Alenka Milovanović.** “Electrostatic Field of Cube Electrodes.” *Serbian Journal of Electrical Engineering* **1(2)** (2004), 187–198. DOI: [10.2298/SJEE0402187V](https://doi.org/10.2298/SJEE0402187V).  
Primary text: [official PDF](https://doiserbia.nb.rs/img/doi/1451-4869/2004/1451-48690402187V.pdf).  
**Access:** Complete twelve-page paper inspected. **Locations used:** §2 and equations (2)–(4). **Role:** Direct cube-specific equivalent-sphere antecedent, with different placement and radius.

**[KM08] Branko Kolundžija and Alenka Milovanović.** “An Approximate Expression for the Calculation of the Electric Field in Vicinity of the Cube Electrode with Rounded Wedges.” *Facta Universitatis, Electronics and Energetics* **21(1)** (2008), 73–81. DOI: [10.2298/FUEE0801073K](https://doi.org/10.2298/FUEE0801073K).  
Primary text: [official PDF](https://doiserbia.nb.rs/img/doi/0353-3670/2008/0353-36700801073K.pdf).  
**Access:** Full text inspected. **Role:** Prior cube construction with sources on an inner surface; not the present hierarchy.

**[MIL-BIB] Alenka Milovanović, faculty publication list.**  
[Faculty page](https://www.ftn.kg.ac.rs/alenka.milovanovic).  
**Access:** Bibliographic entries inspected. **Role:** Verification of earlier publications; not access to their complete contents.

**[MIL-EVAL] University evaluation document concerning Alenka Milovanović** (file dated 18 June 2012).  
[University PDF](https://kg.ac.rs/uplf/alenka_milovanovic_18062012.pdf).  
**Access:** Relevant publication-list pages inspected. **Location used:** PDF page 5 for the 2001 ETRAN item. **Role:** Primary institutional bibliographic corroboration.

**[MB11] Milovanović and Bjekić, 2011 paper used for its bibliography.** DOI: [10.2478/v10187-011-0040-0](https://doi.org/10.2478/v10187-011-0040-0).  
Primary text: [institutional PDF](https://scidar.kg.ac.rs/bitstream/123456789/9641/1/10.2478-v10187-011-0040-0.pdf).  
**Access:** Relevant reference list inspected. **Locations used:** References 4 and 7. **Role:** Corroboration of the 1996 EEM and 1998 capacitance references. The title is not reconstructed from incomplete retained metadata.

The four unresolved earlier items are listed in full to the extent verified in Section 17.2. Their full texts were not obtained.

### Exact shell-kernel and finite-functional antecedents

**[ZUK14] P. J. Zuk, E. Wajnryb, K. A. Mizerski, and P. Szymczak.** “Rotne–Prager–Yamakawa approximation for different-sized particles in application to macromolecular bead models.” *Journal of Fluid Mechanics* **741**, R5 (2014). DOI: [10.1017/jfm.2013.668](https://doi.org/10.1017/jfm.2013.668).  
Primary text: [author-hosted PDF](https://www.fuw.edu.pl/~piotrek/publications/jfm2014b.pdf).  
**Access:** Full relevant text inspected. **Locations used:** Equations (2.7)–(2.9) and (3.1), including printed page R5-5. **Role:** Exact normalized-trace match to the full unequal-radius shell kernel.

**[CRNS19] Bogdan Cichocki, Marcin Rubin, Anna Niedzwiecka, and Piotr Szymczak.** “Diffusion coefficients of elastic macromolecules.” *Journal of Fluid Mechanics* **878**, R3 (2019). DOI: [10.1017/jfm.2019.652](https://doi.org/10.1017/jfm.2019.652).  
Primary text: [author-hosted PDF](https://www.fuw.edu.pl/~piotrek/publications/JFM2019.pdf).  
**Access:** Full relevant text inspected. **Locations used:** Equations (2.16)–(2.21). **Role:** Constrained quadratic minimization and the same inverse-matrix scalar after normalization.

**[WAS24] Radost Waszkiewicz et al.** “Hydrodynamic Radii of Intrinsically Disordered Proteins: Fast Prediction by Minimum Dissipation Approximation and Experimental Validation.” *Journal of Physical Chemistry Letters* **15(19)** (2024), 5024–5033. DOI: [10.1021/acs.jpclett.4c00312](https://doi.org/10.1021/acs.jpclett.4c00312).  
Primary text: [PubMed Central full text](https://pmc.ncbi.nlm.nih.gov/articles/PMC11103702/).  
**Access:** Full article inspected; equation image visually checked. **Location used:** Equation (4). **Role:** Explicit sum of all entries of an inverse scalar interaction matrix. A supporting-information PDF was not accessible; the complete overlap kernel was independently available in [ZUK14].

**[TE23] John W. Tworek and Adrian H. Elcock.** “Orientationally Averaged Version of the Rotne–Prager–Yamakawa Tensor Provides a Fast but Still Accurate Treatment of Hydrodynamic Interactions in Brownian Dynamics Simulations of Biological Macromolecules.” *Journal of Chemical Theory and Computation* **19(15)** (2023), 5099–5111. DOI: [10.1021/acs.jctc.3c00476](https://doi.org/10.1021/acs.jctc.3c00476).  
Primary text: [PubMed Central full text](https://pmc.ncbi.nlm.nih.gov/articles/PMC10413861/).  
**Access:** Full text and relevant formula images inspected. **Role:** Equal-radius scalar-kernel confirmation and a distinct Cholesky application.

### Electrostatic spherical-element predecessors

**[BH95] R. C. Brown and M. A. Hemingway.** “Electric charge distribution and capacitance of agglomerates of spherical particles: Theory and experimental simulation.” *Journal of Aerosol Science* **26(8)** (1995), 1197–1206. DOI: [10.1016/0021-8502(95)00524-2](https://doi.org/10.1016/0021-8502(95)00524-2).  
[Publisher page](https://www.sciencedirect.com/science/article/abs/pii/0021850295005242).  
**Access:** Abstract inspected; full mathematical text not obtained. **Role:** Direct spherical-particle electrostatic antecedent.

**[CAO15] Cao et al.** “The capacitance and charge of agglomerated nanoparticles during sintering.” *Journal of Aerosol Science* **83** (2015), 1–11. DOI: [10.1016/j.jaerosci.2015.01.002](https://doi.org/10.1016/j.jaerosci.2015.01.002).  
[Publisher page](https://www.sciencedirect.com/science/article/abs/pii/S0021850215000099).  
**Access:** Abstract and accessible introductory material inspected; full paper not obtained. The indexed [thesis route](https://conservancy.umn.edu/bitstreams/8f414610-b2ab-409b-afbf-fe62c81fb551/download) was inaccessible. **Role:** Minimum-energy spherical-element approach for general shapes; exact coefficient comparison remains unverified.

### Cube calculations, extrapolation, and other approaches

**[RH51] Reitan and Higgins.** “Calculation of the Electrical Capacitance of a Cube.” *Journal of Applied Physics* **22** (1951), 223–226. DOI: [10.1063/1.1699929](https://doi.org/10.1063/1.1699929).  
**Access:** Bibliography verified through the literature; original full text not inspected. **Role:** Historical cube-capacitance calculation.

**[VM61] van Bladel and Mei.** “On the capacitance of a cube.” *Applied Scientific Research, Section B* **9** (1961), 267–270. DOI: [10.1007/BF02921813](https://doi.org/10.1007/BF02921813).  
[Publisher page](https://link.springer.com/article/10.1007/BF02921813).  
**Access:** Publisher abstract inspected; full article not obtained. **Role:** Explicit comparison of variational and Maxwell subarea methods.

**[READ97] F. H. Read.** “Improved Extrapolation Technique in the Boundary Element Method to Find the Capacitances of the Unit Square and Cube.” *Journal of Computational Physics* **133(1)** (1997), 1–5. DOI: [10.1006/jcph.1996.5519](https://doi.org/10.1006/jcph.1996.5519).  
[Author publication list](https://electronoptics.com/application-help/publications.html); [publisher author page](https://www.sciencedirect.com/author/7006308978/frank-h-read).  
**Access:** Author and publisher descriptions inspected; full article not obtained. **Role:** Cube-capacitance extrapolation precedent. Conflicting numerical error figures in accessible summaries were not used.

**[READ04] F. H. Read.** “Capacitances and singularities of the unit triangle, square, tetrahedron and cube.” *COMPEL* **23(2)** (2004), 572–578. DOI: [10.1108/03321640410510758](https://doi.org/10.1108/03321640410510758).  
[Publisher page](https://www.emerald.com/compel/article-abstract/23/2/572/87945/Capacitances-and-singularities-of-the-unit?redirectedFrom=fulltext).  
**Access:** Publisher abstract inspected; full article not obtained. **Role:** Boundary-element extrapolation and singularity context.

**[WIN04] Wintle.** “The capacitance of the cube and square plate by random walk methods.” *Journal of Electrostatics* **62** (2004), 51–62. DOI: [10.1016/j.elstat.2004.04.005](https://doi.org/10.1016/j.elstat.2004.04.005).  
[Publisher page](https://www.sciencedirect.com/science/article/abs/pii/S0304388604001044).  
**Access:** Abstract and accessible indexed sections inspected; full article not obtained. **Role:** Random-walk and variational context, including trial-source discussion.

**[SU09] Yong Su.** *Tools for Computing the Capacitance of the Unit Cube and Laplace Eigenfunctions on the Sphere.* Dartmouth thesis, 3 June 2009; advisor Alex Barnett.  
Primary text: [thesis PDF](https://users.flatironinstitute.org/~ahb/dartmouth/notes/YongSu2009thesis.pdf).  
**Access:** Full text retrieved and relevant sections inspected. **Role:** Particular solutions, domain decomposition, and the distinction between rapid two-dimensional square results and the cube problem.

**[STM22] Sarkarati, Tehranchi, and Mehrshahi.** “Precise Calculation of Electrical Capacitance by means of Quadruple Integrals in Method of Moments Technique” (2022).  
Primary text: [arXiv PDF](https://arxiv.org/pdf/2206.04795).  
**Access:** Full relevant text inspected. **Role:** Analytic rectangular-panel interaction integrals and quadrature-free matrix assembly with a different basis.

**[GU26] Gu et al.** “High-Discretization Method of Moments for Capacitance Calculation: A Cube and a Hollow Cylinder.” arXiv:2505.13148; version dated 23 May 2026 inspected.  
Primary text: [arXiv PDF](https://arxiv.org/pdf/2505.13148).  
**Access:** Relevant primary preprint inspected. **Role:** Recent surface-subarea method; not the cumulative shell hierarchy.

**[DLMF] NIST Digital Library of Mathematical Functions, §3.9, “Acceleration of Convergence.”**  
[Section 3.9](https://dlmf.nist.gov/3.9).  
**Access:** Relevant formulas and qualifications inspected. **Locations used:** Equations (3.9.7)–(3.9.8). **Role:** Standard Aitken transformation and convergence qualifications.

---

**Document status:** A retrospective synthesis of the conversation, preserving the distinction between exact finite formulas, convergence sketches, recorded computations, inspected prior art, and unresolved claims. No new scientific results or numerical runs were generated for this review.

[HP13]: https://arxiv.org/pdf/1203.5997
[RAM07]: https://www.math.ksu.edu/~ramm/papers/515j.pdf
[RAM05]: https://www.math.ksu.edu/~ramm/papers/476.pdf
[RAM14]: https://www.math.ksu.edu/~ramm/papers/626mo.pdf
[BHP19]: https://discovery.ucl.ac.uk/id/eprint/10079516/1/capacity.pdf
[VM04]: https://doiserbia.nb.rs/img/doi/1451-4869/2004/1451-48690402187V.pdf
[KM08]: https://doiserbia.nb.rs/img/doi/0353-3670/2008/0353-36700801073K.pdf
[MIL-BIB]: https://www.ftn.kg.ac.rs/alenka.milovanovic
[MIL-EVAL]: https://kg.ac.rs/uplf/alenka_milovanovic_18062012.pdf
[MB11]: https://scidar.kg.ac.rs/bitstream/123456789/9641/1/10.2478-v10187-011-0040-0.pdf
[ZUK14]: https://www.fuw.edu.pl/~piotrek/publications/jfm2014b.pdf
[CRNS19]: https://www.fuw.edu.pl/~piotrek/publications/JFM2019.pdf
[WAS24]: https://pmc.ncbi.nlm.nih.gov/articles/PMC11103702/
[TE23]: https://pmc.ncbi.nlm.nih.gov/articles/PMC10413861/
[BH95]: https://www.sciencedirect.com/science/article/abs/pii/0021850295005242
[CAO15]: https://www.sciencedirect.com/science/article/abs/pii/S0021850215000099
[RH51]: https://doi.org/10.1063/1.1699929
[VM61]: https://link.springer.com/article/10.1007/BF02921813
[READ97]: https://doi.org/10.1006/jcph.1996.5519
[READ04]: https://doi.org/10.1108/03321640410510758
[WIN04]: https://www.sciencedirect.com/science/article/abs/pii/S0304388604001044
[SU09]: https://users.flatironinstitute.org/~ahb/dartmouth/notes/YongSu2009thesis.pdf
[STM22]: https://arxiv.org/pdf/2206.04795
[GU26]: https://arxiv.org/pdf/2505.13148
[DLMF]: https://dlmf.nist.gov/3.9




