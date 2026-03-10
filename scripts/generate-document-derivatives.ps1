$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$studentFiles = @(
  "data/students/a-f.tex",
  "data/students/g-l.tex",
  "data/students/m-r.tex",
  "data/students/s-z.tex"
)
$generatedStudentsPath = Join-Path $repoRoot "tex/generated-students.tex"
$reverseIndexPath = Join-Path $repoRoot "tex/reverse-index.tex"

$categoryLabels = [ordered]@{
  funding = "Scholarships, Fellowships, and Endowments"
  department = "Department Awards"
  honors = "Research, Presentation, and Professional Honors"
  other = "Service, Leadership, and Other Recognition"
}

$titleCatalog = @(
  [PSCustomObject]@{ Variant = "Armstrong Physics Endowment"; Title = "Armstrong Physics Endowment"; Category = "funding" }
  [PSCustomObject]@{ Variant = "B.\,H.\ Rose Endowment Fund"; Title = "B.\,H.\ Rose Endowment Fund"; Category = "funding" }
  [PSCustomObject]@{ Variant = "Carl \& Brynn Anderson Graduate Student Award Fund in Physics"; Title = "Carl \& Brynn Anderson Graduate Student Award Fund in Physics"; Category = "funding" }
  [PSCustomObject]@{ Variant = "Clifford W.\ Tompson Scholarship in Physics"; Title = "Clifford W.\ Tompson Scholarship in Physics"; Category = "funding" }
  [PSCustomObject]@{ Variant = "Eli Stuart Haynes \& Nola Anderson Haynes Scholarship"; Title = "Eli Stuart Haynes \& Nola Anderson Haynes Scholarship"; Category = "funding" }
  [PSCustomObject]@{ Variant = "Eli Stuart Haynes \& Nola Anderson Haynes Scholarship Fund"; Title = "Eli Stuart Haynes \& Nola Anderson Haynes Scholarship"; Category = "funding" }
  [PSCustomObject]@{ Variant = "Ernest W.\ Landen Fellowship in Physics"; Title = "Ernest W.\ Landen Fellowship in Physics"; Category = "funding" }
  [PSCustomObject]@{ Variant = "Eugene B.\ Hensley Scholarship in Physics"; Title = "Eugene B.\ Hensley Scholarship in Physics"; Category = "funding" }
  [PSCustomObject]@{ Variant = "Guy Schupp Scholarship Fund"; Title = "Guy Schupp Scholarship Fund"; Category = "funding" }
  [PSCustomObject]@{ Variant = "H.\ Phillip Graduate Fellowship"; Title = "H.\ Phillip Graduate Fellowship"; Category = "funding" }
  [PSCustomObject]@{ Variant = "Henry Mitchell Scholarship"; Title = "Henry Mitchell Scholarship"; Category = "funding" }
  [PSCustomObject]@{ Variant = "Horace (Dan) R.\ Danner Fellowship"; Title = "Horace (Dan) R.\ Danner Fellowship"; Category = "funding" }
  [PSCustomObject]@{ Variant = "James L.\ and Dora D.\ Fergason Fund for Excellence in Physics"; Title = "James L.\ and Dora D.\ Fergason Fund for Excellence in Physics"; Category = "funding" }
  [PSCustomObject]@{ Variant = "John H.\ Letcher Graduate Student Scholarship"; Title = "John H.\ Letcher Graduate Student Scholarship"; Category = "funding" }
  [PSCustomObject]@{ Variant = "Newell S.\ Gingrich Physics Scholarship Fund"; Title = "Newell S.\ Gingrich Physics Scholarship Fund"; Category = "funding" }
  [PSCustomObject]@{ Variant = "Newell S.\ Gingrich Physics \& Astronomy Endowment"; Title = "Newell S.\ Gingrich Physics \& Astronomy Endowment"; Category = "funding" }
  [PSCustomObject]@{ Variant = "O.\,M.\ Stewart Scholarship"; Title = "O.\,M.\ Stewart Scholarship"; Category = "funding" }
  [PSCustomObject]@{ Variant = "Paul E.\ Basye Undergraduate Scholarship"; Title = "Paul E.\ Basye Undergraduate Scholarship"; Category = "funding" }
  [PSCustomObject]@{ Variant = "Rose Marie Dishman Endowed Scholarship in Physics"; Title = "Rose Marie Dishman Endowed Scholarship in Physics"; Category = "funding" }
  [PSCustomObject]@{ Variant = "Samuel S.\ Laws Scholarship"; Title = "Samuel S.\ Laws Scholarship"; Category = "funding" }
  [PSCustomObject]@{ Variant = "William E.\ Spicer Fund for the Development of Excellence in Physics"; Title = "William E.\ Spicer Fund for the Development of Excellence in Physics"; Category = "funding" }

  [PSCustomObject]@{ Variant = "Carl \& Brynn Anderson Travel Award"; Title = "Carl \& Brynn Anderson Travel Award"; Category = "department" }
  [PSCustomObject]@{ Variant = "Gerald Fishman Travel Award"; Title = "Gerald Fishman Travel Award"; Category = "department" }
  [PSCustomObject]@{ Variant = "Harry E.\ Hammond Teaching Assistant Award"; Title = "Harry E.\ Hammond Teaching Assistant Award"; Category = "department" }
  [PSCustomObject]@{ Variant = "Ron Boain \& Catherine Rangel-Boain Travel Award"; Title = "Ron Boain \& Catherine Rangel-Boain Travel Award"; Category = "department" }
  [PSCustomObject]@{ Variant = "Ron Boain \& Catherine Rangel-Boain Dissertation Award"; Title = "Ron Boain \& Catherine Rangel-Boain Dissertation Award"; Category = "department" }
  [PSCustomObject]@{ Variant = "Inaugural Dorina Kosztin Memorial Award"; Title = "Dorina Kosztin Memorial Award"; Category = "department" }

  [PSCustomObject]@{ Variant = "American Astronomical Society FAMOUS Travel Grant"; Title = "American Astronomical Society FAMOUS Travel Grant"; Category = "honors" }
  [PSCustomObject]@{ Variant = "American Physical Society Division of Materials Physics Ovshinsky Travel Award"; Title = "APS Division of Materials Physics Ovshinsky Travel Award"; Category = "honors" }
  [PSCustomObject]@{ Variant = "Ovshinsky Student Travel Award (APS)"; Title = "APS Division of Materials Physics Ovshinsky Travel Award"; Category = "honors" }
  [PSCustomObject]@{ Variant = "DOE Office of Science Graduate Student Research (SCGSR) program"; Title = "DOE Office of Science Graduate Student Research (SCGSR) Program"; Category = "honors" }
  [PSCustomObject]@{ Variant = "Graduate Student Award for Research for James Webb Space Telescope spiral-galaxy work"; Title = "Graduate Student Award for Research for James Webb Space Telescope spiral-galaxy work"; Category = "honors" }
  [PSCustomObject]@{ Variant = "MU Graduate Professional Council Excellence in Research Award"; Title = "MU Graduate Professional Council Excellence in Research Award"; Category = "honors" }
  [PSCustomObject]@{ Variant = "MU Graduate School Professional Presentation Travel Award"; Title = "MU Graduate School Professional Presentation Travel Award"; Category = "honors" }
  [PSCustomObject]@{ Variant = "Travel award to present research at the 2024 Biophysical Society meeting"; Title = "Travel award to present research at the 2024 Biophysical Society meeting"; Category = "honors" }
  [PSCustomObject]@{ Variant = "University of Missouri Award for Academic Distinction"; Title = "University of Missouri Award for Academic Distinction"; Category = "honors" }
  [PSCustomObject]@{ Variant = "Chandrasekhar Fellow"; Title = "Chandrasekhar Fellow"; Category = "honors" }
  [PSCustomObject]@{ Variant = "Early-career microbiologist of the year"; Title = "Early-career microbiologist of the year"; Category = "honors" }
  [PSCustomObject]@{ Variant = "Accepted to present at an IBM Quantum Developer Conference"; Title = "Accepted to present at an IBM Quantum Developer Conference"; Category = "honors" }

  [PSCustomObject]@{ Variant = "Featured in DOE Basic Energy Sciences and Show Me Mizzou coverage for the NiSi magnetism discovery"; Title = "Featured in DOE Basic Energy Sciences and Show Me Mizzou coverage for the NiSi magnetism discovery"; Category = "other" }
  [PSCustomObject]@{ Variant = "Green Chalk Award"; Title = "Green Chalk Award"; Category = "other" }
  [PSCustomObject]@{ Variant = "IBM/Mizzou-QIC inaugural summer internship selection"; Title = "IBM/Mizzou-QIC inaugural summer internship selection"; Category = "other" }
  [PSCustomObject]@{ Variant = "Mary Elizabeth Gutermuth Award for Community Engagement"; Title = "Mary Elizabeth Gutermuth Award for Community Engagement"; Category = "other" }
  [PSCustomObject]@{ Variant = "Mizzou 18 Award"; Title = "Mizzou 18 Award"; Category = "other" }
  [PSCustomObject]@{ Variant = "Organizer, American Physical Society Conference for Undergraduate Women in Physics (CUWiP) at Missouri S\&T"; Title = "Organizer, American Physical Society Conference for Undergraduate Women in Physics (CUWiP) at Missouri S\&T"; Category = "other" }
  [PSCustomObject]@{ Variant = "Remington R.\ Williams Award"; Title = "Remington R.\ Williams Award"; Category = "other" }
  [PSCustomObject]@{ Variant = "Sandra K.\ Abell Science Education Award"; Title = "Sandra K.\ Abell Science Education Award"; Category = "other" }
  [PSCustomObject]@{ Variant = "Selected to represent Mizzou Graduate School at the AAAS CASE Workshop"; Title = "Selected to represent Mizzou Graduate School at the AAAS CASE Workshop"; Category = "other" }
  [PSCustomObject]@{ Variant = "Show Me Mizzou coverage for unusually luminous early-universe candidate galaxies; article ranked in the top 5\% of research outputs by Altmetric"; Title = "Show Me Mizzou coverage for unusually luminous early-universe candidate galaxies; article ranked in the top 5\% of research outputs by Altmetric"; Category = "other" }
  [PSCustomObject]@{ Variant = "Sigma Pi Sigma induction"; Title = "Sigma Pi Sigma induction"; Category = "other" }
  [PSCustomObject]@{ Variant = "Two significant JWST papers highlighted in department news"; Title = "Two significant JWST papers highlighted in department news"; Category = "other" }
  [PSCustomObject]@{ Variant = "ALMA Ambassador"; Title = "ALMA Ambassador"; Category = "other" }
) | Sort-Object { $_.Variant.Length } -Descending

