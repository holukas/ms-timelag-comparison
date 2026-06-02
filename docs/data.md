# Data

All datasets live under `data/` at the repository root. **`data/` is
gitignored** — the files are *not* version-controlled here; this page documents
what the directory contains and how it maps onto the
[processing versions](processing-versions.md) being compared.

```
data/
  eddypro_fluxes/     EddyPro flux output, one file per processing version
  eddypro_settings/   the EddyPro project + metadata that produced each version
  meteo/              meteorological data (for context / gap-filling inputs)
```

## `eddypro_fluxes/`

EddyPro output in **FLUXNET format** (one row per half hour, ~9,500 records,
483 columns), one file per processing version. The version code is embedded in
each filename (e.g. `eddypro_QCL-1_…_fluxnet_…_adv.csv`).

| Version  | Analyzer | Campaign      | Run  |
| -------- | -------- | ------------- | ---- |
| `QCL-1`  | QCL      | 2021_1        | 2026 |
| `QCL-2R` | QCL      | 2021_1        | 2026 |
| `QCL-3`  | QCL      | 2020_4–2021_1 | 2024 |
| `LGR-1`  | LGR      | 2021_2        | 2026 |
| `LGR-2R` | LGR      | 2021_2        | 2026 |
| `LGR-3`  | LGR      | 2021_2–2022_1 | 2024 |

Columns central to this study:

- **Fluxes:** `FN2O`, `FCH4` (and quality/uncertainty companions such as
  `FN2O_RANDUNC_HF`, `FCH4_RANDUNC_HF`).
- **Time-lag diagnostics**, per gas — the variable the comparison turns on:
  `N2O_TLAG_USED`, `N2O_TLAG_ACTUAL`, `N2O_TLAG_NOMINAL`, `N2O_TLAG_MIN`,
  `N2O_TLAG_MAX` and the equivalent `CH4_TLAG_*` set.

## `eddypro_settings/`

The EddyPro configuration that produced each flux file: a `.eddypro` project
file and its companion `.metadata` file per version. Filenames encode the
time-lag strategy:

- `*_OPENLAG-10s_*` — open covariance-maximization search (−1 to 10 s), no
  default fallback → versions `*-1`.
- `*_DEFAULT-10s_*` — covariance maximization (10 s window) with a default
  fallback lag → versions `*-2R`.
- `*_CH-CHA_…` — the earlier (2024) constant-lag runs → versions `*-3`.

These files are the auditable definition of each version; keep them in sync with
the [processing versions](processing-versions.md) table.

## `meteo/`

Meteorological data used as supporting context. *(To be documented once
populated.)*
