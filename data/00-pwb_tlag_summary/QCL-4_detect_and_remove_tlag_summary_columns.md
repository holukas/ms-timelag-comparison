# `detect_and_remove_tlag_summary.csv` - column reference

One row per processed chunk from the PWB time-lag detect + remove pipeline (`diive-tlag-pwb-detect-remove`). Each raw input file is split into fixed-length chunks; the scalar-vs-wind tube-delay lag is detected per chunk, optimised across all chunks (PWBOPT), then removed from the written output.

Run settings reflected here: hz = 20, chunk = 1800 s (36000 rows/full chunk), min chunk = 300 s (6000 rows), applied lag column = `{prefix}_tlag_final_pf_s`.

## General columns

| Column | Description |
|---|---|
| `period` | Output filename of this chunk's lag-corrected file (written into the data subfolder). One row = one output file; this is the key that joins the summary to the files in the data folder. |
| `parent` | Name of the raw input file this chunk was read from. |
| `timestamp` | ISO-8601 start time of the chunk, derived from the parent filename via --start-time-regex / --start-time-format plus the chunk offset. Empty when no start-time regex was given. |
| `chunk_index` | 0-based index of the chunk within its parent file. |
| `chunk_records` | Number of data rows in the chunk. A full chunk has chunk_seconds * hz = 36000 rows; the trailing chunk of a file may be shorter. |
| `status` | Detect-phase outcome of the chunk: 'ok' (lag detected and file written), 'skipped:short' (fewer than min_chunk_seconds * hz = 6000 rows, too few for the bootstrap, not written), 'skipped:duplicate' (its output name collided with a lower-index chunk and was skipped to avoid overwriting it), 'error' (processing failed - see the error column). |
| `error` | Exception type and message when status = 'error', or the reason text when status = 'skipped:duplicate'. Empty otherwise. |
| `theta_deg` | First double-rotation angle (yaw): horizontal wind rotated into the mean wind direction, in degrees. |
| `phi_deg` | Second double-rotation angle (pitch): vertical tilt correction so mean w = 0, in degrees. |

## Per-gas columns

The block below repeats once per scalar, with `{gas}` replaced by the lowercased label. In this run: N2O -> `n2o_*`, CH4 -> `ch4_*`.

| Column | Description |
|---|---|
| `{gas}_tlag_s` | RAW detected time lag (s): the bootstrap mode lag between vertical wind W and this scalar for this chunk. The unprocessed PWB estimate - not necessarily the lag that was applied (see {gas}_tlag_final_pf_s). |
| `{gas}_hdi_lo_s` | Lower bound of the 95% highest-density interval (HDI) of the bootstrap lag distribution (s). |
| `{gas}_hdi_hi_s` | Upper bound of the 95% HDI (s). |
| `{gas}_hdi_range_s` | Width of the 95% HDI (hi - lo, s). The reliability metric: a narrow HDI means a well-determined lag, a wide HDI means a noisy / undetermined one. |
| `{gas}_is_reliable` | True if the chunk passed the S1 reliability test (HDI range below --hdi-thresh). |
| `{gas}_tlag_pw_s` | Lag (s) of the peak of the pre-whitened cross-correlation function - the single, non-bootstrap pre-whitened estimate. |
| `{gas}_corr_pw` | Correlation at that pre-whitened CCF peak (-1..1). |
| `{gas}_cov_pwb` | Raw (un-whitened) W-scalar cross-covariance evaluated at the selected lag. |
| `{gas}_ar_order` | Order of the autoregressive model used to pre-whiten this chunk. |
| `{gas}_best_combination` | Which of the four pre-whitening combinations won the selection: 'cw' (scalar x W, scalar AR), 'wc' (scalar x W, W AR), 'ct' (scalar x T_SONIC, scalar AR), 'tc' (scalar x T_SONIC, T_SONIC AR). Strong fluxes usually win on cw/wc; weak trace gases may fall back to the T_SONIC pair. |
| `{gas}_applied_records` | Number of records the scalar column was shifted by in phase 2 = round(applied_lag_s * hz). The applied lag in seconds = this / hz (hz = 20). NaN if the chunk was not written. |
| `{gas}_status` | Alignment (phase-2) outcome for this gas: 'ok' (shifted and written), 'skipped:lag_nan' (no finite PWBOPT lag to apply), 'pending' (the chunk never reached phase 2, e.g. a detect error or short chunk). |
| `{gas}_pwbopt_s_std` | PWBOPT-selected lag (s), STANDARD rule: the S1/S2/S3 carry-forward applied directly to the raw mode lag across the full time-ordered sequence of chunks. |
| `{gas}_flag_std` | PWBOPT decision flag for the standard series: 'S1_optimal' (reliable detection), 'S2_optimal' (uncertain but within --dev-thresh of the preceding optimal lag, so carried forward), 'S3_unreliable' (neither; filled from neighbours in the final column). |
| `{gas}_pwbopt_s_pf` | PWBOPT-selected lag (s), PRE-FILTERED rule: detections with an HDI range wider than --hdi-prefilter are dropped before the S1/S2/S3 logic runs. |
| `{gas}_flag_pf` | PWBOPT decision flag for the pre-filtered series (same S1/S2/S3 meaning as flag_std). |
| `{gas}_tlag_final_s` | Final lag (s) from the STANDARD PWBOPT series after gap-filling any remaining leading/trailing NaNs. |
| `{gas}_tlag_final_pf_s` | Final lag (s) from the PRE-FILTERED PWBOPT series after gap-filling. This is the pre-filtered, gap-filled best lag - removed by default. **This is the lag column removed in this run (see applied lag column above).** |

## Notes

- `tlag_s` is the raw per-chunk detection; the lag actually removed is the PWBOPT-optimised, gap-filled column named above. A wide-HDI chunk's raw lag can be spurious, so PWBOPT replaces it with the neighbouring reliable lag.
- Only rows with `status = ok` produce an output file. `skipped:short`, `skipped:duplicate` and `error` rows are reported for traceability but write nothing.
- The applied lag in seconds for a gas equals `{gas}_applied_records / hz`.
