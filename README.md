# 📄 RE-Emission Paper

This repository contains the LaTeX source for the paper titled **"Re-Emission — A Free, Open-Source Software for Estimating, Reporting, and Visualizing Greenhouse Gas Emissions from Reservoirs."**  It also includes supplementary code in `PlantUML`, `Python`, and `R` used to generate figures and perform analyses related to the manuscript, including *Model Validation*, the *Myanmar Case Study*, and the *UK Case Study*.

# 📄 RE-Emission Paper Build System

This project automates the compilation of a LaTeX paper using tools such as `latexmk`, `pdflatex`, and common SVG-to-PDF converters (`inkscape`, `rsvg-convert`, `cairosvg`). It supports figures in `.svg` format and compiles them to `.pdf` before building the final paper.

---

## ⚙️ Build Instructions

You can compile the paper using:

```bash
make
```

This will:
- Convert all `.svg` figures in `paper_source/figures/` to `.pdf`
- Compile the LaTeX document in `paper_source/reemission.tex`
- Output the final PDF at `paper_source/reemission.pdf`

Alternatively, you can use the Python helper:

```bash
python build.py
```

This does the same as `make`, and is helpful on systems without `make`.

---

## 🧹 Cleaning Up

To clean intermediate LaTeX files (e.g., `.aux`, `.log`, `.out`, `.toc`, `.bbl`, etc.):

```bash
make clean
```

To also remove all generated figure PDFs and the final compiled paper:

```bash
make cleanall
```

---

## 📂 Project Structure

```
.
├── paper_source/
│   ├── figures/              # Contains all .svg and generated .pdf figures
│   ├── reemission.tex        # Main LaTeX source file
│   ├── references.bib        # Bibliography file
│   └── reemission.pdf        # Output (generated)
├── code/
│   ├── plantUML/             # Contains all diagrams (UML / YAML config files, etc.)
│   ├── Python/               # Contains all source code in Python
│   └── R/                    # Contains all source code in R
├── Makefile                  # Build rules (LaTeX + figures)
├── build.py                  # Optional build script in Python
├── .github/
│   └── workflows/
│       └── latex.yml         # GitHub Actions workflow for CI builds
└── README.md                 # You're reading it
```

---

## 🪟 Notes for Windows Users

On Windows:

- Install the [LaTeX distribution](https://miktex.org/) (MiKTeX or TeX Live)
- Use WSL (Windows Subsystem for Linux) for best compatibility with `make`
- Or run the Python script instead:
  ```bash
  python build.py
  ```

Ensure that required tools like `inkscape`, `rsvg-convert`, or `cairosvg` are on your system path. Use Chocolatey or Scoop to install them:

```powershell
choco install inkscape
```

or

```powershell
scoop install inkscape
```

---

## 🚀 Continuous Integration with GitHub Actions

Every push to the repository will trigger a build using GitHub Actions. The compiled `reemission.pdf` is stored as an artifact.

```
.github/workflows/latex.yml
```

