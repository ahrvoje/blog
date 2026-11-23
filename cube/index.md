---
title: The capacitance of a cube
date: 2026-11-22
author: Hrvoje Abraham, Fable 5.2
doi: 10.5281/zenodo.24485434
---

A metal sphere of radius $r$ has the capacitance $4\pi\varepsilon_0 r$. For a metal cube no formula is known, only numbers. This post has two series for that number, and two solvers for the second series.

The first series has positive terms and is made of charged spherical shells. Each term is an algebraic number from a closed formula, with no integral. The series is exact, but too slow to give many decimals.

The second series is fast. It has the same structure and is made of charged patches on the faces. The post explains why it is fast.

The first solver stores the matrix of the patch system and factors it, the Cholesky method. It gives 18 digits.

The second solver does not store the matrix, the conjugate gradient method. Each of its steps increases the lower bound, and it gives two more digits:

$$
\small
C_{\text{cube}} = 4\pi\varepsilon_0\, s\,\kappa, \qquad \kappa = 0.660\,678\,154\,099\,567\,999\,16 \pm 10^{-20}
$$

for a cube of side $s$. The error is an estimate from the convergence, not a proved bound. The post ends with an estimate of the cost of more digits.

## The problem

Put the unit cube $K$ at potential 1, in units where the potential of a point charge $q$ at distance $r$ is $q/r$. The charge moves to the surface and settles in an equilibrium distribution $\mu$. Its total is the number $\kappa$. In these units a sphere of radius $r$ holds the charge $r$, so $\kappa$ is the radius of the sphere that is equivalent to the cube.

The density of $\mu$ is not known. It is infinite along the edges and still stronger at the corners, and this is the full difficulty of the problem.

One classical fact makes the problem approachable without the density. Take any charge distribution $\nu$ in the cube, not necessarily in equilibrium, with total charge $q(\nu)$ and energy

$$
E(\nu) = \iint \frac{d\nu(x)\, d\nu(y)}{|x-y|}.
$$

Then

$$
2\,q(\nu) - E(\nu) \;=\; \kappa - E(\mu - \nu) \;\le\; \kappa .
$$

The proof is one line. The potential of $\mu$ is 1 on the whole cube, thus the mutual energy of $\mu$ and $\nu$ is $q(\nu)$, and $E(\mu-\nu) = \kappa - 2q(\nu) + E(\nu)$ cannot be negative. Each guess $\nu$ gives a lower bound for $\kappa$, and the error of the bound is the energy of the error of the guess. A guess with an error of $10^{-8}$ gives $\kappa$ to $10^{-16}$.

Now take $N$ fixed distributions $\sigma_1,\dots,\sigma_N$ of unit charge and let the guess be $\nu = \sum q_j \sigma_j$. The best charges $q_j$ follow from a linear system, and the bound becomes

$$
\kappa_N = \mathbf 1^{\mathsf T} G^{-1}\, \mathbf 1 \;\le\; \kappa, \qquad G_{ij} = E(\sigma_i, \sigma_j).
$$

The system has a physical meaning. The product $(Gq)_i$ is the potential of all the trial charges, averaged over $\sigma_i$. Thus $Gq = \mathbf 1$ says: the potential is 1 on each $\sigma_i$ on average. This is the conductor condition, as far as the family can test it. The bound $\mathbf 1^{\mathsf T} G^{-1} \mathbf 1 = \sum q_j$ is the total charge that does this. In Maxwell's words $G$ is the matrix of the coefficients of potential, and the sum of all entries of its inverse is the capacitance of the parts joined together.

All that is necessary is a family $\sigma_j$ for which the energies $G_{ij}$ are easy.

## Shells

The easiest family is a uniformly charged spherical shell. By Newton's shell theorem, a shell of radius $R$ and unit charge has the potential $1/\max(R, d)$ at distance $d$ from its centre: outside it is a point charge, inside the potential is constant. The energy of two shells of radii $R$ and $S$, with centres at distance $d$, is then elementary:

$$
\small
G(R,S,d)=
\begin{cases}
1/\max(R,S), & d \le |R-S|\\[4pt]
\dfrac{1}{d}\left(1-\dfrac{(R+S-d)^2}{4RS}\right), & |R-S| < d < R+S\\[8pt]
1/d, & d \ge R+S
\end{cases}
$$

The three cases are: one shell inside the other, partial overlap, and shells apart.

For the family, divide the cube into $n^3$ cells and put one shell into each cell, of radius $1/2n$. Do this for $n = 1, 2, 4, 8, \dots$ and keep all the shells of all the grids.

<figure>
<svg viewBox="0 0 720 358" width="720" role="img" aria-label="Left: nested spherical shells of the grids 1, 2 and 4 in a cube. Right: the shells of the outer layer of the grid 8, each with a point charge at its centre." style="max-width:100%;height:auto;font-family:inherit">
<g fill="none" stroke-width="1.4">
<rect x="30.0" y="20.0" width="280.0" height="280.0" stroke="var(--ink)" stroke-width="2"/>
<circle cx="65.0" cy="55.0" r="35.0" stroke="var(--code-function)" fill="var(--code-function)" fill-opacity="0.0"/>
<circle cx="65.0" cy="125.0" r="35.0" stroke="var(--code-function)" fill="var(--code-function)" fill-opacity="0.0"/>
<circle cx="65.0" cy="195.0" r="35.0" stroke="var(--code-function)" fill="var(--code-function)" fill-opacity="0.0"/>
<circle cx="65.0" cy="265.0" r="35.0" stroke="var(--code-function)" fill="var(--code-function)" fill-opacity="0.0"/>
<circle cx="135.0" cy="55.0" r="35.0" stroke="var(--code-function)" fill="var(--code-function)" fill-opacity="0.0"/>
<circle cx="135.0" cy="125.0" r="35.0" stroke="var(--code-function)" fill="var(--code-function)" fill-opacity="0.0"/>
<circle cx="135.0" cy="195.0" r="35.0" stroke="var(--code-function)" fill="var(--code-function)" fill-opacity="0.0"/>
<circle cx="135.0" cy="265.0" r="35.0" stroke="var(--code-function)" fill="var(--code-function)" fill-opacity="0.0"/>
<circle cx="205.0" cy="55.0" r="35.0" stroke="var(--code-function)" fill="var(--code-function)" fill-opacity="0.0"/>
<circle cx="205.0" cy="125.0" r="35.0" stroke="var(--code-function)" fill="var(--code-function)" fill-opacity="0.0"/>
<circle cx="205.0" cy="195.0" r="35.0" stroke="var(--code-function)" fill="var(--code-function)" fill-opacity="0.0"/>
<circle cx="205.0" cy="265.0" r="35.0" stroke="var(--code-function)" fill="var(--code-function)" fill-opacity="0.0"/>
<circle cx="275.0" cy="55.0" r="35.0" stroke="var(--code-function)" fill="var(--code-function)" fill-opacity="0.0"/>
<circle cx="275.0" cy="125.0" r="35.0" stroke="var(--code-function)" fill="var(--code-function)" fill-opacity="0.0"/>
<circle cx="275.0" cy="195.0" r="35.0" stroke="var(--code-function)" fill="var(--code-function)" fill-opacity="0.0"/>
<circle cx="275.0" cy="265.0" r="35.0" stroke="var(--code-function)" fill="var(--code-function)" fill-opacity="0.0"/>
<circle cx="100.0" cy="90.0" r="70.0" stroke="var(--accent)" fill="var(--accent)" fill-opacity="0.0"/>
<circle cx="100.0" cy="230.0" r="70.0" stroke="var(--accent)" fill="var(--accent)" fill-opacity="0.0"/>
<circle cx="240.0" cy="90.0" r="70.0" stroke="var(--accent)" fill="var(--accent)" fill-opacity="0.0"/>
<circle cx="240.0" cy="230.0" r="70.0" stroke="var(--accent)" fill="var(--accent)" fill-opacity="0.0"/>
<circle cx="170.0" cy="160.0" r="140.0" stroke="var(--ink)" fill="var(--ink)" fill-opacity="0.0"/>
<rect x="410.0" y="20.0" width="280.0" height="280.0" stroke="var(--ink)" stroke-width="2"/>
<circle cx="427.5" cy="37.5" r="17.5" stroke="var(--code-function)" fill="var(--code-function)" fill-opacity="0.10"/>
<circle cx="427.5" cy="37.5" r="2.2" fill="var(--accent)" stroke="none"/>
<circle cx="427.5" cy="72.5" r="17.5" stroke="var(--code-function)" fill="var(--code-function)" fill-opacity="0.10"/>
<circle cx="427.5" cy="72.5" r="2.2" fill="var(--accent)" stroke="none"/>
<circle cx="427.5" cy="107.5" r="17.5" stroke="var(--code-function)" fill="var(--code-function)" fill-opacity="0.10"/>
<circle cx="427.5" cy="107.5" r="2.2" fill="var(--accent)" stroke="none"/>
<circle cx="427.5" cy="142.5" r="17.5" stroke="var(--code-function)" fill="var(--code-function)" fill-opacity="0.10"/>
<circle cx="427.5" cy="142.5" r="2.2" fill="var(--accent)" stroke="none"/>
<circle cx="427.5" cy="177.5" r="17.5" stroke="var(--code-function)" fill="var(--code-function)" fill-opacity="0.10"/>
<circle cx="427.5" cy="177.5" r="2.2" fill="var(--accent)" stroke="none"/>
<circle cx="427.5" cy="212.5" r="17.5" stroke="var(--code-function)" fill="var(--code-function)" fill-opacity="0.10"/>
<circle cx="427.5" cy="212.5" r="2.2" fill="var(--accent)" stroke="none"/>
<circle cx="427.5" cy="247.5" r="17.5" stroke="var(--code-function)" fill="var(--code-function)" fill-opacity="0.10"/>
<circle cx="427.5" cy="247.5" r="2.2" fill="var(--accent)" stroke="none"/>
<circle cx="427.5" cy="282.5" r="17.5" stroke="var(--code-function)" fill="var(--code-function)" fill-opacity="0.10"/>
<circle cx="427.5" cy="282.5" r="2.2" fill="var(--accent)" stroke="none"/>
<circle cx="462.5" cy="37.5" r="17.5" stroke="var(--code-function)" fill="var(--code-function)" fill-opacity="0.10"/>
<circle cx="462.5" cy="37.5" r="2.2" fill="var(--accent)" stroke="none"/>
<circle cx="462.5" cy="282.5" r="17.5" stroke="var(--code-function)" fill="var(--code-function)" fill-opacity="0.10"/>
<circle cx="462.5" cy="282.5" r="2.2" fill="var(--accent)" stroke="none"/>
<circle cx="497.5" cy="37.5" r="17.5" stroke="var(--code-function)" fill="var(--code-function)" fill-opacity="0.10"/>
<circle cx="497.5" cy="37.5" r="2.2" fill="var(--accent)" stroke="none"/>
<circle cx="497.5" cy="282.5" r="17.5" stroke="var(--code-function)" fill="var(--code-function)" fill-opacity="0.10"/>
<circle cx="497.5" cy="282.5" r="2.2" fill="var(--accent)" stroke="none"/>
<circle cx="532.5" cy="37.5" r="17.5" stroke="var(--code-function)" fill="var(--code-function)" fill-opacity="0.10"/>
<circle cx="532.5" cy="37.5" r="2.2" fill="var(--accent)" stroke="none"/>
<circle cx="532.5" cy="282.5" r="17.5" stroke="var(--code-function)" fill="var(--code-function)" fill-opacity="0.10"/>
<circle cx="532.5" cy="282.5" r="2.2" fill="var(--accent)" stroke="none"/>
<circle cx="567.5" cy="37.5" r="17.5" stroke="var(--code-function)" fill="var(--code-function)" fill-opacity="0.10"/>
<circle cx="567.5" cy="37.5" r="2.2" fill="var(--accent)" stroke="none"/>
<circle cx="567.5" cy="282.5" r="17.5" stroke="var(--code-function)" fill="var(--code-function)" fill-opacity="0.10"/>
<circle cx="567.5" cy="282.5" r="2.2" fill="var(--accent)" stroke="none"/>
<circle cx="602.5" cy="37.5" r="17.5" stroke="var(--code-function)" fill="var(--code-function)" fill-opacity="0.10"/>
<circle cx="602.5" cy="37.5" r="2.2" fill="var(--accent)" stroke="none"/>
<circle cx="602.5" cy="282.5" r="17.5" stroke="var(--code-function)" fill="var(--code-function)" fill-opacity="0.10"/>
<circle cx="602.5" cy="282.5" r="2.2" fill="var(--accent)" stroke="none"/>
<circle cx="637.5" cy="37.5" r="17.5" stroke="var(--code-function)" fill="var(--code-function)" fill-opacity="0.10"/>
<circle cx="637.5" cy="37.5" r="2.2" fill="var(--accent)" stroke="none"/>
<circle cx="637.5" cy="282.5" r="17.5" stroke="var(--code-function)" fill="var(--code-function)" fill-opacity="0.10"/>
<circle cx="637.5" cy="282.5" r="2.2" fill="var(--accent)" stroke="none"/>
<circle cx="672.5" cy="37.5" r="17.5" stroke="var(--code-function)" fill="var(--code-function)" fill-opacity="0.10"/>
<circle cx="672.5" cy="37.5" r="2.2" fill="var(--accent)" stroke="none"/>
<circle cx="672.5" cy="72.5" r="17.5" stroke="var(--code-function)" fill="var(--code-function)" fill-opacity="0.10"/>
<circle cx="672.5" cy="72.5" r="2.2" fill="var(--accent)" stroke="none"/>
<circle cx="672.5" cy="107.5" r="17.5" stroke="var(--code-function)" fill="var(--code-function)" fill-opacity="0.10"/>
<circle cx="672.5" cy="107.5" r="2.2" fill="var(--accent)" stroke="none"/>
<circle cx="672.5" cy="142.5" r="17.5" stroke="var(--code-function)" fill="var(--code-function)" fill-opacity="0.10"/>
<circle cx="672.5" cy="142.5" r="2.2" fill="var(--accent)" stroke="none"/>
<circle cx="672.5" cy="177.5" r="17.5" stroke="var(--code-function)" fill="var(--code-function)" fill-opacity="0.10"/>
<circle cx="672.5" cy="177.5" r="2.2" fill="var(--accent)" stroke="none"/>
<circle cx="672.5" cy="212.5" r="17.5" stroke="var(--code-function)" fill="var(--code-function)" fill-opacity="0.10"/>
<circle cx="672.5" cy="212.5" r="2.2" fill="var(--accent)" stroke="none"/>
<circle cx="672.5" cy="247.5" r="17.5" stroke="var(--code-function)" fill="var(--code-function)" fill-opacity="0.10"/>
<circle cx="672.5" cy="247.5" r="2.2" fill="var(--accent)" stroke="none"/>
<circle cx="672.5" cy="282.5" r="17.5" stroke="var(--code-function)" fill="var(--code-function)" fill-opacity="0.10"/>
<circle cx="672.5" cy="282.5" r="2.2" fill="var(--accent)" stroke="none"/>
<line x1="427.5" y1="107.5" x2="532.5" y2="282.5" stroke="var(--muted)" stroke-dasharray="5 4"/>
</g>
<g fill="var(--ink)" font-size="17" text-anchor="middle">
<text x="510.0" y="195.0" fill="var(--muted)" font-style="italic">1/d</text>
<text x="170.0" y="328.0">all shells of the grids 1, 2, 4, …</text>
<text x="170.0" y="349.0" fill="var(--muted)" font-size="15">each new shell adds one term to the series</text>
<text x="550.0" y="328.0">outer layer of one grid, here n = 8</text>
<text x="550.0" y="349.0" fill="var(--muted)" font-size="15">outside, a shell acts as a point charge</text>
</g>
</svg>
<figcaption>Trial charges in a cross-section of the cube. Left: the nested family that gives the series. Right: the cheaper family that keeps only the shells next to the surface.</figcaption>
</figure>

