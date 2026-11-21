# Enjoying the details

The blog is a static site for GitHub Pages. GitHub serves the files as they are (`.nojekyll`).

## Add or change a post

1. Make a folder in the root. Put `index.md` and all images of the post in it.
2. Start `index.md` with the front matter. `title` and `date` are necessary.

   ```
   ---
   title: The Title
   date: 2024-07-01
   ---
   ```

3. Run `npm install` one time, then `npm run build` after each change.
4. Commit the result, the generated `index.html` files included.

The build writes `index.html` into each post folder and the list of posts into the root `index.html`. Do not edit these files by hand.

## Markdown rules

- `$...$` is inline mathematics and `$$...$$` is display mathematics (KaTeX). An error in a formula stops the build.
- A paragraph that contains only images becomes a figure. Put `{width=450}` after an image to set its width.
- A paragraph fully in `*emphasis*` directly after a figure becomes its caption.
- A missing image file stops the build.

The page template is in `build.mjs`. The style is in `assets/style.css`.
