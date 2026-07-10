# Processing versions

This page lists the time-lag settings compared in this study. Fluxes are computed
several times from the same raw data,
changing only how the time lag between the vertical wind component and each gas
(N₂O, CH₄, H₂O) is determined. Each row below is one processing version,
identified by a short code (e.g. `QCL-3`) used throughout the notebooks, figures,
and tables.

Two measurement campaigns are covered, distinguished by the gas analyzer used:

- 2021_1 (QCL, quantum cascade laser)
- 2021_2 (LGR, Los Gatos Research analyzer)

## The five versions

The same scheme of five versions is applied to each campaign and to each gas
(N₂O, CH₄, H₂O). The versions differ only in how the lag is found. The method
abbreviations (CM, CM$_{CTR}$, PWB, PWB$_{OPT}$) follow Vitale et al. (2024):
CM = covariance maximisation, subscript CTR = constrained (narrow window), PWB =
pre-whitening with block-bootstrap, PWB$_{OPT}$ = the optimised PWB lag (the
S1/S2/S3 decision rule applied to the per-period PWB estimates).

| Version | Method                       | Search window         | Default lag applied          | Notes                                                       |
| ------- | ---------------------------- | --------------------- | ---------------------------- | ----------------------------------------------------------- |
| `-1`    | CM                           | 0 to 10 s             | no (OPENLAG)                 | Also performs the unzipping of the raw data.                |
| `-2`    | CM                           | 0 to 10 s             | yes, nominal lag as fallback | Also exports the rotated time series used by PWB.           |
| `-3`    | CM$_{CTR}$ (constrained CM)  | narrow (per campaign) | yes, nominal lag as fallback | Narrow window is the per-gas range listed below.            |
| `-4`    | Constant lag                 | n/a                   | fixed at the nominal lag     | EddyPro constant-lag run (`tlag_meth=1`); no paper acronym. |
| `-5`    | PWB$_{OPT}$                  | n/a                   | n/a                          | Pre-whitening with block-bootstrap (Vitale et al. 2024).    |

Implementation status: all five versions (`-1` through `-5`) are produced for
both campaigns. For `-5` (PWB) the lag is detected and removed from the raw data
before the EddyPro run, so that run applies no lag compensation; its per-chunk
time-lag summaries are kept alongside the fluxes. The lag applied (and reported
in the figures) is the optimised PWB$_{OPT}$ lag, not the raw per-period PWB
mode.

## Nominal lags and narrow windows

For each campaign and gas, the **nominal lag** is the value used as the default
fallback (`-2`, `-3`) and as the fixed lag (`-4`); the **narrow window** is the
search range for `-3`. Values are derived from the per-period lag analysis
(provenance: the full 2012 to 2022 per-period lag table); only the two periods
covering these campaigns are reproduced here.

### 2021_1 (QCL), source period `2020_4+5_2021_1`

| Gas | Nominal lag (s) | Narrow window (s) |
| --- | --------------- | ----------------- |
| N₂O | 0.60            | 0.40 to 0.90      |
| CH₄ | 0.65            | 0.45 to 0.90      |
| H₂O | 0.70            | 0.60 to 2.00      |

### 2021_2 (LGR), source period `2021_2_2022_1`

| Gas | Nominal lag (s) | Narrow window (s) |
| --- | --------------- | ----------------- |
| N₂O | 1.75            | 1.50 to 3.30      |
| CH₄ | 1.75            | 1.50 to 3.30      |
| H₂O | 1.80            | 1.65 to 6.00      |

For the LGR campaign the lag fluctuates within these ranges across the period.
