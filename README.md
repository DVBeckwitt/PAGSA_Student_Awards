<<<<<<< HEAD
# Graduate Student Awards

This project now separates the LaTeX rendering logic from the award data so updates happen in one place per student.

## Layout

- `main.tex`: thin entrypoint that loads the document pieces.
- `tex/preamble.tex`: packages and document-wide setup.
- `tex/macros.tex`: rendering macros that build the linked student index and the student sections from the same declarations.
- `tex/frontmatter.tex`: title, intro copy, and the index block.
- `data/students/all.tex`: alphabetical include list for the student data files.
- `data/students/*.tex`: the actual award records, grouped alphabetically.
- `newsletters/`: reference newsletters used when adding or correcting awards.

## Updating awards

- Add a student by opening the matching alphabetical file in `data/students/` and adding one `\studententry{...}{...}{...}` block.
- Add or remove an award by editing the `itemize` list inside that student's block.
- Remove a student by deleting that student's entire `\studententry` block.
- Update the visible year range or intro text in `tex/frontmatter.tex`.
- If the list grows enough to need another split, add a new file under `data/students/` and include it from `data/students/all.tex`.

Example block:

```tex
\studententry{sec:ExampleStudent}{Example, Student}{
\begin{itemize}
  \item Example Award (2026)
\end{itemize}
}
```

Use any unique label for the first argument. Keeping the existing `sec:Name` style is the simplest convention.

## Build

- Run `pdflatex main.tex` twice so the hyperlinked index resolves correctly.
- If `latexmk` is installed, `latexmk -pdf main.tex` also works.
=======
# PAGSA_Student_Awards
Collection of all student awards for posterity
>>>>>>> 924e1b2414351d8ecb9f70ff423c01ab96ccf539
