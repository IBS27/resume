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
Srinivas_Indavara_Badrinath_Resume.pdf
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

## Resume variants

The general resume remains in the repository root. Tailored source files and
their ready-to-upload PDFs live directly under `variants/`.

Create a new variant from the current general resume:

```sh
make new-variant VARIANT=ai
```

Edit `variants/ai.tex`, then build or verify it:

```sh
make variant VARIANT=ai
make verify-variant VARIANT=ai
```

The ready-to-upload variant is:

```text
variants/Srinivas_Indavara_Badrinath_Resume_ai.pdf
```

Use short lowercase variant names such as `ai`, `backend`, or `general-swe`.
Variants are maintained together on the same Git branch rather than on
long-lived branches.

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

For a variant, include the same `VARIANT` value in both commands:

```sh
make release VARIANT=ai VERSION=2026.07.31-1
git add variants/ai.tex releases/
git commit -m "release: AI resume 2026.07.31-1"
make tag VARIANT=ai VERSION=2026.07.31-1
```

Annotated tags such as `resume-general-2026.07.31-1` and
`resume-ai-2026.07.31-1` identify the source revision that produced each PDF.
Tags are created locally; push them explicitly if a remote is added later.
