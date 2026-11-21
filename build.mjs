// Builds the site: every folder with an index.md becomes a post (index.html in
// the same folder), and the root index.html lists all posts.
// Run: npm run build

import fs from 'node:fs';
import path from 'node:path';
import MarkdownIt from 'markdown-it';
import attrs from 'markdown-it-attrs';
import katex from 'katex';

const ROOT = import.meta.dirname;
const SITE = 'Enjoying the details';
const AUTHOR = 'Hrvoje Abraham';
const SKIP = new Set(['node_modules', 'assets']);

const esc = (s) =>
  String(s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');

// ---------------------------------------------------------------- Markdown

// Subtle colour for code blocks: comments (* ... *), strings, numbers, functions
// and variables. A name is a function if a call follows it ("[", "@" or "/@") or if it
// starts with a capital letter (a built-in symbol); other names are variables.
// One capital letter at the start of a line, before two spaces, is a row label.
const highlight = (code) =>
  code.replace(
    /(\(\*[\s\S]*?\*\))|("(?:\\.|[^"\\])*")|([A-Za-z$][A-Za-z0-9$`]*)|(\b\d+(?:\.\d+)?(?:[eE][-+]?\d+)?\b)|[&<>]/g,
    (m, comment, string, name, number, offset) => {
      let kind = comment ? 'c' : string ? 's' : number ? 'n' : '';
      if (name) {
        const next = code.slice(offset + m.length);
        const label = m.length === 1 && /^[A-Z]$/.test(m) && /^ {2}/.test(next) && (offset === 0 || code[offset - 1] === '\n');
        if (!label) kind = /^([[@]| ?\/@)/.test(next) || /^[A-Z]/.test(m) ? 'f' : 'v';
      }
      return kind ? `<span class="${kind}">${esc(m)}</span>` : esc(m);
    },
  );

const md = new MarkdownIt({ html: true, typographer: true, highlight }).use(attrs);

// $$ ... $$ on its own lines: display math.
md.block.ruler.before(
  'fence',
  'math_block',
  (state, start, end, silent) => {
    const line = (n) => state.src.slice(state.bMarks[n] + state.tShift[n], state.eMarks[n]);
    const first = line(start);
    if (!first.startsWith('$$')) return false;
    const lines = [first.slice(2)];
    let last = start;
    while (!lines.at(-1).trimEnd().endsWith('$$')) {
      if (++last >= end) return false;
      lines.push(line(last));
    }
    if (silent) return true;
    const token = state.push('math_block', '', 0);
    token.content = lines.join('\n').trimEnd().slice(0, -2);
    token.map = [start, last + 1];
    state.line = last + 1;
    return true;
  },
  { alt: ['paragraph', 'reference', 'blockquote', 'list'] },
);

// $ ... $ in text: inline math. No space is permitted next to the delimiters.
md.inline.ruler.after('escape', 'math_inline', (state, silent) => {
  const { src, pos } = state;
  if (src[pos] !== '$') return false;
  const close = src.indexOf('$', pos + 1);
  if (close === -1) return false;
  const content = src.slice(pos + 1, close);
  if (!content || /^\s|\s$/.test(content)) return false;
  if (!silent) state.push('math_inline', '', 0).content = content;
  state.pos = close + 1;
  return true;
});

const tex = (content, displayMode, env) => {
  env.math = true;
  return katex.renderToString(content, { displayMode, throwOnError: true });
};
md.renderer.rules.math_inline = (tokens, i, _o, env) => tex(tokens[i].content, false, env);
md.renderer.rules.math_block = (tokens, i, _o, env) =>
  `<div class="math">${tex(tokens[i].content, true, env)}</div>\n`;

// A paragraph that holds only images becomes a <figure>. A paragraph in
// *emphasis* directly after it becomes the <figcaption>. Headings get ids.
md.core.ruler.push('figures_and_ids', (state) => {
  const tokens = state.tokens;
  const imagesOnly = (children) =>
    children.some((c) => c.type === 'image') &&
    children.every(
      (c) =>
        ['image', 'link_open', 'link_close', 'softbreak'].includes(c.type) ||
        (c.type === 'text' && !c.content.trim()),
    );
  const emphasisOnly = (c) =>
    c.length > 2 &&
    c[0].type === 'em_open' &&
    c.at(-1).type === 'em_close' &&
    c.filter((t) => t.type === 'em_close' && t.level === 0).length === 1;

  for (let i = 0; i < tokens.length; i++) {
    const [open, inline, close] = [tokens[i], tokens[i + 1], tokens[i + 2]];
    if (open.type === 'heading_open') {
      const id = inline.content.toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '');
      if (id) open.attrSet('id', id);
    }
    if (open.type !== 'paragraph_open' || !imagesOnly(inline.children)) continue;
    open.tag = close.tag = 'figure';
    inline.children = inline.children.filter((c) => c.type !== 'softbreak' && c.type !== 'text');
    const caption = tokens[i + 4];
    if (tokens[i + 3]?.type === 'paragraph_open' && emphasisOnly(caption.children)) {
      caption.children = caption.children.slice(1, -1);
      tokens[i + 3].tag = tokens[i + 5].tag = 'figcaption';
      tokens.splice(i + 2, 0, ...tokens.splice(i + 3, 3));
    }
  }
});

