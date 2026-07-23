# Notebooks

The analysis pipeline, in order. Each notebook reads the previous stage's output
and writes the next (see [Data](data.md) for the folder layout). Click through to
the rendered notebook.

1. [01 · Read flux CSVs and PWB tlag summaries → Parquet](../notebooks/01_read_fluxes_to_parquet.ipynb).
   Reads each EddyPro FLUXNET CSV with `diive` and saves it as Parquet, and
   converts the PWB (`*-5`) tlag summaries to Parquet (`00- → 01-`).
2. [02 · Level-1 merged analyzers, one full-year table](../notebooks/02_level1_merged_analyzers.ipynb).
   Merges the two analyzers into one continuous full-year table of Level-1 EddyPro
   fluxes and time lags (`01-`), before the flux processing chain. A data step only:
   it draws nothing and writes one file,
   `02-level1_merged_parquet/level1_merged.parquet`, with a raw flux and a time-lag
   column per variant and gas plus an `ANALYZER` column.
3. [03 · Level-1 merged analyzers, full-year figures](../notebooks/03_level1_merged_figures.ipynb).
   The pre-quality-control counterpart of notebook 08: the same merged full-year
   view, drawn from the merged table (`02-`) and nothing else. Plots, per gas, the
   merged raw flux, the time lag used, and a per-instrument lag histogram, with the
   five variants as columns. Writes `figures/03_merged_{gas}.png`.
4. [04 · Level-1 flux distribution and cumulative budget](../notebooks/04_level1_cumulative_fluxes.ipynb).
   The pre-quality-control counterpart of notebook 09: the half-hourly flux density
   distribution and the running cumulative budget per variant, over the paired
   common samples. Like notebook 03 it reads only the merged table (`02-`), using
   its `ANALYZER` column to keep the two campaigns apart. Writes
   `figures/04_cumulative_{gas}.png`.
5. [05 · Apply the flux processing chain to each variant](../notebooks/05_flux_processing_chain.ipynb).
   Runs `diive`'s post-processing chain (L2 quality flags, L3.1 storage, L3.2
   outlier removal, L3.3 USTAR filtering) on every variant and gas, so the
   comparison can be repeated on quality-controlled fluxes. Reads the full
   per-variant tables (`01-`) and writes `05-flux_processing_chain_parquet/`. It
   saves no figure files, but at the end it renders an inline overview per gas: a
   date/time heatmap grid and a time-series grid of the CUT_50 QC flux for every
   variant (both analyzers), shown in the notebook only. The saved figures that use
   this stage are built downstream (08, 09).
6. [08 · Merged analyzers, full-year QC flux figures](../notebooks/08_merged_analyzers_full_year.ipynb).
   The two analyzers cover complementary halves of 2021 (QCL runs January to July,
   LGR July to December), so stitching them per variant gives one continuous
   full-year series. Reads the chain output (`05-`) for the QC flux and the `01-`
   level-1 tables for the lag, then plots, per gas, the merged flux, the time lag
   used, and a per-instrument lag histogram (0.05 s EddyPro tlag raster, the two
   instruments overlaid), with the five variants as columns. The time lag is masked
   to the records where the QC flux survives, so the lag row, histogram, and mode
   describe exactly the records shown in the flux row. Writes
   `figures/08_{scenario}_merged_{gas}.png`.
7. [09 · Cumulative quality-controlled flux by variant](../notebooks/09_cumulative_qc_fluxes.ipynb).
   The single place the cumulative comparison is produced. Reads the chain output
   (`05-`) and draws, per gas, two rows. The top row shows the half-hourly flux
   density distribution per variant (a kernel-density line, with PWB_OPT drawn as a
   grey shaded reference area). The bottom row shows the running cumulative QC-flux
   budget of each variant over the paired common samples, in two panels (QCL and
   LGR), integrated to a cumulative mass (N₂O in kg N₂O-N ha⁻¹, CH₄ in g CH₄-C m⁻²)
   with each variant's total in the legend and PWB_OPT again as a grey shaded area.
   Writes `figures/09_cumulative_{scenario}_{gas}.png`.

Notebooks 03 and 04 mirror the figures of 08 and 09 on the Level-1 fluxes
(before quality control); 08 and 09 are the quality-controlled versions. Reading
and plotting are kept apart on the Level-1 side: 02 builds the merged table, 03
and 04 only draw it. Notebook numbers 06 and 07 are intentionally unused: they
held earlier plots (per-analyzer QC figures and other intermediates) that were
removed once figure creation was consolidated.

## Removed notebooks

An earlier setup carried three extra notebooks, all now removed. `x-04` extracted
the year-2024 reference subset from the external flux product FP2025.3 (`→ 04-`)
and `x-05` merged the variant subsets with that reference (`→ 05-`); neither was
reworked for the PWB (`*-5`) scenario, and nothing in the current pipeline reads
their output. The two data folders they wrote are still tracked for provenance
(see [Data](data.md)).

The old `x-06` figure-gallery notebook is gone too; its auto-globbed figure grid now
lives in the [Repository inventory](../notebooks/00_inventory.ipynb) page,
alongside the data-file manifest.