Order the shells by grid, and in a grid by position. The matrix $G$ of the first $N$ shells is the top left corner of the matrix of the first $N+1$ shells. Its Cholesky factor $G = LL^{\mathsf T}$ has the same property, and with $z = L^{-1}\mathbf 1$

$$
\small
\kappa_N = \mathbf 1^{\mathsf T} G^{-1} \mathbf 1 = \lVert L^{-1}\mathbf 1\rVert^2 = \sum_{j<N} z_j^2,
\qquad
\kappa = \sum_{j=0}^{\infty} z_j^2 .
$$

Each new shell adds one term. The term is not negative, and the terms before it do not change.

The three objects have a simple meaning. $G$ holds the energies of the shells. $L$ makes the shells independent: it is the Gram–Schmidt process with the energy as the scalar product, and it replaces the shells one by one with charge distributions $e_0, e_1, \dots$ that have unit energy and zero mutual energy. The number $z_j$ is the total charge of $e_j$. The series is then Parseval's identity: the equilibrium charge is $\sum z_j e_j$, and its energy $\kappa$ is $\sum z_j^2$.

The series is also a recursion. Shell $n$ needs its energies $G_{nj}$ with the shells before it and the rows of $L$ before it:

$$
\small
\begin{gathered}
L_{nj} = \frac{1}{L_{jj}}\Big(G_{nj} - \sum_{k<j} L_{nk} L_{jk}\Big), \qquad
L_{nn}^2 = G_{nn} - \sum_{k<n} L_{nk}^2, \\[6pt]
z_n = \frac{1}{L_{nn}}\Big(1 - \sum_{k<n} L_{nk}\, z_k\Big).
\end{gathered}
$$

The sum in $z_n$ is the potential of the best charge so far, averaged over the new shell, so the numerator is what the potential there still lacks to 1. $L_{nn}^2$ is the energy of the part of the new shell that the earlier shells cannot imitate. The new term $z_n^2$ is the square of the first divided by the second. The recursion keeps all earlier rows: term $n$ costs about $n^2$ operations.

By hand, for the first two shells: the inscribed sphere has $G_{00} = 1/R = 2$, thus $L_{00} = \sqrt2$ and $z_0 = 1/\sqrt2$. The second shell has the radius $\frac14$ and the distance $\frac{\sqrt3}{4}$ to the first one. They overlap, and the energy formula gives $G_{10} = 3 - \frac{2}{\sqrt3}$ and $G_{11} = 4$. Then $L_{10} = G_{10}/\sqrt2$, $L_{11}^2 = 4 - G_{10}^2/2 = 2\sqrt3 - \frac76$ and $z_1 = (1 - G_{10}/2)/L_{11}$.

The centres and radii are rational, the distances are square roots of rationals, and the recursion needs only arithmetic and square roots, so each $z_j$ is an algebraic number. The first two are

$$
z_0^2 = \frac12, \qquad z_1^2 = \frac{\left(\frac1{\sqrt3}-\frac12\right)^2}{2\sqrt3-\frac76} = 0.002604\ldots
$$

The first term is the sphere inscribed in the cube. The partial sums at the end of each grid:

| Grid | Terms | Partial sum | Error |
|---:|---:|:---|:---|
| 1 | 1 | 0.500000000 | 0.16 |
| 2 | 9 | 0.526938289 | 0.13 |
| 4 | 73 | 0.586840900 | 0.074 |
| 8 | 585 | 0.620510985 | 0.040 |
| 16 | 4 681 | 0.639356611 | 0.021 |
| 32 | 37 449 | 0.649547183 | 0.011 |
| 64 | 299 593 | 0.654930553 | 0.0057 |

The series is exact and its terms are explicit, but eight times more terms halve the error. Twenty digits would need about $10^{59}$ terms.

## Why it is slow

The charge is on the surface, so the shells deep in the cube do little. Keep only the outer layer of one grid (the right side of the figure). These shells have equal radii and do not overlap, and the matrix becomes very simple:

$$
Q_n = \frac1n\, \mathbf 1^{\mathsf T} M^{-1} \mathbf 1, \qquad M_{kk} = 2, \quad M_{k\ell} = \frac{1}{|k-\ell|},
$$

where $k$ and $\ell$ are the integer positions of the cells. The cube has 48 symmetries, so the system has one unknown for each orbit of cells: 8 256 unknowns for the 390 152 shells of $n = 256$.

| $n$ | Shells | $Q_n$ | Error |
|---:|---:|:---|:---|
| 16 | 1 352 | 0.638074892611 | 0.023 |
| 32 | 5 768 | 0.648744830566 | 0.012 |
| 64 | 23 816 | 0.654459967974 | 0.0062 |
| 128 | 96 776 | 0.657468745801 | 0.0032 |
| 256 | 390 152 | 0.659033442870 | 0.0016 |
| 512 | 1 566 728 | 0.659839854768 | 0.00084 |

The error is close to $0.43/n$. Richardson extrapolation removes an error term $c\,n^{-p}$ from two values, $(2^p Q_{2n} - Q_n)/(2^p-1)$. The data show the powers $1$ and $4/3$ clearly, and then the powers come close to each other. With the powers $1, 4/3, 5/3, 2$ the values up to $n = 256$ give $0.66067827$, with an error of $1.2\cdot10^{-7}$, and up to $n = 512$ the error is $3\cdot10^{-8}$. More powers gave me 8 digits, not more.

The reason is the edges. Near an edge the density grows like $d^{-1/3}$, where $d$ is the distance to the edge, and at a corner it grows faster, with an irrational power. Each of these adds its own sequence of fractional powers of $1/n$ to the error. A sphere has the same size in all directions. To follow the density at distance $d$ from an edge, the shells there must have a radius near $d$, and then $1/d$ of them are necessary along the edge. No arrangement of shells escapes this count.

## Patches

The cure is to let the trial charges become thin. Put the charge on the faces, on rectangular patches that are a fixed fraction of the neighbour patch in the direction of each edge. Twenty-three layers reach from the centre of a face to $10^{-13}$ from the edge. On each patch the density is a polynomial, of a higher degree on the large patches in the middle and of a low degree on the small ones near the edges.

