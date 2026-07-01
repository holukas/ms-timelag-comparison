# CLAUDE.md

Guidance for Claude Code when working in this repository.

## What this project is

Analysis and documentation for a scientific manuscript on **the impact of
different time-lag settings on eddy covariance fluxes of N₂O and CH₄**.

## How the work is organized

- **`diive` is the engine; this repo just calls it.** All reusable
  processing logic lives in `diive` (editable install at `../../diive`). When
  functionality is missing, it is implemented in `diive`, not here, then used
  from a notebook. **Do not propose a local package / `src/` layout in this
  repo**, nothing here needs to be importable.
- **Notebooks do double duty.** The notebooks in `notebooks/` both *run* the
  processing and *render into the documentation*. They are the analysis and the
  narrative at once.
- **Documentation = Jupyter Book 2 (MyST)**, published to GitHub Pages. Config
  and table of contents live in `myst.yml` at the repo root.

## Layout

```
notebooks/   executable notebooks → run processing AND render into the book
docs/        prose-only book pages (intro, methods text) + references.bib
data/        datasets, organized by processing stage (00-* = raw inputs)
figures/     exported figures (manuscript record)
tables/      exported tables (manuscript record)
myst.yml     Jupyter Book config + TOC
deploy.ps1   build + publish the book to GitHub Pages
```

### Data stages

`data/` is organized by **processing stage**, NOT raw/interim/processed. `00-*`
folders are raw inputs and are never written to; higher numbers are derived.

```
data/00-eddypro_fluxes_level-1/                  raw EddyPro FLUXNET CSVs
data/00-eddypro_settings/                        EddyPro .eddypro + .metadata files
data/00-meteo/                                    meteo data
data/00-pwb_tlag_summary/                        PWB (*-5) tlag summary CSVs
data/01-eddypro_fluxes_level-1_parquet/          flux CSVs as Parquet  (notebook 01)
data/01-pwb_tlag_summary_parquet/                PWB tlag as Parquet   (notebook 01)
data/02-eddypro_fluxes_level-1_parquet_subsets/  column subsets, 2021  (notebook 02)
```

**Version control:** everything under `data/` is **tracked**, both the raw `00-*`
inputs (provenance) and the derived `*.parquet` stages (a committed snapshot of
every stage, regenerable from the inputs). `figures/` is committed too
(manuscript record). The live file manifest is the `00_inventory` notebook,
which lists `data/` and `figures/` straight from disk.

## Processing versions (the study variable)

Fluxes are computed several times, varying only how the N₂O/CH₄/H₂O time lag is
found. Per analyzer (QCL = quantum cascade laser, campaign 2021_1; LGR = Los
Gatos Research, campaign 2021_2), the five variants share one scheme:

- `*-1`: covariance maximization, 0 to 10 s window, no default (`OPENLAG`).
- `*-2`: covariance maximization, 0 to 10 s window, default fallback lag
  (`DEFAULT`).
- `*-3`: covariance maximization, narrow per-campaign window, default fallback
  lag (`DEFAULT`, narrow).
- `*-4`: constant lag, fixed at the per-campaign nominal lag (EddyPro
  `tlag_meth=1`, `CONSTANT`).
- `*-5`: PWB. Detect and remove the lag from the raw data in one run via diive's
  detect-and-remove TUI (`diive-tlag-pwb-detect-remove-tui`; rotation is
  in-memory, no separate apply step), then process fluxes with EC maximization
  disabled (see `docs/processing-steps.md`).

Implementation status: all five variants (`*-1` to `*-5`) have flux output for
both analyzers. The `*-5` (PWB) EddyPro run uses `tlag_meth=0` (no lag
compensation), since the lag was already removed from the raw data; its per-chunk
time-lag summaries are kept alongside the fluxes.

A note on reading the comparison: `*-4` (constant lag) systematically yields a
lower flux budget than the covariance-maximization variants (`*-1` to `*-3`),
strongest for N₂O. This is the covariance-maximization bias (per half-hour, the
lag that maximizes |covariance| is selected, inflating the flux of a low
signal-to-noise gas), not a processing error; it is a core result of the study.

