This folder holds the newsletter PDFs and optional Word files used as reference material for the awards list.

When a newsletter adds or corrects an award, update the matching student entry under `../data/students/` so the LaTeX source remains the maintained record.

GitHub Pages serves the tracked PDF files in this folder directly.

After source-related updates, run `powershell -ExecutionPolicy Bypass -File ../scripts/build-source-index.ps1` so the tracked provenance index in `../data/students/source-index.md` stays aligned with the maintained student data.