function Unwrap-SimpleCommand([string]$text, [string]$command) {
  $pattern = '\\' + [regex]::Escape($command) + '\{([^{}]*)\}'
  while ($text -match $pattern) {
    $text = [regex]::Replace($text, $pattern, '$1')
  }
  return $text
}

function Get-CleanText([string]$text) {
  $text = Unwrap-SimpleCommand $text "textbf"
  $text = Unwrap-SimpleCommand $text "emph"
  $text = $text -replace '\\newline', ' '
  $text = $text -replace '\\textsuperscript\{nd\}', 'nd'
  $text = $text -replace '\s+', ' '
  return $text.Trim()
}

function Get-SortKey([string]$text) {
  $text = Get-CleanText $text
  $text = $text.ToLowerInvariant()
  $text = $text -replace '[^a-z0-9]+', ' '
  return $text.Trim()
}

function Normalize-Placement([string]$rank) {
  switch -Regex ($rank) {
    '^(1st|First)$' { return "First Place" }
    '^(2nd|Second)$' { return "Second Place" }
    '^(3rd|Third)$' { return "Third Place" }
    default { return $rank }
  }
}

function Clean-NoteText([string]$text) {
  $text = Get-CleanText $text
  while ($text.StartsWith("(") -and $text.EndsWith(")")) {
    $text = $text.Substring(1, $text.Length - 2).Trim()
  }
  return $text.Trim()
}

