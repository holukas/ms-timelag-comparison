# Processing steps

This page describes the **PWB** time-lag method used to produce the `*-4`
[processing versions](processing-versions.md), and the diive workflow that
applies it.

## The PWB time-lag method

For reactive and trace gases such as N₂O and CH₄, the gas-wind cross-correlation
is often too weak for conventional covariance-maximization (CM) to pinpoint the
time lag reliably. The `*-4` versions instead use the Pre-Whitening with
Block-bootstrap (PWB) method (Vitale et al., 2024), as implemented in `diive`. It
works in two stages.

**Pre-whitening.** An AR(*p*) filter (order chosen by AIC) removes serial
autocorrelation from each series before the cross-correlation function (CCF) is
computed. Turbulent wind and trace-gas series are strongly autocorrelated, which
broadens and distorts the CCF peak. Whitening the residuals sharpens the peak and
gives a cleaner lag estimate.

**Block-bootstrap.** Instead of a single CCF over the whole averaging period, the
method draws *N*ᵦ resampled series by moving-block resampling, where overlapping
blocks of length *L* preserve local autocorrelation. It detects the peak lag in
each resample and summarizes the resulting distribution by its mode (the lag
estimate) and a 95% Highest Density Interval (HDI). A narrow HDI means resampling
consistently finds the same lag, which is the method's reliability criterion.

Sonic temperature (T_sonic) is required. Four CCF combinations are evaluated
(scalar × W and scalar × T_sonic, each with a scalar, W, or T_sonic AR filter),
and the combination with the strongest peak is selected. The T_sonic-based
combinations often recover a cleaner lag for gases with a weak scalar × W signal.

Reference: Vitale D. et al. (2024), *Environmental and Ecological Statistics* 31,
219-244, [doi:10.1007/s10651-024-00615-9](https://doi.org/10.1007/s10651-024-00615-9).

## Workflow

The `*-4_PWB` versions are produced with diive's detect-and-remove TUI, an
end-to-end pipeline that detects and removes the lag in a single run. There is no
longer a separate pre-rotation step or a separate apply step: rotation is done in
memory, and the lag-corrected 30-minute files come straight out. Launch it with:

```powershell
uv run diive-tlag-pwb-detect-remove-tui
```

The form sets the input and output paths, the wind (u, v, w) and sonic-temperature
columns, the scalars (CH₄, N₂O), the PWB and chunking parameters, the raw-file
format (skip-rows, header rows, separator, file glob), and the per-chunk output
naming. Settings persist between sessions in `~/.diive/detect_remove_tui.yaml`, so
you enter them only once. The same pipeline runs headless as
`uv run diive-tlag-pwb-detect-remove`.

Each long raw file (e.g. 6 h) is read once and processed in 30-minute chunks
snapped to the wall-clock grid (:00 / :30), in two phases:

1. **Detect.** For each chunk, the wind vector is double-rotated in memory (the
   rotated data are never written to disk), and `PreWhiteningBootstrap` runs on
   the rotated W, each scalar, and sonic temperature to estimate the lag per gas.
2. **PWBOPT.** Once every chunk is detected, the PWBOPT decision rule (S1/S2/S3
   carry-forward and gap-fill) is applied across the *whole* chunk sequence in
   temporal order to pick the best lag for each chunk. This replaces a spurious
   wide-HDI estimate with the neighboring optimal lag.
3. **Remove.** Each scalar in the unrotated chunk is shifted back by the
   optimized lag, and the lag-corrected chunk is written as its own 30-minute
   file, with the original header rows and column order preserved.

Outputs land in the output directory: the lag-corrected 30-minute files, a
summary table (`1_lag_detection/detect_and_remove_tlag_summary.csv`), optional
overview plots, and a `log.txt` of the run.

The lag-corrected files then go through normal flux processing with EC time-lag
maximization disabled, because the tube delay has already been corrected here.
