


- For PWB raw EC data files are rotated (2D) in EddyPro and then the rotated files (level 5 in EddyPro) are saved to hard disk. 
- The format of the rotated files is defined by EddyPro
- Rotated files are then used to detect the time lags using the PWB method.
- PWB is implemented in diive and can be run with CLI
 
```powershell
uv run diive-tlag-pwb-batch --input-dir "F:\CURRENT\CHA_TIMELAG-COMPARISON_2021\2-FLUXRUN\QCL-4_PWB\00_rotated_files_level_5" --output-dir "F:\CURRENT\CHA_TIMELAG-COMPARISON_2021\2-FLUXRUN\QCL-4_PWB\01_pwb_results" --scalar CH4:ch4 --scalar N2O:n2o --col-w w --col-tsonic ts --usecols 0 1 2 3 6 7 --col-names u v w ts ch4 n2o --skiprows 9 --hz 20 --lag-max 10.0 --n-bootstrap 99 --block-length 20.0 --min-valid-frac 0.3 --hdi-thresh 0.5 --dev-thresh 0.5 --hdi-prefilter 1.0 --n-workers 2 --save-plots
```

- This generates the file `tlag_results.csv` in `output-dir` 

the workflow is:

1. PWB detection on the _rotated_ files (gives reliable W for CCF)
2. Lag removal applied to the _raw, unrotated_ files
3. Flux processing on the lag-corrected raw files, **with EC time-lag maximization disabled** in EddyPro / FluxRun

- File `tlag_results.csv` is then used to remove the detected time lags from the **original unrotated** raw files

```powershell
uv run diive-tlag-apply-batch --input-dir "F:\CURRENT\CHA_TIMELAG-COMPARISON_2021\2-FLUXRUN\LGR-1_FR-20260520-180601_ASCII\1-0_rawdata_files_ascii\" --output-dir "F:\CURRENT\CHA_TIMELAG-COMPARISON_2021\2-FLUXRUN\LGR-4_PWB\02_orig_rawdata_files_ascii_lagremoved\" --results-csv "F:\CURRENT\CHA_TIMELAG-COMPARISON_2021\2-FLUXRUN\LGR-4_PWB\01_pwb_results\tlag_results.csv" --scalar CH4:ch4 --scalar N2O:n2o --hz 20 --skiprows 9 --n-workers 4
```

