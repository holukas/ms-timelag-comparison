# Notebooks

The analysis pipeline, in order. Each notebook reads the previous stage's output
and writes the next (see [Data](data.md) for the folder layout). Click through to
the rendered notebook.

1. [01 · Read EddyPro FLUXNET CSVs → Parquet](../notebooks/01_read_fluxes_to_parquet.ipynb).
   Reads each EddyPro FLUXNET CSV with `diive` and saves it as Parquet (`00- → 01-`).
2. [02 · Subset flux columns](../notebooks/02_subset_flux_columns.ipynb).
   Keeps a defined column list (fluxes and time-lag diagnostics) (`01- → 02-`).
3. [03 · Plot fluxes and time lag used](../notebooks/03_plot_fluxes.ipynb).
   Plots flux over time lag used per analyzer and gas, by variant, into `figures/03_*.png`.
4. [04 · Subset flux product FP2025.3 (year 2024)](../notebooks/04_subset_flux_product_2024.ipynb).
   Extracts the 2024 reference subset from the external FP2025.3 product (`→ 04-`).
5. [05 · Merge variants with the flux product](../notebooks/05_merge_variants_and_flux_product.ipynb).
   Merges all variant subsets with the 2024 reference, suffixed by source (`→ 05-`).
