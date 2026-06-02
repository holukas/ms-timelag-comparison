# ms-timelag-comparison

Analysis and documentation for a scientific manuscript on the **impact of
different time-lag settings on eddy covariance fluxes of N₂O and CH₄**.

The processing is carried out in Jupyter notebooks that consume the
[`diive`](../../diive) eddy covariance toolkit, and is published as a
[Jupyter Book](https://jupyterbook.org/) reproducibility website.

## Repository layout

```
notebooks/   executable notebooks — run the processing and render into the book
docs/        prose-only book pages (intro, methods) + references.bib
data/        datasets (gitignored)
  raw/         untouched inputs
  interim/     merged / cleaned intermediates
  processed/   analysis-ready
figures/     exported figures
tables/       exported tables
myst.yml     Jupyter Book config + table of contents
```

## Setup

This project uses [uv](https://docs.astral.sh/uv/) for environment management.

```bash
uv sync
```

`diive` is installed as an editable local dependency (see `pyproject.toml`).

## Usage

Run the analysis notebooks:

```bash
uv run jupyter lab
```

Build the documentation book (Jupyter Book 2 / MyST):

```powershell
# On Windows: UTF-8 avoids a cp1252 crash on emoji output, and
# JB_ALLOW_NODEENV lets Jupyter Book install its private Node (MyST engine).
$env:JB_ALLOW_NODEENV=1; $env:PYTHONUTF8=1; $env:PYTHONIOENCODING="utf-8"
uv run jupyter book build --html        # -> _build/html
```

Preview live with auto-reload while writing:

```powershell
uv run jupyter book start               # serves at http://localhost:3000
```

The notebooks run the processing pipeline (merge → clean → plots) and, once
built, render into the published reproducibility website together with the
prose pages in `docs/`.

## Deploy

Publish to GitHub Pages with the bundled script (builds, then pushes
`_build/html` to the `gh-pages` branch):

```powershell
.\deploy.ps1
```

One-time setup in the browser: repo **Settings → Pages → Source: Deploy from a
branch → `gh-pages` / `/ (root)`**. The site is then served at
<https://holukas.github.io/ms-timelag-comparison/>.

## Author

Lukas Hörtnagl — ETH Zürich (lukas.hoertnagl@usys.ethz.ch)

## License

See [LICENSE](LICENSE).
