# CLAUDE.md

Guidance for Claude Code when working in this repository.

## What this project is

Analysis and figures on **the impact of different time-lag settings on eddy
covariance fluxes of N₂O and CH₄**.

This repo is **not a paper of its own**. The figures it produces go into the
time-lag part of the raw-data-processing section of a co-authored, multi-author
paper on methodological challenges in CH₄ and N₂O eddy covariance (in
preparation, Lukas contributes the time-lag test). The paper text is written
elsewhere and is not tracked here. That sets what belongs in `docs/`:

- **Yes:** the theoretical background of the lag problem for low signal-to-noise
  gases, the time-lag options being compared, how the figures are produced, and
  the data stages behind them.
- **No:** the paper's own framing, its other sections and tests, author lists,
  target journals, and result numbers or interpretation that belong in the paper
  text. Keep the docs to what a reader needs in order to understand the figures.

## How the work is organized

- **`diive` is the engine; this repo just calls it.** All reusable
  processing logic lives in `diive` (editable install at `../../diive`). When
  functionality is missing, it is implemented in `diive`, not here, then used
  from a notebook. **Do not propose a local package / `src/` layout in this
  repo**, nothing here needs to be importable.
- **Notebooks do double duty.** The notebooks in `notebooks/` both *run* the
  processing and *render into the documentation*. They are the analysis and the
  narrative at once.
- **Documentation = Quarto website**, published to GitHub Pages. Config and
  table of contents live in `_quarto.yml` at the repo root; `index.md` is the
  landing page. Quarto renders notebooks from their committed outputs
  (`execute.enabled: false`), so building never re-runs them. A page has to be
  listed **twice** in `_quarto.yml` to show up: once under `project.render`
  (what gets built) and once under `website.sidebar.contents` (where it appears
  in the TOC). Anything not in `project.render` stays out of the site.

## Layout

```
notebooks/   executable notebooks → run processing AND render into the site
docs/        prose-only pages (methods text) + references.bib
index.md     site landing page (introduction)
data/        datasets, organized by processing stage (00-* = raw inputs)
figures/     exported figures (the deliverable of this repo)
tables/      exported tables
_quarto.yml  Quarto website config + TOC
_extensions/ vendored Quarto extensions (lightbox), tracked, do not edit by hand
deploy.ps1   build + publish the site to GitHub Pages
```

Every notebook in `notebooks/` is part of the active pipeline. An earlier `x-`
prefix marked parked notebooks; those have been removed, and only the data folders
they wrote survive (see below). Do not reintroduce that prefix: retire a notebook
by deleting it, and say so in `index.md`.

Numbered notebooks are the pipeline itself. A `SUPPL_` prefix marks a supplementary
notebook: it hangs off a numbered one, reads a stage that already exists and writes
only figures, so it never takes a stage number of its own. Its figures carry a
matching `suppl_` filename prefix. There is one so far,
`SUPPL_level1_lag_diagnostics.ipynb` (supplement to `03`).

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
data/02-level1_merged_parquet/                   both analyzers merged into one Level-1
                                                 table (notebook 02, level1_merged.parquet)
data/05-flux_processing_chain_parquet/           QC fluxes, one file per variant and gas
                                                 (notebook 05, e.g. QCL-3_FN2O_fpc.parquet)
