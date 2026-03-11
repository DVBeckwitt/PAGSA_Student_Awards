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

## Entry Template

```tex
\studententry{sec:ExampleStudent}{Example, Student}{
\begin{itemize}
  \item Example Award (2026)
\end{itemize}
}
```
