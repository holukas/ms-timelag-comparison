# Notebooks

The analysis pipeline, in order. Each notebook reads the previous stage's output
and writes the next (see [Data](data.md) for the folder layout). Click through to
the rendered notebook.

1. [01 · Read flux CSVs and PWB tlag summaries → Parquet](../notebooks/01_read_fluxes_to_parquet.ipynb).
   Reads each EddyPro FLUXNET CSV with `diive` and saves it as Parquet, and
   converts the PWB (`*-4`) tlag summaries to Parquet (`00- → 01-`).
2. [02 · Subset flux columns](../notebooks/02_subset_flux_columns.ipynb).
   Keeps a defined column list (fluxes and time-lag diagnostics) and restricts
   the rows to the analysis year (2021) (`01- → 02-`).
3. [03 · Plot fluxes and time lag used](../notebooks/03_plot_fluxes.ipynb).
   Plots flux over time lag used per analyzer and gas, by variant including the
   PWB (`*-4`) lag, into `figures/03_*.png`.
4. [04 · Subset flux product FP2025.3 (year 2024)](../notebooks/04_subset_flux_product_2024.ipynb).
   Extracts the 2024 reference subset from the external FP2025.3 product (`→ 04-`).
5. [05 · Merge variants with the flux product](../notebooks/05_merge_variants_and_flux_product.ipynb).
   Merges all variant subsets with the 2024 reference, suffixed by source (`→ 05-`).
6. [06 · Figure gallery](../notebooks/06_figure_gallery.ipynb).
   Shows every figure in `figures/` as a grid, globbed at run time.
