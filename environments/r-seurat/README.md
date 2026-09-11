# r-seurat

Single-cell / spatial transcriptomics environment. Builds on [r-research](../r-research/) and adds Seurat.

- **Base:** `ghcr.io/banilmohammed/r-research:latest`
- **CRAN mirror:** same Posit Package Manager snapshot as r-research (`noble/2026-09-10`)

## Packages

See [install.R](./install.R). All of [r-research](../r-research/README.md)'s packages are included, plus:

- `Seurat`, `SeuratObject`
- `hdf5r` — required for 10x/`.h5` file I/O
- `patchwork` — combining Seurat's ggplot-based plots
- `SeuratDisk` — AnnData/`.h5ad` interop, installed from GitHub, pinned to a specific commit

Standard scRNA-seq workflows (clustering, markers, UMAP) and spatial transcriptomics are both supported by core Seurat — no additional packages needed for spatial.

## Usage

### Non-HPC (Docker)

```bash
docker pull ghcr.io/banilmohammed/r-seurat:latest
docker run -it --rm -v "$PWD":/workspace ghcr.io/banilmohammed/r-seurat:latest
```

### HPC (Hoffman2 / Apptainer)

```bash
apptainer pull r-seurat.sif docker://ghcr.io/banilmohammed/r-seurat:latest
apptainer shell r-seurat.sif
```

Sample job script snippet:

```bash
#!/bin/bash
#$ -cwd
#$ -l h_rt=02:00:00,h_data=16G

apptainer exec r-seurat.sif Rscript my_analysis.R
```
