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
   variant including the PWB (`*-5`) lag, into `figures/03_*.png`.
4. [04 · Compare cumulative flux across the time-lag scenarios](../notebooks/04_compare_variant_fluxes.ipynb).
   Pairs the scenarios per analyzer on the half-hours where every scenario has a
   valid flux, then plots the cumulative flux (the running budget) per scenario
   in three panels: all common half-hours, daytime (`SW_IN_POT > 0`), and
   nighttime (`SW_IN_POT == 0`). Writes `figures/04_cumulative_*.png`.

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
