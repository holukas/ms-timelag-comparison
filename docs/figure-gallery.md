# Figure gallery

The manuscript record of the plots produced by the analysis notebooks. The main
figures are built on the **quality-controlled** fluxes from the flux processing
chain ([notebook 05](../notebooks/05_flux_processing_chain.ipynb), L2 to L3.3 with
USTAR filtering) applied to every variant, shown here for the `CUT_50` USTAR
scenario. The Level-1 sections at the bottom are the same figures on the **raw**
fluxes, before quality control (notebooks 03 and 04). Click any figure to open it
full size.

## Merged full-year flux and time lag (notebook 08)

The QCL and LGR halves of each variant stitched into one continuous 2021 series
([notebook 08](../notebooks/08_merged_analyzers_full_year.ipynb)), one figure per
gas. Each shows the merged quality-controlled flux, the time lag used (over the
records where the QC flux survives), and a per-instrument lag histogram (0.05 s
bins on the EddyPro tlag raster, the two instruments overlaid), with the five
variants as columns; the dashed line marks
the QCL to LGR handover in July, and each panel prints the two instruments' modal
lags in its corner. Shown for the `CUT_50` USTAR scenario.

::: {.grid}

::: {.g-col-12 .g-col-md-6}
![Merged QCL + LGR, full-year 2021 N₂O QC flux, time lag, and lag histogram by
variant (CUT_50).](../figures/08_cut_50_merged_n2o.png){#fig-qc-merged-n2o
group="qc-merged"}
:::

::: {.g-col-12 .g-col-md-6}
![Merged QCL + LGR, full-year 2021 CH₄ QC flux, time lag, and lag histogram by
variant (CUT_50).](../figures/08_cut_50_merged_ch4.png){#fig-qc-merged-ch4
group="qc-merged"}
:::

:::

## Cumulative flux comparison (notebook 09)

One figure per gas, with two rows. The lower row is the cumulative
quality-controlled flux (the running budget) per variant, on the half-hours where
every variant has a valid flux, integrated to a cumulative mass (N₂O as
kg N₂O-N ha⁻¹, CH₄ as g CH₄-C m⁻²); each variant's overall total is given in the
legend, and lines that fan apart mean the lag setting accumulates into a
different total budget even after quality control. The upper row is the flux
density distribution per variant on those same samples, with PWB$_{OPT}$ drawn as
a grey shaded reference area. Each figure has the QCL campaign (2021_1) on the
left and the LGR campaign (2021_2) on the right.

::: {.grid}

::: {.g-col-12 .g-col-md-6}
![N₂O flux distribution and cumulative QC-flux budget by variant
(kg N₂O-N ha⁻¹), QCL and LGR
(CUT_50).](../figures/09_cumulative_cut_50_n2o.png){#fig-qc-cumulative-n2o
group="qc-cumulative"}
:::

::: {.g-col-12 .g-col-md-6}
![CH₄ flux distribution and cumulative QC-flux budget by variant (g CH₄-C m⁻²),
QCL and LGR (CUT_50).](../figures/09_cumulative_cut_50_ch4.png){#fig-qc-cumulative-ch4
group="qc-cumulative"}
:::

:::

## Level-1 merged full-year raw flux (notebook 03)

The pre-quality-control counterpart of the merged figure above, drawn from the
merged Level-1 table
([notebook 03](../notebooks/03_level1_merged_figures.ipynb), on the table built by
[notebook 02](../notebooks/02_level1_merged_analyzers.ipynb)), one figure per gas:
the merged raw flux, the time lag used, and the per-instrument lag histogram, with
the five variants as columns.

::: {.grid}

::: {.g-col-12 .g-col-md-6}
![Merged QCL + LGR, full-year 2021 N₂O raw flux, time lag, and lag histogram by
variant (Level-1, before quality control).](../figures/03_merged_n2o.png){#fig-l1-merged-n2o
group="l1-merged"}
:::

::: {.g-col-12 .g-col-md-6}
![Merged QCL + LGR, full-year 2021 CH₄ raw flux, time lag, and lag histogram by
variant (Level-1, before quality control).](../figures/03_merged_ch4.png){#fig-l1-merged-ch4
group="l1-merged"}
:::

:::

## Level-1 cumulative raw flux (notebook 04)

The pre-quality-control counterpart of the cumulative figure above, built on the
Level-1 fluxes ([notebook 04](../notebooks/04_level1_cumulative_fluxes.ipynb)), one
figure per gas: the flux density distribution (top) and the cumulative budget
(bottom) per variant, QCL on the left and LGR on the right.

::: {.grid}

::: {.g-col-12 .g-col-md-6}
![N₂O raw-flux distribution and cumulative budget by variant (kg N₂O-N ha⁻¹), QCL
and LGR (Level-1, before quality
control).](../figures/04_cumulative_n2o.png){#fig-l1-cumulative-n2o
group="l1-cumulative"}
:::

::: {.g-col-12 .g-col-md-6}
![CH₄ raw-flux distribution and cumulative budget by variant (g CH₄-C m⁻²), QCL
and LGR (Level-1, before quality
control).](../figures/04_cumulative_ch4.png){#fig-l1-cumulative-ch4
group="l1-cumulative"}
:::

:::