function New-Recognition(
  [string]$Category,
  [string]$Title,
  [string]$Detail,
  [string]$Note,
  [string]$Continuation,
  [string]$Source
) {
  $display = $Title
  $indexParts = [System.Collections.Generic.List[string]]::new()

  if ($Detail) {
    $display += " ($Detail)"
    $indexParts.Add($Detail) | Out-Null
  }

  if ($Note) {
    $display += " \emph{($Note)}"
    $indexParts.Add($Note) | Out-Null
  }

  if ($Continuation) {
    $display += " $Continuation"
  }

  if ($Source) {
    $display += " $Source"
  }

  [PSCustomObject]@{
    Category = $Category
    Title = $Title
    TitleSort = Get-SortKey $Title
    Display = $display
    IndexDetail = ($indexParts -join "; ")
  }
}

function Convert-CatalogMatch(
  [PSCustomObject]$CatalogEntry,
  [string]$Suffix,
  [string]$Continuation,
  [string]$Source
) {
  $detail = ""
  $noteParts = [System.Collections.Generic.List[string]]::new()

  if ($Suffix) {
    if ($Suffix -match '^\((?<detail>[^)]+)\)(?<tail>.*)$') {
      $detail = $matches['detail'].Trim()
      $tail = $matches['tail'].Trim()
    }
    else {
      $tail = $Suffix.Trim()
    }

    if ($detail -match '^(?<primary>[^;]+); (?<extra>.+)$') {
      $detail = $matches['primary'].Trim()
      $noteParts.Add($matches['extra'].Trim()) | Out-Null
    }

    $cleanTail = Clean-NoteText $tail
    if ($cleanTail) {
      $noteParts.Add($cleanTail) | Out-Null
    }
  }

  return New-Recognition `
    -Category $CatalogEntry.Category `
    -Title $CatalogEntry.Title `
    -Detail $detail `
    -Note ($noteParts -join "; ") `
    -Continuation $Continuation `
    -Source $Source
}

