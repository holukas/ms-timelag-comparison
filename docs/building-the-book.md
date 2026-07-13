# Building the book

How to build and publish this site. It is a [Quarto](https://quarto.org/) website
project, configured by `_quarto.yml` at the repo root and published to GitHub
Pages.

The commands below are PowerShell (Windows), run from the repo root.

## Prerequisites

- uv for the Python environment: `uv sync` once. This also installs Quarto (the
  `quarto-cli` package), so `uv run quarto ...` works with no separate install.
  Check it with `uv run quarto --version`. (A system-wide Quarto from
  `winget install --id Posit.Quarto` or <https://quarto.org/docs/get-started/>
  works too, if you prefer.)

Quarto renders the notebooks from the outputs already stored in each `.ipynb`
(`execute.enabled: false` in `_quarto.yml`), so building the site never runs the
notebooks. Run the notebooks yourself in JupyterLab first to refresh their
outputs; the build just renders what is committed.

## Preview locally

Live server with auto-reload while writing:

```powershell
$env:PYTHONUTF8=1
uv run quarto preview          # serves at http://localhost:4200 and opens a browser
```

## Build static HTML

```powershell
$env:PYTHONUTF8=1
uv run quarto render           # output in _site/
```

`$env:PYTHONUTF8=1` avoids a cp1252 crash on Windows if any notebook output
contains emoji.

## Publish to GitHub Pages

Use the bundled script. It renders the site and pushes `_site` to the `gh-pages`
branch:

```powershell
.\deploy.ps1
```

`deploy.ps1` runs, in effect:

```powershell
$env:PYTHONUTF8=1
uv run quarto render                     # -> _site
uv run ghp-import -n -p -f _site         # -n adds .nojekyll
```

One-time setup (in the browser, only needed once): repo Settings → Pages →
Source: Deploy from a branch → `gh-pages` / `/ (root)`. The site is then served
at <https://holukas.github.io/ms-timelag-comparison/>.

## Verify a deploy

GitHub's CDN takes a minute or two and caches aggressively:

```powershell
# Pages enabled? (404 = off, JSON with "status":"built" = on)
curl.exe -s https://api.github.com/repos/holukas/ms-timelag-comparison/pages
# Live site responding?
curl.exe -s -o $null -w "%{http_code}`n" https://holukas.github.io/ms-timelag-comparison/
```

After publishing, hard-refresh the page (Ctrl+Shift+R). A normal reload can show
the previously cached version.

## Last updated date

Every page shows its own "last updated" date, taken from the file's last git
commit (`date: last-modified` in `_quarto.yml`). Nothing to maintain by hand:
commit a change to a page and its date updates on the next build.

## Table of contents and layout

Pages are listed in `_quarto.yml` twice: under `project.render` (what gets built,
and in what order) and under `website.sidebar.contents` (the left navigation).
Add a new prose page by creating it in `docs/` and adding a `- docs/<name>.md`
entry to both. The analysis notebooks in `notebooks/` are added the same way.

To hide the left sidebar on a single page, add `sidebar: false` to that page's
YAML front matter. To change the look, edit `format.html.theme` in `_quarto.yml`
(any [Bootswatch theme](https://quarto.org/docs/output-formats/html-themes.html),
or your own `.scss`).

## Gotchas

- `PYTHONUTF8` is worth setting on Windows so emoji in notebook output cannot
  trigger a cp1252 `UnicodeEncodeError`. `deploy.ps1` sets it for you.
- Quarto uses page-relative asset links, so the site works from the
  `/ms-timelag-comparison/` sub-path with no base-path environment variable to
  set (unlike the previous Jupyter Book setup).
- The `references.bib` file has no entries yet; that is harmless. Citations use
  Pandoc syntax (`[@key]`) once entries are added.
