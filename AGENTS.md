# Rules for work on this blog

These rules are for each agent and each person who writes or changes a post. Read [README.md](README.md) first: it tells how a post is made and built. This file tells what a good post is, and which errors were made before.

## Language

- Write in Simplified Technical English (ASD-STE100): short sentences, one meaning for each word, active voice, no idioms.
- Follow Zinsser: simplicity, brevity, clarity, humanity. Remove each word that does no work.
- Use one term for one thing in the full post. If the post says "patch", do not change to "element" or "panel" later.
- The posts are in the first person of the author. Write "I" only for work that was done for the post. Do not invent how the author found a value or made a decision. If you do not know, say only what the value is.

## Claims and numbers

- Each number in a post comes from a run of the programs of the post. Give the parameters of the run with the number.
- Calculate each number. Do not take it from an earlier text or from memory. A value that is correct for one run can be wrong for a different run. Example: the ratio between two mesh layers was 4 for 23 layers and 7.4 for 16 layers.
- Label a model as a model. A simplified calculation shows a mechanism. Its numbers are not the errors of the real calculation, and the text must say so.
- Separate these three clearly: a proved statement, an argument, a number from an experiment. Use the words "proved", "argument" and "measured" or "estimate".
- Read each sentence next to a table against the table. The sentence and the table must not contradict each other.
- If a result contradicts an earlier statement in the post or in the conversation, correct the statement and say that it was corrected.

## References

- Search for each reference before you cite it. Confirm the authors, the title, the year and the journal.
- Cite a paper only for what you confirmed it contains. If you derive a formula or an exponent, present it as the argument of the post, not as the result of the paper.
- Give a historic reference and a modern one for each named method: the first paper, and a current textbook or review.
- Link to an open copy when one is available (arXiv, Numdam, a DOI).

## Explanations

- Give each known method its name, and say what each part of the name means. A reader must be able to search for it.
- When the post uses a sum of basis functions, say what one basis function is, what the unknowns are, and what the sum is on one element.
- When the post makes a choice (a mesh, a degree, a parameter), give the reason and the alternative, and show what the alternative gives. A run of the alternative is better than an opinion about it.
- Show the result, not only its accuracy. If the post calculates a field, draw the field.

## Figures

- Line drawings are inline SVG in `index.md`. Use the theme variables (`var(--ink)`, `var(--muted)`, `var(--accent)`, `var(--rule)`) for all lines and text, so that light and dark mode are correct.
- A field (a density, a potential) is a raster. Write PNG files into the post folder and put them into an SVG figure with `<image>`. Keep all labels as SVG text, not as pixels.
- Make the colour scale of a raster with the same code as the raster. A picture with bands must have a scale with the same bands.
- Use a logarithmic colour scale for a quantity that covers many decades, and say so in the caption. Use a scale with monotone lightness, not a rainbow.
- If the true geometry hides the structure, add a second view that shows it, and say how the second view is changed.
- The caption gives the run that made the figure: its parameters, and the meaning of each colour and line.
- Give each figure an `aria-label` that describes what it shows.

## Layout

The build makes these guarantees. Do not work around them by hand, and do not remove them.

- **Punctuation stays with a formula.** The build joins each inline formula with the text that touches it, so a comma or a bracket cannot stand alone at a line start or end. If the build stops with "punctuation touches a formula through markup", move the punctuation into the markup.
- **Table cells do not wrap.** A wide table scrolls sideways. Keep each cell short: a number, an amount with its unit, a few words. Put a long explanation into the text before the table.
- **Number groups stay together.** Write a long number with plain spaces between the groups (`58 996`). The build joins the groups.
- Put the punctuation of a display formula inside the formula.

When you change `build.mjs` or `assets/style.css`:

- Make a guarantee structural. The build must make the defect impossible, or it must stop. A rule that an author can forget is not a guarantee.
- Prove the change in a browser. Lay out a post at many widths from 280 px to 1000 px and count the defects, before and after. A style rule that must work in theory can fail in the browser: a `white-space: nowrap` on an ancestor did not stop the line break after a formula.
- A test must first fail on the old page. A test that cannot fail proves nothing.

## Build and verification

- Run `npm run build` after each change. Do not edit an `index.html` by hand.
- Look at the result. Render the changed part of the page with a headless browser and read the image: formulas, figures, tables, the narrow layout.
- A change of the build or the style changes all posts. Examine all of them, or say which ones you did not examine.
- Report what was measured and what was not. Do not write "verified" for a thing that was only built.

## Programs and data

- Do not change a program of a published post to get a number for a new text. Load it from a second script and change only what is necessary, so the published program and the new number cannot differ.
- Each script has a time limit for the full process, and no open input. If a run passes its expected time, stop it and find the cause.
- Do not send program text with backslashes or Unicode escapes through shell quoting to change a file. The shell changes it without an error. Change the file directly.
- Keep temporary scripts and pages out of the repository. Tell the author where they are, and ask before you add them to a post folder.

## Julia

- Use the Julia in the user Programs folder: `%LOCALAPPDATA%\Programs\Julia-1.13.4\bin\julia.exe` (version 1.13.4, installed 2026-11-23 from the official archive, checksum verified). It is not on the `PATH`, so call it with the full path. Older versions are in `C:\Julia-1.1x.y`. Do not use them for new work.
- For a new version, take the newest stable entry of `https://julialang-s3.julialang.org/bin/versions.json`, verify the SHA-256 of the archive, and extract it next to the present one. Then change the path in this file.
- Start a program with `-t auto`. The machine has 32 threads: 8 fast cores and 16 slow ones.
- For one large matrix product, set `BLAS.set_num_threads(8)`. With 16 to 32 threads the product was up to 2 times slower, because BLAS then also uses the slow cores. For many products of moderate size, use Julia tasks with `BLAS.set_num_threads(1)`, as `product!` in `cube/cg.jl` does.
- A name that is assigned inside a `@threads` loop and also outside it in the same function is one variable for all threads. The result is wrong sums, without an error. Example: `G = parts[n]` inside the loop and `G = sum(parts)` after it. Use a name inside the loop that is not used in the rest of the function. This error was made twice here, and the first time it was blamed on BLAS.
- Matrix products in floating point do not keep symmetry: `A*C*A` is not exactly symmetric for symmetric `A` and `C`. If a later step reads only one triangle, make the matrix symmetric first.
- In floating point the conjugate gradient method loses the orthogonality of its steps. Do not use a formula that is true only with that orthogonality, such as the short form of the bound. Use the form with the residual, or the sum of the step gains.
- `patches.jl` defines its own `mul!`. A script that includes it must write `LinearAlgebra.mul!` for the matrix product.
- Compare each new solver with the old one on a small case before you use its numbers, to all digits that the old one has. A check against the largest entry of a matrix does not see an error in the small entries. All errors above were found by such comparisons, and the last one only at the 15th digit.

## Published material

- A folder with a deposit (for example `cube/zenodo/`) is a published record with a DOI. Change it only when the author asks for a new version. If a post changes after its deposit, tell the author that the two now differ.
- A new version is made with `cube/zenodo/publish.ps1`. It opens a draft of the next version of the published record, builds the PDF, uploads the files and publishes. A published version cannot be changed or removed, so compile and read the PDF before the run. State in the paper what is new in the version.
- The token is in the environment variable `ZENODO_TOKEN`. Do not print it and do not write it into a file.
- Commit only when the author asks. A commit includes the generated `index.html` files.