function Get-StudentEntries([string]$filePath) {
  $lines = Get-Content $filePath
  $entries = [System.Collections.Generic.List[object]]::new()

  for ($i = 0; $i -lt $lines.Count; $i++) {
    $line = $lines[$i].Trim()
    if ($line -match '^\\studententry\{([^}]+)\}\{([^}]+)\}\{$') {
      $label = $matches[1]
      $displayName = $matches[2]
      $items = [System.Collections.Generic.List[string]]::new()
      $currentItem = $null

      for ($i = $i + 1; $i -lt $lines.Count; $i++) {
        $inner = $lines[$i].TrimEnd()
        if ($inner -match '^\s*\\item\s+(.*)$') {
          if ($currentItem) {
            $items.Add($currentItem.Trim()) | Out-Null
          }
          $currentItem = $matches[1]
          continue
        }

        if ($currentItem -and $inner -match '^\s*\\end\{itemize\}\s*$') {
          $items.Add($currentItem.Trim()) | Out-Null
          $currentItem = $null
          continue
        }

        if ($currentItem) {
          $currentItem += " " + $inner.Trim()
          continue
        }

        if ($inner -match '^\s*\}\s*$') {
          break
        }
      }

      $entries.Add([PSCustomObject]@{
        Label = $label
        DisplayName = $displayName
        Items = @($items)
      }) | Out-Null
    }
  }

  return @($entries)
}

