# CLAUDE.md

Guidance for Claude Code when working in this repository.

## What this project is

Analysis and documentation for a scientific manuscript on **the impact of
different time-lag settings on eddy covariance fluxes of N₂O and CH₄**.

## How the work is organized

- **`diive` is the engine, this repo is the consumer.** All reusable
  processing logic lives in `diive` (editable install at `../../diive`). When
  functionality is missing, it is implemented in `diive`, not here, then used
  from a notebook. **Do not propose a local package / `src/` layout in this
  repo** — nothing here needs to be importable.
- **Notebooks do double duty.** The notebooks in `notebooks/` both *run* the
  processing and *render into the documentation*. They are the analysis and the
  narrative at once.
- **Documentation = Jupyter Book 2 (MyST)**, published to GitHub Pages. Config
  and table of contents live in `myst.yml` at the repo root.

## Layout

```
notebooks/   executable notebooks → run processing AND render into the book
docs/        prose-only book pages (intro, methods text) + references.bib
data/        datasets (gitignored)
  raw/         untouched inputs
  interim/     merged / cleaned intermediates
  processed/   analysis-ready
figures/     exported figures (manuscript record)
tables/       exported tables (manuscript record)
myst.yml     Jupyter Book config + TOC
```

Rule of thumb: `data/` holds datasets flowing through the pipeline (gitignored);
`figures/` and `tables/` hold generated outputs that are part of the manuscript
record (committed).

## Environment

- Python ≥3.12, managed with **uv** (`uv.lock`, `.venv` present).
- Run things via `uv run ...` (e.g. `uv run jupyter lab`).
- `diive` is an **editable** install: new functions added to it are available
  in notebooks here after a kernel restart, no reinstall needed.

## Conventions

- Author: Lukas Hörtnagl (ETH Zürich).
- The set of time-lag settings being compared is the study variable — keep it
  defined explicitly and auditable in the notebook(s), not hardcoded ad hoc.
