# Processing versions

This page is the explicit, auditable registry of the time-lag settings being
compared in this study. Fluxes are computed several times from the same raw data,
changing only how the time lag between the vertical wind component and each gas
(N₂O, CH₄) is determined. Each row below is one processing version, identified by
a short code (e.g. `QCL-2R`) used throughout the notebooks, figures, and tables.

Two measurement campaigns are covered, distinguished by the gas analyzer used:

- 2021_1 (QCL, quantum cascade laser)
- 2021_2 (LGR, Los Gatos Research analyzer)

For each campaign the same scheme of versions is applied:

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
  Fluxes for this variant are not computed yet, so far only its per-chunk
  time-lag results are available.

## 2021_1 (QCL)

| Version   | Method                  | Search window | Default / fixed lag (N₂O, CH₄) | Notes                                                |
| --------- | ----------------------- | ------------- | ------------------------------ | ---------------------------------------------------- |
| `QCL-1`   | Covariance maximization | −1 to 10 s    | none                           | Also performs the unzipping of the raw data.         |
| `QCL-2R`  | Covariance maximization | −1 to 10 s    | 0.60 s, 0.65 s                 | Also exports rotated time series for the PWB method. |
| `QCL-3`   | Constant lag            | n/a           | 0.60 s, 0.65 s                 |                                                      |
| `QCL-4`   | PWB                     | n/a           | detected per chunk             | Time lags only, no fluxes yet.                       |

## 2021_2 (LGR)

| Version   | Method                  | Search window | Default / fixed lag (N₂O, CH₄) | Notes                                                |
| --------- | ----------------------- | ------------- | ------------------------------ | ---------------------------------------------------- |
| `LGR-1`   | Covariance maximization | −1 to 10 s    | none                           | Also performs the unzipping of the raw data.         |
| `LGR-2R`  | Covariance maximization | −1 to 10 s    | 1.75 s, 1.75 s                 | Also exports rotated time series for the PWB method. |
| `LGR-3`   | Constant lag            | n/a           | 1.75 s, 1.75 s                 |                                                      |
| `LGR-4`   | PWB                     | n/a           | detected per chunk             | Time lags only, no fluxes yet.                       |
