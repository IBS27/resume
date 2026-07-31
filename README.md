# LaTeX Resume

`resume.tex` is the source of truth. It uses the Calibri regular, bold, and
italic subsets stored in `fonts/`.

## Requirements

- XeLaTeX and `latexmk`
- Poppler (`pdfinfo`, `pdftotext`, and `pdftoppm`) for verification

## Everyday workflow

```sh
make pdf
```

The ready-to-send file is written to:

```text
output/pdf/Srinivas_Indavara_Badrinath_Resume.pdf
```

All LaTeX intermediates stay under `build/latex/`. Running `latexmk` directly
also respects this location through `.latexmkrc`.

To check that the resume remains one page, extract its text, and render a PNG
for visual inspection:

```sh
make verify
```

The preview and extracted text are written under `tmp/pdfs/`.

To remove routine generated files:

```sh
make clean
```

## Versioned releases

Git commits track every source revision. A released resume uses a calendar
version in the form `YYYY.MM.DD-N`, where `N` distinguishes multiple releases
on the same day.

Create and inspect a snapshot:

```sh
make release VERSION=2026.07.31-1
```

This writes an exact PDF snapshot under `releases/`. Commit the source and
snapshot together:

```sh
git add resume.tex releases/
git commit -m "release: resume 2026.07.31-1"
make tag VERSION=2026.07.31-1
```

Annotated tags such as `resume-2026.07.31-1` identify the source revision that
produced each released PDF. Tags are created locally; push them explicitly if
a remote is added later.
