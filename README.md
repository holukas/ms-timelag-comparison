# ms-timelag-comparison

Analysis and documentation for a scientific manuscript on the impact of
different time-lag settings on eddy covariance fluxes of N₂O and CH₄.

The processing runs in Jupyter notebooks that use the
[`diive`](../../diive) eddy covariance toolkit, and is published as a
[Jupyter Book](https://jupyterbook.org/) reproducibility website.

## Repository layout

```
notebooks/   executable notebooks: run the processing and render into the book
docs/        prose-only book pages (intro, methods) + references.bib
data/        datasets, organized by processing stage (see below)
figures/     exported figures
tables/      exported tables
myst.yml     Jupyter Book config + table of contents
deploy.ps1   build + publish the book to GitHub Pages
```

### Data stages and version control

`data/` is organized by processing stage. `00-*` are the raw inputs and are
never written to; higher-numbered folders are derived and regenerable.

```
data/
  00-eddypro_fluxes_level-1/                  raw EddyPro flux output (FLUXNET CSV)
  00-eddypro_settings/                        EddyPro project + metadata files
  00-meteo/                                    meteorological data
  00-pwb_tlag_summary/                        PWB (*-5) tlag summaries
  01-eddypro_fluxes_level-1_parquet/          flux CSVs as Parquet      (notebook 01)
  01-pwb_tlag_summary_parquet/                PWB tlag summaries as Parquet (notebook 01)
  02-eddypro_fluxes_level-1_parquet_subsets/  column subsets, 2021 only (notebook 02)
  05-flux_processing_chain_parquet/           quality-controlled fluxes  (notebook 05)
```

Version control: everything under `data/` is tracked, both the raw `00-*` inputs
(for provenance) and the derived `*.parquet` stages (a committed snapshot,
regenerable from the inputs).

## Analysis pipeline

The notebooks run in order; each stage feeds the next:

1. `01_read_fluxes_to_parquet.ipynb` reads each EddyPro FLUXNET CSV with `diive`,
   saves it as Parquet, and converts the PWB (`*-5`) tlag summaries (`00-… → 01-…`).
2. `02_subset_flux_columns.ipynb` keeps a defined list of columns (fluxes and
   time-lag diagnostics) and restricts the rows to 2021 (`01-… → 02-…`).
3. `05_flux_processing_chain.ipynb` runs `diive`'s post-processing chain (L2
   quality flags, L3.1 storage, L3.2 outlier removal, L3.3 USTAR filtering) on
   every variant and gas, writing the quality-controlled fluxes (`01-… → 05-…`).
   This notebook writes data only; the figures are built downstream.
4. `08_merged_analyzers_full_year.ipynb` merges the two analyzers (QCL and LGR
   cover complementary halves of 2021) into one full-year series per variant and
   plots the flux, time lag used, and a lag histogram, one figure per gas
   (`figures/08_*.png`).
5. `09_cumulative_qc_fluxes.ipynb` plots the cumulative quality-controlled flux
   (running budget) per variant, one figure per gas with QCL and LGR panels, as a
   cumulative mass (N₂O in kg N₂O-N ha⁻¹, CH₄ in g CH₄-C m⁻²), into
   `figures/09_*.png`.

`00_inventory.ipynb` is a standalone page: it lists the `data/` and `figures/`
manifest straight from disk and renders the figure gallery. Notebook numbers 03,
04, 06 and 07 are unused (03/04/06 produced earlier plots that were removed once
figure creation was consolidated into 08 and 09). The `x-04` / `x-05` notebooks
(flux-product reference and merge) are parked and not part of the active pipeline.

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

The notebooks run the processing pipeline (read → subset → quality-control →
plot) and, once built, render into the published reproducibility website together
with the prose pages in `docs/`.

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

Lukas Hörtnagl, ETH Zürich (lukas.hoertnagl@usys.ethz.ch)

## License

See [LICENSE](LICENSE).
