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
│   ├── figures/                         # Contains all .svg and generated .pdf figures
│   ├── reemission.tex                   # Main LaTeX source file
│   ├── reemission_rev1.tex              # Revision 1 of the paper
│   ├── reemission_rev2.tex              # Revision 2 of the paper
│   ├── reemission.bib                   # Bibliography file
│   ├── supplementary_materials.tex      # Supplementary materials
│   ├── supplementary_materials_r2.tex   # Supplementary materials revision 2
│   ├── highlights.txt                   # Paper highlights
│   ├── elsarticle.cls                   # Elsevier article class file
│   ├── elsarticle-*.bst                 # Bibliography style files
│   ├── reemission.pdf                   # Output (generated)
│   └── Makefile                         # Build rules (LaTeX + figures)
├── code/
│   ├── data/
│   │   ├── myanmar_inputs.json          # Myanmar case study input data
│   │   ├── uk_inputs.json               # UK case study input data
│   │   ├── uk_inputs_trimmed.json       # Trimmed UK input data
│   │   ├── validation_inputs.json       # Validation input data
│   │   ├── validation_outputs.json      # Validation output data
│   │   ├── reservoir_data_with_years.csv # Reservoir data with temporal information
│   │   ├── sensitivity_analysis_input_data.yaml # Sensitivity analysis inputs
│   │   └── dams_data/
│   │       └── mya_dams.geojson         # Myanmar dams geospatial data
│   ├── plantUML/                        # UML diagrams and configuration visualizations
│   │   ├── c4_container_diagram.md
│   │   ├── ch4_preimpoundment*.md
│   │   ├── co2_preimpoundment*.md
│   │   ├── class_uml_composite.md
│   │   ├── input_file.md
│   │   ├── output_file.md
│   │   └── ...                          # Additional diagram files
│   ├── Python/
│   │   ├── create_test_input.py         # Script to create test inputs
│   │   ├── create_test_input.sh         # Shell script for test input creation
│   │   ├── run_sobol_batches.py         # Sobol sensitivity analysis runner
│   │   ├── params_*.yaml                # Parameter configuration files
│   │   ├── requirements.txt             # Python dependencies
│   │   ├── mya_emission_profile_projections.ipynb # Myanmar projections notebook
│   │   ├── uk_emissions_under_parametetric_unertainties.ipynb # UK uncertainty analysis
│   │   └── README.md
│   ├── g_res_reemission_comparison/
│   │   ├── g-res-reemission-comparison.ipynb # Comparison analysis notebook
│   │   ├── emission_profile_comparison.csv   # Emission profile data
│   │   ├── total_emissions_comparison.csv    # Total emissions data
│   │   └── figures/
│   │       └── README.md
│   └── R/
│       ├── Gres_GHGcalcs on Geocaret output_val.R # G-res validation script
│       ├── ReEmission_validation_plots.ipynb      # Validation plots notebook
│       ├── comparison_data/
│       │   ├── results_chris.csv
│       │   └── validation_outputs_comb_30_6.csv
│       └── README.md
├── usage_statistics/                    # Usage statistics and benchmarking data
│   ├── Completed_EECU-seconds_[MEAN].csv
│   ├── Completed_EECU-seconds_[SUM].csv
│   ├── filesize.txy
│   ├── usage_plot.py
│   └── DEMO02FIN_20251208-1315/
│       ├── output_parameters.csv
│       ├── output_parameters.json
│       ├── settings.txt
│       └── tasks.csv
├── .github/
│   └── workflows/
│       └── latex.yml                    # GitHub Actions workflow for CI builds
└── README.md                            # You're reading it
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

