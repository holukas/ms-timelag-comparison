# ms-timelag-comparison

Analysis and documentation for a scientific manuscript on the impact of
different time-lag settings on eddy covariance fluxes of N₂O and CH₄.

The processing runs in Jupyter notebooks that use the
[`diive`](../../diive) eddy covariance toolkit, and is published as a
[Quarto](https://quarto.org/) reproducibility website.

## Repository layout

```
notebooks/   executable notebooks: run the processing and render into the site
docs/        prose-only pages (intro, methods) + references.bib
index.md     site landing page (introduction)
data/        datasets, organized by processing stage (see below)
figures/     exported figures
tables/      exported tables
_quarto.yml  Quarto website config + table of contents
_extensions/ vendored Quarto extensions (lightbox), committed with the repo
deploy.ps1   build + publish the site to GitHub Pages
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
  02-level1_merged_parquet/                   both analyzers merged into one
                                              Level-1 table              (notebook 02)
  05-flux_processing_chain_parquet/           quality-controlled fluxes  (notebook 05)
  04-flux-product-2025.3_subset_2024/         retired, from the removed x-04
  05-merged_variants_fluxproduct/             retired, from the removed x-05
```

The two retired folders come from notebooks that have been removed and sit outside
the current pipeline; they are kept for provenance only.

Version control: everything under `data/` is tracked, both the raw `00-*` inputs
(for provenance) and the derived `*.parquet` stages (a committed snapshot,
regenerable from the inputs). `figures/` is tracked as well, as the manuscript
record.

## Analysis pipeline

The notebooks run in order; each stage feeds the next:

1. `01_read_fluxes_to_parquet.ipynb` reads each EddyPro FLUXNET CSV with `diive`,
   saves it as Parquet, and converts the PWB (`*-5`) tlag summaries (`00-… → 01-…`).
2. `02_level1_merged_analyzers.ipynb` merges the two analyzers into one continuous
   full-year table of Level-1 fluxes and time lags, before quality control
   (`01-… → 02-…`). A data step only: it draws nothing and writes one file.
3. `03_level1_merged_figures.ipynb` draws that merged table (`02-`), one figure per
   gas: raw flux, time lag used, and lag histogram (`figures/03_merged_*.png`). The
   pre-QC counterpart of notebook 08.
4. `04_level1_cumulative_fluxes.ipynb` builds the flux distribution and cumulative
   budget from the same merged table (`02-`), one figure per gas
   (`figures/04_cumulative_*.png`). The pre-QC counterpart of notebook 09.
5. `05_flux_processing_chain.ipynb` runs `diive`'s post-processing chain (L2
   quality flags, L3.1 storage, L3.2 outlier removal, L3.3 USTAR filtering with
   CUT_16/CUT_50/CUT_84) on every variant and gas, writing the quality-controlled
   fluxes (`01-… → 05-…`). It saves data files only; the overview plots it draws
   at the end (a heatmap grid and a CUT_50 time-series grid per gas) are shown
   inline on the page and not written to `figures/`.
6. `08_merged_analyzers_full_year.ipynb` merges the two analyzers (QCL and LGR
   cover complementary halves of 2021) into one full-year series per variant and
   plots the flux, time lag used, and a per-instrument lag histogram (0.05 s
   raster), one figure per gas (`figures/08_*.png`). The time lag is masked to the
   records whose QC flux survives, so the lag row and histogram describe exactly
   the records shown in the flux row.
7. `09_cumulative_qc_fluxes.ipynb` builds one figure per gas with two rows: the
   half-hourly flux density distribution per variant on top, and the running
   quality-controlled budget per variant below (QCL and LGR panels), as a
   cumulative mass (N₂O in kg N₂O-N ha⁻¹, CH₄ in g CH₄-C m⁻²), into
   `figures/09_*.png`.

Notebooks 03 and 04 are the Level-1 (pre-quality-control) mirrors of 08 and 09.
On the Level-1 side the reading and the plotting are kept as separate steps: 02
builds the merged table, 03 and 04 only draw it.

`00_inventory.ipynb` is a standalone page: it lists the `data/` and `figures/`
manifest straight from disk and renders the figure gallery. Notebook numbers 06
and 07 are unused (earlier plots that were removed once figure creation was
consolidated). The former `x-04` / `x-05` notebooks (flux-product reference and
merge) have been removed; the `04-…` and `05-merged…` data folders are their
leftovers, kept for provenance, and have nothing to do with the active notebooks
carrying those numbers.

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

Build the documentation site with Quarto (`uv sync` installs it via the
`quarto-cli` package):

```powershell
$env:PYTHONUTF8=1                        # avoids a cp1252 crash on emoji output
uv run quarto render                     # -> _site
```

Preview live with auto-reload while writing:

```powershell
uv run quarto preview                    # serves at http://localhost:4200
```

Quarto renders the notebooks from their committed outputs (`execute.enabled: false`
in `_quarto.yml`), so building never re-runs them; run them in JupyterLab first to
refresh. The notebooks run the processing pipeline (read → quality-control →
plot) and render into the published reproducibility website
together with the prose pages in `docs/`.

A page shows up on the site only if it is listed twice in `_quarto.yml`: under
`project.render` (what gets built) and under `website.sidebar.contents` (where it
appears in the table of contents). The site uses the bootswatch `cosmo` (light)
and `darkly` (dark) themes with `lightbox: auto`, so any figure, notebook output
included, opens zoomed in an overlay. The lightbox extension is vendored in
`_extensions/` and committed, so a fresh clone renders without extra setup.

## Deploy

Publish to GitHub Pages with the bundled script (renders, then pushes
`_site` to the `gh-pages` branch):

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
