$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
Push-Location $repoRoot

try {
  if (Get-Command latexmk -ErrorAction SilentlyContinue) {
    & latexmk -pdf -interaction=nonstopmode -halt-on-error main.tex
    if ($LASTEXITCODE -eq 0) {
      exit 0
    }
  }

  & pdflatex -interaction=nonstopmode -halt-on-error main.tex
  if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
  }

  & pdflatex -interaction=nonstopmode -halt-on-error main.tex
  exit $LASTEXITCODE
}
finally {
  Pop-Location
}