function Normalize-RecognitionItem([string]$rawItem) {
  $sources = [regex]::Matches($rawItem, '\\awardsource\{[^}]+\}') | ForEach-Object { $_.Value }
  $sourceSuffix = if ($sources.Count -gt 0) { $sources -join " " } else { "" }
  $core = [regex]::Replace($rawItem, '\s*\\awardsource\{[^}]+\}\s*', ' ').Trim()
  $segments = $core -split '\\newline', 2
  $baseRaw = $segments[0].Trim()
  $continuation = if ($segments.Count -gt 1) { '\newline' + $segments[1].Trim() } else { "" }
  if ($continuation -match '^\\newline\((\\emph\{.*\})\)$') {
    $continuation = '\newline ' + $matches[1]
  }
  if ($continuation -match '^\\newline(\\emph\{.*\})$') {
    $continuation = '\newline ' + $matches[1]
  }
  $cleanBase = Get-CleanText $baseRaw

  if ($cleanBase -match '^(?<rank>1st|2nd|3rd|First|Second|Third) Place(?: \((?<qualifier>tie|Grad)\))? -- (?<year>\d{4}/\d{4}|\d{4}) Physics Leaders Meeting(?: \(Grad Presentation\))?$') {
    $placement = Normalize-Placement $matches['rank']
    $detail = if ($matches['qualifier'] -eq 'tie') { "$placement, tie, $($matches['year'])" } else { "$placement, $($matches['year'])" }
    return New-Recognition "honors" "Physics Leaders Meeting Graduate Presentation Award" $detail "" $continuation $sourceSuffix
  }

  if ($cleanBase -match '^Graduate Student Presentation Award \((?<year>\d{4}/\d{4}) Physics Leaders Meeting\)$') {
    return New-Recognition "honors" "Physics Leaders Meeting Graduate Presentation Award" $matches['year'] "" $continuation $sourceSuffix
  }

  if ($cleanBase -match '^2022 Physics Leaders'' Award for Outstanding Student Presentation$') {
    return New-Recognition "honors" "Physics Leaders Meeting Graduate Presentation Award" "Outstanding Student Presentation, 2022" "" $continuation $sourceSuffix
  }

  if ($cleanBase -match '^(?<rank>1st|2nd|3rd|First|Second|Third) Place -- Show Me Research Week, Physical and Mathematical Sciences Division \((?<year>\d{4})\)$') {
    $detail = "$(Normalize-Placement $matches['rank']), $($matches['year'])"
    return New-Recognition "honors" "Show Me Research Week, Physical and Mathematical Sciences Division" $detail "" $continuation $sourceSuffix
  }

  if ($cleanBase -match '^(?<rank>\d+(?:nd|rd)) place in the .*MU Research \\& Creative Activities Forum \((?<detail>[^)]+)\)$') {
    $placement = switch ($matches['rank']) {
      '2nd' { 'Second Place' }
      '3rd' { 'Third Place' }
      default { "$($matches['rank']) Place" }
    }
    $detail = "$placement, $($matches['detail'])"
    return New-Recognition "honors" "MU Research \& Creative Activities Forum" $detail "" $continuation $sourceSuffix
  }

  if ($cleanBase -match '^(?<rank>1st|2nd|3rd|First|Second|Third) Place -- (?<title>.*Boain.*Dissertation Award) \((?<term>[^)]+)\)$') {
    $detail = "$(Normalize-Placement $matches['rank']), $($matches['term'])"
    return New-Recognition "department" "Ron Boain \& Catherine Rangel-Boain Dissertation Award" $detail "" $continuation $sourceSuffix
  }

  if ($cleanBase -match '^Second Place -- Ron Boain \& Catherine Rangel-Boain Dissertation Award \((?<term>[^)]+)\)$') {
    return New-Recognition "department" "Ron Boain \& Catherine Rangel-Boain Dissertation Award" "Second Place, $($matches['term'])" "" $continuation $sourceSuffix
  }

  if ($cleanBase -match '^AAS Chambliss Astronomy Achievement Award \((?<year>\d{4})\)$') {
    return New-Recognition "honors" "AAS Chambliss Astronomy Achievement Award" $matches['year'] "" $continuation $sourceSuffix
  }

  if ($cleanBase -match '^Chambliss Astronomy Achievement Student Award \(AAS\) \((?<year>\d{4})\)$') {
    return New-Recognition "honors" "AAS Chambliss Astronomy Achievement Award" $matches['year'] "" $continuation $sourceSuffix
  }

  if ($cleanBase -match '^Chambliss Astronomy Achievement Student Award -- Honorable Mention \((?<year>\d{4})\)$') {
    return New-Recognition "honors" "AAS Chambliss Astronomy Achievement Award" "Honorable Mention, $($matches['year'])" "" $continuation $sourceSuffix
  }

  if ($cleanBase -match '^Student Presentation (?:Prize )?Award -- APS Prairie Section Fall 2023 Meeting$') {
    return New-Recognition "honors" "APS Prairie Section Fall 2023 Meeting Student Presentation Award" "" "" $continuation $sourceSuffix
  }

  if ($cleanBase -match '^(?<year>\d{4}) Outstanding Graduate Student Research \((?<context>[^)]+)\)$') {
    return New-Recognition "honors" "Outstanding Graduate Student Research" "$($matches['context']), $($matches['year'])" "" $continuation $sourceSuffix
  }

  if ($cleanBase -match '^2020 AAS Astronomy Ambassador$') {
    return New-Recognition "other" "AAS Astronomy Ambassador" "2020" "" $continuation $sourceSuffix
  }

  if ($cleanBase -match '^Tapped into Rollins Society Class of (?<year>\d{4})$') {
    return New-Recognition "other" "Rollins Society" "Class of $($matches['year'])" "" $continuation $sourceSuffix
  }

  foreach ($catalogEntry in $titleCatalog) {
    if ($cleanBase -eq $catalogEntry.Variant) {
      return Convert-CatalogMatch $catalogEntry "" $continuation $sourceSuffix
    }

    if ($cleanBase.StartsWith($catalogEntry.Variant + " ")) {
      $suffix = $cleanBase.Substring($catalogEntry.Variant.Length).Trim()
      return Convert-CatalogMatch $catalogEntry $suffix $continuation $sourceSuffix
    }
  }

  throw "Unrecognized item: $rawItem"
}