Keep this registry explicit and auditable. It lives in
`docs/processing-versions.md` and the notebooks' config cells (`ANALYZERS`,
`GASES`, `KEEP_COLS`), never hardcoded ad hoc.

## Analysis pipeline

All figures are built on the quality-controlled fluxes; the raw Level-1 plots have
been retired. Notebooks run in order, each stage feeding the next: `01` read CSV →
Parquet, `02` subset columns (incl. `SW_IN_POT` for a daytime/nighttime split).
`05` applies diive's flux processing chain (L2 quality flags, L3.1 storage, L3.2
outlier removal, L3.3 USTAR filtering) to every variant so the comparison runs on
quality-controlled fluxes; it reads the full `01-` tables (the chain needs the
EddyPro flag and `USTAR` columns) and writes `data/05-flux_processing_chain_parquet/`
(data only, no figures). Figure creation is consolidated into two notebooks that
both read the chain output. `08` merges the two analyzers' QC fluxes, which cover
complementary halves of 2021 (QCL is campaign 2021_1, LGR is 2021_2), into one
continuous full-year series per variant, then plots the merged flux, time lag
used, and a stacked per-instrument lag histogram, one figure per gas
(`figures/08_*.png`). `09` is the single place the cumulative comparison is
produced: the running QC-flux budget per variant over the paired common samples,
one figure per gas with QCL and LGR panels (`figures/09_cumulative_*.png`).
Notebook numbers `03`, `04`, `06` and `07` are intentionally unused (`03` / `04`
were the retired raw-flux plots, `06` the retired per-analyzer QC figures). The
chain (L2–L4) is post-processing on top of the Level-1 EddyPro fluxes.

## Notebook conventions

- First code cell records `NB_START = datetime.now()`; the notebook ends with a
  `## Runtime` markdown header + a cell printing start / end / elapsed.
- diive I/O: `ReadFileType(filetype='EDDYPRO-FLUXNET-CSV-30MIN', ...)` to read,
  `diive.core.io.files.save_parquet` / `load_parquet` for Parquet.
- Figure notebooks expose `FIGSIZE` / `DPI` constants; keep `DPI` high (300) for
  publication-ready output.

## Environment

- Python ≥3.12, managed with **uv** (`uv.lock`, `.venv` present).
- Run things via `uv run ...` (e.g. `uv run jupyter lab`).
- `diive` is an **editable** install: new functions added to it are available
  in notebooks here after a kernel restart, no reinstall needed.
- **Building the book on Windows:** set `$env:PYTHONUTF8=1` (avoids a cp1252
  crash on emoji output); first build needs `$env:JB_ALLOW_NODEENV=1` to install
  Jupyter Book's private Node. Publishing needs `$env:BASE_URL="/ms-timelag-comparison"`
  baked in, or the live site loses its CSS. **Always build/deploy from
  PowerShell** (use `.\deploy.ps1`); Git Bash mangles a leading-slash
  `BASE_URL` into a Windows path.

## Conventions

- Author: Lukas Hörtnagl (ETH Zürich).
- The set of time-lag settings being compared is the study variable. Keep it
  defined explicitly and auditable in the notebook(s), not hardcoded ad hoc.
- Prose style: humanize all book/doc text. No em or en dashes (use commas,
  colons, periods, parentheses; "to" for ranges). Plain, neutral technical
  voice; trim mechanical boldface and AI-writing tells.

## The user runs things, not the assistant

The user runs all of these themselves. Do the edits, then stop and leave them to
run it:

- **Commits and pushes.** Never `git commit` or `git push`. Drafting a commit
  message is fine; committing is not. No `Co-Authored-By` or attribution
  trailers in commit messages.
- **Notebook execution.** Never execute notebooks (no `jupyter nbconvert
  --execute`, no running cells).
- **Book build and deploy.** Never run `jupyter book build` / `start` or
  `deploy.ps1`. Explain how; let the user run it.