data/04-flux-product-2025.3_subset_2024/         retired, from the removed x-04
data/05-merged_variants_fluxproduct/             retired, from the removed x-05
```

The two retired folders come from notebooks that no longer exist and are outside
the current pipeline. They are kept for provenance; nothing downstream reads them.

**Version control:** everything under `data/` is **tracked**, both the raw `00-*`
inputs (provenance) and the derived `*.parquet` stages (a committed snapshot of
every stage, regenerable from the inputs). `figures/` is committed too
(the deliverable). The live file manifest is the `00_inventory` notebook,
which lists `data/` and `figures/` straight from disk.

## Processing versions (the study variable)

Fluxes are computed several times, varying only how the N₂O/CH₄/H₂O time lag is
found. Per analyzer (QCL = quantum cascade laser, campaign 2021_1; LGR = Los
Gatos Research, campaign 2021_2), the five variants share one scheme:

- `*-1`: covariance maximization, 0 to 10 s window, no default (`OPENLAG`; CM).
- `*-2`: covariance maximization, 0 to 10 s window, default fallback lag
  (`DEFAULT`; CM).
- `*-3`: covariance maximization, narrow per-campaign window, default fallback
  lag (`DEFAULT`, narrow; CM$_{CTR}$).
- `*-4`: constant lag, fixed at the per-campaign nominal lag (EddyPro
  `tlag_meth=1`, `CONSTANT`; no paper acronym).
- `*-5`: PWB. Detect and remove the lag from the raw data in one run via diive's
  detect-and-remove TUI (`diive-tlag-pwb-detect-remove-tui`; rotation is
  in-memory, no separate apply step), then process fluxes with EC maximization
  disabled (see `docs/time-lag.qmd`). The lag applied is the optimised
  PWB$_{OPT}$ lag (`PWB$_{OPT}$`).

The `OPENLAG` / `DEFAULT` / `CONSTANT` / `PWB` tokens are the EddyPro/diive
setting names; `CM`, `CM$_{CTR}$`, `PWB`, `PWB$_{OPT}$` are the method
abbreviations from Vitale et al. (2024) used in the figures and docs (CM =
covariance maximisation, CTR = constrained/narrow window, PWB$_{OPT}$ = optimised
pre-whitening with block-bootstrap). Both name the same five variants.

Implementation status: all five variants (`*-1` to `*-5`) have flux output for
both analyzers. The `*-5` (PWB) EddyPro run uses `tlag_meth=0` (no lag
compensation), since the lag was already removed from the raw data; its per-chunk
time-lag summaries are kept alongside the fluxes.

### Campaign settings

The nominal lags and the `*-3` narrow windows per campaign and gas are tabulated
in `docs/time-lag.qmd`; they match the `.metadata` files of the EddyPro
runs (`col_19` is CH₄, `col_20` is N₂O), which is where to check them against what
was actually run. The campaigns do not overlap: the QCL half runs 1 Jan to
20 Jul 2021, the LGR half 22 Jul to 31 Dec 2021 (first and last reported flux).

### Reading the comparison

Two failure modes drive the differences between the variants, and they push the
flux in opposite directions (both are described in
`docs/time-lag.qmd`): the maximization locks onto a noise peak and
inflates the flux, or it finds no peak at all and the lags pile up at the 0 s and
10 s rails of the search window.

Which one dominates **differs between the gases**, so never state the comparison
as one rule for both. For N₂O the covariance-maximization variants come out above
`*-5` and the constant lag below it; for CH₄ the wide search mostly fails (a large
share of rail values, the raw modal bin sitting on the 10 s rail), and its budget
lands below the constant lag instead. The post-chain numbers do not always keep
the sign of the Level-1 ones either.

Numbers belong in the figures and in the paper text, not in this file or in
`docs/`: recompute them from the parquet stages when they are needed, per gas and
per campaign.

Keep this list defined in one place. It lives in
`docs/time-lag.qmd` and the notebooks' config cells (`ANALYZERS`,
`GASES`, `KEEP_COLS`), never hardcoded ad hoc.

### The PWB method, and what belongs to whom

Local copies of the two sources, outside this repo:

```
F:\Sync\luhk_work\dev-data\diive-data\references\VITALE_2024_TIME-LAG-DETECTION\
    Vitale et al. - 2024 - A pre-whitening with block-bootstrap ....pdf   the paper
    RFlux-master-v3.2.0\                                                 the R package
