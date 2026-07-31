# Resume

This repository keeps a resume as version-controlled LaTeX and provides a
small Make-based workflow for producing a one-page PDF. It supports a general
resume, independently tailored variants, visual and ATS-friendly text checks,
and dated release snapshots.

## Use this workflow for your resume

Install these dependencies:

- XeLaTeX and `latexmk`
- Poppler (`pdfinfo`, `pdftotext`, and `pdftoppm`)

Then fork the repository or clone it directly:

```sh
git clone https://github.com/IBS27/resume.git
cd resume
```

Personalize the template:

1. Replace the resume content and PDF metadata in `resume.tex`.
2. Change `FULL_NAME` in `Makefile`; it controls the generated PDF filenames.
3. Replace the bundled fonts or adjust the font declarations if desired.

Build and verify the resume:

```sh
make verify
```

This creates the ready-to-use PDF in the repository root, confirms that it is
one page, and writes a rendered preview and extracted text to `tmp/pdfs/`.

For a resume tailored to a particular role:

```sh
make new-variant VARIANT=backend
make verify-variant VARIANT=backend
```

Run `make help` to see the remaining build, cleanup, and release commands.
