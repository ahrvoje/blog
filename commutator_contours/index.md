---
title: On the Applications of Commutator Contours
date: 2024-07-01
author: Hrvoje Abraham
email: ahrvoje@gmail.com
---

I accidentally noticed that some contours with special properties, called commutator contours, appear as solutions of two rather distinct problems: picture-hanging puzzles and integral representations of special functions. In this post, we will unify these two stories.

## Commutator Contours
Camille Jordan was the first to introduce the concept of the commutator contour in his legendary Cours d'Analyse [[1]](#1) in 1887, which unfortunately was never translated into English. As he introduced it first, I will call it Jordan-Pochhammer contour, rather than just the Pochhammer contour as most often referenced by formal sources. As described in the Wikipedia article on Jordan-Pochhammer contour [[2]](#2):

> *A Pochhammer contour winds clockwise around one point, then clockwise around another point, then counterclockwise around the first point, then counterclockwise around the second. ... Its winding number about any point is 0 despite the fact that within the doubly punctured plane it cannot be shrunk to a single point.*

![Jordan-Pochhammer contour](Jordan-Pochhammer_curve.png){width=450}

Net zero winding can be easily checked by illustration of the contour cycle:

![Jordan-Pochhammer cycle](Jordan-Pochhammer_cycle.png){width=450}

