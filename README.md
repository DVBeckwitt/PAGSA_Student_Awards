# Student Awards and Recognitions

This repository maintains a single LaTeX source of Physics and Astronomy student awards and recognitions drawn from the department newsletters through the 2025 issue.

GitHub Pages serves the tracked PDF artifacts in this repository directly, including `PAGSA_Student_Awards.pdf` and the newsletter PDFs under `newsletters/`.

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
- `scripts/`: versioned PowerShell maintenance scripts for audit, derived-file generation, provenance regeneration, and PDF builds.

## Maintenance Workflow

1. Update the matching student entry under `data/students/`.
2. Run `powershell -ExecutionPolicy Bypass -File scripts/audit_student_data.ps1`.
3. Run `powershell -ExecutionPolicy Bypass -File scripts/generate-document-derivatives.ps1`.
4. Run `powershell -ExecutionPolicy Bypass -File scripts/build-source-index.ps1`.
5. Rebuild `PAGSA_Student_Awards.pdf` with `powershell -ExecutionPolicy Bypass -File scripts/build.ps1` or `latexmk -pdf main.tex`.

## Entry Template

```tex
\studententry{sec:ExampleStudent}{Example, Student}{
\begin{itemize}
  \item Example Award (2026)
\end{itemize}
}
```
