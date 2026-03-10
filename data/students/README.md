# Student Data Guide

Maintain these files as the canonical award record. The newsletters are source material, not the primary editing surface.

## Rules

- Keep each file sorted by surname.
- Keep students in the correct file bucket: `a-f`, `g-l`, `m-r`, or `s-z`.
- Prefer concise bullets in the form `Award Name (year)`.
- Keep source provenance out of the visible award text unless it changes the meaning of the award.
- Record newsletter provenance in `source-index.md`.
- Use official award names consistently across the data.

## Canonical Names

- `Carl \& Brynn Anderson Graduate Student Award Fund in Physics`
- `Carl \& Brynn Anderson Travel Award`
- `Newell S.\ Gingrich Physics \& Astronomy Endowment`
- `Ron Boain \& Catherine Rangel-Boain Dissertation Award`
- `Ron Boain \& Catherine Rangel-Boain Travel Award`

## Workflow

1. Update the matching student entry.
2. Run `powershell -ExecutionPolicy Bypass -File scripts/audit_student_data.ps1`.
3. If newsletter sourcing changed, regenerate `source-index.md`.
4. Rebuild with `latexmk -pdf main.tex` or run `pdflatex` twice.
