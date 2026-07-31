# Resume Repository

## Sources

- `resume.tex` is the canonical general resume.
- `variants/<name>.tex` is a tailored resume. Use lowercase names such as `ai`
  or `backend`.
- A new variant is copied from the current `resume.tex`. After creation, it is
  independent; changes do not propagate between the general resume and variants.
- Edit `.tex` sources, never generated PDFs or files under `build/`.

## Commands

General resume:

```sh
make pdf
make verify
```

Create and work on a variant:

```sh
make new-variant VARIANT=ai
make variant VARIANT=ai
make verify-variant VARIANT=ai
```

Clean generated files:

```sh
make clean
make clean-variant VARIANT=ai
```

Use `make verify` or `make verify-variant` after a requested content or layout
change when compilation is required. Do not run `xelatex` directly.

## Generated Files

- The ready-to-upload general PDF is
  `Srinivas_Indavara_Badrinath_Resume.pdf` in the repository root.
- A variant PDF is
  `variants/Srinivas_Indavara_Badrinath_Resume_<name>.pdf`.
- LaTeX intermediates belong in `build/latex/`.
- Rendered previews and extracted text belong in `tmp/pdfs/`.
- Routine generated files are ignored by Git.
- PDFs under `releases/` are immutable snapshots and are intentionally tracked.

## Releases

Use calendar versions in the form `YYYY.MM.DD-N`.

General resume:

```sh
make release VERSION=2026.07.31-1
git add resume.tex releases/
git commit -m "release: resume 2026.07.31-1"
make tag VERSION=2026.07.31-1
```

Variant:

```sh
make release VARIANT=ai VERSION=2026.07.31-1
git add variants/ai.tex releases/
git commit -m "release: AI resume 2026.07.31-1"
make tag VARIANT=ai VERSION=2026.07.31-1
```

Do not overwrite an existing release or tag.

## Validation

- Keep every resume to one page.
- Visually inspect the PNG produced by a verification command.
- Check extracted text when text order or ATS readability may have changed.
- Use ASCII hyphens in source text.
- Preserve unrelated worktree changes.