Jordan-Pochhammer contour is an example of commutator contour for two points. The question is: can such a contour be constructed given n points, and how? The answer is yes, and the paper on picture-hanging puzzles [[3]](#3) offers two constructions, exponential and polynomial.

We define $2n$ symbols ($x_1$, $x_1^{-1}$, ..., $x_n$, $x_n^{-1}$) with $x_i$ being winding the curve around point $i$ clockwise and $x_i^{-1}$ for winding it counterclockwise. The algebra rules are simple: symbol's order can't change, and the product $x_i \cdot x_i^{-1}$ reduces to $1.$

![](notation.png){width=450}

*Example of the contour for the expression $x_1 x_2 x_1^{-1} x_2^{-1}.$ Simply follow the line considering consecutive symbols in the expression.*

In the exponential construction, a 3-point commutator curve can be built starting with 2-point commutator being extended to 3 points:

$$S_2 = [x_1, x_2] = x_1 x_2 x_1^{-1} x_2^{-1}$$

$$
\begin{equation*}
\begin{split}
S_3 &= [S_2, x_3] = S_2 x_3 S_2^{-1} x_3^{-1} = \\
    &= (x_1 x_2 x_1^{-1} x_2^{-1}) x_3 (x_1 x_2 x_1^{-1} x_2^{-1})^{-1} x_3^{-1} = \\
    &= x_1 x_2 x_1^{-1} x_2^{-1} x_3 x_2 x_1 x_2^{-1} x_1^{-1} x_3^{-1}
\end{split}
\end{equation*}
$$

This construction is called exponential as commutator is longer by a factor of 2 for any additional point, with additional two entries for $x_n$ and $x_n^{-1}$. With every step we get $S_n = [S_{n-1}, x_n] = S_{n-1} x_n S_{n-1}^{-1} x_n^{-1}.$

It would be convenient to find a way to construct a shorter variant if possible, and that is the polynomial construction defined by Chris Lusby Taylor [[3]](#3), [[4]](#4). For a single point, we define $E(i:i)=x_i$, for two points we define $E(i:i+1) = [x_i, x_{i+1}] = x_i x_{i+1} x_i^{-1} x_{i+1}^{-1}$. Now for some specific problem with $n$ points the solution is obtained by recursion

$$E(i:j) = \left[ E \left( i: \left\lfloor \frac{i+j}{2} \right\rfloor \right), E \left( \left\lfloor \frac{i+j}{2} \right\rfloor + 1 : j \right) \right]$$

Using polynomial construction for 3 points doesn't result in any gain compared to the exponential version, but for 4 points, polynomial commutator contains 16 symbols compared to 22 in the exponential version.

$$
\begin{equation*}
\begin{split}
    &E(1:4) = [E(1:2), E(3,4)] = \\
    &= E(1:2) E(3,4) E(1,2)^{-1} E(3:4)^{-1} = \\
    &= (x_1 x_2 x_1^{-1} x_2^{-1}) (x_3 x_4 x_3^{-1} x_4^{-1}) \cdot \\
    & \qquad \cdot (x_1 x_2 x_1^{-1} x_2^{-1})^{-1} (x_3 x_4 x_3^{-1} x_4^{-1})^{-1} = \\
    &= x_1 x_2 x_1^{-1} x_2^{-1} x_3 x_4 x_3^{-1} x_4^{-1} \cdot \\
    & \qquad \cdot x_2 x_1 x_2^{-1} x_1^{-1} x_4 x_3 x_4^{-1} x_3^{-1}
\end{split}
\end{equation*}
$$

Length of n-point commutator resulting from the polynomial construction is $n^2$ (hence the name) which is considerably shorter compared to the exponential version with size $2^n$.

## Picture-Hanging Puzzles
As mentioned, the corresponding commutator contour is the solution of the picture-hanging problem: "Hang a picture on n nails so that removing any one nail causes the picture to fall."

![](notation.png){width=450}

*The solution of the picture-hanging problem for two nails with the commutator $x_1 x_2 x_1^{-1} x_2^{-1}.$*

![](solution-3.png){width=450}

*The solution of the picture-hanging problem for three nails with the commutator $x_1 x_2 x_1^{-1} x_2^{-1} x_3 x_2 x_1 x_2^{-1} x_1^{-1} x_3^{-1}.$*

A commutator contour is the solution of the problem because removing some nail $i$ algebraically corresponds to removing symbols $x_i$ & $x_i^{-1}$ from the commutator expression, after which some $x_j, x_j^{-1}$ pairs come "in direct contact" and by step by step multiplication, the entire expression reduces to $1$, which is interpreted as "the knot is no more." The property is a straightforward consequence of the construction described before.

At this point it is interesting to note that $n$-point solutions are not unique. Commutators can be defined in different ways by choosing different starting symbols pair. In the 2-point example, we constructed the commutator with $[x_1, x_2]$, but using the commutator $[x_1, x_2^{-1}]$ instead is equally valid. This way we get the second solution. Depending on the literature, some use the first, some the second. Effects are similar as they would be for any adequate n-point commutator contour.

![](notation.png){width=450} ![](solution-2A.png){width=450}

*Two complementary solutions of two-nail picture-hanging problem from two different sources: [[3]](#3) with commutator $x_1 x_2 x_1^{-1} x_2^{-1}$ and [[7]](#7) with $x_1 x_2^{-1} x_1^{-1} x_2.$*

## Integral Representations of Special Functions
As mentioned, Camille Jordan was the first to introduce the concept of the commutator contour. He needed it as a tool for constructing integral representations of multivalued complex functions. As seen from the Appendix, he used a similar formalism with expressions such as $A B A^{-1} B^{-1}.$ My first contact with the topic was when I was intrigued by the contour in the NIST Handbook of Mathematical Functions [[5]](#5) used in the integral representation of the Kummer hypergeometric function.

![](F1.mag.png){width=450}

*NIST Handbook of Mathematical Functions, 13.4, [https://dlmf.nist.gov/13.4](https://dlmf.nist.gov/13.4)*

The handbook also presents the Jordan-Pochhammer contour used in integral representation of the Beta function. Leo Pochhammer visualized it for the first time in "Zur Theorie der Euler'schen Integrale" [[6]](#6) in 1890 in a slightly different manner, as shown in the Appendix.

![](F3.mag.png){width=450}

*NIST Handbook of Mathematical Functions, 5.12, [https://dlmf.nist.gov/5.12](https://dlmf.nist.gov/5.12)*

TODO: Here I will skip the theory of integral representations, which I would very much like to cover for its elegance and beauty: why commutator contour, topology of Riemann surfaces, traveling the surface, and accumulating the phase, etc.

The technique is also used in integral representations of Legendre functions. With varying numbers of branch points and their configuration, there are quite a few cases to cover. One example from Courant-Hilbert Methods of Mathematical Physics, Vol. 1 [[8]](#8), with the full page shown in the Appendix:

![](legendre_MMP_Courant_Hilbert_507.png){width=450}

TODO: Identify commutator contours for integral representations of multivalued functions with three or more branch points. It would be nice to utilize polynomial construction and check different configurations of branch points and contours.

A year ago, I accidentally discovered a small gem - a modest scan of a page from Schrödinger's notebook containing the first record of his famous equation. The notebook was created during his visit to Villa Herwig-Arosa at Christmas 1925. Along with the equation, this exact part of the page contains a two branch points integration commutator contour, possibly even a try to draw a complementary contour as there are two of them with slight experimentation on its construction.

![Schrödinger's equation - George Japaridze facebook post 01.05.2023.](schrodinger_contour.png){width=700}

*Note from Schrödinger's 1925 notebook with the first record of the equation. The same part of the page contains two commutator contours of two branch points problem. (Disclaimer: unverified)*

## Conclusion
I would be interested in obtaining more examples of application of commutator contours, such as integral representations with three or more branch points, or in totally different domains. Additionally, it would be interesting to know if there has been any generalized treatise to date.

## Acknowledgements
I would like to express my sincere gratitude to all those who influenced the creation of the post. To the colleague physicist Goran Duplančić for introducing me to the picture-hanging problem. To my dear colleague Matej Dobrovodski for buying and flying the NIST book from the UK as none of us knew the book is about the size of a small pig. Last but not least, to Ivica Smolić for useful discussion and for motivating me to produce some output on this modest observation.

## Appendix

![Camille Jordan, Cours d'Analyse, Ed. 2, Vol. 3, pg. 242](jordan_contour_1.png){width=600}

![Camille Jordan, Cours d'Analyse, Ed. 2, Vol. 3, pg. 243](jordan_contour_2.png){width=600}

![Camille Jordan, Cours d'Analyse, Ed. 2, Vol. 3, pg. 244](jordan_contour_3.png){width=600}

*First introduction of the concept of commutator contour by Camille Jordan, 1887 [[1]](#1)*

![Pochhammer, L. (1890), Zur Theorie der Euler'schen Integrale, Mathematische Annalen, 35 (4), pg. 499](pochhammer.png){width=600}

*Pochhammer's first visualization of commutator contour in "Zur Theorie der Euler'schen Integrale", 1890 [[6]](#6)*

![](legendre_MMP_Courant_Hilbert_506.png){width=600}

![](legendre_MMP_Courant_Hilbert_507.png){width=600}

*Integral representation of Legendre function from Courant-Hilbert "Methods of Mathematical Physics" [[8]](#8)*

![Schrödinger's equation - George Japaridze facebook post 01.05.2023.](schrodinger_page.png){width=600}

*The page from Schrödinger's 1925 notebook with the first record of the equation. Same part of the page contains two commutator contours of the two branch points problem. (Disclaimer: unverified)*

## References

1. Camille Jordan, Cours d'analyse de l'École polytechnique, 1887, Ed. 1, Vol. 3, pg. 242-244 [https://archive.org/details/coursdanalysede08jordgoog/page/242/mode/2up](https://archive.org/details/coursdanalysede08jordgoog/page/242/mode/2up) {#1}
2. [https://en.wikipedia.org/wiki/Pochhammer_contour](https://en.wikipedia.org/wiki/Pochhammer_contour) Jordan-Pochhammer contour {#2}
3. [https://arxiv.org/abs/1203.3602](https://arxiv.org/abs/1203.3602) Picture-hanging puzzles {#3}
4. [http://www.mathpuzzle.com/hangingpicture.htm](http://www.mathpuzzle.com/hangingpicture.htm) Ed Pegg Jr., Picture hanging, 2002 {#4}
5. [https://dlmf.nist.gov/13.4](https://dlmf.nist.gov/13.4) Integral representation of the Kummer function {#5}
6. [https://zenodo.org/records/1428390](https://zenodo.org/records/1428390) Pochhammer, L. (1890), Zur Theorie der Euler'schen Integrale, Mathematische Annalen, 35 (4), pg. 499 {#6}
7. [https://laurentlessard.com/bookproofs/hanging-a-picture-frame/](https://laurentlessard.com/bookproofs/hanging-a-picture-frame/) {#7}
8. R. Courant, D. Hilbert, Methods of Mathematical Physics, Vol. 1, Interscience (Wiley) New York, 1962. {#8}
