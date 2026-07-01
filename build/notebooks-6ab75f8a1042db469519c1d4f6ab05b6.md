# Notebooks

The analysis pipeline, in order. Each notebook reads the previous stage's output
and writes the next (see [Data](data.md) for the folder layout). Click through to
the rendered notebook.

1. [01 · Read flux CSVs and PWB tlag summaries → Parquet](../notebooks/01_read_fluxes_to_parquet.ipynb).
   Reads each EddyPro FLUXNET CSV with `diive` and saves it as Parquet, and
   converts the PWB (`*-5`) tlag summaries to Parquet (`00- → 01-`).
2. [02 · Subset flux columns](../notebooks/02_subset_flux_columns.ipynb).
   Keeps a defined column list (fluxes, time-lag diagnostics, and `SW_IN_POT` for
   a later daytime / nighttime split) and restricts the rows to the analysis year
   (2021) (`01- → 02-`).
3. [03 · Plot fluxes and time lag used](../notebooks/03_plot_fluxes.ipynb).
   Plots flux, time lag used, and a lag histogram per analyzer and gas, by
   variant including the PWB (`*-5`) lag, into `figures/03_*.png`. These plot the
   raw Level-1 flux and are intermediate: notebook 06 rebuilds them on the
   quality-controlled flux.
4. [04 · Compare cumulative flux across the time-lag scenarios](../notebooks/04_compare_variant_fluxes.ipynb).
   Pairs the scenarios per analyzer on the half-hours where every scenario has a
   valid flux, then plots the cumulative flux (the running budget) per scenario
   in three panels: all common half-hours, daytime (`SW_IN_POT > 0`), and
   nighttime (`SW_IN_POT == 0`). Writes `figures/04_cumulative_*.png`. Also
   intermediate (raw Level-1 flux); see notebook 06 for the quality-controlled
   version.
5. [05 · Apply the flux processing chain to each variant](../notebooks/05_flux_processing_chain.ipynb).
   Runs `diive`'s post-processing chain (L2 quality flags, L3.1 storage, L3.2
   outlier removal, L3.3 USTAR filtering) on every variant and gas, so the
   comparison can be repeated on quality-controlled fluxes. Reads the full
   per-variant tables (`01-`), writes `05-flux_processing_chain_parquet/` and a
   post-QC cumulative overlay `figures/05_cumulative_qc_*.png`.
6. [06 · Figures on quality-controlled fluxes](../notebooks/06_figures_qc_fluxes.ipynb).
   Reads the chain output (`05-`) and rebuilds the notebook 03 and notebook 04
   figures on the quality-controlled flux for one USTAR scenario: flux / time lag
   / lag histogram by variant, and the paired cumulative comparison (all,
   daytime, nighttime). Writes `figures/06_*.png`. These are the relevant result
   figures; the notebook 03 / 04 `figures/03_*` / `04_*` are intermediate.
7. [08 · Merged analyzers, full-year QC flux figures](../notebooks/08_merged_analyzers_full_year.ipynb)
   (there is no notebook 07). The two analyzers cover complementary halves of 2021
   (QCL runs January to July, LGR July to December), so stitching them per variant
   gives one continuous full-year series. Reads the same sources as notebook 06
   (chain output `05-` for the QC flux, the `02-` / `01-` subsets for the lag) and
   plots, per gas, the merged flux, the time lag used, and a stacked
   per-instrument lag histogram, with the five variants as columns. Writes
   `figures/08_{scenario}_merged_{gas}.png`.

## Parked notebooks

These ran against the earlier setup and are parked (`x-` prefix)
pending rework for the PWB (`*-5`) scenario. They are not part of the active
pipeline and are not built into the book.

- `x-04` · Subset flux product FP2025.3 (year 2024): extracts the 2024 reference
  subset from the external FP2025.3 product (`→ 04-`).
- `x-05` · Merge variants with the flux product: merges the variant subsets with
  the 2024 reference, suffixed by source (`→ 05-`).

The old `x-06` figure-gallery notebook is gone; its auto-globbed figure grid now
lives in the [Repository inventory](../notebooks/00_inventory.ipynb) page,
alongside the data-file manifest.
