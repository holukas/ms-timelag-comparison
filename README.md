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
data/        datasets, organized by processing stage (see below)
figures/     exported figures
tables/      exported tables
myst.yml     Jupyter Book config + table of contents
deploy.ps1   build + publish the book to GitHub Pages
```

### Data stages and version control

`data/` is organized by **processing stage**. `00-*` are the raw inputs and are
never written to; higher-numbered folders are derived and regenerable.

```
data/
  00-eddypro_fluxes_level-1/                  raw EddyPro flux output (FLUXNET CSV)
  00-eddypro_settings/                        EddyPro project + metadata files
  00-meteo/                                    meteorological data
  01-eddypro_fluxes_level-1_parquet/          flux CSVs as Parquet   (notebook 01)
  02-eddypro_fluxes_level-1_parquet_subsets/  column subsets         (notebook 02)
```

Version control: the **raw `00-*` inputs are tracked** (for provenance), while
derived **`*.parquet` files are gitignored** (large and regenerable).

## Analysis pipeline

The notebooks run in order; each stage feeds the next:

1. **`01_read_fluxes_to_parquet.ipynb`** — read each EddyPro FLUXNET CSV with
   `diive` and save it as Parquet (`00-… → 01-…`).
2. **`02_subset_flux_columns.ipynb`** — keep a defined list of columns (fluxes +
   time-lag diagnostics) and save the subsets (`01-… → 02-…`).
3. **`03_plot_fluxes.ipynb`** — per analyzer (QCL, LGR) and gas (N₂O, CH₄), plot
   flux over time lag used by variant; writes `figures/03_*.png`.

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

The notebooks run the processing pipeline (read → subset → plot) and, once
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