function Write-GeneratedStudentSections([object[]]$studentEntries) {
  $lines = [System.Collections.Generic.List[string]]::new()
  $lines.Add("% Auto-generated by scripts/generate-document-derivatives.ps1. Do not edit by hand.") | Out-Null
  $lines.Add("") | Out-Null

  foreach ($entry in $studentEntries) {
    $byCategory = [ordered]@{
      funding = [System.Collections.Generic.List[string]]::new()
      department = [System.Collections.Generic.List[string]]::new()
      honors = [System.Collections.Generic.List[string]]::new()
      other = [System.Collections.Generic.List[string]]::new()
    }

    foreach ($item in $entry.NormalizedItems) {
      $byCategory[$item.Category].Add($item.Display) | Out-Null
    }

    $lines.Add("\studententry{$($entry.Label)}{$($entry.DisplayName)}{") | Out-Null

    $writtenCategory = $false
    foreach ($categoryKey in $categoryLabels.Keys) {
      $items = @($byCategory[$categoryKey])
      if ($items.Count -eq 0) {
        continue
      }

      if ($writtenCategory) {
        $lines.Add("") | Out-Null
        $lines.Add("\medskip") | Out-Null
      }

      $lines.Add("\noindent\textbf{$($categoryLabels[$categoryKey])}") | Out-Null
      $lines.Add("\begin{itemize}") | Out-Null
      foreach ($display in $items) {
        $lines.Add("  \item $display") | Out-Null
      }
      $lines.Add("\end{itemize}") | Out-Null
      $writtenCategory = $true
    }

    $lines.Add("}") | Out-Null
    $lines.Add("") | Out-Null
  }

  Set-Content -Path $generatedStudentsPath -Value $lines
}