<figure>
<svg viewBox="0 0 720 358" width="720" role="img" aria-label="Left: a face of the cube divided into rectangular patches that become thin near the edges. Right: the charge density across the face, which grows without limit at the edges." style="max-width:100%;height:auto;font-family:inherit">
<g fill="none" stroke-width="1">
<rect x="30.0" y="20.0" width="0.4" height="0.4" fill="var(--code-function)" fill-opacity="0.03" stroke="none"/>
<rect x="30.0" y="20.4" width="0.4" height="0.8" fill="var(--code-function)" fill-opacity="0.03" stroke="none"/>
<rect x="30.0" y="21.1" width="0.4" height="2.3" fill="var(--code-function)" fill-opacity="0.03" stroke="none"/>
<rect x="30.0" y="23.4" width="0.4" height="6.6" fill="var(--code-function)" fill-opacity="0.03" stroke="none"/>
<rect x="30.0" y="30.0" width="0.4" height="18.0" fill="var(--code-function)" fill-opacity="0.03" stroke="none"/>
<rect x="30.0" y="47.9" width="0.4" height="42.0" fill="var(--code-function)" fill-opacity="0.03" stroke="none"/>
<rect x="30.0" y="89.9" width="0.4" height="70.1" fill="var(--code-function)" fill-opacity="0.03" stroke="none"/>
<rect x="30.0" y="160.0" width="0.4" height="0.0" fill="var(--code-function)" fill-opacity="0.03" stroke="none"/>
<rect x="30.0" y="160.0" width="0.4" height="70.1" fill="var(--code-function)" fill-opacity="0.03" stroke="none"/>
<rect x="30.0" y="230.1" width="0.4" height="42.0" fill="var(--code-function)" fill-opacity="0.03" stroke="none"/>
<rect x="30.0" y="272.1" width="0.4" height="18.0" fill="var(--code-function)" fill-opacity="0.03" stroke="none"/>
<rect x="30.0" y="290.0" width="0.4" height="6.6" fill="var(--code-function)" fill-opacity="0.03" stroke="none"/>
<rect x="30.0" y="296.6" width="0.4" height="2.3" fill="var(--code-function)" fill-opacity="0.03" stroke="none"/>
<rect x="30.0" y="298.9" width="0.4" height="0.8" fill="var(--code-function)" fill-opacity="0.03" stroke="none"/>
<rect x="30.0" y="299.6" width="0.4" height="0.4" fill="var(--code-function)" fill-opacity="0.03" stroke="none"/>
<rect x="30.4" y="20.0" width="0.8" height="0.4" fill="var(--code-function)" fill-opacity="0.03" stroke="none"/>
<rect x="30.4" y="20.4" width="0.8" height="0.8" fill="var(--code-function)" fill-opacity="0.06" stroke="none"/>
<rect x="30.4" y="21.1" width="0.8" height="2.3" fill="var(--code-function)" fill-opacity="0.06" stroke="none"/>
<rect x="30.4" y="23.4" width="0.8" height="6.6" fill="var(--code-function)" fill-opacity="0.06" stroke="none"/>
<rect x="30.4" y="30.0" width="0.8" height="18.0" fill="var(--code-function)" fill-opacity="0.06" stroke="none"/>
<rect x="30.4" y="47.9" width="0.8" height="42.0" fill="var(--code-function)" fill-opacity="0.06" stroke="none"/>
<rect x="30.4" y="89.9" width="0.8" height="70.1" fill="var(--code-function)" fill-opacity="0.06" stroke="none"/>
<rect x="30.4" y="160.0" width="0.8" height="0.0" fill="var(--code-function)" fill-opacity="0.06" stroke="none"/>
<rect x="30.4" y="160.0" width="0.8" height="70.1" fill="var(--code-function)" fill-opacity="0.06" stroke="none"/>
<rect x="30.4" y="230.1" width="0.8" height="42.0" fill="var(--code-function)" fill-opacity="0.06" stroke="none"/>
<rect x="30.4" y="272.1" width="0.8" height="18.0" fill="var(--code-function)" fill-opacity="0.06" stroke="none"/>
<rect x="30.4" y="290.0" width="0.8" height="6.6" fill="var(--code-function)" fill-opacity="0.06" stroke="none"/>
<rect x="30.4" y="296.6" width="0.8" height="2.3" fill="var(--code-function)" fill-opacity="0.06" stroke="none"/>
<rect x="30.4" y="298.9" width="0.8" height="0.8" fill="var(--code-function)" fill-opacity="0.06" stroke="none"/>
<rect x="30.4" y="299.6" width="0.8" height="0.4" fill="var(--code-function)" fill-opacity="0.03" stroke="none"/>
<rect x="31.1" y="20.0" width="2.3" height="0.4" fill="var(--code-function)" fill-opacity="0.03" stroke="none"/>
<rect x="31.1" y="20.4" width="2.3" height="0.8" fill="var(--code-function)" fill-opacity="0.06" stroke="none"/>
<rect x="31.1" y="21.1" width="2.3" height="2.3" fill="var(--code-function)" fill-opacity="0.09" stroke="none"/>
<rect x="31.1" y="23.4" width="2.3" height="6.6" fill="var(--code-function)" fill-opacity="0.09" stroke="none"/>
<rect x="31.1" y="30.0" width="2.3" height="18.0" fill="var(--code-function)" fill-opacity="0.09" stroke="none"/>
<rect x="31.1" y="47.9" width="2.3" height="42.0" fill="var(--code-function)" fill-opacity="0.09" stroke="none"/>
<rect x="31.1" y="89.9" width="2.3" height="70.1" fill="var(--code-function)" fill-opacity="0.09" stroke="none"/>
<rect x="31.1" y="160.0" width="2.3" height="0.0" fill="var(--code-function)" fill-opacity="0.09" stroke="none"/>
<rect x="31.1" y="160.0" width="2.3" height="70.1" fill="var(--code-function)" fill-opacity="0.09" stroke="none"/>
<rect x="31.1" y="230.1" width="2.3" height="42.0" fill="var(--code-function)" fill-opacity="0.09" stroke="none"/>
<rect x="31.1" y="272.1" width="2.3" height="18.0" fill="var(--code-function)" fill-opacity="0.09" stroke="none"/>
<rect x="31.1" y="290.0" width="2.3" height="6.6" fill="var(--code-function)" fill-opacity="0.09" stroke="none"/>
<rect x="31.1" y="296.6" width="2.3" height="2.3" fill="var(--code-function)" fill-opacity="0.09" stroke="none"/>
<rect x="31.1" y="298.9" width="2.3" height="0.8" fill="var(--code-function)" fill-opacity="0.06" stroke="none"/>
<rect x="31.1" y="299.6" width="2.3" height="0.4" fill="var(--code-function)" fill-opacity="0.03" stroke="none"/>
<rect x="33.4" y="20.0" width="6.6" height="0.4" fill="var(--code-function)" fill-opacity="0.03" stroke="none"/>
<rect x="33.4" y="20.4" width="6.6" height="0.8" fill="var(--code-function)" fill-opacity="0.06" stroke="none"/>
<rect x="33.4" y="21.1" width="6.6" height="2.3" fill="var(--code-function)" fill-opacity="0.09" stroke="none"/>
<rect x="33.4" y="23.4" width="6.6" height="6.6" fill="var(--code-function)" fill-opacity="0.12" stroke="none"/>
<rect x="33.4" y="30.0" width="6.6" height="18.0" fill="var(--code-function)" fill-opacity="0.12" stroke="none"/>
<rect x="33.4" y="47.9" width="6.6" height="42.0" fill="var(--code-function)" fill-opacity="0.12" stroke="none"/>
<rect x="33.4" y="89.9" width="6.6" height="70.1" fill="var(--code-function)" fill-opacity="0.12" stroke="none"/>
<rect x="33.4" y="160.0" width="6.6" height="0.0" fill="var(--code-function)" fill-opacity="0.12" stroke="none"/>
<rect x="33.4" y="160.0" width="6.6" height="70.1" fill="var(--code-function)" fill-opacity="0.12" stroke="none"/>
<rect x="33.4" y="230.1" width="6.6" height="42.0" fill="var(--code-function)" fill-opacity="0.12" stroke="none"/>
<rect x="33.4" y="272.1" width="6.6" height="18.0" fill="var(--code-function)" fill-opacity="0.12" stroke="none"/>
<rect x="33.4" y="290.0" width="6.6" height="6.6" fill="var(--code-function)" fill-opacity="0.12" stroke="none"/>
<rect x="33.4" y="296.6" width="6.6" height="2.3" fill="var(--code-function)" fill-opacity="0.09" stroke="none"/>
<rect x="33.4" y="298.9" width="6.6" height="0.8" fill="var(--code-function)" fill-opacity="0.06" stroke="none"/>
<rect x="33.4" y="299.6" width="6.6" height="0.4" fill="var(--code-function)" fill-opacity="0.03" stroke="none"/>
<rect x="40.0" y="20.0" width="18.0" height="0.4" fill="var(--code-function)" fill-opacity="0.03" stroke="none"/>
<rect x="40.0" y="20.4" width="18.0" height="0.8" fill="var(--code-function)" fill-opacity="0.06" stroke="none"/>
<rect x="40.0" y="21.1" width="18.0" height="2.3" fill="var(--code-function)" fill-opacity="0.09" stroke="none"/>
<rect x="40.0" y="23.4" width="18.0" height="6.6" fill="var(--code-function)" fill-opacity="0.12" stroke="none"/>
<rect x="40.0" y="30.0" width="18.0" height="18.0" fill="var(--code-function)" fill-opacity="0.15" stroke="none"/>
<rect x="40.0" y="47.9" width="18.0" height="42.0" fill="var(--code-function)" fill-opacity="0.15" stroke="none"/>
<rect x="40.0" y="89.9" width="18.0" height="70.1" fill="var(--code-function)" fill-opacity="0.15" stroke="none"/>
<rect x="40.0" y="160.0" width="18.0" height="0.0" fill="var(--code-function)" fill-opacity="0.15" stroke="none"/>
<rect x="40.0" y="160.0" width="18.0" height="70.1" fill="var(--code-function)" fill-opacity="0.15" stroke="none"/>
<rect x="40.0" y="230.1" width="18.0" height="42.0" fill="var(--code-function)" fill-opacity="0.15" stroke="none"/>
<rect x="40.0" y="272.1" width="18.0" height="18.0" fill="var(--code-function)" fill-opacity="0.15" stroke="none"/>
<rect x="40.0" y="290.0" width="18.0" height="6.6" fill="var(--code-function)" fill-opacity="0.12" stroke="none"/>
<rect x="40.0" y="296.6" width="18.0" height="2.3" fill="var(--code-function)" fill-opacity="0.09" stroke="none"/>
<rect x="40.0" y="298.9" width="18.0" height="0.8" fill="var(--code-function)" fill-opacity="0.06" stroke="none"/>
<rect x="40.0" y="299.6" width="18.0" height="0.4" fill="var(--code-function)" fill-opacity="0.03" stroke="none"/>
<rect x="57.9" y="20.0" width="42.0" height="0.4" fill="var(--code-function)" fill-opacity="0.03" stroke="none"/>
<rect x="57.9" y="20.4" width="42.0" height="0.8" fill="var(--code-function)" fill-opacity="0.06" stroke="none"/>
<rect x="57.9" y="21.1" width="42.0" height="2.3" fill="var(--code-function)" fill-opacity="0.09" stroke="none"/>
<rect x="57.9" y="23.4" width="42.0" height="6.6" fill="var(--code-function)" fill-opacity="0.12" stroke="none"/>
<rect x="57.9" y="30.0" width="42.0" height="18.0" fill="var(--code-function)" fill-opacity="0.15" stroke="none"/>
<rect x="57.9" y="47.9" width="42.0" height="42.0" fill="var(--code-function)" fill-opacity="0.18" stroke="none"/>
<rect x="57.9" y="89.9" width="42.0" height="70.1" fill="var(--code-function)" fill-opacity="0.18" stroke="none"/>
<rect x="57.9" y="160.0" width="42.0" height="0.0" fill="var(--code-function)" fill-opacity="0.18" stroke="none"/>
<rect x="57.9" y="160.0" width="42.0" height="70.1" fill="var(--code-function)" fill-opacity="0.18" stroke="none"/>
<rect x="57.9" y="230.1" width="42.0" height="42.0" fill="var(--code-function)" fill-opacity="0.18" stroke="none"/>
<rect x="57.9" y="272.1" width="42.0" height="18.0" fill="var(--code-function)" fill-opacity="0.15" stroke="none"/>
<rect x="57.9" y="290.0" width="42.0" height="6.6" fill="var(--code-function)" fill-opacity="0.12" stroke="none"/>
<rect x="57.9" y="296.6" width="42.0" height="2.3" fill="var(--code-function)" fill-opacity="0.09" stroke="none"/>
<rect x="57.9" y="298.9" width="42.0" height="0.8" fill="var(--code-function)" fill-opacity="0.06" stroke="none"/>
<rect x="57.9" y="299.6" width="42.0" height="0.4" fill="var(--code-function)" fill-opacity="0.03" stroke="none"/>
<rect x="99.9" y="20.0" width="70.1" height="0.4" fill="var(--code-function)" fill-opacity="0.03" stroke="none"/>
<rect x="99.9" y="20.4" width="70.1" height="0.8" fill="var(--code-function)" fill-opacity="0.06" stroke="none"/>
<rect x="99.9" y="21.1" width="70.1" height="2.3" fill="var(--code-function)" fill-opacity="0.09" stroke="none"/>
<rect x="99.9" y="23.4" width="70.1" height="6.6" fill="var(--code-function)" fill-opacity="0.12" stroke="none"/>
<rect x="99.9" y="30.0" width="70.1" height="18.0" fill="var(--code-function)" fill-opacity="0.15" stroke="none"/>
<rect x="99.9" y="47.9" width="70.1" height="42.0" fill="var(--code-function)" fill-opacity="0.18" stroke="none"/>
<rect x="99.9" y="89.9" width="70.1" height="70.1" fill="var(--code-function)" fill-opacity="0.21" stroke="none"/>
<rect x="99.9" y="160.0" width="70.1" height="0.0" fill="var(--code-function)" fill-opacity="0.21" stroke="none"/>
<rect x="99.9" y="160.0" width="70.1" height="70.1" fill="var(--code-function)" fill-opacity="0.21" stroke="none"/>
<rect x="99.9" y="230.1" width="70.1" height="42.0" fill="var(--code-function)" fill-opacity="0.18" stroke="none"/>
<rect x="99.9" y="272.1" width="70.1" height="18.0" fill="var(--code-function)" fill-opacity="0.15" stroke="none"/>
<rect x="99.9" y="290.0" width="70.1" height="6.6" fill="var(--code-function)" fill-opacity="0.12" stroke="none"/>
<rect x="99.9" y="296.6" width="70.1" height="2.3" fill="var(--code-function)" fill-opacity="0.09" stroke="none"/>
<rect x="99.9" y="298.9" width="70.1" height="0.8" fill="var(--code-function)" fill-opacity="0.06" stroke="none"/>
<rect x="99.9" y="299.6" width="70.1" height="0.4" fill="var(--code-function)" fill-opacity="0.03" stroke="none"/>
<rect x="170.0" y="20.0" width="0.0" height="0.4" fill="var(--code-function)" fill-opacity="0.03" stroke="none"/>
<rect x="170.0" y="20.4" width="0.0" height="0.8" fill="var(--code-function)" fill-opacity="0.06" stroke="none"/>
<rect x="170.0" y="21.1" width="0.0" height="2.3" fill="var(--code-function)" fill-opacity="0.09" stroke="none"/>
<rect x="170.0" y="23.4" width="0.0" height="6.6" fill="var(--code-function)" fill-opacity="0.12" stroke="none"/>
<rect x="170.0" y="30.0" width="0.0" height="18.0" fill="var(--code-function)" fill-opacity="0.15" stroke="none"/>
<rect x="170.0" y="47.9" width="0.0" height="42.0" fill="var(--code-function)" fill-opacity="0.18" stroke="none"/>
<rect x="170.0" y="89.9" width="0.0" height="70.1" fill="var(--code-function)" fill-opacity="0.21" stroke="none"/>
<rect x="170.0" y="160.0" width="0.0" height="0.0" fill="var(--code-function)" fill-opacity="0.24" stroke="none"/>
<rect x="170.0" y="160.0" width="0.0" height="70.1" fill="var(--code-function)" fill-opacity="0.21" stroke="none"/>
<rect x="170.0" y="230.1" width="0.0" height="42.0" fill="var(--code-function)" fill-opacity="0.18" stroke="none"/>
<rect x="170.0" y="272.1" width="0.0" height="18.0" fill="var(--code-function)" fill-opacity="0.15" stroke="none"/>
<rect x="170.0" y="290.0" width="0.0" height="6.6" fill="var(--code-function)" fill-opacity="0.12" stroke="none"/>
<rect x="170.0" y="296.6" width="0.0" height="2.3" fill="var(--code-function)" fill-opacity="0.09" stroke="none"/>
<rect x="170.0" y="298.9" width="0.0" height="0.8" fill="var(--code-function)" fill-opacity="0.06" stroke="none"/>
<rect x="170.0" y="299.6" width="0.0" height="0.4" fill="var(--code-function)" fill-opacity="0.03" stroke="none"/>
<rect x="170.0" y="20.0" width="70.1" height="0.4" fill="var(--code-function)" fill-opacity="0.03" stroke="none"/>
<rect x="170.0" y="20.4" width="70.1" height="0.8" fill="var(--code-function)" fill-opacity="0.06" stroke="none"/>
<rect x="170.0" y="21.1" width="70.1" height="2.3" fill="var(--code-function)" fill-opacity="0.09" stroke="none"/>
<rect x="170.0" y="23.4" width="70.1" height="6.6" fill="var(--code-function)" fill-opacity="0.12" stroke="none"/>
<rect x="170.0" y="30.0" width="70.1" height="18.0" fill="var(--code-function)" fill-opacity="0.15" stroke="none"/>
<rect x="170.0" y="47.9" width="70.1" height="42.0" fill="var(--code-function)" fill-opacity="0.18" stroke="none"/>
<rect x="170.0" y="89.9" width="70.1" height="70.1" fill="var(--code-function)" fill-opacity="0.21" stroke="none"/>
<rect x="170.0" y="160.0" width="70.1" height="0.0" fill="var(--code-function)" fill-opacity="0.21" stroke="none"/>
<rect x="170.0" y="160.0" width="70.1" height="70.1" fill="var(--code-function)" fill-opacity="0.21" stroke="none"/>
<rect x="170.0" y="230.1" width="70.1" height="42.0" fill="var(--code-function)" fill-opacity="0.18" stroke="none"/>
<rect x="170.0" y="272.1" width="70.1" height="18.0" fill="var(--code-function)" fill-opacity="0.15" stroke="none"/>
<rect x="170.0" y="290.0" width="70.1" height="6.6" fill="var(--code-function)" fill-opacity="0.12" stroke="none"/>
<rect x="170.0" y="296.6" width="70.1" height="2.3" fill="var(--code-function)" fill-opacity="0.09" stroke="none"/>
<rect x="170.0" y="298.9" width="70.1" height="0.8" fill="var(--code-function)" fill-opacity="0.06" stroke="none"/>
<rect x="170.0" y="299.6" width="70.1" height="0.4" fill="var(--code-function)" fill-opacity="0.03" stroke="none"/>
<rect x="240.1" y="20.0" width="42.0" height="0.4" fill="var(--code-function)" fill-opacity="0.03" stroke="none"/>
<rect x="240.1" y="20.4" width="42.0" height="0.8" fill="var(--code-function)" fill-opacity="0.06" stroke="none"/>
<rect x="240.1" y="21.1" width="42.0" height="2.3" fill="var(--code-function)" fill-opacity="0.09" stroke="none"/>
<rect x="240.1" y="23.4" width="42.0" height="6.6" fill="var(--code-function)" fill-opacity="0.12" stroke="none"/>
<rect x="240.1" y="30.0" width="42.0" height="18.0" fill="var(--code-function)" fill-opacity="0.15" stroke="none"/>
<rect x="240.1" y="47.9" width="42.0" height="42.0" fill="var(--code-function)" fill-opacity="0.18" stroke="none"/>
<rect x="240.1" y="89.9" width="42.0" height="70.1" fill="var(--code-function)" fill-opacity="0.18" stroke="none"/>
<rect x="240.1" y="160.0" width="42.0" height="0.0" fill="var(--code-function)" fill-opacity="0.18" stroke="none"/>
<rect x="240.1" y="160.0" width="42.0" height="70.1" fill="var(--code-function)" fill-opacity="0.18" stroke="none"/>
<rect x="240.1" y="230.1" width="42.0" height="42.0" fill="var(--code-function)" fill-opacity="0.18" stroke="none"/>
<rect x="240.1" y="272.1" width="42.0" height="18.0" fill="var(--code-function)" fill-opacity="0.15" stroke="none"/>
<rect x="240.1" y="290.0" width="42.0" height="6.6" fill="var(--code-function)" fill-opacity="0.12" stroke="none"/>
<rect x="240.1" y="296.6" width="42.0" height="2.3" fill="var(--code-function)" fill-opacity="0.09" stroke="none"/>
<rect x="240.1" y="298.9" width="42.0" height="0.8" fill="var(--code-function)" fill-opacity="0.06" stroke="none"/>
<rect x="240.1" y="299.6" width="42.0" height="0.4" fill="var(--code-function)" fill-opacity="0.03" stroke="none"/>
<rect x="282.1" y="20.0" width="18.0" height="0.4" fill="var(--code-function)" fill-opacity="0.03" stroke="none"/>
<rect x="282.1" y="20.4" width="18.0" height="0.8" fill="var(--code-function)" fill-opacity="0.06" stroke="none"/>
<rect x="282.1" y="21.1" width="18.0" height="2.3" fill="var(--code-function)" fill-opacity="0.09" stroke="none"/>
<rect x="282.1" y="23.4" width="18.0" height="6.6" fill="var(--code-function)" fill-opacity="0.12" stroke="none"/>
<rect x="282.1" y="30.0" width="18.0" height="18.0" fill="var(--code-function)" fill-opacity="0.15" stroke="none"/>
<rect x="282.1" y="47.9" width="18.0" height="42.0" fill="var(--code-function)" fill-opacity="0.15" stroke="none"/>
<rect x="282.1" y="89.9" width="18.0" height="70.1" fill="var(--code-function)" fill-opacity="0.15" stroke="none"/>
<rect x="282.1" y="160.0" width="18.0" height="0.0" fill="var(--code-function)" fill-opacity="0.15" stroke="none"/>
<rect x="282.1" y="160.0" width="18.0" height="70.1" fill="var(--code-function)" fill-opacity="0.15" stroke="none"/>
<rect x="282.1" y="230.1" width="18.0" height="42.0" fill="var(--code-function)" fill-opacity="0.15" stroke="none"/>
<rect x="282.1" y="272.1" width="18.0" height="18.0" fill="var(--code-function)" fill-opacity="0.15" stroke="none"/>
<rect x="282.1" y="290.0" width="18.0" height="6.6" fill="var(--code-function)" fill-opacity="0.12" stroke="none"/>
<rect x="282.1" y="296.6" width="18.0" height="2.3" fill="var(--code-function)" fill-opacity="0.09" stroke="none"/>
<rect x="282.1" y="298.9" width="18.0" height="0.8" fill="var(--code-function)" fill-opacity="0.06" stroke="none"/>
<rect x="282.1" y="299.6" width="18.0" height="0.4" fill="var(--code-function)" fill-opacity="0.03" stroke="none"/>
<rect x="300.0" y="20.0" width="6.6" height="0.4" fill="var(--code-function)" fill-opacity="0.03" stroke="none"/>
<rect x="300.0" y="20.4" width="6.6" height="0.8" fill="var(--code-function)" fill-opacity="0.06" stroke="none"/>
<rect x="300.0" y="21.1" width="6.6" height="2.3" fill="var(--code-function)" fill-opacity="0.09" stroke="none"/>
<rect x="300.0" y="23.4" width="6.6" height="6.6" fill="var(--code-function)" fill-opacity="0.12" stroke="none"/>
<rect x="300.0" y="30.0" width="6.6" height="18.0" fill="var(--code-function)" fill-opacity="0.12" stroke="none"/>
<rect x="300.0" y="47.9" width="6.6" height="42.0" fill="var(--code-function)" fill-opacity="0.12" stroke="none"/>
<rect x="300.0" y="89.9" width="6.6" height="70.1" fill="var(--code-function)" fill-opacity="0.12" stroke="none"/>
<rect x="300.0" y="160.0" width="6.6" height="0.0" fill="var(--code-function)" fill-opacity="0.12" stroke="none"/>
<rect x="300.0" y="160.0" width="6.6" height="70.1" fill="var(--code-function)" fill-opacity="0.12" stroke="none"/>
<rect x="300.0" y="230.1" width="6.6" height="42.0" fill="var(--code-function)" fill-opacity="0.12" stroke="none"/>
<rect x="300.0" y="272.1" width="6.6" height="18.0" fill="var(--code-function)" fill-opacity="0.12" stroke="none"/>
<rect x="300.0" y="290.0" width="6.6" height="6.6" fill="var(--code-function)" fill-opacity="0.12" stroke="none"/>
<rect x="300.0" y="296.6" width="6.6" height="2.3" fill="var(--code-function)" fill-opacity="0.09" stroke="none"/>
<rect x="300.0" y="298.9" width="6.6" height="0.8" fill="var(--code-function)" fill-opacity="0.06" stroke="none"/>
<rect x="300.0" y="299.6" width="6.6" height="0.4" fill="var(--code-function)" fill-opacity="0.03" stroke="none"/>
<rect x="306.6" y="20.0" width="2.3" height="0.4" fill="var(--code-function)" fill-opacity="0.03" stroke="none"/>
<rect x="306.6" y="20.4" width="2.3" height="0.8" fill="var(--code-function)" fill-opacity="0.06" stroke="none"/>
<rect x="306.6" y="21.1" width="2.3" height="2.3" fill="var(--code-function)" fill-opacity="0.09" stroke="none"/>
<rect x="306.6" y="23.4" width="2.3" height="6.6" fill="var(--code-function)" fill-opacity="0.09" stroke="none"/>
<rect x="306.6" y="30.0" width="2.3" height="18.0" fill="var(--code-function)" fill-opacity="0.09" stroke="none"/>
<rect x="306.6" y="47.9" width="2.3" height="42.0" fill="var(--code-function)" fill-opacity="0.09" stroke="none"/>
<rect x="306.6" y="89.9" width="2.3" height="70.1" fill="var(--code-function)" fill-opacity="0.09" stroke="none"/>
<rect x="306.6" y="160.0" width="2.3" height="0.0" fill="var(--code-function)" fill-opacity="0.09" stroke="none"/>
<rect x="306.6" y="160.0" width="2.3" height="70.1" fill="var(--code-function)" fill-opacity="0.09" stroke="none"/>
<rect x="306.6" y="230.1" width="2.3" height="42.0" fill="var(--code-function)" fill-opacity="0.09" stroke="none"/>
<rect x="306.6" y="272.1" width="2.3" height="18.0" fill="var(--code-function)" fill-opacity="0.09" stroke="none"/>
<rect x="306.6" y="290.0" width="2.3" height="6.6" fill="var(--code-function)" fill-opacity="0.09" stroke="none"/>
<rect x="306.6" y="296.6" width="2.3" height="2.3" fill="var(--code-function)" fill-opacity="0.09" stroke="none"/>
<rect x="306.6" y="298.9" width="2.3" height="0.8" fill="var(--code-function)" fill-opacity="0.06" stroke="none"/>
<rect x="306.6" y="299.6" width="2.3" height="0.4" fill="var(--code-function)" fill-opacity="0.03" stroke="none"/>
<rect x="308.9" y="20.0" width="0.8" height="0.4" fill="var(--code-function)" fill-opacity="0.03" stroke="none"/>
<rect x="308.9" y="20.4" width="0.8" height="0.8" fill="var(--code-function)" fill-opacity="0.06" stroke="none"/>
<rect x="308.9" y="21.1" width="0.8" height="2.3" fill="var(--code-function)" fill-opacity="0.06" stroke="none"/>
<rect x="308.9" y="23.4" width="0.8" height="6.6" fill="var(--code-function)" fill-opacity="0.06" stroke="none"/>
<rect x="308.9" y="30.0" width="0.8" height="18.0" fill="var(--code-function)" fill-opacity="0.06" stroke="none"/>
<rect x="308.9" y="47.9" width="0.8" height="42.0" fill="var(--code-function)" fill-opacity="0.06" stroke="none"/>
<rect x="308.9" y="89.9" width="0.8" height="70.1" fill="var(--code-function)" fill-opacity="0.06" stroke="none"/>
<rect x="308.9" y="160.0" width="0.8" height="0.0" fill="var(--code-function)" fill-opacity="0.06" stroke="none"/>
<rect x="308.9" y="160.0" width="0.8" height="70.1" fill="var(--code-function)" fill-opacity="0.06" stroke="none"/>
<rect x="308.9" y="230.1" width="0.8" height="42.0" fill="var(--code-function)" fill-opacity="0.06" stroke="none"/>
<rect x="308.9" y="272.1" width="0.8" height="18.0" fill="var(--code-function)" fill-opacity="0.06" stroke="none"/>
<rect x="308.9" y="290.0" width="0.8" height="6.6" fill="var(--code-function)" fill-opacity="0.06" stroke="none"/>
<rect x="308.9" y="296.6" width="0.8" height="2.3" fill="var(--code-function)" fill-opacity="0.06" stroke="none"/>
<rect x="308.9" y="298.9" width="0.8" height="0.8" fill="var(--code-function)" fill-opacity="0.06" stroke="none"/>
<rect x="308.9" y="299.6" width="0.8" height="0.4" fill="var(--code-function)" fill-opacity="0.03" stroke="none"/>
<rect x="309.6" y="20.0" width="0.4" height="0.4" fill="var(--code-function)" fill-opacity="0.03" stroke="none"/>
<rect x="309.6" y="20.4" width="0.4" height="0.8" fill="var(--code-function)" fill-opacity="0.03" stroke="none"/>
<rect x="309.6" y="21.1" width="0.4" height="2.3" fill="var(--code-function)" fill-opacity="0.03" stroke="none"/>
<rect x="309.6" y="23.4" width="0.4" height="6.6" fill="var(--code-function)" fill-opacity="0.03" stroke="none"/>
<rect x="309.6" y="30.0" width="0.4" height="18.0" fill="var(--code-function)" fill-opacity="0.03" stroke="none"/>
<rect x="309.6" y="47.9" width="0.4" height="42.0" fill="var(--code-function)" fill-opacity="0.03" stroke="none"/>
<rect x="309.6" y="89.9" width="0.4" height="70.1" fill="var(--code-function)" fill-opacity="0.03" stroke="none"/>
<rect x="309.6" y="160.0" width="0.4" height="0.0" fill="var(--code-function)" fill-opacity="0.03" stroke="none"/>
<rect x="309.6" y="160.0" width="0.4" height="70.1" fill="var(--code-function)" fill-opacity="0.03" stroke="none"/>
<rect x="309.6" y="230.1" width="0.4" height="42.0" fill="var(--code-function)" fill-opacity="0.03" stroke="none"/>
<rect x="309.6" y="272.1" width="0.4" height="18.0" fill="var(--code-function)" fill-opacity="0.03" stroke="none"/>
<rect x="309.6" y="290.0" width="0.4" height="6.6" fill="var(--code-function)" fill-opacity="0.03" stroke="none"/>
<rect x="309.6" y="296.6" width="0.4" height="2.3" fill="var(--code-function)" fill-opacity="0.03" stroke="none"/>
<rect x="309.6" y="298.9" width="0.4" height="0.8" fill="var(--code-function)" fill-opacity="0.03" stroke="none"/>
<rect x="309.6" y="299.6" width="0.4" height="0.4" fill="var(--code-function)" fill-opacity="0.03" stroke="none"/>
<line x1="30.0" y1="20.0" x2="30.0" y2="300.0" stroke="var(--code-function)"/>
<line x1="30.0" y1="20.0" x2="310.0" y2="20.0" stroke="var(--code-function)"/>
<line x1="30.4" y1="20.0" x2="30.4" y2="300.0" stroke="var(--code-function)"/>
<line x1="30.0" y1="20.4" x2="310.0" y2="20.4" stroke="var(--code-function)"/>
<line x1="31.1" y1="20.0" x2="31.1" y2="300.0" stroke="var(--code-function)"/>
<line x1="30.0" y1="21.1" x2="310.0" y2="21.1" stroke="var(--code-function)"/>
<line x1="33.4" y1="20.0" x2="33.4" y2="300.0" stroke="var(--code-function)"/>
<line x1="30.0" y1="23.4" x2="310.0" y2="23.4" stroke="var(--code-function)"/>
<line x1="40.0" y1="20.0" x2="40.0" y2="300.0" stroke="var(--code-function)"/>
<line x1="30.0" y1="30.0" x2="310.0" y2="30.0" stroke="var(--code-function)"/>
<line x1="57.9" y1="20.0" x2="57.9" y2="300.0" stroke="var(--code-function)"/>
<line x1="30.0" y1="47.9" x2="310.0" y2="47.9" stroke="var(--code-function)"/>
<line x1="99.9" y1="20.0" x2="99.9" y2="300.0" stroke="var(--code-function)"/>
<line x1="30.0" y1="89.9" x2="310.0" y2="89.9" stroke="var(--code-function)"/>
<line x1="170.0" y1="20.0" x2="170.0" y2="300.0" stroke="var(--code-function)"/>
<line x1="30.0" y1="160.0" x2="310.0" y2="160.0" stroke="var(--code-function)"/>
<line x1="170.0" y1="20.0" x2="170.0" y2="300.0" stroke="var(--code-function)"/>
<line x1="30.0" y1="160.0" x2="310.0" y2="160.0" stroke="var(--code-function)"/>
<line x1="240.1" y1="20.0" x2="240.1" y2="300.0" stroke="var(--code-function)"/>
<line x1="30.0" y1="230.1" x2="310.0" y2="230.1" stroke="var(--code-function)"/>
<line x1="282.1" y1="20.0" x2="282.1" y2="300.0" stroke="var(--code-function)"/>
<line x1="30.0" y1="272.1" x2="310.0" y2="272.1" stroke="var(--code-function)"/>
<line x1="300.0" y1="20.0" x2="300.0" y2="300.0" stroke="var(--code-function)"/>
<line x1="30.0" y1="290.0" x2="310.0" y2="290.0" stroke="var(--code-function)"/>
<line x1="306.6" y1="20.0" x2="306.6" y2="300.0" stroke="var(--code-function)"/>
<line x1="30.0" y1="296.6" x2="310.0" y2="296.6" stroke="var(--code-function)"/>
<line x1="308.9" y1="20.0" x2="308.9" y2="300.0" stroke="var(--code-function)"/>
<line x1="30.0" y1="298.9" x2="310.0" y2="298.9" stroke="var(--code-function)"/>
<line x1="309.6" y1="20.0" x2="309.6" y2="300.0" stroke="var(--code-function)"/>
<line x1="30.0" y1="299.6" x2="310.0" y2="299.6" stroke="var(--code-function)"/>
<line x1="310.0" y1="20.0" x2="310.0" y2="300.0" stroke="var(--code-function)"/>
<line x1="30.0" y1="300.0" x2="310.0" y2="300.0" stroke="var(--code-function)"/>
<rect x="30.0" y="20.0" width="280.0" height="280.0" stroke="var(--ink)" stroke-width="2"/>
<line x1="410.0" y1="20.0" x2="410.0" y2="300.0" stroke="var(--rule)"/>
<line x1="410.4" y1="20.0" x2="410.4" y2="300.0" stroke="var(--rule)"/>
<line x1="411.1" y1="20.0" x2="411.1" y2="300.0" stroke="var(--rule)"/>
<line x1="413.4" y1="20.0" x2="413.4" y2="300.0" stroke="var(--rule)"/>
<line x1="420.0" y1="20.0" x2="420.0" y2="300.0" stroke="var(--rule)"/>
<line x1="437.9" y1="20.0" x2="437.9" y2="300.0" stroke="var(--rule)"/>
<line x1="479.9" y1="20.0" x2="479.9" y2="300.0" stroke="var(--rule)"/>
<line x1="550.0" y1="20.0" x2="550.0" y2="300.0" stroke="var(--rule)"/>
<line x1="550.0" y1="20.0" x2="550.0" y2="300.0" stroke="var(--rule)"/>
<line x1="620.1" y1="20.0" x2="620.1" y2="300.0" stroke="var(--rule)"/>
<line x1="662.1" y1="20.0" x2="662.1" y2="300.0" stroke="var(--rule)"/>
<line x1="680.0" y1="20.0" x2="680.0" y2="300.0" stroke="var(--rule)"/>
<line x1="686.6" y1="20.0" x2="686.6" y2="300.0" stroke="var(--rule)"/>
<line x1="688.9" y1="20.0" x2="688.9" y2="300.0" stroke="var(--rule)"/>
<line x1="689.6" y1="20.0" x2="689.6" y2="300.0" stroke="var(--rule)"/>
<line x1="690.0" y1="20.0" x2="690.0" y2="300.0" stroke="var(--rule)"/>
<line x1="410.0" y1="300.0" x2="690.0" y2="300.0" stroke="var(--ink)" stroke-width="2"/>
<polyline points="413.2,33.1 413.9,49.8 414.6,63.0 415.3,73.7 416.0,82.6 416.7,90.3 417.4,96.9 418.1,102.8 418.8,107.9 419.5,112.6 420.2,116.8 420.9,120.7 421.6,124.2 422.3,127.5 423.0,130.5 423.7,133.2 424.4,135.8 425.1,138.3 425.8,140.6 426.5,142.7 427.2,144.7 427.9,146.6 428.6,148.4 429.3,150.2 430.0,151.8 430.7,153.4 431.4,154.8 432.1,156.3 432.8,157.6 433.5,158.9 434.2,160.2 434.9,161.4 435.6,162.5 436.3,163.6 437.0,164.7 437.7,165.7 438.4,166.7 439.1,167.6 439.8,168.6 440.5,169.4 441.2,170.3 441.9,171.1 442.6,172.0 443.3,172.7 444.0,173.5 444.7,174.2 445.4,174.9 446.1,175.6 446.8,176.3 447.5,177.0 448.2,177.6 448.9,178.2 449.6,178.8 450.3,179.4 451.0,180.0 451.7,180.6 452.4,181.1 453.1,181.6 453.8,182.1 454.5,182.7 455.2,183.1 455.9,183.6 456.6,184.1 457.3,184.6 458.0,185.0 458.7,185.4 459.4,185.9 460.1,186.3 460.8,186.7 461.5,187.1 462.2,187.5 462.9,187.9 463.6,188.2 464.3,188.6 465.0,189.0 465.7,189.3 466.4,189.7 467.1,190.0 467.8,190.3 468.5,190.7 469.2,191.0 469.9,191.3 470.6,191.6 471.3,191.9 472.0,192.2 472.7,192.5 473.4,192.8 474.1,193.0 474.8,193.3 475.5,193.6 476.2,193.8 476.9,194.1 477.6,194.3 478.3,194.6 479.0,194.8 479.7,195.1 480.4,195.3 481.1,195.5 481.8,195.8 482.5,196.0 483.2,196.2 483.9,196.4 484.6,196.6 485.3,196.8 486.0,197.0 486.7,197.2 487.4,197.4 488.1,197.6 488.8,197.8 489.5,198.0 490.2,198.1 490.9,198.3 491.6,198.5 492.3,198.7 493.0,198.8 493.7,199.0 494.4,199.1 495.1,199.3 495.8,199.5 496.5,199.6 497.2,199.8 497.9,199.9 498.6,200.0 499.3,200.2 500.0,200.3 500.7,200.5 501.4,200.6 502.1,200.7 502.8,200.8 503.5,201.0 504.2,201.1 504.9,201.2 505.6,201.3 506.3,201.4 507.0,201.6 507.7,201.7 508.4,201.8 509.1,201.9 509.8,202.0 510.5,202.1 511.2,202.2 511.9,202.3 512.6,202.4 513.3,202.5 514.0,202.6 514.7,202.6 515.4,202.7 516.1,202.8 516.8,202.9 517.5,203.0 518.2,203.1 518.9,203.1 519.6,203.2 520.3,203.3 521.0,203.3 521.7,203.4 522.4,203.5 523.1,203.6 523.8,203.6 524.5,203.7 525.2,203.7 525.9,203.8 526.6,203.8 527.3,203.9 528.0,204.0 528.7,204.0 529.4,204.1 530.1,204.1 530.8,204.1 531.5,204.2 532.2,204.2 532.9,204.3 533.6,204.3 534.3,204.4 535.0,204.4 535.7,204.4 536.4,204.5 537.1,204.5 537.8,204.5 538.5,204.5 539.2,204.6 539.9,204.6 540.6,204.6 541.3,204.6 542.0,204.7 542.7,204.7 543.4,204.7 544.1,204.7 544.8,204.7 545.5,204.7 546.2,204.7 546.9,204.7 547.6,204.7 548.3,204.8 549.0,204.8 549.7,204.8 550.3,204.8 551.0,204.8 551.7,204.8 552.4,204.7 553.1,204.7 553.8,204.7 554.5,204.7 555.2,204.7 555.9,204.7 556.6,204.7 557.3,204.7 558.0,204.7 558.7,204.6 559.4,204.6 560.1,204.6 560.8,204.6 561.5,204.5 562.2,204.5 562.9,204.5 563.6,204.5 564.3,204.4 565.0,204.4 565.7,204.4 566.4,204.3 567.1,204.3 567.8,204.2 568.5,204.2 569.2,204.1 569.9,204.1 570.6,204.1 571.3,204.0 572.0,204.0 572.7,203.9 573.4,203.8 574.1,203.8 574.8,203.7 575.5,203.7 576.2,203.6 576.9,203.6 577.6,203.5 578.3,203.4 579.0,203.3 579.7,203.3 580.4,203.2 581.1,203.1 581.8,203.1 582.5,203.0 583.2,202.9 583.9,202.8 584.6,202.7 585.3,202.6 586.0,202.6 586.7,202.5 587.4,202.4 588.1,202.3 588.8,202.2 589.5,202.1 590.2,202.0 590.9,201.9 591.6,201.8 592.3,201.7 593.0,201.6 593.7,201.4 594.4,201.3 595.1,201.2 595.8,201.1 596.5,201.0 597.2,200.8 597.9,200.7 598.6,200.6 599.3,200.5 600.0,200.3 600.7,200.2 601.4,200.0 602.1,199.9 602.8,199.8 603.5,199.6 604.2,199.5 604.9,199.3 605.6,199.1 606.3,199.0 607.0,198.8 607.7,198.7 608.4,198.5 609.1,198.3 609.8,198.1 610.5,198.0 611.2,197.8 611.9,197.6 612.6,197.4 613.3,197.2 614.0,197.0 614.7,196.8 615.4,196.6 616.1,196.4 616.8,196.2 617.5,196.0 618.2,195.8 618.9,195.5 619.6,195.3 620.3,195.1 621.0,194.8 621.7,194.6 622.4,194.3 623.1,194.1 623.8,193.8 624.5,193.6 625.2,193.3 625.9,193.0 626.6,192.8 627.3,192.5 628.0,192.2 628.7,191.9 629.4,191.6 630.1,191.3 630.8,191.0 631.5,190.7 632.2,190.3 632.9,190.0 633.6,189.7 634.3,189.3 635.0,189.0 635.7,188.6 636.4,188.2 637.1,187.9 637.8,187.5 638.5,187.1 639.2,186.7 639.9,186.3 640.6,185.9 641.3,185.4 642.0,185.0 642.7,184.6 643.4,184.1 644.1,183.6 644.8,183.1 645.5,182.7 646.2,182.1 646.9,181.6 647.6,181.1 648.3,180.6 649.0,180.0 649.7,179.4 650.4,178.8 651.1,178.2 651.8,177.6 652.5,177.0 653.2,176.3 653.9,175.6 654.6,174.9 655.3,174.2 656.0,173.5 656.7,172.7 657.4,172.0 658.1,171.1 658.8,170.3 659.5,169.4 660.2,168.6 660.9,167.6 661.6,166.7 662.3,165.7 663.0,164.7 663.7,163.6 664.4,162.5 665.1,161.4 665.8,160.2 666.5,158.9 667.2,157.6 667.9,156.3 668.6,154.8 669.3,153.4 670.0,151.8 670.7,150.2 671.4,148.4 672.1,146.6 672.8,144.7 673.5,142.7 674.2,140.6 674.9,138.3 675.6,135.8 676.3,133.2 677.0,130.5 677.7,127.5 678.4,124.2 679.1,120.7 679.8,116.8 680.5,112.6 681.2,107.9 681.9,102.8 682.6,96.9 683.3,90.3 684.0,82.6 684.7,73.7 685.4,63.0 686.1,49.8 686.8,33.1" stroke="var(--accent)" stroke-width="2"/>
</g>
<g fill="var(--ink)" font-size="17" text-anchor="middle">
<text x="550.0" y="185.0" fill="var(--accent)" font-style="italic">charge density</text>
<text x="170.0" y="328.0">one face: patches graded toward the edges</text>
<text x="170.0" y="349.0" fill="var(--muted)" font-size="15">darker patches carry polynomials of higher degree</text>
<text x="550.0" y="328.0">density across the face</text>
<text x="550.0" y="349.0" fill="var(--muted)" font-size="15">it grows like (distance to the edge)^(−1/3)</text>
</g>
</svg>
<figcaption>The fast family. Each layer of patches is a fixed fraction of the layer before it, so a few tens of layers reach the scale 10⁻¹² at the edges.</figcaption>
</figure>

