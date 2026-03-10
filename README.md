# Graduate Student Awards

This repository maintains a single LaTeX source of Physics and Astronomy graduate student awards and recognitions drawn from the department newsletters through the 2025 issue.

## Layout

- `main.tex`: thin document entrypoint.
- `tex/preamble.tex`: document-wide packages and setup.
- `tex/macros.tex`: shared rendering macros.
- `tex/frontmatter.tex`: title, scope note, and linked index.
- `tex/generated-students.tex`: generated alphabetical student sections used by the document.
- `tex/reverse-index.tex`: generated reverse index grouped by recognition type.
- `data/students/all.tex`: include list for the alphabetical student data files.
- `data/students/*.tex`: maintained award records, grouped by surname.
- `data/students/README.md`: contributor rules for editing the data.
- `data/students/source-index.md`: tracked provenance index for newsletter issues mentioning each student.
- `newsletters/`: source newsletters used for verification.
- `scripts/build.ps1`: optional PowerShell build helper.
- `scripts/audit_student_data.ps1`: consistency checks for ordering and legacy wording.
- `scripts/build-source-index.ps1`: regenerates the provenance index from the data and extracted newsletter text.

## Build

Preferred:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/generate-document-derivatives.ps1
latexmk -pdf main.tex
```

Fallback:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/generate-document-derivatives.ps1
pdflatex -interaction=nonstopmode -halt-on-error main.tex
pdflatex -interaction=nonstopmode -halt-on-error main.tex
```

`scripts/build.ps1` runs the generator first and then builds with the available TeX toolchain.

## Updating Awards

1. Edit the matching alphabetical file under `data/students/`.
2. Keep entries sorted by surname inside each file.
3. Keep award bullets concise: `Award Name (year)` with an optional short note on the next line.
4. Use canonical award names from `data/students/README.md`.
5. Regenerate the derived document files before rebuilding:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/generate-document-derivatives.ps1
```

6. Regenerate the provenance index after meaningful source updates:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build-source-index.ps1 > data/students/source-index.md
```

7. Run the audit script before rebuilding:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/audit_student_data.ps1
```

8. Rebuild with the `latexmk` or `pdflatex` commands above.

## Entry Template

```tex
\studententry{sec:ExampleStudent}{Example, Student}{
\begin{itemize}
  \item Example Award (2026)
\end{itemize}
}
```

Use a stable label in the first argument. Keeping the existing `sec:SurnameGiven` convention is the simplest approach.
