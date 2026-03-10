$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$studentFiles = @(
  "data/students/a-f.tex",
  "data/students/g-l.tex",
  "data/students/m-r.tex",
  "data/students/s-z.tex"
)

function Get-Variants([string]$displayName) {
  $parts = $displayName.Split(",", 2)
  $surnameRaw = $parts[0].Trim()
  $givenRaw = if ($parts.Count -gt 1) { $parts[1].Trim() } else { "" }

  $surnameAliases = [System.Collections.Generic.List[string]]::new()
  $givenAliases = [System.Collections.Generic.List[string]]::new()

  $surnameMain = ($surnameRaw -replace "\s*\(.*?\)", "").Trim()
  $givenMain = ($givenRaw -replace "\s*\(.*?\)", "").Trim()

  if ($surnameMain) { $surnameAliases.Add($surnameMain) }
  if ($givenMain) { $givenAliases.Add($givenMain) }

  foreach ($match in [regex]::Matches($surnameRaw, '\((.*?)\)')) {
    $alias = $match.Groups[1].Value.Trim()
    if ($alias) { $surnameAliases.Add($alias) }
  }

  foreach ($match in [regex]::Matches($givenRaw, '\((.*?)\)')) {
    $alias = $match.Groups[1].Value.Trim()
    if ($alias -and $alias -notmatch '^misattributed') {
      $givenAliases.Add($alias)
    }
    if ($alias -match 'misattributed as ([A-Za-z]+)') {
      $givenAliases.Add($Matches[1])
    }
  }

  switch ($displayName) {
    "Abhijeet, Abbi" { $givenAliases.Add("Abhi") }
    "Kuhn, Vicki (listed as Vicky Kuhn in DAP 2024)" { $givenAliases.Add("Vicky") }
    "Leslie (Miles), John" { $surnameAliases.Add("Miles") }
  }

  $variants = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
  foreach ($given in $givenAliases) {
    foreach ($surname in $surnameAliases) {
      $forward = (($given + " " + $surname).ToLower() -replace '[^a-z0-9]+', ' ').Trim()
      $reverse = (($surname + " " + $given).ToLower() -replace '[^a-z0-9]+', ' ').Trim()
      if ($forward) { $variants.Add($forward) | Out-Null }
      if ($reverse) { $variants.Add($reverse) | Out-Null }
    }
  }

  return @($variants)
}

function Get-EntryBlocks([string]$filePath) {
  $lines = Get-Content $filePath
  $blocks = [System.Collections.Generic.List[string]]::new()
  $current = [System.Collections.Generic.List[string]]::new()

  foreach ($line in $lines) {
    if ($line -match '^\\studententry\{' -and $current.Count -gt 0) {
      $blocks.Add(($current -join "`n").Trim())
      $current = [System.Collections.Generic.List[string]]::new()
    }
    $current.Add($line)
  }

  if ($current.Count -gt 0) {
    $blocks.Add(($current -join "`n").Trim())
  }

  foreach ($block in $blocks) {
    if ($block -match '^\\studententry\{[^}]+\}\{([^}]+)\}') {
      [PSCustomObject]@{
        Display = $Matches[1].Trim()
        Body = $block
      }
    }
  }
}

Push-Location $repoRoot

try {
  $issueTexts = Get-ChildItem tmp_DAP_*.txt -ErrorAction SilentlyContinue | Sort-Object Name | ForEach-Object {
    [PSCustomObject]@{
      Issue = ($_.BaseName -replace '^tmp_DAP_', 'DAP ')
      Text = ((Get-Content $_.FullName -Raw).ToLower() -replace '[^a-z0-9]+', ' ')
    }
  }

  $entries = foreach ($file in $studentFiles) {
    Get-EntryBlocks $file
  }

  Write-Output "# Source Index"
  Write-Output ""
  Write-Output "Student | Newsletter Issues"
  Write-Output "--- | ---"

  foreach ($entry in ($entries | Sort-Object Display)) {
    $issues = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)

    foreach ($yearMatch in [regex]::Matches($entry.Body, '20(19|20|21|22|23|24|25)')) {
      $year = [int]$yearMatch.Value
      if ($year -eq 2019) {
        $issues.Add("DAP 2020") | Out-Null
      }
      elseif ($year -ge 2020 -and $year -le 2025) {
        $issues.Add("DAP $year") | Out-Null
      }
    }

    $variants = Get-Variants $entry.Display
    foreach ($issue in $issueTexts) {
      foreach ($variant in $variants) {
        if ($issue.Text.Contains($variant)) {
          $issues.Add($issue.Issue) | Out-Null
          break
        }
      }
    }

    $sortedIssues = @($issues) | Sort-Object
    $displayIssues = if ($sortedIssues.Count -gt 0) {
      $sortedIssues -join ", "
    }
    else {
      "Needs manual verification"
    }

    Write-Output "$($entry.Display) | $displayIssues"
  }
}
finally {
  Pop-Location
}