The energies of two patches are fourfold integrals of $1/r$, and they must be accurate to all digits. One identity makes them easy:

$$
\frac1r = \frac{2}{\sqrt\pi}\int_0^\infty e^{-t^2 r^2}\,dt \;\approx\; \sum_k w_k\, e^{-t_k^2 r^2}.
$$

With $t = e^u$ the integrand is smooth and decreases fast in both directions, and the plain trapezoidal rule with a step $h$ in $u$ is enough. Its relative error is the same for all distances $r$. The Fourier transform of the integrand is a gamma function, and this gives the bound $2\sqrt2\, e^{-\pi^2/2h}$. I picked $h = 0.12$ as the largest round step with a bound below the target: $4\cdot10^{-18}$. The work grows like $1/h$, so a smaller step only costs time. The measured error is smaller than the bound, because it changes sign with $\ln r$ and averages out: the steps $0.2$, $0.15$ and $0.12$ move $\kappa$ by $2\cdot10^{-13}$, $8\cdot10^{-17}$ and $5\cdot10^{-22}$.

A Gaussian of $r$ is a product of Gaussians of the coordinates. Thus each energy is a sum of products of integrals in one variable,

$$
\iint p(x)\, q(x')\, e^{-t^2 (x-x')^2}\, dx\, dx',
$$