// Images get their true pixel size, so the page does not move while it loads.
// A missing image file stops the build.
function imageSize(file) {
  const b = fs.readFileSync(file);
  if (b.readUInt32BE(0) === 0x89504e47) return [b.readUInt32BE(16), b.readUInt32BE(20)];
  if (b.readUInt16BE(0) === 0xffd8) {
    for (let p = 2; p < b.length; p += 2 + b.readUInt16BE(p + 2)) {
      const m = b[p + 1];
      if (m >= 0xc0 && m <= 0xcf && m !== 0xc4 && m !== 0xc8 && m !== 0xcc)
        return [b.readUInt16BE(p + 7), b.readUInt16BE(p + 5)];
    }
  }
  throw new Error(`Cannot read the image size: ${file}`);
}

md.renderer.rules.image = (tokens, i, options, env, self) => {
  const token = tokens[i];
  const [w, h] = imageSize(path.join(env.dir, decodeURI(token.attrGet('src'))));
  const width = Number(token.attrGet('width')) || w;
  token.attrSet('alt', self.renderInlineAsText(token.children, options, env));
  token.attrSet('width', String(width));
  token.attrSet('height', String(Math.round((h * width) / w)));
  token.attrSet('loading', 'lazy');
  token.attrSet('decoding', 'async');
  return self.renderToken(tokens, i, options);
};

// ---------------------------------------------------------------- Template

// `root` is the relative path from the page to the site root ('' or '../').
// All pages get their <head> from here, so they cannot differ.
const page = ({ root, title, description, math, body }) => `<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>${esc(title)}</title>
<meta name="description" content="${esc(description)}">
<meta name="author" content="${esc(AUTHOR)}">
<link rel="preload" href="${root}assets/fonts/source-serif-4-latin-opsz-normal.woff2" as="font" type="font/woff2" crossorigin>
<link rel="stylesheet" href="${root}assets/style.css">${
  math ? `\n<link rel="stylesheet" href="${root}assets/katex/katex.min.css">` : ''
}
<link rel="icon" href="${root}favicon.ico" sizes="48x48">
<link rel="icon" type="image/png" sizes="32x32" href="${root}favicon-32x32.png">
<link rel="icon" type="image/png" sizes="16x16" href="${root}favicon-16x16.png">
<link rel="apple-touch-icon" sizes="180x180" href="${root}apple-touch-icon.png">
<link rel="manifest" href="${root}site.webmanifest">
<meta name="apple-mobile-web-app-title" content="${esc(SITE)}">
<meta name="application-name" content="${esc(SITE)}">
<meta name="msapplication-config" content="${root}browserconfig.xml">
<meta name="msapplication-TileColor" content="#fcfbf8">
<meta name="theme-color" content="#fcfbf8" media="(prefers-color-scheme: light)">
<meta name="theme-color" content="#171614" media="(prefers-color-scheme: dark)">
</head>
<body>
${body}
</body>
</html>
`;

const longDate = (iso) =>
  new Date(`${iso}T00:00:00Z`).toLocaleDateString('en-GB', {
    day: 'numeric',
    month: 'long',
    year: 'numeric',
    timeZone: 'UTC',
  });

