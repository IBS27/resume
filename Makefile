SHELL := /bin/sh

FULL_NAME := Srinivas_Indavara_Badrinath
SOURCE := resume.tex
BUILD_DIR := build/latex
VERIFY_DIR := tmp/pdfs
VARIANT_DIR := variants
RELEASE_DIR := releases

BUILD_PDF := $(BUILD_DIR)/resume.pdf
OUTPUT_PDF := $(FULL_NAME)_Resume.pdf
VERIFY_PNG := $(VERIFY_DIR)/resume.png
VERIFY_TEXT := $(VERIFY_DIR)/resume.txt

VARIANT ?= general
VARIANT_SOURCE := $(VARIANT_DIR)/$(VARIANT).tex
VARIANT_BUILD_DIR := $(BUILD_DIR)/variants/$(VARIANT)
VARIANT_BUILD_PDF := $(VARIANT_BUILD_DIR)/$(VARIANT).pdf
VARIANT_OUTPUT_PDF := $(VARIANT_DIR)/$(FULL_NAME)_Resume_$(VARIANT).pdf
VARIANT_VERIFY_PNG := $(VERIFY_DIR)/resume-$(VARIANT).png
VARIANT_VERIFY_TEXT := $(VERIFY_DIR)/resume-$(VARIANT).txt

ifeq ($(VARIANT),general)
RELEASE_BUILD_TARGET := verify
RELEASE_INPUT_PDF := $(OUTPUT_PDF)
else
RELEASE_BUILD_TARGET := verify-variant
RELEASE_INPUT_PDF := $(VARIANT_OUTPUT_PDF)
endif

RELEASE_PDF := $(RELEASE_DIR)/$(FULL_NAME)_Resume_$(VARIANT)-$(VERSION).pdf
RELEASE_TAG := resume-$(VARIANT)-$(VERSION)

.PHONY: help pdf verify variant verify-variant new-variant clean clean-variant
.PHONY: release tag check-version check-variant-name check-variant

help:
	@printf '%s\n' \
		'make pdf                                      Build the general resume in the root' \
		'make verify                                   Build and verify the general resume' \
		'make new-variant VARIANT=ai                   Create variants/ai.tex' \
		'make variant VARIANT=ai                       Build variants/..._Resume_ai.pdf' \
		'make verify-variant VARIANT=ai                Build and verify a variant' \
		'make clean                                    Clean the general resume output' \
		'make clean-variant VARIANT=ai                 Clean one variant output' \
		'make release VERSION=YYYY.MM.DD-N             Release the general resume' \
		'make release VARIANT=ai VERSION=YYYY.MM.DD-N  Release a variant' \
		'make tag VERSION=YYYY.MM.DD-N                 Tag the general release' \
		'make tag VARIANT=ai VERSION=YYYY.MM.DD-N      Tag a variant release'

pdf:
	@mkdir -p "$(BUILD_DIR)"
	latexmk -xelatex -interaction=nonstopmode -halt-on-error -file-line-error "$(SOURCE)"
	@cp "$(BUILD_PDF)" "$(OUTPUT_PDF)"
	@printf 'Built %s\n' "$(OUTPUT_PDF)"

verify: pdf
	@command -v pdfinfo >/dev/null
	@command -v pdftotext >/dev/null
	@command -v pdftoppm >/dev/null
	@pages=$$(pdfinfo "$(OUTPUT_PDF)" | awk '/^Pages:/ { print $$2 }'); \
		if [ "$$pages" != "1" ]; then \
			printf 'Expected a one-page resume, found %s pages\n' "$$pages" >&2; \
			exit 1; \
		fi
	@mkdir -p "$(VERIFY_DIR)"
	pdftotext "$(OUTPUT_PDF)" "$(VERIFY_TEXT)"
	pdftoppm -f 1 -l 1 -singlefile -png "$(OUTPUT_PDF)" "$(VERIFY_DIR)/resume"
	@printf 'Verified one-page output. Inspect %s\n' "$(VERIFY_PNG)"

check-variant-name:
	@if [ "$(VARIANT)" = "general" ]; then \
		printf 'Set VARIANT to a descriptive name such as ai or backend\n' >&2; \
		exit 1; \
	fi
	@printf '%s\n' "$(VARIANT)" | grep -Eq '^[a-z0-9][a-z0-9-]*$$' || { \
		printf 'VARIANT must use lowercase letters, numbers, and hyphens\n' >&2; \
		exit 1; \
	}

check-variant: check-variant-name
	@if [ ! -f "$(VARIANT_SOURCE)" ]; then \
		printf 'Variant source does not exist: %s\n' "$(VARIANT_SOURCE)" >&2; \
		exit 1; \
	fi

