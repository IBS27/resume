# Resume Repository

- `resume.tex` is the only canonical resume source.
- Use `make pdf` for a normal build and `make verify` when validation is requested.
- Do not run `xelatex` directly. LaTeX intermediates belong in `build/latex/`.
- The current ready-to-send PDF belongs in `output/pdf/`.
- Rendered previews and extracted text belong in `tmp/pdfs/`.
- Do not commit routine generated files. PDFs under `releases/` are intentional,
  immutable snapshots and are the only generated files tracked by Git.
- After a content or layout change, compile only when requested or required to
  validate that requested change. Visually inspect the rendered PNG when compiling.
- Create releases with `make release VERSION=YYYY.MM.DD-N`, commit the resulting
  snapshot, then run `make tag VERSION=YYYY.MM.DD-N`.
- Keep the resume to one page and use ASCII hyphens in source text.