function Write-ReverseIndex([object[]]$studentEntries) {
  $lines = [System.Collections.Generic.List[string]]::new()
  $lines.Add("% Auto-generated by scripts/generate-document-derivatives.ps1. Do not edit by hand.") | Out-Null
  $lines.Add("\pagebreak") | Out-Null
  $lines.Add("\section*{Reverse Index by Recognition}") | Out-Null
  $lines.Add("") | Out-Null
  $lines.Add("{\footnotesize") | Out-Null
  $lines.Add("\raggedright") | Out-Null
  $lines.Add("\noindent") | Out-Null
  $lines.Add("\emph{Entries are grouped by recognition type. Student links jump to the alphabetical record, and each page reference points to that student's section.}") | Out-Null
  $lines.Add("") | Out-Null

  $recognitions = foreach ($entry in $studentEntries) {
    foreach ($item in $entry.NormalizedItems) {
      [PSCustomObject]@{
        Category = $item.Category
        CategoryLabel = $categoryLabels[$item.Category]
        Title = $item.Title
        TitleSort = $item.TitleSort
        StudentLabel = $entry.Label
        StudentName = $entry.DisplayName
        Detail = $item.IndexDetail
      }
    }
  }

  foreach ($categoryKey in $categoryLabels.Keys) {
    $categoryItems = $recognitions | Where-Object { $_.Category -eq $categoryKey }
    if (-not $categoryItems) {
      continue
    }

    if ($lines.Count -gt 6) {
      $lines.Add("") | Out-Null
      $lines.Add("\medskip") | Out-Null
    }

    $lines.Add("\noindent\textbf{$($categoryLabels[$categoryKey])}") | Out-Null
    $lines.Add("\begin{itemize}") | Out-Null

    $titles = $categoryItems |
      Sort-Object TitleSort, Title |
      Group-Object Title

    foreach ($titleGroup in $titles) {
      $title = $titleGroup.Name
      $entries = $titleGroup.Group |
        Group-Object StudentLabel |
        Sort-Object { Get-SortKey $_.Group[0].StudentName } |
        ForEach-Object {
          $details = $_.Group.Detail | Where-Object { $_ } | Select-Object -Unique
          $entryText = "\hyperref[$($_.Group[0].StudentLabel)]{$($_.Group[0].StudentName)} (p.~\pageref{$($_.Group[0].StudentLabel)}"
          if ($details.Count -gt 0) {
            $entryText += "; " + ($details -join "; ")
          }
          $entryText += ")"
          $entryText
        }

      $lines.Add("  \item \textbf{$title}: " + ($entries -join "; ")) | Out-Null
    }

    $lines.Add("\end{itemize}") | Out-Null
  }

  $lines.Add("}") | Out-Null

  Set-Content -Path $reverseIndexPath -Value $lines
}

Push-Location $repoRoot

try {
  $studentEntries = foreach ($file in $studentFiles) {
    Get-StudentEntries $file
  }

  foreach ($entry in $studentEntries) {
    $normalizedItems = foreach ($item in $entry.Items) {
      Normalize-RecognitionItem $item
    }

    $entry | Add-Member -NotePropertyName NormalizedItems -NotePropertyValue @($normalizedItems)
  }

  Write-GeneratedStudentSections $studentEntries
  Write-ReverseIndex $studentEntries

  Write-Output "Generated tex/generated-students.tex and tex/reverse-index.tex."
}
finally {
  Pop-Location
}
