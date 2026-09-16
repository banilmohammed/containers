# r-research

R environment for research applications

- **Base:** `bioconductor/bioconductor_docker:RELEASE_3_23-R-4.6.1` (R 4.6.1, Bioconductor 3.23, Ubuntu 24.04)
- **CRAN mirror:** [Posit Package Manager](https://packagemanager.posit.co) binary snapshot, `noble/2026-09-10` — pre-built binaries, no source compilation
- **Reports:** [Quarto CLI](https://quarto.org) v1.10.18 for rendering `.qmd` documents
- **R console:** [arf](https://github.com/eitsupi/arf) v0.5.2, a Rust R console (radian-style: multiline editing, completion, syntax highlighting)
- **Jupyter/`.ipynb` support:** [IRkernel](https://irkernel.github.io/) registered as a Jupyter kernel, for editing/running `.ipynb` files with an R kernel in VS Code (no Jupyter server — VS Code's Jupyter extension talks to the kernel directly; `jupyter_core`/`jupyter_client` are installed via pip only so `IRkernel::installspec()` can register it at build time)

## Packages

See [install.R](./install.R) for the full install script, or [PACKAGES.md](./PACKAGES.md) for the complete list of installed packages and versions (including transitive dependencies), generated from the built image.

- **Tidyverse:** `tidyverse`
- **Modeling:** `glmnet`, `lme4`, `broom`
- **PRS-specific:** `bigsnpr`, `bigstatsr`
- **Plotting:** `ggrepel`, `ggVennDiagram`, `ComplexHeatmap`, `eulerr`
- **Genetics I/O:** `pgenlibr` (PLINK2 `.pgen` reader, installed from GitHub, pinned to a specific commit), `rtracklayer`, `GenomicRanges`
- **Utility:** `data.table`, `glue`, `janitor`

## Using arf as the R console in VS Code

With the [vscode-R](https://marketplace.visualstudio.com/items?itemName=REditorSupport.r) extension (also used by Quarto's R support), point it at `arf` in your local VS Code `settings.json`:

```json
{
  "r.rterm.linux": "arf",
  "r.bracketedPaste": true
}
```

## Usage

### Non-HPC (Docker)

```bash
docker pull ghcr.io/banilmohammed/r-research:latest
docker run -it --rm -v "$PWD":/workspace ghcr.io/banilmohammed/r-research:latest
```

### HPC (Hoffman2 / Apptainer)

```bash
apptainer pull r-research.sif docker://ghcr.io/banilmohammed/r-research:latest
apptainer shell r-research.sif
```

Sample job script snippet:

```bash
#!/bin/bash
#$ -cwd
#$ -l h_rt=01:00:00,h_data=8G

apptainer exec r-research.sif Rscript my_analysis.R
```
