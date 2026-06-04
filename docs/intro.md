# Introduction

This book documents the analysis for the manuscript on the impact of different
time-lag settings on eddy covariance fluxes of N₂O and CH₄.

In eddy covariance, the time lag between the vertical wind measured by the sonic
anemometer and the gas signal from the analyzer must be determined before fluxes
can be computed. How that lag is found can change the resulting flux: a wide
covariance-maximization search, a search with a default fallback, a fixed
constant lag, and an external detection method do not all give the same answer.
This study quantifies that effect by computing the fluxes several times from the
same raw data, varying only the time-lag setting, and comparing the results.

Two measurement campaigns at the CH-CHA grassland site are covered, distinguished
by the gas analyzer:

- QCL (quantum cascade laser), campaign 2021_1
- LGR (Los Gatos Research analyzer), campaign 2021_2

## How to read this book

- [Processing versions](processing-versions.md) is the explicit, auditable
  registry of the time-lag settings being compared (the study variable).
- [Processing steps](processing-steps.md) describes the PWB lag detection and
  removal workflow used for the additional variant.
- [Data](data.md) covers the datasets and how the `data/` folder is organized by
  processing stage.
- [Building the book](building-the-book.md) explains how to build and publish
  this site.

## Reproducibility

The analysis runs in Jupyter notebooks (`notebooks/`) that use the
[`diive`](https://github.com/holukas/diive) eddy covariance toolkit. The
notebooks both run the processing (read EddyPro output, subset, merge, plot) and
render into this book, so the figures and tables you see are produced by the code
shown alongside them.

Author: Lukas Hörtnagl, ETH Zürich (lukas.hoertnagl@usys.ethz.ch)