// ---------------------------------------------------------------- Posts

function readPost(slug) {
  const dir = path.join(ROOT, slug);
  const source = fs.readFileSync(path.join(dir, 'index.md'), 'utf8').replace(/\r\n/g, '\n');
  const match = /^---\n([\s\S]*?)\n---\n([\s\S]*)$/.exec(source);
  if (!match) throw new Error(`${slug}/index.md: front matter is missing`);
  const meta = Object.fromEntries(
    match[1].split('\n').filter(Boolean).map((l) => l.split(/:\s*(.*)/s).slice(0, 2)),
  );
  if (!meta.title) throw new Error(`${slug}/index.md: "title" is missing`);
  if (!/^\d{4}-\d{2}-\d{2}$/.test(meta.date ?? ''))
    throw new Error(`${slug}/index.md: "date" must be YYYY-MM-DD`);
  const env = { dir };
  const html = md.render(match[2], env);
  const firstParagraph = (/<p>([\s\S]*?)<\/p>/.exec(html)?.[1] ?? '').replace(/<[^>]+>/g, '');
  const description = firstParagraph.length > 200 ? `${firstParagraph.slice(0, 199)}…` : firstParagraph;
  return { slug, dir, html, math: Boolean(env.math), description, ...meta };
}

const posts = fs
  .readdirSync(ROOT, { withFileTypes: true })
  .filter((d) => d.isDirectory() && !d.name.startsWith('.') && !SKIP.has(d.name))
  .filter((d) => fs.existsSync(path.join(ROOT, d.name, 'index.md')))
  .map((d) => readPost(d.name))
  .sort((a, b) => b.date.localeCompare(a.date));

for (const post of posts) {
  const author = post.author ?? AUTHOR;
  const byline = post.email ? `<a href="mailto:${esc(post.email)}">${esc(author)}</a>` : esc(author);
  const body = `<header class="site"><a href="../"><img src="../favicon-32x32.png" alt="" width="16" height="16">${esc(SITE)}</a></header>
<main class="post">
<h1>${esc(post.title)}</h1>
<p class="meta"><time datetime="${post.date}">${longDate(post.date)}</time> · ${byline}</p>
${post.html}</main>`;
  fs.writeFileSync(
    path.join(post.dir, 'index.html'),
    page({ root: '../', title: `${post.title} · ${SITE}`, description: post.description, math: post.math, body }),
  );
}

const list = posts
  .map(
    (p) =>
      `<li><time datetime="${p.date}">${longDate(p.date)}</time><a href="${p.slug}/">${esc(p.title)}</a></li>`,
  )
  .join('\n');
fs.writeFileSync(
  path.join(ROOT, 'index.html'),
  page({
    root: '',
    title: SITE,
    description: `${SITE}, a blog by ${AUTHOR}.`,
    math: false,
    body: `<main class="home">
<h1><img src="android-chrome-192x192.png" alt="" width="40" height="40">${esc(SITE)}</h1>
<p class="meta">${esc(AUTHOR)}</p>
<ol class="posts">
${list}
</ol>
</main>`,
  }),
);

// ---------------------------------------------------------------- Assets

// Fonts and the KaTeX style sheet come from the installed packages, so the
// style sheet always agrees with the KaTeX version that rendered the formulas.
const copy = (from, to, keep) => {
  fs.mkdirSync(to, { recursive: true });
  for (const f of fs.readdirSync(from).filter(keep)) fs.copyFileSync(path.join(from, f), path.join(to, f));
};
const modules = path.join(ROOT, 'node_modules');
copy(
  path.join(modules, '@fontsource-variable/source-serif-4/files'),
  path.join(ROOT, 'assets/fonts'),
  (f) => /^source-serif-4-latin(-ext)?-opsz-(normal|italic)\.woff2$/.test(f),
);
copy(path.join(modules, 'katex/dist'), path.join(ROOT, 'assets/katex'), (f) => f === 'katex.min.css');
copy(path.join(modules, 'katex/dist/fonts'), path.join(ROOT, 'assets/katex/fonts'), (f) => f.endsWith('.woff2'));

console.log(`Built ${posts.length} posts: ${posts.map((p) => p.slug).join(', ')}`);
