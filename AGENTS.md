# Resume Repository

- `resume.tex` is the canonical general resume source.
- Tailored resume sources belong in `variants/<name>.tex`.
- Use `make pdf` for a normal build and `make verify` when validation is requested.
- Use `make variant VARIANT=<name>` for a tailored resume.
- Do not run `xelatex` directly. LaTeX intermediates belong in `build/latex/`.
- The current general PDF is `Srinivas_Indavara_Badrinath_Resume.pdf` in the root.
- Variant PDFs belong directly in `variants/` and include the full name and
  variant in their filenames.
- Rendered previews and extracted text belong in `tmp/pdfs/`.
- Do not commit routine generated files. PDFs under `releases/` are intentional,
  immutable snapshots and are the only generated files tracked by Git.
- After a content or layout change, compile only when requested or required to
  validate that requested change. Visually inspect the rendered PNG when compiling.
- Create releases with `make release VERSION=YYYY.MM.DD-N`. Add
  `VARIANT=<name>` for a tailored resume. Commit the resulting snapshot, then
  use the matching `make tag` command.
- Keep the resume to one page and use ASCII hyphens in source text.
