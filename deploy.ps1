# Build the Quarto website and publish it to GitHub Pages (gh-pages branch).
#
# Prerequisites (one-time):
#   - uv sync  (installs the quarto-cli package, so `uv run quarto` works)
#   - GitHub repo -> Settings -> Pages -> Source: "Deploy from a branch"
#                  -> Branch: gh-pages  /  (root)  -> Save
#
# Then run this script from the repo root whenever you want to publish:
#   .\deploy.ps1
#
# Live site: https://holukas.github.io/ms-timelag-comparison/

$ErrorActionPreference = "Stop"

# UTF-8 keeps emoji in notebook output from crashing the default cp1252 console.
$env:PYTHONUTF8 = "1"
$env:PYTHONIOENCODING = "utf-8"

# 1. Render the static site into _site. execute.enabled is false in _quarto.yml,
#    so Quarto uses the outputs already committed in each .ipynb and never runs a
#    kernel. Quarto emits page-relative asset links, so no BASE_URL is needed.
uv run quarto render

# 2. Publish _site to the gh-pages branch (-n adds .nojekyll so GitHub Pages does
#    not strip the underscore-prefixed asset folders).
uv run ghp-import -n -p -f _site

Write-Host "`nPublished. Verify in a minute or two:" -ForegroundColor Green
Write-Host "  https://holukas.github.io/ms-timelag-comparison/"
