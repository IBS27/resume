# Resume Variants

Create a tailored resume with:

```sh
make new-variant VARIANT=ai
```

Each `<name>.tex` file is an independently editable resume. Its generated PDF
is written beside it as:

```text
Srinivas_Indavara_Badrinath_Resume_<name>.pdf
```

Use `make verify-variant VARIANT=<name>` before sending or releasing a variant.
