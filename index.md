# Introduction

This site documents one analysis: how different time-lag settings change eddy
covariance fluxes of N₂O and CH₄. It produces the figures for the time-lag part
of a co-authored paper on methodological challenges in CH₄ and N₂O flux
measurements (in preparation). The paper itself is written elsewhere, and only
the material needed to interpret these figures is documented here.

In eddy covariance, the time lag between the vertical wind measured by the sonic
anemometer and the gas signal from the analyzer must be determined before fluxes
can be computed. For N₂O and CH₄ this is more difficult than for CO₂ or H₂O,
because the gas-wind cross-covariance is often weak: the peak the lag search
looks for can be indistinguishable from noise, and the search then returns a lag
that reflects that noise rather than the travel time through the tube. The
setting used to determine the lag therefore affects the resulting flux. The
analysis computes the fluxes several times from the same raw data, varying only
the time-lag setting, and compares the results.

## Measurement site

The measurements come from Chamau (CH-Cha), an intensively managed grassland in
the pre-alpine valley bottom near Zug, Switzerland (47.210227 N, 8.410645 E,
393 m a.s.l.). Mean annual temperature is 10.0 °C (2006 to 2024) and mean annual
precipitation about 1134 mm. The sward is a mixture of Italian ryegrass and white
clover grown mainly for silage, cut roughly six times a year, with occasional
spring and autumn grazing by sheep and cattle, and renewed every 6 to 7 years by
ploughing. The soil is a Cambisol/Gleysol on tertiary molasse with postglacial
deposits from the Reuss glacier, pH 5.3 in the top 10 cm. Eddy covariance
measurements started in July 2005 and cover net ecosystem exchange,
evapotranspiration, sensible heat, CH₄ and N₂O. Chamau is one of three grassland
sites in the Swiss FluxNet network (site information:
[Swiss FluxNet](https://www.swissfluxnet.ethz.ch/index.php/sites/site-info-ch-cha/),
[ETH Grassland Sciences](https://gl.ethz.ch/infrastructure/sites/chamau.html)).

Two measurement campaigns in 2021 are covered, distinguished by the gas analyzer:
QCL (quantum cascade laser, campaign 2021_1, 1 January to 20 July) and LGR (Los
Gatos Research analyzer, campaign 2021_2, 22 July to 31 December).

## How to read this site

- [Time lag](docs/time-lag.qmd) is the methods page: why the lag is difficult to
  determine for these two gases, the five settings compared, the values each one
  was run with, and the PWB method behind the fifth.
- [Data](docs/data.md) describes the datasets and the processing stages of the
  `data/` folder.
- [Figure gallery](docs/figure-gallery.md) collects the resulting figures,
  including the two that go into the paper.
- The analysis notebooks below the methods pages run the processing and render
  into this site, and [Repository inventory](notebooks/00_inventory.ipynb) lists
  the tracked files directly from disk.

## The analysis pipeline

The notebooks run in order, each stage reading the output of the previous one:

1. **01** reads the EddyPro FLUXNET CSV files and the PWB time-lag summaries and
   saves them as Parquet (`00-` to `01-`).
2. **02** merges the two campaigns into one continuous full-year table of
   Level-1 fluxes and time lags, before quality control (`01-` to `02-`).
3. **03** draws that merged table: raw flux, time lag used, and the lag
   distribution per instrument, one figure per gas.
4. **04** derives the flux distribution and the cumulative budget from the same
   table, one figure per gas.
5. **05** applies the diive flux processing chain (L2 quality flags, L3.1
   storage, L3.2 outlier removal, L3.3 USTAR filtering) to every version and gas
   (`01-` to `05-`).
6. **08** repeats the figures of notebook 03 on the quality-controlled fluxes.
7. **09** repeats the figures of notebook 04 on the quality-controlled fluxes.
8. **SUPPL** supplements notebook 03 by reading the same merged table along the
   time lag instead of along time.

Notebooks 03 and 04 are the Level-1 (pre-quality-control) counterparts of 08 and
09. Reading and plotting are kept apart on the Level-1 side: 02 builds the merged
table, 03 and 04 only draw it. Numbers 06 and 07 are unused; they held earlier
figures that were removed when figure creation was consolidated.

## Reproducibility

The analysis runs in Jupyter notebooks (`notebooks/`) that use the
[`diive`](https://github.com/holukas/diive) eddy covariance toolkit. The
notebooks both run the processing and render into this site, so every figure
shown here comes from the code displayed alongside it.

Author: Lukas Hörtnagl, ETH Zürich (lukas.hoertnagl@usys.ethz.ch)