with polynomials $p$ and $q$ on two intervals. The polynomials are not unknowns. They are fixed before the calculation: the Legendre polynomials $P_0, P_1, \dots$ up to the chosen degree, each moved to one interval of the mesh. Only the amount of charge on each of them is unknown.

Integration by parts moves all derivatives to the polynomials, and what stays are repeated integrals of the Gaussian at the differences of the interval ends. These are combinations of $\operatorname{erf}$ and $\exp$. Again there is no numerical integration over the cube.

## The recipe

The full construction has four steps. All formulas are explicit.

**1. The Gaussians.** Take $t_k = e^{0.12\,k}$ and $w_k = \frac{2}{\sqrt\pi}\, 0.12\, t_k$ for $k = -350, \dots, 366$. These are the values of `patches.jl`. They are sufficient for 18 digits. The conjugate gradient runs below use a smaller step and a wider range.

**2. One edge.** Choose functions $\varphi_1, \dots, \varphi_N$ of one variable on the edge $[-\frac12, \frac12]$. Here each is a Legendre polynomial on one interval of the mesh, and zero outside it. With the mesh nodes $x_0 < x_1 < \dots$ and the interval $[x_i, x_{i+1}]$ of length $h_i$, the function of degree $n$ on this interval is

$$
\small
\varphi_{i,n}(x) = \frac{1}{h_i}\, P_n(\xi), \qquad \xi = \frac{2x - x_i - x_{i+1}}{h_i} \in [-1, 1],
$$

where $P_0 = 1$, $P_1 = \xi$, $P_2 = \frac12(3\xi^2 - 1)$, and so on. The variable $\xi$ stretches the interval to $[-1, 1]$, where the Legendre polynomials live. The index $a$ counts the pairs $(i, n)$. The function of degree 0 is the uniform charge 1 on the interval. The higher degrees have the total charge 0, because $\int_{-1}^{1} P_n = 0$ for $n \ge 1$: they only move charge inside the interval, as a slope, a curvature, and so on. Thus $m_a$ is 1 for degree 0 and 0 for the others.

The nodes are $x_i = \pm\frac12 \tanh(16\, i/I)$ for $I$ layers on each half of the edge, and the last node is the end of the edge.

Why $\tanh$? The distance of a node to the edge is $\frac12 - \frac12\tanh u = 1/(1 + e^{2u})$, which is $e^{-2u}$ for large $u$. Equal steps in $u$ thus give distances in a fixed ratio, $e^{-32/I}$ from one node to the next. The density near an edge is a power, $d^{-1/3}$, and a power looks the same at each scale: from $d$ to $d/2$ it changes by the same factor for all $d$. So each scale needs the same number of intervals, and that is a mesh with a fixed ratio. In the middle of the face the density is smooth, and there $\tanh u \approx u$ gives nearly equal intervals. The function $\tanh$ joins the two rules in one formula. It is a convenient choice, not a necessary one: a mesh with a fixed ratio from another formula would also do. The number 16 sets the smallest interval, $e^{-32}$.

The density is the same on both halves, so the program uses each function together with its mirror image, $\varphi(x) + \varphi(-x)$, as one function.

For each $t = t_k$ make two tables and note the charges:

$$
\small
\begin{gathered}
A_{ac} = \iint \varphi_a(x)\, \varphi_c(x')\, e^{-t^2 (x-x')^2}\, dx\, dx', \\[6pt]
s_a = \int \varphi_a(y)\, e^{-t^2 (1/2-y)^2}\, dy, \qquad
m_a = \int \varphi_a(y)\, dy .
\end{gathered}
$$

**3. One face.** The trial charges on a face are the products $\varphi_a(x)\,\varphi_b(y)$, and the density is $\sum C_{ab}\, \varphi_a(x)\, \varphi_b(y)$. The numbers $C_{ab}$ are the only unknowns. All six faces carry the same density. The energy of the product $(a,b)$ on one face with the product $(c,d)$ on all six faces is

$$
\small
H_{ab,cd} = \sum_k w_k \Big[ \big(1 + e^{-t_k^2}\big) A_{ac} A_{bd} + 2\, A_{ac}\, s_b\, s_d + 2\, s_a\, A_{bc}\, s_d \Big].
$$

The first term is the face itself and the opposite face, at distance 1. The other two are the four adjacent faces.

**4. The system.** Solve $H C = m$, where $m_{ab} = m_a m_b$. Then $\kappa_N = 6\, m^{\mathsf T} C$.

The smallest case can be done almost by hand. Take one function, $\varphi = 1$ on the full edge: a uniformly charged cube. The two tables are

$$
A(t) = \frac{\sqrt\pi\, t\, \operatorname{erf} t + e^{-t^2} - 1}{t^2}, \qquad s(t) = \frac{\sqrt\pi\, \operatorname{erf} t}{2t},
$$

for example $A(1) = 0.861528$ and $s(1) = 0.746824$. The system is one equation, and

$$
\small
\begin{gathered}
h = \sum_k w_k \Big[ \big(1 + e^{-t_k^2}\big) A(t_k)^2 + 4\, A(t_k)\, s(t_k)^2 \Big] = 9.2475851, \\[6pt]
\kappa_1 = \frac6h = 0.648818 .
\end{gathered}
$$

A coarse sum with the step $0.5$ and 33 terms, from $t = e^{-8}$ to $e^{8}$, already gives $0.6490$. So the first term of the fast series is $0.6488$, where the first term of the shell series was $0.5$. Each further function $\varphi$ adds rows to $H$ and terms to the series, by the same four steps.

## How the system is solved

Why $HC = m$? It is the same statement as $Gq = \mathbf 1$ for the shells. Add a small charge $\delta$ of the shape $\varphi_a\varphi_b$ to the faces. The bound $2q - E$ changes in proportion to $\delta\,(m_{ab} - (HC)_{ab})$, and at the best $C$ no such change can help, so all these differences are zero.

Physically, $(HC)_{ab}$ is the potential of the full trial charge on a face, weighted with $\varphi_a\varphi_b$ and integrated, and $m_{ab}$ is the same integral of the potential 1. So the system says: the surface is at potential 1, as far as the trial functions can test it. For the functions of degree 0 this means that the mean potential over each patch is exactly 1. The higher degrees also remove its mean slope and curvature over the patch. A conductor has the potential 1 at every point of its surface. The system asks for this in as many ways as there are unknowns. The matrix $H$ is symmetric and positive definite, and it is full: each patch acts on each other patch. The density must not change when $x$ and $y$ change places, so $C_{ab} = C_{ba}$, and $N$ functions on the edge give $N(N+1)/2$ unknowns. The largest run has $N = 343$ and 58 996 unknowns.

The solution has three stages.

1. Scale $H$ to a unit diagonal, because the energies of the small patches near the edges are much larger than the energies of the large ones.
2. Factor $H = LL^{\mathsf T}$ with Cholesky in double precision, and solve $Lz = m$. Then

$$
\kappa_N = 6\, m^{\mathsf T} H^{-1} m = 6 \sum_j z_j^2 .
$$

3. Refine. Double precision gives $\kappa_N$ to about $10^{-16}$, and the last digits need more. Compute the residual $m - HC$ in double-double arithmetic (31 digits), solve for the correction with the same factor $L$, and add it. Two rounds bring the residual to $10^{-30}$.

The residual does not need the matrix $H$ in high precision. With the tables as matrices, the product $HC$ for one Gaussian is $(1 + e^{-t^2})\,A C A + 2\,(A C s)\,s^{\mathsf T} + 2\,s\,(A C s)^{\mathsf T}$, three small matrix products.

As with the shells, the result is a lower bound and a sum of positive terms, one term for each trial function.

| Layers | Top degree | Unknowns | $\kappa_N$ | $\kappa - \kappa_N$ | Time |
|---:|---:|---:|:---|:---|---:|
| 8 | 2 | 190 | 0.660605384086 | $7\cdot10^{-5}$ | 6 s |
| 12 | 4 | 903 | 0.660678004068 | $1.5\cdot10^{-7}$ | 14 s |
| 16 | 6 | 2 701 | 0.660678153932361 | $2\cdot10^{-10}$ | 30 s |
| 20 | 8 | 6 328 | 0.660678154099484426 | $8\cdot10^{-14}$ | 59 s |
| 23 | 10 | 16 653 | 0.660678154099567955 | $4\cdot10^{-17}$ | 159 s |
| 23 | 12 | 19 503 | 0.660678154099567999066 | $3\cdot10^{-19}$ | 203 s |
| 32 | 14 | 58 996 | 0.660678154099567999411 | | 1 123 s |

Each row is a lower bound for the system with this Gaussian sum. The sum is a little short, and this makes the values about $3\cdot10^{-19}$ too high, as the section on the conjugate gradient method shows. So the digits beyond the 18th are not lower bounds of $\kappa$. The errors are differences from the last row, and they fall by a factor of 100 to 2000 from row to row. Sixteen digits need about 17 000 unknowns. The shells gave 3 digits with 1.5 million.

