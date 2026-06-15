# Processing versions

This page is the explicit, auditable registry of the time-lag settings being
compared in this study. Fluxes are computed several times from the same raw data,
changing only how the time lag between the vertical wind component and each gas
(N₂O, CH₄, H₂O) is determined. Each row below is one processing version,
identified by a short code (e.g. `QCL-3`) used throughout the notebooks, figures,
and tables.

Two measurement campaigns are covered, distinguished by the gas analyzer used:

- 2021_1 (QCL, quantum cascade laser)
- 2021_2 (LGR, Los Gatos Research analyzer)

## The five versions

<<<<<<< Updated upstream
- A covariance-maximization run over a wide search window of −1 to 10 s, with no
  default lag applied when maximization does not return a clear value.
- A second covariance-maximization run over the same −1 to 10 s window, but
  falling back to a default lag (analyzer-specific values below) when no clear
  maximum is found. This run also exports the rotated time series used as input
  to the PWB method.
- A constant-lag run, in which a single fixed lag is imposed for the whole
  campaign (no per-record search).
- A PWB run (`*-4`), which detects and removes the lag with the Pre-Whitening
  with Block-bootstrap method (see [processing steps](processing-steps.md)).
  The lag is removed from the raw data first, then fluxes are computed with EC
  maximization disabled. Both the fluxes and the per-chunk time-lag results are
  available.
=======
The same scheme of five versions is applied to each campaign and to each gas
(N₂O, CH₄, H₂O). The versions differ only in how the lag is found:
>>>>>>> Stashed changes

| Version | Method                  | Search window         | Default lag applied            | Notes                                            |
| ------- | ----------------------- | --------------------- | ------------------------------ | ------------------------------------------------ |
| `-1`    | Covariance maximization | 0 to 10 s             | no (OPENLAG)                   | Also performs the unzipping of the raw data.     |
| `-2`    | Covariance maximization | 0 to 10 s             | yes, nominal lag as fallback   |                                                  |
| `-3`    | Covariance maximization | narrow (per campaign) | yes, nominal lag as fallback   | Narrow window is the per-gas range listed below. |
| `-4`    | Constant lag            | n/a                   | fixed at the nominal lag       | From the Flux Product. Implemented.              |
| `-5`    | PWB                     | n/a                   | n/a                            | Pre-whitening with block-bootstrap (Vitale et al. 2024). |

<<<<<<< Updated upstream
| Version   | Method                  | Search window | Default / fixed lag (N₂O, CH₄) | Notes                                                |
| --------- | ----------------------- | ------------- | ------------------------------ | ---------------------------------------------------- |
| `QCL-1`   | Covariance maximization | −1 to 10 s    | none                           | Also performs the unzipping of the raw data.         |
| `QCL-2R`  | Covariance maximization | −1 to 10 s    | 0.60 s, 0.65 s                 | Also exports rotated time series for the PWB method. |
| `QCL-3`   | Constant lag            | n/a           | 0.60 s, 0.65 s                 |                                                      |
| `QCL-4`   | PWB                     | n/a           | detected per chunk             | Lag removed from raw data, then fluxes with EC max off. |
=======
Implementation status: only the constant-lag run (`-4`) is currently done for
both campaigns; `-1`, `-2`, `-3`, and `-5` are still to be produced.
>>>>>>> Stashed changes

## Nominal lags and narrow windows

<<<<<<< Updated upstream
| Version   | Method                  | Search window | Default / fixed lag (N₂O, CH₄) | Notes                                                |
| --------- | ----------------------- | ------------- | ------------------------------ | ---------------------------------------------------- |
| `LGR-1`   | Covariance maximization | −1 to 10 s    | none                           | Also performs the unzipping of the raw data.         |
| `LGR-2R`  | Covariance maximization | −1 to 10 s    | 1.75 s, 1.75 s                 | Also exports rotated time series for the PWB method. |
| `LGR-3`   | Constant lag            | n/a           | 1.75 s, 1.75 s                 |                                                      |
| `LGR-4`   | PWB                     | n/a           | detected per chunk             | Lag removed from raw data, then fluxes with EC max off. |
=======
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
>>>>>>> Stashed changes
