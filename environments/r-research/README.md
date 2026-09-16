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

## Rendering .qmd files to markdown with Quarto

Inside a running container, render a `.qmd` document to GitHub-flavored markdown:

```bash
quarto render my_doc.qmd --to gfm
```

This executes any R code chunks and writes `my_doc.md` (plus a `my_doc_files/` directory for any generated figures) alongside the source file. Drop `--to gfm` to use Quarto's default output format instead (HTML), or pass another target (`--to md` for plain Pandoc markdown, `--to gfm` for GitHub-flavored — see `quarto render --help` for the full list).

Example, mounting a local project directory:

```bash
docker run --rm -v "$PWD":/workspace ghcr.io/banilmohammed/r-research:latest \
  quarto render /workspace/my_doc.qmd --to gfm
```

On Hoffman2, the same command works via `apptainer exec` (see the sample job script below).

## Running .ipynb notebooks with the R kernel in VS Code

The image registers [IRkernel](https://irkernel.github.io/) as a Jupyter kernel named **R** at build time, so VS Code's built-in Jupyter extension can discover and use it directly — no Jupyter server needed.

**One-time setup, if you haven't already:**
1. Install the [Jupyter extension](https://marketplace.visualstudio.com/items?itemName=ms-toolsai.jupyter) in VS Code.
2. Attach VS Code to the running container (e.g. via [Dev Containers: Attach to Running Container](https://code.visualstudio.com/docs/devcontainers/attach-container), or open a remote session on the machine where the container is running).

**Per-notebook:**
1. Open or create an `.ipynb` file.
2. Click **Select Kernel** in the top-right of the notebook editor.
3. Choose **Jupyter Kernel...**, then select **R** from the list — this is the kernel `IRkernel::installspec()` registered in the image (`/usr/local/share/jupyter/kernels/ir/kernel.json`).
4. Run cells as usual (`Shift+Enter`); output, plots, and errors render inline the same way they would with a Python kernel.

If **R** doesn't appear in the kernel list, the extension may need a moment to rescan, or you may be attached to a different container/environment than the one you built — check `jupyter kernelspec list`-equivalent by confirming the file above exists in the container you're attached to.

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
