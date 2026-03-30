# Student Awards and Recognitions

This repository tracks a LaTeX document of Physics and Astronomy student awards and recognitions at Mizzou, compiled from department newsletters, recognition pages, and related coverage from roughly 2015 through early 2026.

The authoritative data lives in `data/students/`. Newsletter PDFs in `newsletters/` are reference material for verification and provenance. The repository also tracks the current generated TeX outputs in `tex/` and the rendered PDF `PAGSA_Student_Awards.pdf`.

## Overview

- Edit student records in `data/students/*.tex`.
- Keep the tracked generated files in `tex/` aligned with the maintained student data.
- Build the final PDF from `main.tex`.
- Use `newsletters/` to verify entries and maintain provenance notes.

## Requirements

- A TeX distribution with `pdflatex`
- `latexmk` and `perl` for the preferred build path

## Editing Workflow

1. Update the correct student entry under `data/students/`.
2. Keep the entry in the correct surname bucket: `a-f`, `g-l`, `m-r`, or `s-z`.
3. Preserve alphabetical order within the file.
4. Keep `data/students/source-index.md` aligned with maintained newsletter provenance.
5. Keep the generated outputs in `tex/` aligned with the student data.
6. Rebuild the PDF.

## Project Structure

- `main.tex`: document entrypoint.
- `PAGSA_Student_Awards.pdf`: tracked rendered PDF.
- `data/students/`: canonical student data and provenance index.
- `tex/`: document setup, macros, front matter, and generated LaTeX outputs.
- `newsletters/`: tracked DAP newsletter PDFs used for verification.

### Important Files

- `data/students/a-f.tex`, `g-l.tex`, `m-r.tex`, `s-z.tex`: canonical award records.
- `data/students/source-index.md`: student-to-newsletter provenance map.
- `data/students/README.md`: detailed editing guidance for the data files.
- `tex/generated-students.tex`: tracked generated student sections. Do not edit by hand.
- `tex/reverse-index.tex`: tracked generated reverse index. Do not edit by hand.
- `tex/award-reference.tex`: recurring named award and fund descriptions shown in the front matter.
- `tex/macros.tex`: shared document macros such as `\studententry` and `\awardsource`.

## Data Conventions

- Prefer concise entries such as `Award Name (year)`.
- Keep DAP newsletter provenance in `data/students/source-index.md`.
- Use inline `\awardsource{...}` links for older newsletter PDFs or non-newsletter pages that are not covered by `source-index.md`.
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

## Build

Build manually from the repository root once the tracked generated TeX files in `tex/` are current:

```powershell
latexmk -pdf main.tex
```

Or, if `latexmk` is not available:

```powershell
pdflatex -interaction=nonstopmode -halt-on-error main.tex
pdflatex -interaction=nonstopmode -halt-on-error main.tex
```
