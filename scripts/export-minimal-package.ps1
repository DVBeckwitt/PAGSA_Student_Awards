$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$releaseRoot = Join-Path $repoRoot "release"
$packageName = "PAGSA_Student_Awards_minimal_package"
$stagingDir = Join-Path $releaseRoot $packageName
$zipPath = Join-Path $releaseRoot ($packageName + ".zip")

function Copy-FileSet {
  param(
    [Parameter(Mandatory = $true)]
    [string]$DestinationRoot,

    [Parameter(Mandatory = $true)]
    [string[]]$RelativePaths
  )

  foreach ($relativePath in $RelativePaths) {
    $sourcePath = Join-Path $repoRoot $relativePath
    if (-not (Test-Path $sourcePath)) {
      throw "Required path not found: $relativePath"
    }

    $destinationPath = Join-Path $DestinationRoot $relativePath
    $destinationDir = Split-Path -Parent $destinationPath
    if (-not (Test-Path $destinationDir)) {
      New-Item -ItemType Directory -Path $destinationDir -Force | Out-Null
    }

    Copy-Item -Path $sourcePath -Destination $destinationPath -Force
  }
}

function Get-RepoRelativePath {
  param(
    [Parameter(Mandatory = $true)]
    [string]$FullPath
  )

  $relativePath = [string](Resolve-Path -Relative $FullPath)
  if ($relativePath.StartsWith(".\")) {
    return $relativePath.Substring(2)
  }

  return $relativePath
}

Push-Location $repoRoot

try {
  if (-not (Test-Path $releaseRoot)) {
    New-Item -ItemType Directory -Path $releaseRoot -Force | Out-Null
  }

  if (Test-Path $stagingDir) {
    Remove-Item -Path $stagingDir -Recurse -Force
  }

  if (Test-Path $zipPath) {
    Remove-Item -Path $zipPath -Force
  }

  New-Item -ItemType Directory -Path $stagingDir -Force | Out-Null

  Copy-FileSet -DestinationRoot $stagingDir -RelativePaths @(
    "main.tex"
  )

  $texFiles = Get-ChildItem -Path (Join-Path $repoRoot "tex") -File -Filter *.tex -Recurse |
    Sort-Object FullName |
    ForEach-Object { Get-RepoRelativePath -FullPath $_.FullName }

  if (-not $texFiles) {
    throw "No LaTeX files were found under tex/."
  }

  Copy-FileSet -DestinationRoot $stagingDir -RelativePaths $texFiles

  $dataFiles = Get-ChildItem -Path (Join-Path $repoRoot "data\\students") -File |
    Where-Object { $_.Extension -eq ".tex" -or $_.Name -eq "source-index.md" } |
    Sort-Object FullName |
    ForEach-Object { Get-RepoRelativePath -FullPath $_.FullName }

  if (-not $dataFiles) {
    throw "No data files were found under data/students/."
  }

  Copy-FileSet -DestinationRoot $stagingDir -RelativePaths $dataFiles

  $newsletterPdfs = Get-ChildItem -Path (Join-Path $repoRoot "newsletters") -File -Filter "DAP *.pdf" |
    Sort-Object Name |
    ForEach-Object { Get-RepoRelativePath -FullPath $_.FullName }

  if (-not $newsletterPdfs) {
    throw "No DAP PDF files were found under newsletters/."
  }

  Copy-FileSet -DestinationRoot $stagingDir -RelativePaths $newsletterPdfs

  Compress-Archive -Path $stagingDir -DestinationPath $zipPath -CompressionLevel Optimal

  Write-Output $stagingDir
  Write-Output $zipPath
}
finally {
  Pop-Location
}
