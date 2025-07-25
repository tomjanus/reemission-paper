# File: Makefile

# Directories and file namese
MAIN_NAME = reemission
BIB_NAME = references
TEX = $(MAIN_NAME).tex
BIB = $(MAIN_NAME).bib
PDF = $(MAIN_NAME).pdf
SVG_DIR = figures
PDF_DIR = figures

# Figures
SVGS = $(wildcard $(SVG_DIR)/*.svg)
PDFS = $(SVGS:.svg=.pdf)

# Tool detection
CONVERTER = $(firstword $(foreach t, inkscape rsvg-convert cairosvg, $(shell command -v $(t) 2>/dev/null)))
LATEXMK = $(shell command -v latexmk 2>/dev/null)
PDFLATEX = $(shell command -v pdflatex 2>/dev/null)
BIBTEX = $(shell command -v bibtex 2>/dev/null)

.PHONY: all figs clean cleanall check-tools

# Main target
all: check-tools figs $(PDF)

# Convert all SVGs to PDFs
figs: $(PDFS)

$(SVG_DIR)/%.pdf: $(SVG_DIR)/%.svg
	@if [ "$(CONVERTER)" = "" ]; then \
		echo "❌ No SVG to PDF converter found. Install inkscape, rsvg-convert, or cairosvg."; \
		exit 1; \
	elif [ "$(CONVERTER)" = "inkscape" ]; then \
		echo "🔄 Converting $< to PDF using Inkscape..."; \
		inkscape $< --export-type=pdf --export-filename=$@; \
	elif [ "$(CONVERTER)" = "rsvg-convert" ]; then \
		echo "🔄 Converting $< to PDF using rsvg-convert..."; \
		rsvg-convert -f pdf -o $@ $<; \
	elif [ "$(CONVERTER)" = "cairosvg" ]; then \
		echo "🔄 Converting $< to PDF using CairoSVG..."; \
		cairosvg $< -o $@; \
	fi

# Compile the LaTeX document
$(PDF): $(TEX) $(PDFS) $(BIB)
ifeq ($(LATEXMK),)
	@if [ -z "$(PDFLATEX)" ] || [ -z "$(BIBTEX)" ]; then \
		echo "❌ No LaTeX compiler found (need latexmk or pdflatex + bibtex)"; \
		exit 1; \
	else \
		echo "🔧 Compiling with pdflatex and bibtex..."; \
		$(PDFLATEX) $(TEX); \
		$(BIBTEX) $(MAIN_NAME); \
		$(PDFLATEX) $(TEX); \
		$(PDFLATEX) $(TEX); \
	fi
else
	@echo "🔧 Compiling with latexmk..."; \
	$(LATEXMK) -pdf -bibtex -silent $(TEX)
endif

# Tool checks
check-tools:
	@if [ -z "$(CONVERTER)" ]; then \
		echo "⚠️  Warning: No SVG->PDF converter found. Figures will not be processed."; \
	fi
	@if [ -z "$(LATEXMK)" ] && ([ -z "$(PDFLATEX)" ] || [ -z "$(BIBTEX)" ]); then \
		echo "❌ Error: No usable LaTeX compiler found (latexmk or pdflatex + bibtex required)."; \
		exit 1; \
	fi

clean:
	@echo "🧹 Cleaning LaTeX auxiliary files..."
	@if command -v latexmk >/dev/null 2>&1; then \
		echo "Using latexmk to clean..."; \
		latexmk -C -quiet -output-directory=. reemission.tex; \
	else \
		echo "latexmk not found. Falling back to manual clean."; \
		rm -f *.aux *.log *.out *.bbl *.blg *.spl *.toc; \
	fi

cleanall: clean
	@echo "🧹 Removing all generated PDFs (figures + main)..."
	rm -f $(PDFS) $(PDF)

