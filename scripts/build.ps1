$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
Push-Location $repoRoot

try {
  & powershell -ExecutionPolicy Bypass -File (Join-Path $PSScriptRoot "generate-document-derivatives.ps1")
  if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
  }

  if ((Get-Command latexmk -ErrorAction SilentlyContinue) -and (Get-Command perl -ErrorAction SilentlyContinue)) {
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
