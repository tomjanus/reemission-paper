# 📄 RE-Emission Paper

This repository contains the LaTeX source for the paper titled **"Re-Emission — A Free, Open-Source Software for Estimating, Reporting, and Visualizing Greenhouse Gas Emissions from Reservoirs."** It also includes supplementary code, data, and analyses used to generate figures and perform analyses related to the manuscript.

This includes:
- *Model Validation*
- *Myanmar Case Study*
- *UK Case Study*
- *G-res Re-emission Comparison*
- *Sensitivity Analysis (Sobol)*

The repository also contains the cover letter, revisions, and usage statistics related to the paper's submission.

# ⚙️ Build Instructions

You can compile the paper using:

```bash
make
```

inside the `paper_source` directory. For this, you need to install `make` on your operating system.

This will:
- Convert all `.svg` figures in `./figures/` to `.pdf`
- Compile the LaTeX document in `./reemission.tex`
- Output the final PDF at `./reemission.pdf`

---

## 🧹 Cleaning Up

To clean intermediate LaTeX files (e.g., `.aux`, `.log`, `.out`, `.toc`, `.bbl`, etc.):

```bash
make clean
```

inside the `paper_source` directory. To also remove all generated figure PDFs and the final compiled paper:

```bash
make cleanall
```

---

## 📂 Project Structure

```
.
├── paper_source/
│   ├── figures/                     # Contains all .svg and generated .pdf figures
│   ├── reemission.tex               # Main LaTeX source file
│   ├── reemission.bib               # Bibliography file
│   ├── reemission.pdf               # Output (generated)
│   └── Makefile                     # Build rules (LaTeX + figures)
├── code/
│   ├── Python/                      # Python scripts for analysis and plotting
│   ├── R/                           # R scripts for analysis and plotting
│   ├── data/                        # Input data for case studies and validation
│   ├── g_res_reemission_comparison/ # Jupyter notebook and data for comparing G-res and re-emission
│   └── plantUML/                    # PlantUML diagrams
├── usage_statistics/                # Usage statistics of the project
├── .github/
│   └── workflows/
│       └── latex.yml                # GitHub Actions workflow for CI builds
└── README.md                        # You're reading it
```

---

## 🪟 Notes for Windows Users

On Windows:

- Install a [LaTeX distribution](https://miktex.org/) (MiKTeX or TeX Live)
- Use WSL (Windows Subsystem for Linux) for best compatibility with `make`

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

Every push to the repository will trigger a build using GitHub Actions. The compiled main file `reemission_rev2.pdf` and supplementary materials file `supplementary_materials_r2.pdf` are stored as an artifact.

```
.github/workflows/latex.yml
```


