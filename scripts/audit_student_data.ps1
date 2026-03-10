$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$studentFiles = @(
  @{ Path = "data/students/a-f.tex"; Start = "A"; End = "F" }
  @{ Path = "data/students/g-l.tex"; Start = "G"; End = "L" }
  @{ Path = "data/students/m-r.tex"; Start = "M"; End = "R" }
  @{ Path = "data/students/s-z.tex"; Start = "S"; End = "Z" }
)
$legacyPatterns = @(
  "listing",
  "listings",
  "references",
  "multiple years"
)

function Get-SortKey([string]$displayName) {
  return (($displayName -replace "[()]", "") -replace "\s+", " ").Trim().ToLower()
}

function Get-Surname([string]$displayName) {
  return ($displayName.Split(",", 2)[0] -replace "\s*\(.*?\)", "").Trim()
}

function Get-EntryNames([string]$filePath) {
  Select-String -Path $filePath -Pattern '^\\studententry\{[^}]+\}\{([^}]+)\}' | ForEach-Object {
    [PSCustomObject]@{
      Line = $_.LineNumber
      Name = $_.Matches[0].Groups[1].Value.Trim()
    }
  }
}

$issues = [System.Collections.Generic.List[string]]::new()

Push-Location $repoRoot

try {
  $conflicts = rg -n '^(<<<<<<<|=======|>>>>>>>)' README.md tex data newsletters scripts
  if ($LASTEXITCODE -eq 0 -and $conflicts) {
    $conflicts | ForEach-Object { $issues.Add("Merge conflict marker: $_") }
  }

  foreach ($file in $studentFiles) {
    $entries = @(Get-EntryNames $file.Path)
    $previous = $null

    foreach ($entry in $entries) {
      $surname = Get-Surname $entry.Name
      $initial = $surname.Substring(0, 1).ToUpper()
      if ($initial -lt $file.Start -or $initial -gt $file.End) {
        $issues.Add("$($file.Path):$($entry.Line) surname '$surname' is outside the $($file.Start)-$($file.End) bucket.")
      }

      if ($previous -and (Get-SortKey $entry.Name) -lt (Get-SortKey $previous.Name)) {
        $issues.Add("$($file.Path):$($entry.Line) '$($entry.Name)' should sort before '$($previous.Name)'.")
      }

      $previous = $entry
    }
  }

  foreach ($pattern in $legacyPatterns) {
    $matches = rg -n --fixed-strings $pattern data/students
    if ($LASTEXITCODE -eq 0 -and $matches) {
      $matches | ForEach-Object { $issues.Add("Legacy wording '$pattern': $_") }
    }
  }

  $sourcesPath = Join-Path $repoRoot "data/students/source-index.md"
  if (Test-Path $sourcesPath) {
    $sourceIndex = Get-Content $sourcesPath -Raw
    foreach ($file in $studentFiles) {
      foreach ($entry in Get-EntryNames $file.Path) {
        if ($sourceIndex -notmatch [regex]::Escape($entry.Name)) {
          $issues.Add("Missing source-index entry for '$($entry.Name)'.")
        }
      }
    }
  }

  if ($issues.Count -gt 0) {
    $issues | ForEach-Object { Write-Output $_ }
    exit 1
  }

  Write-Output "Student data audit passed."
}
finally {
  Pop-Location
}
