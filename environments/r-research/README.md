# r-research

R environment for research

- **Base:** `bioconductor/bioconductor_docker:RELEASE_3_23-R-4.6.1` (R 4.6.1, Bioconductor 3.23, Ubuntu 24.04)
- **CRAN mirror:** [Posit Package Manager](https://packagemanager.posit.co) binary snapshot, `noble/2026-09-10` — pre-built binaries, no source compilation
- **Reports:** [Quarto CLI](https://quarto.org) v1.10.18 for rendering `.qmd` documents

## Packages

See [install.R](./install.R) for the full install script.

- **Tidyverse:** `tidyverse`
- **Modeling:** `glmnet`, `lme4`, `broom`
- **PRS-specific:** `bigsnpr`, `bigstatsr`
- **Plotting:** `ggrepel`, `ggVennDiagram`
- **Genetics I/O:** `pgenlibr` (PLINK2 `.pgen` reader, installed from GitHub, pinned to a specific commit)
- **Utility:** `data.table`

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
