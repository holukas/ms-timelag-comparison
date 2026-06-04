# Building the book

How to build and publish this site. It is a Jupyter Book 2 (MyST) project,
configured by `myst.yml` at the repo root and published to GitHub Pages.

The commands below are PowerShell (Windows). Always build and deploy from
PowerShell, not Git Bash (see [Gotchas](#gotchas) for why).

## Prerequisites

- uv for the Python environment (`uv sync` once to set it up).
- Node.js. Jupyter Book 2 runs on the MyST JavaScript engine. You do not need to
  install Node yourself: on the first build it installs a private, sandboxed copy
  under `AppData\Local\jupyter-book\` (not on your `PATH`). Allow it with
  `$env:JB_ALLOW_NODEENV=1` the first time.

## Preview locally

Live server with auto-reload while writing:

```powershell
$env:PYTHONUTF8=1
uv run jupyter book start          # serves at http://localhost:3000
```

## Build static HTML

```powershell
$env:JB_ALLOW_NODEENV=1; $env:PYTHONUTF8=1
uv run jupyter book build --html   # output in _build/html/
```

`$env:PYTHONUTF8=1` is required on Windows. Without it, the emoji in Jupyter
Book's console output crash the default cp1252 terminal.

## Publish to GitHub Pages

Use the bundled script. It cleans `_build`, sets the right environment variables
(including `BASE_URL`), builds, and pushes `_build/html` to the `gh-pages` branch:

```powershell
.\deploy.ps1
```

`deploy.ps1` runs, in effect:

```powershell
$env:JB_ALLOW_NODEENV=1; $env:PYTHONUTF8=1
$env:BASE_URL="/ms-timelag-comparison"          # must match the Pages sub-path
Remove-Item -Recurse -Force _build -ErrorAction SilentlyContinue
uv run jupyter book build --html
uv run ghp-import -n -p -f _build/html           # -n adds .nojekyll
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

## Gotchas

- `PYTHONUTF8` is required on Windows. Missing it gives a `UnicodeEncodeError`
  (cp1252) when Jupyter Book prints emoji. `deploy.ps1` sets it for you.
- Never build or deploy from Git Bash. Git Bash rewrites a leading-slash
  `BASE_URL=/ms-timelag-comparison` into a Windows path
  (`C:/.../ms-timelag-comparison`), which corrupts every asset URL. Use
  PowerShell. If you must use Git Bash, prefix the command with
  `MSYS_NO_PATHCONV=1`.
- `BASE_URL` must match the Pages sub-path. Build without it, or with the wrong
  value, and the CSS and JS return 404 on the live site: it renders unstyled and
  shows a "Site not loading correctly?" banner. The fix is to rebuild with
  `BASE_URL="/ms-timelag-comparison"` and redeploy.
- The `references.bib` warning is harmless until the bibliography has entries; the
  page still builds.

## Table of contents

Pages are listed in `myst.yml` under `project.toc`. Add a new prose page by
creating it in `docs/` and adding a `- file: docs/<name>.md` entry there. The
analysis notebooks in `notebooks/` are both run and rendered into the book, so
you can add them to the TOC the same way.
