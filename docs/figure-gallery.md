# Figure gallery

The figures produced by the analysis notebooks. Two of them are the ones prepared
for the paper and are shown first, with the captions as written for it: the N₂O
figure in the main text and the CH₄ figure in its supplement. The remaining
sections show the supporting figures, which document the same comparison after
quality control and in cumulative form. Click any figure to open it full size.

## Figures prepared for the paper

Both are drawn by [notebook 03](../notebooks/03_level1_merged_figures.ipynb) from
the merged Level-1 table of
[notebook 02](../notebooks/02_level1_merged_analyzers.ipynb). The figure labels
`XLAG-N2OX` and `XLAG-CH4X` are placeholders for the numbering of the paper.

![**Figure XLAG-N2OX:** Half-hourly N₂O fluxes in 2021 at the Chamau grassland
site (CH-Cha, Switzerland) and the time lags used to compute them. N₂O was
measured with a quantum cascade laser (QCL, Aerodyne Research Inc., MA, USA) from
1 Jan until 20 Jul and with a laser spectrometer (LGR, Los Gatos Research,
Mountain View, CA, USA) from 22 Jul until 31 Dec; the dashed line marks the
instrument changeover. Fluxes are EddyPro output, before quality control.
Columns: covariance maximisation without fallback (a, f, k), the same search
falling back to the nominal lag (b, g, l), a narrow window with that fallback
(c, h, m), a constant lag at the campaign nominal value (d, i, n), and
pre-whitening with block-bootstrap cross-correlation (PWB_OPT; Vitale et al.,
2024) with 99 resamples (e, j, o). The searched window differs per column: 0 to
10 s in (a, b), a campaign-specific narrow window in (c) (0.40 to 0.90 s, default
0.60 s, for QCL; 1.50 to 3.30 s, default 1.75 s, for LGR), ±10 s in (e), and none
in (d), where the lag is fixed. The wide-window run is exploratory: the peak of
its lag distribution (k) sets the nominal lag of (b, c, d), its spread the window
of (c). Rows: flux (top), lag used (middle), and the distribution of those lags
per instrument in 0.05 s bins with the modal lag given (bottom). N₂O emissions
alternate between extended low-flux periods and short episodes of high emission
(a to e), so the signal available for temporal alignment varies strongly over the
year. Only the wide search accumulates lags at its limits (f, k); the narrow
search instead falls back to the nominal lag in a large share of half-hours
(h, m), while the PWB_OPT lags stay well inside their window (j, o). During the
high-emission episodes, when the signal-to-noise ratio is high, the methods
converge on the same lag. The narrow window (h) and PWB_OPT (j) both follow the
seasonal drift of the lag, which the constant lag cannot reproduce (i). In
periods where PWB_OPT cannot detect a clear time lag, the optimal lag of the
closest preceding averaging period is carried forward (j). The shared count axis
is scaled to (o), so taller spikes are cut off. The equivalent figure for CH₄ is
shown in the Supplement (Fig. XLAG-CH4X).](../figures/03_merged_n2o.png){#fig-paper-n2o}

![**Figure XLAG-CH4X:** Half-hourly CH₄ fluxes in 2021 at the Chamau grassland
site (CH-Cha, Switzerland) and the time lags used to compute them. CH₄ was
measured with a quantum cascade laser (QCL, Aerodyne Research Inc., MA, USA) from
1 Jan until 20 Jul and with a laser spectrometer (LGR, Los Gatos Research,
Mountain View, CA, USA) from 22 Jul until 31 Dec; the dashed line marks the
changeover. Fluxes are EddyPro output, before quality control. Columns:
covariance maximisation without fallback (a, f, k), the same search falling back
to the nominal lag (b, g, l), a narrow window with that fallback (c, h, m), a
constant lag at the campaign nominal value (d, i, n), and pre-whitening with
block-bootstrap cross-correlation (PWB_OPT; Vitale et al., 2024) with 99
resamples (e, j, o). The searched window differs per column: 0 to 10 s in (a, b),
a campaign-specific narrow window in (c) (0.45 to 0.90 s, default 0.65 s, for
QCL; 1.50 to 3.30 s, default 1.75 s, for LGR), ±10 s in (e), and none in (d),
where the lag is fixed. Rows: flux (top), lag used (middle), and the distribution
of those lags per instrument in 0.05 s bins with the modal lag given (bottom).
CH₄ fluxes stay low all year, with most half-hours within ±50 nmol m⁻² s⁻¹ and no
episodes of strong emission (a to e), so the signal available for temporal
alignment remains weak throughout (low signal-to-noise ratio). Under these
conditions the wide search fails frequently: about a fifth of its lags fall on
the 0 s or 10 s limit and its most frequent value is the 10 s limit itself
(f, k), so the nominal lag of (b, c, d) was taken from the peak of the
distribution below that limit. The fallback removes most of this accumulation
(g, l), and the narrow search resorts to the nominal lag in a large share of
half-hours (h, m). PWB_OPT keeps to a narrow band well inside its window and
follows the seasonal drift of the lag, which the constant lag cannot reproduce
(i, j, o). In periods where PWB_OPT cannot detect a clear time lag, the optimal
lag of the closest preceding averaging period is carried forward (j). The shared
count axis is scaled to (o), so taller spikes are cut off. The equivalent figure
for N₂O is shown in Fig. XLAG-N2OX.](../figures/03_merged_ch4.png){#fig-paper-ch4}

## Time-lag diagnostics of the same data

The merged Level-1 table read along the time lag rather than along time
([supplement to notebook 03](../notebooks/SUPPL_level1_lag_diagnostics.ipynb)),
one figure per gas. Top row: the share of half-hours whose lag left that
version's modal lag by more than 0.5 s, by month and hour of day. Middle row: the
joint distribution of the half-hourly flux and the lag it was computed with.
Bottom row: how often two versions select the same lag, what that means for the
summed flux, and how the flux offset to PWB$_{OPT}$ develops with the distance
between the two lags.

::: {.grid}

::: {.g-col-12 .g-col-md-6}
![N₂O time-lag diagnostics per version: off-mode share by month and hour, joint
density of flux and lag used, and the pairwise lag and budget differences
(Level-1, before quality control).](../figures/suppl_lagdiag_n2o.png){#fig-l1-lagdiag-n2o
group="l1-lagdiag"}
:::

::: {.g-col-12 .g-col-md-6}
![CH₄ time-lag diagnostics per version: off-mode share by month and hour, joint
density of flux and lag used, and the pairwise lag and budget differences
(Level-1, before quality control).](../figures/suppl_lagdiag_ch4.png){#fig-l1-lagdiag-ch4
group="l1-lagdiag"}
:::

:::

## Cumulative Level-1 flux

The flux density distribution and the running budget per version, on the same
Level-1 fluxes ([notebook 04](../notebooks/04_level1_cumulative_fluxes.ipynb)),
one figure per gas, with the QCL campaign on the left and the LGR campaign on the
right.

::: {.grid}

::: {.g-col-12 .g-col-md-6}
![N₂O raw-flux distribution and cumulative budget per version (kg N₂O-N ha⁻¹),
QCL and LGR (Level-1, before quality
control).](../figures/04_cumulative_n2o.png){#fig-l1-cumulative-n2o
group="l1-cumulative"}
:::

::: {.g-col-12 .g-col-md-6}
![CH₄ raw-flux distribution and cumulative budget per version (g CH₄-C m⁻²), QCL
and LGR (Level-1, before quality
control).](../figures/04_cumulative_ch4.png){#fig-l1-cumulative-ch4
group="l1-cumulative"}
:::

:::

## After quality control

The same comparison after the flux processing chain
([notebook 05](../notebooks/05_flux_processing_chain.ipynb): L2 quality flags,
L3.1 storage, L3.2 outlier removal, L3.3 USTAR filtering), shown for the `CUT_50`
USTAR scenario. The first pair repeats the merged full-year view of the paper
figures on quality-controlled fluxes
([notebook 08](../notebooks/08_merged_analyzers_full_year.ipynb)), with the time
lag masked to the records whose quality-controlled flux survives.

::: {.grid}

::: {.g-col-12 .g-col-md-6}
![Merged QCL and LGR, full-year 2021 N₂O quality-controlled flux, time lag, and
lag distribution per version
(CUT_50).](../figures/08_cut_50_merged_n2o.png){#fig-qc-merged-n2o
group="qc-merged"}
:::

::: {.g-col-12 .g-col-md-6}
![Merged QCL and LGR, full-year 2021 CH₄ quality-controlled flux, time lag, and
lag distribution per version
(CUT_50).](../figures/08_cut_50_merged_ch4.png){#fig-qc-merged-ch4
group="qc-merged"}
:::

:::

The second pair is the cumulative comparison on the same fluxes
([notebook 09](../notebooks/09_cumulative_qc_fluxes.ipynb)): the flux density
distribution per version above, and the running budget over the half-hours where
every version reports a valid flux below, integrated to a cumulative mass with
each version's total in the legend.

::: {.grid}

::: {.g-col-12 .g-col-md-6}
![N₂O flux distribution and cumulative quality-controlled budget per version
(kg N₂O-N ha⁻¹), QCL and LGR
(CUT_50).](../figures/09_cumulative_cut_50_n2o.png){#fig-qc-cumulative-n2o
group="qc-cumulative"}
:::

::: {.g-col-12 .g-col-md-6}
![CH₄ flux distribution and cumulative quality-controlled budget per version
(g CH₄-C m⁻²), QCL and LGR
(CUT_50).](../figures/09_cumulative_cut_50_ch4.png){#fig-qc-cumulative-ch4
group="qc-cumulative"}
:::

:::
