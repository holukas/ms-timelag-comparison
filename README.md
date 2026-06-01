# ms-timelag-comparison

Analysis and documentation for a scientific manuscript on the **impact of
different time-lag settings on eddy covariance fluxes of N₂O and CH₄**.

The processing is carried out in Jupyter notebooks that consume the
[`diive`](../../diive) eddy covariance toolkit, and is published as a
[Jupyter Book](https://jupyterbook.org/) reproducibility website.

## Repository layout

```
notebooks/   executable notebooks — run the processing and render into the book
docs/        prose-only book pages (intro, methods) + references.bib
data/        datasets (gitignored)
  raw/         untouched inputs
  interim/     merged / cleaned intermediates
  processed/   analysis-ready
figures/     exported figures
tables/       exported tables
myst.yml     Jupyter Book config + table of contents
```

## Setup

This project uses [uv](https://docs.astral.sh/uv/) for environment management.

```bash
uv sync
```

`diive` is installed as an editable local dependency (see `pyproject.toml`).

## Usage

Run the analysis notebooks:

```bash
uv run jupyter lab
```

Build the documentation book:

```bash
uv run jupyter book build .
```

The notebooks run the processing pipeline (merge → clean → plots) and, once
built, render into the published reproducibility website together with the
prose pages in `docs/`.

## Author

Lukas Hörtnagl — ETH Zürich (lukas.hoertnagl@usys.ethz.ch)

## License

See [LICENSE](LICENSE).
