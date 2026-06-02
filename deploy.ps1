# Build the Jupyter Book and publish it to GitHub Pages (gh-pages branch).
#
# One-time setup (only needed once, in the browser):
#   GitHub repo -> Settings -> Pages -> Source: "Deploy from a branch"
#                  -> Branch: gh-pages  /  (root)  -> Save
#
# Then run this script from the repo root whenever you want to publish:
#   .\deploy.ps1
#
# Live site: https://holukas.github.io/ms-timelag-comparison/

$ErrorActionPreference = "Stop"

# Windows needs UTF-8 (avoids cp1252 crash on emoji output) and the private
# Node install flag for Jupyter Book 2's MyST engine. BASE_URL must match the
# Pages sub-path or CSS/JS will 404 and the site renders unstyled.
$env:JB_ALLOW_NODEENV = "1"
$env:PYTHONUTF8 = "1"
$env:PYTHONIOENCODING = "utf-8"
$env:BASE_URL = "/ms-timelag-comparison"

# 1. Clean previous build (JB2 has no clean subcommand; just remove the dir).
Remove-Item -Recurse -Force _build -ErrorAction SilentlyContinue

# 2. Build the static HTML site into _build/html.
uv run jupyter book build --html

# 3. Publish _build/html to the gh-pages branch (-n adds .nojekyll so GitHub
#    Pages does not strip the underscore-prefixed asset folders).
uv run ghp-import -n -p -f _build/html

Write-Host "`nPublished. Verify in a minute or two:" -ForegroundColor Green
Write-Host "  https://holukas.github.io/ms-timelag-comparison/"
