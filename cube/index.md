---
title: The capacitance of a cube
date: 2026-11-22
author: Hrvoje Abraham, Fable 5.2
doi: 10.5281/zenodo.24451074
---

A metal sphere of radius $r$ has the capacitance $4\pi\varepsilon_0 r$. For a metal cube no formula is known, only numbers. This post has two results.

The first is a series of positive terms for that number, made of charged spherical shells. Each term is an algebraic number from a closed formula, with no integral. The series is exact, but too slow to give many decimals.

The second is a fast series of the same structure, made of charged patches on the faces. It gives

$$
\small
C_{\text{cube}} = 4\pi\varepsilon_0\, s\,\kappa, \qquad \kappa = 0.660\,678\,154\,099\,568\,000 \pm 10^{-18}
$$

for a cube of side $s$. The error is an estimate from the convergence, not a proved bound.

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

**1. The Gaussians.** Take $t_k = e^{0.12\,k}$ and $w_k = \frac{2}{\sqrt\pi}\, 0.12\, t_k$ for $k = -350, \dots, 366$.

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

Each row is a lower bound. The errors are differences from the last row, and they fall by a factor of 100 to 2000 from row to row. Sixteen digits need about 17 000 unknowns. The shells gave 3 digits with 1.5 million.

## The result

$$
\kappa = 0.660\,678\,154\,099\,568\,000 \pm 10^{-18}
$$

The best run gives $0.660\,678\,154\,099\,567\,999\,4$, a lower bound. The last two runs differ by $3.5\cdot10^{-19}$, and the step before that was $4\cdot10^{-17}$, so the next step is far below $10^{-19}$. The numerical parameters below add at most $3\cdot10^{-19}$ each. From these I assume an error of $10^{-18}$. It is an estimate, not a proved bound. The nearest double is `0.660678154099568`.

Three numerical parameters could spoil the last digits, and I varied each of them:

- The smallest patch. The mesh stops at $e^{-32}$ from the edge. With two more layers the result moves by $2\cdot10^{-19}$.
- The step of the Gaussian sum. The steps $0.12$ and $0.10$ agree to $5\cdot10^{-22}$. The nodes $t_k$ must be exact: when I rounded $\ln t_k$ to double precision, the result moved by $2\cdot10^{-17}$.
- The range of the Gaussian sum, $e^{-42} \le t \le e^{44}$. A wider range moves the result by less than $3\cdot10^{-19}$.

The value agrees with the best published one, $0.66067815409957$ of Helsing and Perfekt, in all its digits.

## The programs

Both programs are plain Julia with threads, without packages:

- [shells.jl](shells.jl) makes the two shell tables. The matrix is assembled over the orbits of the 48 symmetries. The values $Q_n$ are refined to 28 digits with double-double residuals, so that the extrapolation does not amplify rounding errors.
- [patches.jl](patches.jl) makes the patch table. The integrals in one variable cancel strongly and use 1024-bit numbers. The matrix $H$ and its Cholesky factor are in double precision, and the solution is refined with double-double residuals.

```
julia -t auto shells.jl 512
julia -t auto patches.jl
```

On a 32-thread desktop (Core i9-13900K, 64 GB) the shell tables take about 2 minutes, most of it for $n = 512$, and the six default rows of the patch table take 8 minutes. The last row of the patch table is `julia -t auto patches.jl 32 14 0.75`. It needs 19 minutes and about 30 GB.

## Notes

Is this new? The idea is not. It is the Rayleigh–Ritz method: restrict a variational problem to a finite family and solve a linear system. Each part has a name and a history.

- The energy principle is due to Gauss and Thomson. For the capacity it is the base of Pólya and Szegő, *Isoperimetric Inequalities in Mathematical Physics* (1951).
- A finite family with the matrix of energies is Maxwell's method of subareas, in electrical engineering the method of moments (Harrington, 1968), and with the energy as the scalar product the Galerkin boundary element method. The formula $\mathbf 1^{\mathsf T} G^{-1} \mathbf 1$ with its error identity is in Betcke, Haberl and Praetorius, [*Adaptive boundary element methods for the computation of the electrostatic capacity on complex polyhedra*](https://arxiv.org/abs/1901.08393) (2019).
- The energy of two overlapping shells is, up to a factor, the trace of the Rotne–Prager–Yamakawa tensor of hydrodynamics (Zuk, Wajnryb, Mizerski and Szymczak, 2014). There the same sum over the inverse matrix gives the hydrodynamic radius of a chain of beads.
- $G = LL^{\mathsf T}$ and $\sum z_j^2$ are Cholesky, Gram–Schmidt and Parseval.
- Patches graded in a fixed ratio toward the edges, with polynomials on them, are the *hp* boundary element method, which is known to converge exponentially for such densities.
- The sum of Gaussians for $1/r$ is a standard tool as well: sinc quadrature (Stenger), and Beylkin and Monzón, *Approximation by exponential sums revisited* (2010).

What can be particular to this post is the combination: the nested shell family in this order as an explicit series, and the patch system with all integrals reduced to $\operatorname{erf}$. I did not find the shell series in the literature, and a short search showed no published value of $\kappa$ with more than 14 digits. Neither search was complete, and I do not claim that anything here is new.

The lower bounds are exact statements about exact arithmetic. That the bounds converge to $\kappa$, and how many digits are final, rests here on the numbers: on the agreement of runs with different meshes, degrees and parameters, and on the agreement with the 13 digits of Helsing and Perfekt, [*On the polarizability and capacitance of the cube*](https://arxiv.org/abs/1203.5997) (2013), $0.66067815409957$.