```

Facts worth not re-deriving:

- **PWB$_{OPT}$ is the paper's, not diive's.** The S1/S2/S3 rule is Sect. 2.3 of
  Vitale et al. (2024): S1 accepts a lag whose 95 % HDI range is below 0.5 s, S2
  accepts a wider-HDI lag if it deviates by no more than 0.5 s from the optimal
  lag of the closest preceding averaging period, S3 replaces the rest with that
  preceding optimal lag. The carry-forward looks **backward only**.
- **RFlux v3.2.0 does not implement the selection.** The package exports one
  time-lag function, `tlag_detection()`, which works on a single averaging period
  and returns the PWB lag with its HDI bounds. Nothing in the package does S1/S2/S3
  (grep for "optimal" finds nothing). diive implements it in
  `diive/flux/hires/lag_pwb.py` (`apply_pwbopt`), plus a gap filler for periods
  before the first reliable detection (back-fill, then median of the raw lags,
  then a constant), which is diive's addition, not the paper's.
- **PWB searches a window too.** diive defaults to a symmetric ±10 s
  (`lag_max_s = 10.0`), matching the paper's broad window; the study's runs use
  99 bootstrap samples and a 20 s block length. So never write that PWB uses no
  search window; what distinguishes it is that its lags do not pile up at the
  limits.
- **CH-Cha is one of the paper's own four sites**, so their PWB results at Chamau
  are directly comparable to the ones produced here.

## Analysis pipeline

The main figures are built on the quality-controlled fluxes (`08`, `09`);
`03` and `04` mirror those same figures on the Level-1 fluxes, before the chain, as
the pre-quality-control counterpart. Notebooks run in order, each stage feeding the
next: `01` read CSV → Parquet. On the Level-1 side the merge and the plotting are
deliberately separate steps: `02` only merges, `03` only plots. `02` reads the
Level-1 tables (`01-`), stitches the two analyzers into one continuous full-year
series per variant, and writes a single file,
`data/02-level1_merged_parquet/level1_merged.parquet` (an `ANALYZER` column plus,
per variant and gas, a merged flux column `FN2O_V1` … and a merged lag column
`N2O_TLAG_USED_V1` …, the lag masked to the records that carry a flux). `03` reads
only that file and writes the raw-flux figures (`figures/03_merged_*.png`), the
Level-1 version of `08` (merged full-year raw flux, time lag, lag histogram). `04`
is the Level-1 version of `09` (raw flux distribution and cumulative budget); it
reads the same merged file, splitting the campaigns apart again on the `ANALYZER`
column because its budgets are paired within an analyzer, and writes
`figures/04_cumulative_*.png`. So `02` is the only reader of `01-` on this side,
and none of the three applies quality control.
`05` applies diive's flux processing chain (L2 quality flags, L3.1 storage, L3.2
outlier removal, L3.3 USTAR filtering, CUT_16/CUT_50/CUT_84) to every variant and
gas so the comparison runs on quality-controlled fluxes; it reads the full `01-`
tables (the chain needs the EddyPro flag and `USTAR` columns) and writes
`data/05-flux_processing_chain_parquet/`. It writes only data files, but at the
end it also renders inline overview figures per gas (a date/time heatmap grid and
a time-series grid of the CUT_50 QC flux for every variant, both analyzers); those
overviews are shown inline only and are not saved to `figures/`. Figure creation is
consolidated into two notebooks that both read the chain output. `08` merges the
two analyzers' QC fluxes, which cover complementary halves of 2021 (QCL is
campaign 2021_1, LGR is 2021_2), into one continuous full-year series per variant,
then plots the merged flux, time lag used, and a per-instrument lag histogram
(0.05 s EddyPro tlag raster, the two instruments overlaid), one figure per gas
(`figures/08_*.png`); the time lag is masked to the records where the QC flux
survives, so the lag row, histogram and mode describe exactly the records in the
flux row. `09` is the single place the cumulative comparison is produced, one
figure per gas with two rows: the half-hourly flux density distribution per
variant on top (kernel-density line, fixed x-range per gas, PWB$_{OPT}$ drawn as a
grey shaded reference area), and the running QC-flux budget per variant over the
paired common samples below (QCL and LGR panels, PWB$_{OPT}$ again a grey shaded
area), writing `figures/09_cumulative_*.png`. `SUPPL_level1_lag_diagnostics` sits
beside `03` rather than in the numbered chain: it reads the same merged file
(`02-`) along the time lag instead of along time (off-mode share of the lag by
month and hour, joint density of flux and lag used, pairwise lag-agreement and
budget-difference matrices) and writes `figures/suppl_lagdiag_*.png`.
Notebook numbers `06` and `07`
are intentionally unused (earlier retired plots: the per-analyzer QC figures and
other intermediates). The chain
(L2 to L4) is post-processing on top of the Level-1 EddyPro fluxes.

## Notebook conventions

- First code cell records `NB_START = datetime.now()`; the notebook ends with a
  `## Runtime` markdown header + a cell printing start / end / elapsed.
