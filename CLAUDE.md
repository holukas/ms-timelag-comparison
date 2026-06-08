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
data/00-pwb_tlag_summary/                        PWB (*-4) tlag summary CSVs
data/01-eddypro_fluxes_level-1_parquet/          flux CSVs as Parquet  (notebook 01)
data/01-pwb_tlag_summary_parquet/                PWB tlag as Parquet   (notebook 01)
data/02-eddypro_fluxes_level-1_parquet_subsets/  column subsets, 2021  (notebook 02)
```

**Version control:** raw `00-*` inputs are **tracked** (provenance); `*.parquet`
files are **gitignored** (large, regenerable). `figures/` and `tables/` are
committed (manuscript record).

## Processing versions (the study variable)

Fluxes are computed several times, varying only how the N₂O/CH₄ time lag is
found. Per analyzer (QCL = quantum cascade laser, campaign 2021_1; LGR = Los
Gatos Research, campaign 2021_2), the variants share one scheme:

- `*-1`: covariance maximization, −1 to 10 s window, no default (`OPENLAG`).
- `*-2R`: covariance maximization, 10 s window, default fallback lag; also
  exports rotated time series (`DEFAULT`).
- `*-3`: constant lag (earlier 2024 runs).
- `*-4`: PWB. Detect and remove the lag from the raw data in one run via diive's
  detect-and-remove TUI (`diive-tlag-pwb-detect-remove-tui`; rotation is
  in-memory, no separate apply step), then process fluxes with EC maximization
  disabled (see `docs/processing-steps.md`).

Keep this registry explicit and auditable. It lives in
`docs/processing-versions.md` and the notebooks' config cells (`ANALYZERS`,
`GASES`, `KEEP_COLS`), never hardcoded ad hoc.

## Analysis pipeline

Notebooks run in order, each stage feeding the next:
`01` read CSV → Parquet, `02` subset columns, `03` plot flux vs. time lag used.

## Notebook conventions

- First code cell records `NB_START = datetime.now()`; the notebook ends with a
  `## Runtime` markdown header + a cell printing start / end / elapsed.
- diive I/O: `ReadFileType(filetype='EDDYPRO-FLUXNET-CSV-30MIN', ...)` to read,
  `diive.core.io.files.save_parquet` / `load_parquet` for Parquet.
- `figures/03_*.png` are intermediate (small `FIGSIZE` / `DPI`); bump those
  constants for publication-ready output.

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
