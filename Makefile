SHELL := /bin/sh

SOURCE := resume.tex
BUILD_DIR := build/latex
OUTPUT_DIR := output/pdf
VERIFY_DIR := tmp/pdfs
RELEASE_DIR := releases

BUILD_PDF := $(BUILD_DIR)/resume.pdf
OUTPUT_PDF := $(OUTPUT_DIR)/Srinivas_Indavara_Badrinath_Resume.pdf
VERIFY_PNG := $(VERIFY_DIR)/resume.png
VERIFY_TEXT := $(VERIFY_DIR)/resume.txt
RELEASE_PDF := $(RELEASE_DIR)/Srinivas_Indavara_Badrinath_Resume-$(VERSION).pdf
RELEASE_TAG := resume-$(VERSION)

.PHONY: help pdf verify clean release tag check-version

help:
	@printf '%s\n' \
		'make pdf                         Build the current resume' \
		'make verify                      Build, check one-page output, and render a preview' \
		'make clean                       Remove routine generated files' \
		'make release VERSION=YYYY.MM.DD-N  Create an immutable PDF snapshot' \
		'make tag VERSION=YYYY.MM.DD-N      Tag a committed release snapshot'

pdf:
	@mkdir -p "$(BUILD_DIR)" "$(OUTPUT_DIR)"
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

clean:
	latexmk -C "$(SOURCE)"
	@rm -f "$(OUTPUT_PDF)" "$(VERIFY_PNG)" "$(VERIFY_TEXT)"
	@printf 'Removed routine generated files\n'

check-version:
	@if [ -z "$(VERSION)" ]; then \
		printf 'VERSION is required (example: VERSION=2026.07.31-1)\n' >&2; \
		exit 1; \
	fi
	@printf '%s\n' "$(VERSION)" | grep -Eq '^[0-9]{4}\.[0-9]{2}\.[0-9]{2}-[1-9][0-9]*$$' || { \
		printf 'VERSION must match YYYY.MM.DD-N\n' >&2; \
		exit 1; \
	}

release: check-version verify
	@mkdir -p "$(RELEASE_DIR)"
	@if [ -e "$(RELEASE_PDF)" ]; then \
		printf 'Release already exists: %s\n' "$(RELEASE_PDF)" >&2; \
		exit 1; \
	fi
	@cp "$(OUTPUT_PDF)" "$(RELEASE_PDF)"
	@printf 'Created %s\nCommit it, then run: make tag VERSION=%s\n' "$(RELEASE_PDF)" "$(VERSION)"

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