- diive I/O: `ReadFileType(filetype='EDDYPRO-FLUXNET-CSV-30MIN', ...)` to read,
  `diive.core.io.files.save_parquet` / `load_parquet` for Parquet.
- Figure notebooks expose `FIGSIZE` / `DPI` constants; keep `DPI` high (300) for
  publication-ready output.

## Captions (always)

**Every figure and every table gets a caption. Table captions go above the table,
figure captions below the figure.** No exceptions: this holds for the prose pages,
the notebooks, and anything added later. `_quarto.yml` sets `tbl-cap-location:
top` and `fig-cap-location: bottom`, and `styles.css` pins `caption-side: top`
because Bootstrap would otherwise drop a plain HTML table's caption to the bottom.

How to write them:

- **Notebooks use a plain markdown cell**, not Quarto `#|` cell options: a caption
  cell right *after* the cell that draws the figure, right *before* the cell that
  shows the table. Cell options were tried and dropped, because they are invisible
  in JupyterLab (they render only on the built site), and these notebooks are read
  in both places. Start the cell with `**Figure.**` / `**Table.**` and, when the
  cell emits one figure per gas, say which comes first ("N₂O first, then CH₄").
  The trade-off is deliberate: no automatic "Figure 1:" numbering and no `@fig-`
  cross-references for notebook output.
- **Captions built in code** (a loop that displays several tables) print the
  caption line right before the table with `display(Markdown(...))`.
- **Markdown pages** do use Quarto's own captions, so they are numbered: a figure
  is `![Caption text](path){#fig-id}`, caption in the image's text slot, never as a
  loose paragraph underneath. A table caption is a `: Caption text {#tbl-id}` line
  directly after the table; Quarto renders it above.

## Environment

- Python ≥3.12, managed with **uv** (`uv.lock`, `.venv` present).
- Run things via `uv run ...` (e.g. `uv run jupyter lab`).
- `diive` is an **editable** install: new functions added to it are available
  in notebooks here after a kernel restart, no reinstall needed.
- **Building the site:** Quarto ships via the `quarto-cli` dev dep, so `uv sync`
  installs it (no separate CLI needed). `uv run quarto render` builds into
  `_site`; `uv run quarto preview` serves with live reload. Set
  `$env:PYTHONUTF8=1` on Windows to avoid a cp1252 crash on emoji output. Quarto
  emits page-relative asset links, so no `BASE_URL` is needed (the old Jupyter
  Book footgun is gone). Publish with `.\deploy.ps1` (renders, then
  `ghp-import` to `gh-pages`).
- **Site look:** bootswatch `cosmo` (light) / `darkly` (dark), and `lightbox:
  auto`, so every figure on the site, notebook output included, opens zoomed in
  an overlay. The lightbox needs the vendored `_extensions/quarto-ext/lightbox`
  (added once with `quarto add quarto-ext/lightbox`); it is committed, so a
  fresh clone renders without extra setup.

## Conventions

- Author: Lukas Hörtnagl (ETH Zürich).
- The set of time-lag settings being compared is the study variable. Keep it
  defined in one place in the notebook(s), not hardcoded ad hoc.
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
- **Site build and deploy.** Never run `quarto render` / `quarto preview` or
  `deploy.ps1`. Explain how; let the user run it.