new-variant: check-variant-name
	@if [ -e "$(VARIANT_SOURCE)" ]; then \
		printf 'Variant already exists: %s\n' "$(VARIANT_SOURCE)" >&2; \
		exit 1; \
	fi
	@mkdir -p "$(VARIANT_DIR)"
	@cp "$(SOURCE)" "$(VARIANT_SOURCE)"
	@printf 'Created %s\n' "$(VARIANT_SOURCE)"

variant: check-variant
	@mkdir -p "$(VARIANT_BUILD_DIR)" "$(VARIANT_DIR)"
	latexmk -xelatex -interaction=nonstopmode -halt-on-error -file-line-error \
		-outdir="$(VARIANT_BUILD_DIR)" -auxdir="$(VARIANT_BUILD_DIR)" "$(VARIANT_SOURCE)"
	@cp "$(VARIANT_BUILD_PDF)" "$(VARIANT_OUTPUT_PDF)"
	@printf 'Built %s\n' "$(VARIANT_OUTPUT_PDF)"

verify-variant: variant
	@command -v pdfinfo >/dev/null
	@command -v pdftotext >/dev/null
	@command -v pdftoppm >/dev/null
	@pages=$$(pdfinfo "$(VARIANT_OUTPUT_PDF)" | awk '/^Pages:/ { print $$2 }'); \
		if [ "$$pages" != "1" ]; then \
			printf 'Expected a one-page resume, found %s pages\n' "$$pages" >&2; \
			exit 1; \
		fi
	@mkdir -p "$(VERIFY_DIR)"
	pdftotext "$(VARIANT_OUTPUT_PDF)" "$(VARIANT_VERIFY_TEXT)"
	pdftoppm -f 1 -l 1 -singlefile -png "$(VARIANT_OUTPUT_PDF)" "$(VERIFY_DIR)/resume-$(VARIANT)"
	@printf 'Verified one-page output. Inspect %s\n' "$(VARIANT_VERIFY_PNG)"

clean:
	latexmk -C "$(SOURCE)"
	@rm -f "$(OUTPUT_PDF)" "$(VERIFY_PNG)" "$(VERIFY_TEXT)"
	@printf 'Removed routine generated files\n'

clean-variant: check-variant
	latexmk -C -outdir="$(VARIANT_BUILD_DIR)" -auxdir="$(VARIANT_BUILD_DIR)" "$(VARIANT_SOURCE)"
	@rm -f "$(VARIANT_OUTPUT_PDF)" "$(VARIANT_VERIFY_PNG)" "$(VARIANT_VERIFY_TEXT)"
	@printf 'Removed generated files for variant %s\n' "$(VARIANT)"

check-version:
	@if [ -z "$(VERSION)" ]; then \
		printf 'VERSION is required (example: VERSION=2026.07.31-1)\n' >&2; \
		exit 1; \
	fi
	@printf '%s\n' "$(VERSION)" | grep -Eq '^[0-9]{4}\.[0-9]{2}\.[0-9]{2}-[1-9][0-9]*$$' || { \
		printf 'VERSION must match YYYY.MM.DD-N\n' >&2; \
		exit 1; \
	}

release: check-version $(RELEASE_BUILD_TARGET)
	@mkdir -p "$(RELEASE_DIR)"
	@if [ -e "$(RELEASE_PDF)" ]; then \
		printf 'Release already exists: %s\n' "$(RELEASE_PDF)" >&2; \
		exit 1; \
	fi
	@cp "$(RELEASE_INPUT_PDF)" "$(RELEASE_PDF)"
	@printf 'Created %s\nCommit it, then run: make tag VARIANT=%s VERSION=%s\n' \
		"$(RELEASE_PDF)" "$(VARIANT)" "$(VERSION)"

tag: check-version
	@git rev-parse --is-inside-work-tree >/dev/null
	@if [ -n "$$(git status --porcelain)" ]; then \
		printf 'Commit all changes before tagging a release\n' >&2; \
		exit 1; \
	fi
	@git ls-files --error-unmatch "$(RELEASE_PDF)" >/dev/null 2>&1 || { \
		printf 'The release PDF is not committed: %s\n' "$(RELEASE_PDF)" >&2; \
		exit 1; \
	}
	@if git rev-parse -q --verify "refs/tags/$(RELEASE_TAG)" >/dev/null; then \
		printf 'Tag already exists: %s\n' "$(RELEASE_TAG)" >&2; \
		exit 1; \
	fi
	git tag -a "$(RELEASE_TAG)" -m "Resume release $(VERSION)"
	@printf 'Created tag %s\n' "$(RELEASE_TAG)"