## Why it is fast

The patch method has a name: it is the Galerkin boundary element method in its *hp* form. Each part of the name says one thing.

- *Boundary element.* The unknown is the charge on the surface only, and the surface is divided into elements, here the patches. The equation is an integral equation: the potential of the surface charge is 1 on the surface. A finite element method has its unknowns in the full volume and solves a differential equation there. Its matrix is sparse, because only adjacent elements interact. Here the matrix is full, but the unknowns cover only a surface.
- *Galerkin.* The equation is tested with the same functions that build the solution: one trial function, one equation. This is the system $HC = m$. It makes $H$ symmetric, and it gives the lower bound.
- *h* and *p*. The letter $h$ is the size of the elements and $p$ is the degree of the polynomials. The $h$ version makes the elements smaller at a fixed degree. The $p$ version increases the degree on a fixed mesh. The $hp$ version does both: small elements of low degree where the solution is singular, large elements of high degree where it is smooth.

The Galerkin method with finite elements on a surface goes back to Nédélec and Planchard, [*Une méthode variationnelle d'éléments finis pour la résolution numérique d'un problème extérieur dans* $\mathbf R^3$](https://www.numdam.org/item/M2AN_1973__7_3_105_0/) (1973), and to Hsiao and Wendland, *A finite element method for some integral equations of the first kind* (1977). Uniform patches on the cube are older: Reitan and Higgins, *Calculation of the electrical capacitance of a cube* (1951), divided each face into 36 squares and found $0.6555$. The $hp$ idea is from Gui and Babuška, *The h, p and h-p versions of the finite element method in 1 dimension* (1986). Its exponential convergence for boundary elements was proved by Babuška, Guo and Stephan (1990) for polygons, and by Heuer, Maischak and Stephan, *Exponential convergence of the hp-version for the boundary element method on open surfaces* (1999), for surfaces in space. A modern textbook is Sauter and Schwab, [*Boundary Element Methods*](https://doi.org/10.1007/978-3-540-68093-2) (2011).

**The density on one patch.** A patch is the product of the interval $i$ in $x$ and the interval $j$ in $y$. On it the density is

$$
\small
\sigma(x, y) = \frac{1}{h_i h_j} \sum_{n=0}^{p_i} \sum_{m=0}^{p_j} C_{(i,n)(j,m)}\, P_n(\xi)\, P_m(\eta),
$$

where $\xi$ and $\eta$ are $x$ and $y$ stretched to $[-1, 1]$ on the patch. The products $P_n(\xi) P_m(\eta)$ are fixed shapes, and each has its own coefficient. Their sum is one polynomial, of degree $p_i$ in $x$ and $p_j$ in $y$. So "a sum of many polynomials" and "one polynomial of high degree" are the same statement. A patch of degree 10 in both directions has $11 \times 11 = 121$ products. Only the product $n = m = 0$ has a total charge, and its coefficient is the charge of the patch. All the others have the total charge 0 and only move charge inside the patch. Nothing joins the polynomials of two adjacent patches: the density can jump at a patch border, and it can be negative at a point. The lower bound is true for each trial charge, so neither does harm.

<figure>
<svg viewBox="0 0 720 388" width="720" role="img" aria-label="Left: the computed charge density on a full face of the cube, lowest in the centre and high at the edges. Right: one quarter of the face with all patches drawn at equal size, with the density rising over seven decades toward the corner." style="max-width:100%;height:auto;font-family:inherit">
<image href="density_face.png" x="30" y="20" width="280" height="280"/>
<image href="density_quarter.png" x="410" y="20" width="280" height="280"/>
<image href="density_face_scale.png" x="30" y="308" width="280" height="8" preserveAspectRatio="none"/>
<image href="density_quarter_scale.png" x="410" y="308" width="280" height="8" preserveAspectRatio="none"/>
<g fill="var(--muted)" font-size="13" text-anchor="middle">
<text x="65.0" y="332">0.1</text><text x="131.8" y="332">0.3</text><text x="205.0" y="332">1</text><text x="271.8" y="332">3</text>
<text x="419.3" y="332">10⁻¹</text><text x="456.7" y="332">1</text><text x="494.0" y="332">10</text><text x="531.3" y="332">10²</text><text x="568.7" y="332">10³</text><text x="606.0" y="332">10⁴</text><text x="643.3" y="332">10⁵</text><text x="680.7" y="332">10⁶</text>
</g>
<g fill="var(--ink)" font-size="17" text-anchor="middle">
<text x="170.0" y="360.0">the full face, true geometry</text>
<text x="170.0" y="381.0" fill="var(--muted)" font-size="15">only four layers are wide enough to see</text>
<text x="550.0" y="360.0">one quarter, all patches at equal size</text>
<text x="550.0" y="381.0" fill="var(--muted)" font-size="15">face centre bottom left, cube corner top right</text>
</g>
</svg>
<figcaption>The computed density of the run with 16 layers and top degree 6. The colour is the logarithm of the density, and each band is a factor of 1.12, so the bands are level lines. White lines are patch borders. In this run each layer is 7.4 times thinner than the layer before it.</figcaption>
</figure>

The density is $0.068$ in the centre of the face, and its mean over the corner patch is $10^6$. The bands bend inside the patches: the density is not uniform there. They go across the patch borders almost without a step, so the density is almost continuous, but only because that is the best fit. In the last two layers the degree is 0, and the bands are straight. The density is positive at all the 65 536 points that I tested. The white cross in the centre is the mirror: the mesh is made for one half of the edge, so the middle of the face is four patches, not one.

**Equal errors, not equal charges.** The large patches hold much more charge than the small ones. Is that a bad distribution of the work? No. The error of a patch does not come from its charge. It comes from the misfit of the polynomial, and the misfit depends on one number: the size of the patch divided by its distance to the edge. On a mesh with a fixed ratio $q$ between the layers this number is the same for all patches. The best polynomial of degree $p$ for the power $d^{-1/3}$ on such a patch has a relative error near $\rho^{-p}$, with

$$
\rho = \frac{1 + \sqrt q}{1 - \sqrt q},
$$

which is 3 for $q = \frac14$, the ratio of the runs with 23 layers. Each degree thus divides the misfit by 3, on a large patch and on a small one.

The share of a patch in the error of $\kappa$ is an energy: about the square of the relative misfit times the square of the charge of the patch. With one degree more the first factor falls 9 times. One layer nearer to the edge, the charge falls by $q^{2/3}$ and its square by $q^{4/3}$, which is $0.16$. The two effects balance when the degree falls by about $0.8$ for each layer toward the edge. The runs with 23 layers use the slope $0.75$. This is the reason for the falling degree: the small patches need less, because they hold less. The shares are then nearly equal, and few unknowns are wasted.

A model with one edge shows the size of the effect. Take the density $d^{-1/3}$, fit it on each interval, and take the interval length times the integral of the squared misfit as the error of the interval. Three meshes with 182 unknowns each, the first with the 23 layers and the degrees of the runs:

| Mesh | Intervals | Smallest interval | Sum of the errors |
|:---|---:|:---|:---|
| Fixed ratio, degrees 10 to 0 | 23 | $5\cdot10^{-14}$ | $6\cdot10^{-15}$ |
| Equal charge, degrees 10 to 0 | 23 | $5\cdot10^{-3}$ | $6\cdot10^{-4}$ |
| Equal charge, degree 0 | 182 | $2\cdot10^{-4}$ | $1\cdot10^{-5}$ |

On the first mesh the charge of an interval changes by 8 orders of magnitude from the centre to the edge, and the error stays between $10^{-20}$ and $10^{-15}$. On the meshes of equal charge it is the opposite, and the interval at the edge holds almost all of the error. The reason is the count: $n$ intervals of equal charge have their nodes at $d \propto (i/n)^{3/2}$, so the smallest is $n^{-3/2}$, and $10^{-13}$ would need some $10^{8}$ intervals. Equal charge is a good rule for a fixed low degree. With polynomials it is worse than no rule.

**Uniform patches.** Can the polynomials be left out? The program can do it: degree 0 on all patches, and more layers on the same $\tanh$ mesh.

| Layers | Unknowns | $\kappa_N$ | $\kappa - \kappa_N$ |
|---:|---:|:---|:---|
| 8 | 36 | 0.658542980 | $2.1\cdot10^{-3}$ |
| 16 | 136 | 0.660434935 | $2.4\cdot10^{-4}$ |
| 32 | 528 | 0.660649605 | $2.9\cdot10^{-5}$ |

Four times more unknowns divide the error by about $8.5$. This is a power law, near $M^{-1.6}$ for $M$ unknowns, and sixteen digits would need about $10^{10}$ unknowns. The error of a uniform patch is in proportion to its size divided by its distance to the edge, and only a smaller step from layer to layer can decrease it. The table does this: the smallest patch is fixed, so more layers make all steps smaller. More layers at a fixed step would only extend the mesh toward the edge, and would not help. With the polynomials, 903 unknowns give $1.5\cdot10^{-7}$.

**Exponential convergence.** Take $L$ layers and a top degree in proportion to $L$. The error has two sources. The first is the last layer, which touches the edge. No polynomial fits a power at its singular point, so this error stays, but the layer is small, $q^{L}$, and its share falls like a power of $q^{L}$. The second is the misfit on all other patches, which falls like $\rho^{-2p}$ with $p$ in proportion to $L$. Both are $e^{-cL}$ for some $c$. Now count the unknowns. The edge has about $L \cdot p/2$ functions, which is in proportion to $L^2$, and the face has one unknown for each pair of them, in proportion to $L^4$. Thus

$$
\kappa - \kappa_M \approx e^{-b\, M^{1/4}}
$$

for $M$ unknowns. A fixed degree gives only a power of $M$. In the first four rows of the table above, the logarithm of the error falls by $3.5$ to $4.6$ for each unit of $M^{1/4}$. This paragraph is an argument, not a proof. The proofs for meshes of this type are in the papers cited above.

## Matrix-free conjugate gradient

The Cholesky method stores the matrix $H$. For $M$ unknowns it has $M^2$ entries: 28 GB for the largest run above, and a computer with 64 GB stops near 85 000 unknowns. The work of the factorization grows like $M^3$. But the matrix is not necessary.

**The product.** The refinement above already makes the product $HC$ without $H$. For one Gaussian it is $(1 + e^{-t^2})\,A C A + 2\,(A C s)\,s^{\mathsf T} + 2\,s\,(A C s)^{\mathsf T}$, where $C$ is the symmetric $N\times N$ matrix of the unknowns. One product for $K$ Gaussians costs about $4KN^3$ operations, and it needs only the tables: $KN^2$ numbers. There are $M = N(N+1)/2$ unknowns, so the memory grows like $M$ and not like $M^2$.

**The method.** The conjugate gradient method of Hestenes and Stiefel, *Methods of conjugate gradients for solving linear systems* (1952), solves a system with a symmetric positive definite matrix, and it needs only such products. Start with no charge, $C_0 = 0$. The residual $r = m - HC$ is what the potential still lacks to 1, tested with each trial function. Divide it by the diagonal of $H$ to get $z$: this is the scaling to a unit diagonal of the Cholesky method. The first direction is $d_0 = z_0$, and each step is

$$
\small
\begin{gathered}
\alpha_k = \frac{r_k^{\mathsf T} z_k}{d_k^{\mathsf T} H d_k}, \qquad
C_{k+1} = C_k + \alpha_k d_k, \qquad
r_{k+1} = r_k - \alpha_k H d_k, \\[6pt]
d_{k+1} = z_{k+1} + \frac{r_{k+1}^{\mathsf T} z_{k+1}}{r_k^{\mathsf T} z_k}\, d_k .
\end{gathered}
$$

One step needs one product $Hd_k$ and some sums.

**Strict convergence.** For a symmetric positive definite matrix the method has three properties, and the capacitance gives each of them a meaning.

*Each step increases the bound.* Each $C_k$ is a trial charge, so it has its own lower bound $\kappa_k = 6\,(2\,m^{\mathsf T}C_k - C_k^{\mathsf T}HC_k)$. One step changes it by

$$
\kappa_{k+1} - \kappa_k = 6\,\alpha_k\, r_k^{\mathsf T} z_k > 0 .
$$

The number $d^{\mathsf T}Hd$ is an energy and $r^{\mathsf T}z$ is a sum of squares, so the gain is positive while the residual is not zero. The bounds increase at each step. They cannot oscillate, and they cannot pass $\kappa_M$, the value of the full system.

*Each step is the best one.* $C_k$ has the smallest energy of the error among all charges that $k$ products can build from the right side. In exact arithmetic the method ends with the exact solution after $M$ steps at most.

*The error falls at least geometrically.* The energy of the error, which is the error of $\kappa$, is not more than $4\,\big((\sqrt c - 1)/(\sqrt c + 1)\big)^{2k}$ times its first value, where $c$ is the condition number of the scaled matrix.

These properties are known, also in this form. The value $m^{\mathsf T}H^{-1}m$ is a quadratic form of the inverse matrix. Golub and Meurant, [*Matrices, moments and quadrature II; how to compute the norm of the error in iterative methods*](https://doi.org/10.1007/BF02510247) (1997) and the book *Matrices, Moments and Quadrature with Applications* (2010), show that the conjugate gradient steps are a Gauss quadrature rule for such a form, and that this rule gives a lower bound. That is the series of gains above. They also give an upper bound, from a Gauss–Radau rule and a lower bound of the smallest eigenvalue. Here it would enclose the error of the solver from the two sides. It would be an upper bound of $\kappa_M$, the value of the system, and not of $\kappa$. I did not use it.

The condition number is small and grows slowly. I measured it from the step sizes, and for the two smallest sizes also from the full matrix, with the same result:

| Layers | Top degree | Edge functions $N$ | Unknowns | Condition number | Steps to $10^{-13}$ |
|---:|---:|---:|---:|---:|---:|
| 8 | 2 | 19 | 190 | 231 | 105 |
| 12 | 4 | 42 | 903 | 629 | 191 |
| 16 | 6 | 73 | 2 701 | 1 080 | 269 |
| 20 | 8 | 112 | 6 328 | 1 550 | 323 |
| 23 | 10 | 182 | 16 653 | 2 110 | 356 |
| 27 | 14 | 268 | 36 046 | 2 680 | 421 |

It is about 10 to 15 times $N$, so the steps grow like $\sqrt N$, which is $M^{1/4}$. The diagonal is the only preconditioner that is necessary.

<figure>
<svg viewBox="0 0 720 372" width="720" role="img" aria-label="The error of the lower bound falls in a nearly straight line on a logarithmic scale, from 1 at the first step to 3e-36 at step 697, and it stays below the bound from the condition number." style="max-width:100%;height:auto;font-family:inherit">
<g fill="none" stroke-width="1">
<line x1="78" y1="310.0" x2="696" y2="310.0" stroke="var(--rule)"/>
<line x1="78" y1="273.8" x2="696" y2="273.8" stroke="var(--rule)"/>
<line x1="78" y1="237.5" x2="696" y2="237.5" stroke="var(--rule)"/>
<line x1="78" y1="201.3" x2="696" y2="201.3" stroke="var(--rule)"/>
<line x1="78" y1="165.0" x2="696" y2="165.0" stroke="var(--rule)"/>
<line x1="78" y1="128.8" x2="696" y2="128.8" stroke="var(--rule)"/>
<line x1="78" y1="92.5" x2="696" y2="92.5" stroke="var(--rule)"/>
<line x1="78" y1="56.3" x2="696" y2="56.3" stroke="var(--rule)"/>
<line x1="78" y1="20.0" x2="696" y2="20.0" stroke="var(--rule)"/>
<line x1="78.0" y1="20" x2="78.0" y2="310" stroke="var(--rule)"/>
<line x1="166.3" y1="20" x2="166.3" y2="310" stroke="var(--rule)"/>
<line x1="254.6" y1="20" x2="254.6" y2="310" stroke="var(--rule)"/>
<line x1="342.9" y1="20" x2="342.9" y2="310" stroke="var(--rule)"/>
<line x1="431.1" y1="20" x2="431.1" y2="310" stroke="var(--rule)"/>
<line x1="519.4" y1="20" x2="519.4" y2="310" stroke="var(--rule)"/>
<line x1="607.7" y1="20" x2="607.7" y2="310" stroke="var(--rule)"/>
<line x1="696.0" y1="20" x2="696.0" y2="310" stroke="var(--rule)"/>
<line x1="78" y1="310" x2="696" y2="310" stroke="var(--ink)" stroke-width="2"/>
<polyline points="78.0,20.0 82.4,20.0 86.8,20.0 91.2,20.6 95.7,21.8 100.1,23.0 104.5,24.2 108.9,25.5 113.3,26.7 117.7,27.9 122.1,29.1 126.6,30.3 131.0,31.5 135.4,32.8 139.8,34.0 144.2,35.2 148.6,36.4 153.0,37.6 157.5,38.9 161.9,40.1 166.3,41.3 170.7,42.5 175.1,43.7 179.5,44.9 183.9,46.2 188.4,47.4 192.8,48.6 197.2,49.8 201.6,51.0 206.0,52.2 210.4,53.5 214.8,54.7 219.3,55.9 223.7,57.1 228.1,58.3 232.5,59.5 236.9,60.8 241.3,62.0 245.7,63.2 250.2,64.4 254.6,65.6 259.0,66.8 263.4,68.1 267.8,69.3 272.2,70.5 276.6,71.7 281.1,72.9 285.5,74.2 289.9,75.4 294.3,76.6 298.7,77.8 303.1,79.0 307.5,80.2 312.0,81.5 316.4,82.7 320.8,83.9 325.2,85.1 329.6,86.3 334.0,87.5 338.4,88.8 342.9,90.0 347.3,91.2 351.7,92.4 356.1,93.6 360.5,94.8 364.9,96.1 369.3,97.3 373.8,98.5 378.2,99.7 382.6,100.9 387.0,102.1 391.4,103.4 395.8,104.6 400.2,105.8 404.7,107.0 409.1,108.2 413.5,109.5 417.9,110.7 422.3,111.9 426.7,113.1 431.1,114.3 435.6,115.5 440.0,116.8 444.4,118.0 448.8,119.2 453.2,120.4 457.6,121.6 462.0,122.8 466.5,124.1 470.9,125.3 475.3,126.5 479.7,127.7 484.1,128.9 488.5,130.1 492.9,131.4 497.4,132.6 501.8,133.8 506.2,135.0 510.6,136.2 515.0,137.4 519.4,138.7 523.8,139.9 528.3,141.1 532.7,142.3 537.1,143.5 541.5,144.8 545.9,146.0 550.3,147.2 554.7,148.4 559.2,149.6 563.6,150.8 568.0,152.1 572.4,153.3 576.8,154.5 581.2,155.7 585.6,156.9 590.1,158.1 594.5,159.4 598.9,160.6 603.3,161.8 607.7,163.0 612.1,164.2 616.5,165.4 621.0,166.7 625.4,167.9 629.8,169.1 634.2,170.3 638.6,171.5 643.0,172.7 647.4,174.0 651.9,175.2 656.3,176.4 660.7,177.6 665.1,178.8 669.5,180.1 673.9,181.3 678.3,182.5 682.8,183.7 687.2,184.9 691.6,186.1" stroke="var(--muted)" stroke-dasharray="5 4" stroke-width="1.4"/>
<line x1="449.7" y1="20" x2="449.7" y2="310" stroke="var(--code-function)" stroke-dasharray="2 4" stroke-width="1.4"/>
<polyline points="78.9,24.8 79.8,28.0 80.6,30.7 81.5,32.2 82.4,35.2 83.3,36.1 84.2,37.7 85.1,38.4 85.9,40.1 86.8,40.8 87.7,41.7 88.6,42.3 89.5,43.3 90.4,43.8 91.2,44.4 92.1,44.8 93.0,45.3 93.9,45.8 94.8,46.1 95.7,47.0 96.5,47.4 97.4,48.4 98.3,49.2 99.2,50.0 100.1,51.3 101.0,51.8 101.8,52.1 102.7,52.8 103.6,53.2 104.5,53.6 105.4,54.0 106.3,54.3 107.1,54.7 108.0,55.0 108.9,55.2 109.8,55.5 110.7,55.8 111.5,56.0 112.4,56.5 113.3,56.9 114.2,57.5 115.1,58.3 116.0,58.8 116.8,59.4 117.7,59.9 118.6,60.4 119.5,60.9 120.4,61.4 121.3,61.9 122.1,62.2 123.0,62.7 123.9,63.1 124.8,63.4 125.7,63.8 126.6,64.3 127.4,64.7 128.3,65.2 129.2,65.6 130.1,66.0 131.0,66.8 131.9,67.3 132.7,68.0 133.6,68.7 134.5,69.4 135.4,70.0 136.3,70.7 137.2,71.1 138.0,71.6 138.9,72.1 139.8,72.6 140.7,72.9 141.6,73.4 142.4,73.8 143.3,74.0 144.2,74.4 145.1,74.7 146.0,75.1 146.9,75.6 147.7,76.0 148.6,76.5 149.5,76.9 150.4,77.3 151.3,77.8 152.2,78.2 153.0,78.7 153.9,79.1 154.8,79.5 155.7,79.9 156.6,80.2 157.5,80.6 158.3,81.1 159.2,81.4 160.1,81.7 161.0,82.3 161.9,82.7 162.8,83.2 163.6,83.8 164.5,84.3 165.4,85.0 166.3,85.7 167.2,86.2 168.1,86.7 168.9,87.2 169.8,87.6 170.7,88.0 171.6,88.3 172.5,88.6 173.3,88.9 174.2,89.3 175.1,89.7 176.0,90.1 176.9,90.5 177.8,90.9 178.6,91.3 179.5,91.9 180.4,92.4 181.3,92.9 182.2,93.4 183.1,93.9 183.9,94.3 184.8,94.7 185.7,95.1 186.6,95.4 187.5,95.8 188.4,96.1 189.2,96.5 190.1,96.8 191.0,97.2 191.9,97.6 192.8,98.0 193.7,98.5 194.5,98.9 195.4,99.2 196.3,99.6 197.2,100.1 198.1,100.6 199.0,101.1 199.8,101.4 200.7,102.0 201.6,102.3 202.5,102.6 203.4,103.1 204.2,103.5 205.1,103.9 206.0,104.3 206.9,104.6 207.8,105.0 208.7,105.5 209.5,105.9 210.4,106.2 211.3,106.8 212.2,107.1 213.1,107.5 214.0,108.0 214.8,108.4 215.7,108.8 216.6,109.2 217.5,109.5 218.4,109.7 219.3,110.2 220.1,110.7 221.0,111.0 221.9,111.4 222.8,111.8 223.7,112.1 224.6,112.5 225.4,112.8 226.3,113.2 227.2,113.5 228.1,113.8 229.0,114.2 229.9,114.6 230.7,115.0 231.6,115.6 232.5,116.0 233.4,116.4 234.3,116.8 235.1,117.2 236.0,117.6 236.9,118.0 237.8,118.5 238.7,118.9 239.6,119.3 240.4,119.5 241.3,119.9 242.2,120.3 243.1,120.7 244.0,120.9 244.9,121.3 245.7,121.7 246.6,122.1 247.5,122.5 248.4,122.9 249.3,123.3 250.2,123.7 251.0,124.1 251.9,124.5 252.8,124.9 253.7,125.3 254.6,125.6 255.5,126.0 256.3,126.4 257.2,126.7 258.1,127.0 259.0,127.3 259.9,127.7 260.8,128.1 261.6,128.4 262.5,128.7 263.4,129.1 264.3,129.5 265.2,129.9 266.0,130.3 266.9,130.7 267.8,131.1 268.7,131.5 269.6,131.8 270.5,132.3 271.3,132.6 272.2,133.0 273.1,133.4 274.0,133.7 274.9,134.1 275.8,134.5 276.6,134.8 277.5,135.2 278.4,135.6 279.3,135.9 280.2,136.3 281.1,136.7 281.9,137.1 282.8,137.4 283.7,137.6 284.6,137.9 285.5,138.2 286.4,138.6 287.2,138.9 288.1,139.2 289.0,139.6 289.9,140.1 290.8,140.4 291.7,140.9 292.5,141.4 293.4,141.9 294.3,142.4 295.2,142.8 296.1,143.2 296.9,143.6 297.8,143.8 298.7,144.2 299.6,144.4 300.5,144.8 301.4,145.1 302.2,145.3 303.1,145.6 304.0,146.0 304.9,146.3 305.8,146.6 306.7,146.8 307.5,147.2 308.4,147.6 309.3,148.0 310.2,148.4 311.1,148.7 312.0,149.1 312.8,149.5 313.7,149.8 314.6,150.1 315.5,150.4 316.4,150.7 317.3,151.0 318.1,151.3 319.0,151.7 319.9,152.1 320.8,152.4 321.7,152.8 322.6,153.2 323.4,153.6 324.3,153.9 325.2,154.2 326.1,154.6 327.0,154.9 327.8,155.3 328.7,155.5 329.6,155.7 330.5,156.1 331.4,156.4 332.3,156.7 333.1,157.0 334.0,157.3 334.9,157.5 335.8,157.8 336.7,158.2 337.6,158.5 338.4,158.9 339.3,159.4 340.2,159.7 341.1,160.2 342.0,160.5 342.9,160.8 343.7,161.1 344.6,161.4 345.5,161.7 346.4,162.0 347.3,162.3 348.2,162.5 349.0,162.8 349.9,163.1 350.8,163.3 351.7,163.6 352.6,163.8 353.5,164.1 354.3,164.5 355.2,164.8 356.1,165.0 357.0,165.3 357.9,165.7 358.7,166.0 359.6,166.3 360.5,166.6 361.4,167.0 362.3,167.3 363.2,167.7 364.0,168.0 364.9,168.4 365.8,168.7 366.7,169.1 367.6,169.4 368.5,169.7 369.3,170.0 370.2,170.3 371.1,170.6 372.0,170.8 372.9,171.0 373.8,171.2 374.6,171.4 375.5,171.7 376.4,171.9 377.3,172.1 378.2,172.4 379.1,172.7 379.9,172.9 380.8,173.3 381.7,173.6 382.6,173.8 383.5,174.2 384.4,174.4 385.2,174.7 386.1,175.0 387.0,175.2 387.9,175.6 388.8,175.8 389.6,176.0 390.5,176.3 391.4,176.6 392.3,176.9 393.2,177.1 394.1,177.3 394.9,177.6 395.8,178.1 396.7,178.4 397.6,178.7 398.5,179.0 399.4,179.4 400.2,179.7 401.1,180.0 402.0,180.2 402.9,180.4 403.8,180.8 404.7,180.9 405.5,181.2 406.4,181.5 407.3,181.8 408.2,182.1 409.1,182.4 410.0,182.7 410.8,183.0 411.7,183.3 412.6,183.6 413.5,183.9 414.4,184.1 415.3,184.3 416.1,184.6 417.0,184.8 417.9,185.0 418.8,185.3 419.7,185.6 420.5,185.9 421.4,186.1 422.3,186.3 423.2,186.7 424.1,187.0 425.0,187.2 425.8,187.6 426.7,187.8 427.6,188.1 428.5,188.4 429.4,188.7 430.3,189.1 431.1,189.3 432.0,189.6 432.9,190.0 433.8,190.2 434.7,190.7 435.6,190.9 436.4,191.1 437.3,191.5 438.2,191.9 439.1,192.1 440.0,192.6 440.9,192.9 441.7,193.3 442.6,193.7 443.5,194.0 444.4,194.4 445.3,194.8 446.2,195.1 447.0,195.4 447.9,195.6 448.8,195.9 449.7,196.2 450.6,196.4 451.4,196.5 452.3,196.6 453.2,196.8 454.1,197.0 455.0,197.1 455.9,197.3 456.7,197.5 457.6,197.6 458.5,197.9 459.4,198.0 460.3,198.2 461.2,198.5 462.0,198.6 462.9,198.8 463.8,199.2 464.7,199.4 465.6,199.6 466.5,199.9 467.3,200.1 468.2,200.4 469.1,200.7 470.0,200.9 470.9,201.4 471.8,201.6 472.6,201.9 473.5,202.3 474.4,202.6 475.3,203.0 476.2,203.2 477.1,203.6 477.9,203.9 478.8,204.1 479.7,204.4 480.6,204.6 481.5,204.8 482.3,205.0 483.2,205.4 484.1,205.5 485.0,205.8 485.9,206.1 486.8,206.3 487.6,206.6 488.5,206.8 489.4,207.0 490.3,207.3 491.2,207.5 492.1,207.7 492.9,207.9 493.8,208.2 494.7,208.4 495.6,208.6 496.5,208.8 497.4,209.0 498.2,209.3 499.1,209.5 500.0,209.7 500.9,210.0 501.8,210.4 502.7,210.7 503.5,211.1 504.4,211.4 505.3,211.6 506.2,212.0 507.1,212.3 508.0,212.7 508.8,213.1 509.7,213.4 510.6,213.8 511.5,214.1 512.4,214.4 513.2,214.7 514.1,215.1 515.0,215.4 515.9,215.7 516.8,216.0 517.7,216.3 518.5,216.5 519.4,216.8 520.3,217.0 521.2,217.3 522.1,217.6 523.0,217.8 523.8,218.1 524.7,218.3 525.6,218.5 526.5,218.7 527.4,218.9 528.3,219.1 529.1,219.3 530.0,219.4 530.9,219.6 531.8,219.9 532.7,220.2 533.6,220.4 534.4,220.8 535.3,221.0 536.2,221.4 537.1,221.7 538.0,221.9 538.9,222.2 539.7,222.5 540.6,222.7 541.5,223.1 542.4,223.4 543.3,223.7 544.1,224.1 545.0,224.4 545.9,224.7 546.8,225.1 547.7,225.4 548.6,225.8 549.4,226.1 550.3,226.4 551.2,226.8 552.1,227.1 553.0,227.3 553.9,227.7 554.7,227.9 555.6,228.1 556.5,228.3 557.4,228.6 558.3,228.9 559.2,229.2 560.0,229.4 560.9,229.7 561.8,230.0 562.7,230.3 563.6,230.6 564.5,230.9 565.3,231.2 566.2,231.5 567.1,231.8 568.0,232.0 568.9,232.3 569.8,232.6 570.6,232.8 571.5,233.1 572.4,233.4 573.3,233.6 574.2,233.9 575.0,234.1 575.9,234.4 576.8,234.6 577.7,234.9 578.6,235.1 579.5,235.3 580.3,235.6 581.2,235.8 582.1,236.1 583.0,236.4 583.9,236.6 584.8,236.8 585.6,237.1 586.5,237.3 587.4,237.6 588.3,237.9 589.2,238.3 590.1,238.5 590.9,238.8 591.8,239.1 592.7,239.4 593.6,239.7 594.5,240.1 595.4,240.3 596.2,240.6 597.1,240.9 598.0,241.1 598.9,241.4 599.8,241.6 600.7,241.8 601.5,242.0 602.4,242.3 603.3,242.5 604.2,242.7 605.1,242.9 605.9,243.2 606.8,243.5 607.7,243.8 608.6,244.0 609.5,244.2 610.4,244.5 611.2,244.8 612.1,245.0 613.0,245.2 613.9,245.5 614.8,245.7 615.7,245.9 616.5,246.1 617.4,246.3 618.3,246.6 619.2,246.9 620.1,247.2 621.0,247.4 621.8,247.8 622.7,248.1 623.6,248.4 624.5,248.7 625.4,249.0 626.3,249.3 627.1,249.6 628.0,249.9 628.9,250.2 629.8,250.4 630.7,250.6 631.6,250.9 632.4,251.2 633.3,251.4 634.2,251.7 635.1,251.9 636.0,252.2 636.8,252.5 637.7,252.7 638.6,252.9 639.5,253.1 640.4,253.4 641.3,253.6 642.1,253.9 643.0,254.1 643.9,254.4 644.8,254.7 645.7,255.0 646.6,255.2 647.4,255.5 648.3,255.8 649.2,256.2 650.1,256.5 651.0,256.7 651.9,257.1 652.7,257.3 653.6,257.5 654.5,257.8 655.4,258.2 656.3,258.4 657.2,258.8 658.0,259.0 658.9,259.3 659.8,259.7 660.7,260.0 661.6,260.4 662.5,260.7 663.3,261.1 664.2,261.4 665.1,261.7 666.0,262.1 666.9,262.4 667.7,262.7 668.6,263.0 669.5,263.3 670.4,263.7 671.3,264.0 672.2,264.3 673.0,264.7 673.9,265.0 674.8,265.3 675.7,265.5 676.6,265.8 677.5,266.1 678.3,266.5 679.2,266.8 680.1,267.1 681.0,267.5 681.9,267.8 682.8,268.3 683.6,268.6 684.5,269.0 685.4,269.4 686.3,269.9 687.2,270.2 688.1,270.8 688.9,271.3 689.8,272.1 690.7,273.2 691.6,274.1 692.5,275.6 693.4,278.0" stroke="var(--accent)" stroke-width="2"/>
</g>
<g fill="var(--muted)" font-size="13" text-anchor="end">
<text x="70" y="314.5">10⁻⁴⁰</text>
<text x="70" y="278.3">10⁻³⁵</text>
<text x="70" y="242.0">10⁻³⁰</text>
<text x="70" y="205.8">10⁻²⁵</text>
<text x="70" y="169.5">10⁻²⁰</text>
<text x="70" y="133.3">10⁻¹⁵</text>
<text x="70" y="97.0">10⁻¹⁰</text>
<text x="70" y="60.8">10⁻⁵</text>
<text x="70" y="24.5">1</text>
</g>
<g fill="var(--muted)" font-size="13" text-anchor="middle">
<text x="78.0" y="328">0</text>
<text x="166.3" y="328">100</text>
<text x="254.6" y="328">200</text>
<text x="342.9" y="328">300</text>
<text x="431.1" y="328">400</text>
<text x="519.4" y="328">500</text>
<text x="607.7" y="328">600</text>
<text x="696.0" y="328">700</text>
</g>
<g fill="var(--ink)" font-size="17" text-anchor="middle">
<text x="387" y="354">step of the conjugate gradient method</text>
<text x="262.9" y="163.1" fill="var(--accent)" font-style="italic" text-anchor="end">error of the bound</text>
<text x="474.0" y="94.0" fill="var(--muted)" font-size="15" text-anchor="start">bound from the condition number</text>
<text x="457.7" y="38" fill="var(--code-function)" font-size="15" text-anchor="start">second round</text>
</g>
</svg>
<figcaption>The error of the lower bound after each step, for the run with 27 layers and top degree 14 (36 046 unknowns). The error is the sum of the gains of all later steps. It falls by a factor of 0.89 for each step, 20 steps for one digit, and it is below 10⁻²⁰ after 315 steps. The bound from the condition number 2 680 gives the factor 0.93.</figcaption>
</figure>

**In floating point** the three properties need care. I made each of these errors, and found each by a comparison with the Cholesky method on a small size.

- *The steps lose their orthogonality.* In exact arithmetic $C_k^{\mathsf T} r_k = 0$, and the bound is then only $6\,m^{\mathsf T}C_k$. In double precision this product grew by a factor of about 6 for each step, and at step 30 the short formula was $6\cdot10^{-5}$ above the true value. The formula with the gains stays correct, as Strakoš and Tichý showed in [*On error estimation in the conjugate gradient method and why it works in finite precision computations*](https://etna.math.kent.edu/vol.13.2002/pp56-80.dir/pp56-80.html) (2002). The gains are small numbers with full relative accuracy, so their sum gives the error of a step also where it is far below the rounding of $\kappa$. The figure uses this.
- *Double precision ends at 16 digits.* But the error of $\kappa$ is the square of the error of $C$. The first round of steps, in double precision, brings the residual to $10^{-13}$, and that gives $\kappa$ to $5\cdot10^{-25}$. A second round starts from the residual of the first, computed in double-double, and adds its result. Two products in double-double are all the high precision that the solver needs.
- *The products do not keep the symmetry.* $ACA$ is not exactly symmetric in floating point. The residual in double-double reads one triangle of $C$, and without an exact symmetry the result was wrong in the 15th digit.

With these corrections the two methods agree: to 24 digits for 12 layers and degree 4, with the same Gaussian sum, and in all 18 digits of the table above for 20 layers and degree 8.

**A wider Gaussian sum.** More digits need more of the Gaussian sum, and one test changed an earlier statement. The sum of the Cholesky runs starts at $t = e^{-42}$. The part below that is about $e^{-42}$ of each energy, and it is positive. Without it the energies are too small and $\kappa_N$ is too large. With the start at $e^{-56}$ the value for 12 layers decreases by $2.7\cdot10^{-19}$, and a start at $e^{-70}$ changes nothing more. The upper end has the same effect, $2.8\cdot10^{-20}$ for an end at $e^{52}$ in place of $e^{44}$. So the values of the Cholesky table are about $3\cdot10^{-19}$ too high. This is inside the stated error of $10^{-18}$, but beyond the 18th digit those values are not lower bounds. The new program sums from $e^{-56}$ to $e^{60}$ with the step $0.1$: 1 161 Gaussians.

**The runs.** The program [cg.jl](cg.jl) does all this. It takes the tables from `patches.jl`, so the two programs cannot differ in the system. Two runs with different meshes and degrees:

| | Run A | Run B |
|:---|---:|---:|
| Layers, top degree | 27, 14 | 26, 15 |
| Smallest patch | $e^{-38}$ | $e^{-36}$ |
| Edge functions, unknowns | 268, 36 046 | 259, 33 670 |
| Tables | 374 s | 606 s |
| Steps, first and second round | 421, 277 | 415, stopped |
| One product | 0.85 s | 1.37 s |
| One product in double-double | 14 s | 13 s |
| Total | 16 min | 20 min, the time limit |
| Memory in the table phase | 10 GB | |

$$
\small
\begin{aligned}
\kappa_A &= 0.660\,678\,154\,099\,567\,999\,152\,95 \\
\kappa_B &= 0.660\,678\,154\,099\,567\,999\,155\,72
\end{aligned}
$$

Run B passed its time limit of 20 minutes in its second round. The computer was slower during that run, and I did not find the cause. Its value is the bound of the first round. In run A the two rounds differ by $5\cdot10^{-25}$, so nothing is lost. Both values are lower bounds, and they differ by $2.8\cdot10^{-21}$. This agrees with the laws of the section before: run A has an error of about $3\cdot10^{-21}$ from its degree, and run B an error of about $10^{-21}$ from its mesh.

**Memory.** The tables are $KN^2$ numbers, in double-double and in double: 24 bytes each. For run A this is 2.0 GB, where the matrix $H$ would need 10 GB. For the largest Cholesky run it would be 3.4 GB in place of 28 GB. The peak of a run is higher, because the integrals in one variable are made with 1024-bit numbers on 32 threads. The memory is no limit now. The time is.

**More digits.** What would more digits cost on this computer? These are estimates from scaling laws. I did not run them.

- Each degree gains a factor of about 10: the top degree is the number of digits minus 6.
- The share of the last layer is its size to the power $4/3$: each digit needs the mesh depth $T$ larger by $0.86$, and $1.44$ layers for each unit of $T$.
- The edge functions $N$ then grow like the square of the digits, and the unknowns like the 4th power.
- The step of the Gaussian sum decreases like 1/digits and its range grows like the digits, so the Gaussians grow like the square.
- The table time grows like the 9th power of the digits, the time of the steps like the 10th, and the memory like the 6th.

| Digits | Layers, degree | Unknowns | Gaussians | Tables | Steps | Memory | Total time |
|---:|---:|---:|---:|---:|---:|---:|---:|
| 20 (run A) | 27, 14 | 36 046 | 1 161 | 6 min | 10 min | 2 GB | 16 min |
| 25 | 32, 19 | 80 000 | 1 300 | 30 min | 30 min | 5 GB | 1 hour |
| 30 | 38, 24 | 160 000 | 1 900 | 2 h | 3 h | 15 GB | 6 hours |
| 40 | 50, 34 | 480 000 | 3 400 | 28 h | 2 days | 130 GB | 4 days |
| 50 | 62, 44 | 1 100 000 | 5 300 | 8 days | 17 days | 480 GB | 4 weeks |

The Cholesky method would need 50 GB, 200 GB, 1.9 TB and 10 TB for the matrix of these four rows.

The rows for 25 and 30 digits are possible with the program as it is: one hour, and one night. From 31 digits on, double-double is not sufficient for the last residual. The rows for 40 and 50 digits do not fit into 64 GB. They would need the tables in double precision only, half of each symmetric table, and the high precision tables made again for the last residual: about 13 GB and 48 GB. The products of `cg.jl` reach about a quarter of the speed of this processor, so the time of the steps can decrease 3 to 4 times. The time of the tables cannot decrease so easily. Forty digits are a project of days, and fifty digits are not practical with this method on one desktop. And each of these values needs a second run with a different mesh before its digits can be trusted.

## The result

$$
\kappa = 0.660\,678\,154\,099\,567\,999\,16 \pm 10^{-20}
$$

The two conjugate gradient runs give the lower bounds $0.660\,678\,154\,099\,567\,999\,152\,95$ and $0.660\,678\,154\,099\,567\,999\,155\,72$. Each is a little low: the first by about $3\cdot10^{-21}$ from its degree, the second by about $10^{-21}$ from its mesh. These two numbers are estimates from the scaling laws, not measurements. From the bounds and the estimates I take the value above, and I assume an error of $10^{-20}$. It is an estimate, not a proved bound. The nearest double is `0.660678154099568`.

The Cholesky runs agree with this. Their first result was $0.660\,678\,154\,099\,568\,000 \pm 10^{-18}$, and the new value is inside that range. The best of them, less the $3\cdot10^{-19}$ of its short Gaussian sum, is about $5\cdot10^{-20}$ below the new value. That is the effect of its larger smallest patch, $e^{-32}$.

These numerical parameters could spoil the last digits:

- The smallest patch. The mesh of the Cholesky runs stops at $e^{-32}$ from the edge, and with two more layers their result moves by $2\cdot10^{-19}$. The two new runs stop at $e^{-38}$ and $e^{-36}$. Their difference of $2.8\cdot10^{-21}$ contains this effect.
- The step of the Gaussian sum. The steps $0.12$ and $0.10$ agree to $5\cdot10^{-22}$, and the new runs use $0.10$, with an error bound 4 000 times smaller than that of $0.12$. The nodes $t_k$ must be exact: when I rounded $\ln t_k$ to double precision, the result moved by $2\cdot10^{-17}$.
- The range of the Gaussian sum. The range $e^{-42} \le t \le e^{44}$ of the Cholesky runs makes their values $3\cdot10^{-19}$ too high. The new range is $e^{-56} \le t \le e^{60}$. For 12 layers a start at $e^{-70}$ changes no digit of 24.
- The solver. The two rounds of the conjugate gradient method differ by $5\cdot10^{-25}$.

The value agrees with the best published one, $0.66067815409957$ of Helsing and Perfekt, in all its digits.

## The programs

The three programs are plain Julia with threads, without packages:

- [shells.jl](shells.jl) makes the two shell tables. The matrix is assembled over the orbits of the 48 symmetries. The values $Q_n$ are refined to 28 digits with double-double residuals, so that the extrapolation does not amplify rounding errors.
- [patches.jl](patches.jl) makes the patch table. The integrals in one variable cancel strongly and use 1024-bit numbers. The matrix $H$ and its Cholesky factor are in double precision, and the solution is refined with double-double residuals.
- [cg.jl](cg.jl) solves the same system with the conjugate gradient method. It includes `patches.jl` for the mesh and the tables, and it adds the products without the matrix, the steps in double precision and the residual in double-double.

```
julia -t auto shells.jl 512
julia -t auto patches.jl
julia -t auto cg.jl
```

On a 32-thread desktop (Core i9-13900K, 64 GB) the shell tables take about 2 minutes, most of it for $n = 512$, and the six default rows of the patch table take 8 minutes. The last row of the patch table is `julia -t auto patches.jl 32 14 0.75`. It needs 19 minutes and about 30 GB. The line with `cg.jl` is run A, 16 minutes with Julia 1.13. Run B is `julia -t auto cg.jl 26 15 0.75 18`.

## Notes

Is this new? The idea is not. It is the Rayleigh–Ritz method: restrict a variational problem to a finite family and solve a linear system. Each part has a name and a history.

- The energy principle is due to Gauss and Thomson. For the capacity it is the base of Pólya and Szegő, *Isoperimetric Inequalities in Mathematical Physics* (1951).
- A finite family with the matrix of energies is Maxwell's method of subareas, in electrical engineering the method of moments (Harrington, 1968), and with the energy as the scalar product the Galerkin boundary element method. The formula $\mathbf 1^{\mathsf T} G^{-1} \mathbf 1$ with its error identity is in Betcke, Haberl and Praetorius, [*Adaptive boundary element methods for the computation of the electrostatic capacity on complex polyhedra*](https://arxiv.org/abs/1901.08393) (2019).
- The energy of two overlapping shells is, up to a factor, the trace of the Rotne–Prager–Yamakawa tensor of hydrodynamics (Zuk, Wajnryb, Mizerski and Szymczak, 2014). There the same sum over the inverse matrix gives the hydrodynamic radius of a chain of beads.
- $G = LL^{\mathsf T}$ and $\sum z_j^2$ are Cholesky, Gram–Schmidt and Parseval.
- Patches graded in a fixed ratio toward the edges, with polynomials on them, are the *hp* boundary element method, which is known to converge exponentially for such densities. The references are in the section *Why it is fast*.
- The conjugate gradient method is from Hestenes and Stiefel (1952). A solver that uses only products with the matrix is the usual way to solve a large boundary element system. That its steps give lower bounds of $m^{\mathsf T}H^{-1}m$, and how to get upper bounds, is in Golub and Meurant (1997, 2010).
- The sum of Gaussians for $1/r$ is a standard tool as well: sinc quadrature (Stenger), and Beylkin and Monzón, *Approximation by exponential sums revisited* (2010).

What can be particular to this post is the combination: the nested shell family in this order as an explicit series, and the patch system with all integrals reduced to $\operatorname{erf}$. I did not find the shell series in the literature, and a short search showed no published value of $\kappa$ with more than 14 digits. Neither search was complete, and I do not claim that anything here is new.

The lower bounds are exact statements about exact arithmetic. That the bounds converge to $\kappa$, and how many digits are final, rests here on the numbers: on the agreement of runs with different meshes, degrees and parameters, on the agreement of the two solvers, and on the agreement with the 13 digits of Helsing and Perfekt, [*On the polarizability and capacitance of the cube*](https://arxiv.org/abs/1203.5997) (2013), $0.66067815409957$.
