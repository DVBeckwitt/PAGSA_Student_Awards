# Student Awards and Recognitions

This repository tracks a LaTeX document of Physics and Astronomy student awards and recognitions at Mizzou, compiled from department newsletters and related department coverage from roughly 2019 through the 2025 newsletter cycle.

The authoritative data lives in `data/students/`. Newsletter PDFs in `newsletters/` are reference material for verification and provenance. The rendered output is tracked as `PAGSA_Student_Awards.pdf`.

## Overview

- Edit student records in `data/students/*.tex`.
- Generate derived LaTeX files with the scripts in `scripts/`.
- Build the final PDF from `main.tex`.
- Use `newsletters/` to verify entries and regenerate provenance data when needed.

## Requirements

- PowerShell
- A TeX distribution with `pdflatex`
- `latexmk` and `perl` for the preferred build path
- `pdftotext` if you need to regenerate `data/students/source-index.md`

`scripts/build.ps1` uses `latexmk` when available and falls back to running `pdflatex` twice.

## Quick Start

Run the standard maintenance flow from the repository root:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/audit_student_data.ps1
powershell -ExecutionPolicy Bypass -File scripts/generate-document-derivatives.ps1
powershell -ExecutionPolicy Bypass -File scripts/build.ps1
```

If you changed newsletter sourcing or added a new source PDF, also run:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build-source-index.ps1
```

## Editing Workflow

1. Update the correct student entry under `data/students/`.
2. Keep the entry in the correct surname bucket: `a-f`, `g-l`, `m-r`, or `s-z`.
3. Preserve alphabetical order within the file.
4. Run the audit script.
5. Regenerate derived files.
6. Rebuild the PDF.
7. Regenerate `data/students/source-index.md` only when the newsletter-source mapping changed.

## Project Structure

- `main.tex`: document entrypoint.
- `PAGSA_Student_Awards.pdf`: tracked rendered PDF.
- `data/students/`: canonical student data and provenance index.
- `tex/`: document setup, macros, front matter, and generated LaTeX outputs.
- `newsletters/`: tracked DAP newsletter PDFs used for verification.
- `scripts/`: PowerShell automation for audit, generation, provenance, and builds.

### Important Files

- `data/students/a-f.tex`, `g-l.tex`, `m-r.tex`, `s-z.tex`: canonical award records.
- `data/students/source-index.md`: student-to-newsletter provenance map.
- `data/students/README.md`: detailed editing guidance for the data files.
- `tex/generated-students.tex`: generated student sections. Do not edit by hand.
- `tex/reverse-index.tex`: generated reverse index. Do not edit by hand.
- `tex/award-reference.tex`: recurring named award and fund descriptions shown in the front matter.
- `tex/macros.tex`: shared document macros such as `\studententry` and `\awardsource`.

## Data Conventions

- Prefer concise entries such as `Award Name (year)`.
- Keep newsletter provenance in `data/students/source-index.md` unless a visible source link improves the rendered document.
- Treat `newsletters/` as source material, not the primary editing surface.
- Update `tex/award-reference.tex` when a recurring named department award or fund needs a short front-matter description.

## Entry Example

```tex
\studententry{sec:ExampleStudent}{Example, Student}{
\begin{itemize}
  \item Example Award (2026)
  \item Another Award (2026)
        \awardsource{https://example.edu/source}
\end{itemize}
}
```

## Scripts

- `scripts/audit_student_data.ps1`: validates sort order, surname buckets, legacy wording, merge-conflict markers, and source-index coverage.
- `scripts/generate-document-derivatives.ps1`: regenerates `tex/generated-students.tex` and `tex/reverse-index.tex`.
- `scripts/build-source-index.ps1`: rebuilds `data/students/source-index.md` from the tracked newsletter PDFs using `pdftotext`.
- `scripts/build.ps1`: regenerates derived files, builds the document, and copies the final PDF to `PAGSA_Student_Awards.pdf`.

## Manual Build

If you prefer not to use `scripts/build.ps1`, build manually after regenerating the derived files:

```powershell
latexmk -pdf main.tex
```

Or, if `latexmk` is not available:

```powershell
pdflatex -interaction=nonstopmode -halt-on-error main.tex
pdflatex -interaction=nonstopmode -halt-on-error main.tex
```
