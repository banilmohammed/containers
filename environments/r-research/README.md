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
- **Modeling:** `glmnet`, `lme4`, `broom`, `broom.mixed` (tidy/glance/augment support for `lme4` mixed models)
- **PRS-specific:** `bigsnpr`, `bigstatsr`
- **Plotting:** `ggrepel`, `ggVennDiagram`, `ComplexHeatmap`, `eulerr`
- **Genetics I/O:** `pgenlibr` (PLINK2 `.pgen` reader, installed from GitHub, pinned to a specific commit), `rtracklayer`, `GenomicRanges`
- **Spatial:** `sf` (simple features for spatial vector data; needs `libgdal34`/`libgeos-c1v5`/`libproj25`/`libsqlite3-0` at runtime, installed in the Dockerfile), `rnaturalearth` + `rnaturalearthdata` (world map data, bundled so `ne_countries()` etc. work offline)
- **Utility:** `data.table`, `glue`, `janitor`
- **Editor support:** `languageserver` (powers IntelliSense/diagnostics for the [vscode-R](https://marketplace.visualstudio.com/items?itemName=REditorSupport.r) extension)

## Adding packages

Packages are installed at build time from [install.R](./install.R) — installing a package inside a *running* container (e.g. `install.packages("foo")` at the R prompt) only lasts until the container exits, since the filesystem isn't persisted. To add a package permanently:

1. **Check it has a pre-built binary at the pinned snapshot.** This repo's CRAN mirror is fixed to a dated [Posit Package Manager](https://packagemanager.posit.co) snapshot (`noble/2026-09-10`, set in `install.R`) rather than live CRAN, so builds stay reproducible. Most packages have binaries, but it's worth confirming before adding one — especially packages with compiled C/C++/Fortran code (e.g. anything using Rcpp) — since installing from source instead of a binary is slow and can fail without system `-dev` headers the image doesn't have. Check with:
   ```bash
   curl -sI -A "R (4.6.0 x86_64-pc-linux-gnu x86_64 linux-gnu)" \
     "https://packagemanager.posit.co/cran/__linux__/noble/2026-09-10/src/contrib/<package>_<version>.tar.gz"
   ```
   A `200 OK` (or a redirect) with an `x-package-type: binary` response header confirms a binary exists. Find the exact version pinned at that snapshot (not necessarily the newest version on CRAN today) via:
   ```bash
   curl -s "https://packagemanager.posit.co/cran/__linux__/noble/2026-09-10/src/contrib/PACKAGES" | grep -A1 "^Package: <package>$"
   ```
2. **Add the package name to `install.R`** — to the CRAN `install.packages(c(...))` list for CRAN packages, or to the `BiocManager::install(c(...))` call for Bioconductor packages. No version number needed; the snapshot date is what pins it.
3. **Rebuild and test locally** before pushing:
   ```bash
   docker build -t r-research:test environments/r-research
   docker run --rm r-research:test Rscript -e 'library(<package>)'
   ```
4. **Commit and push.** The GitHub Actions workflow rebuilds and republishes the image automatically on a push that touches `environments/r-research/**`.
5. **Regenerate [PACKAGES.md](./PACKAGES.md)** (optional but keeps it accurate) by querying the rebuilt image:
   ```bash
   docker run --rm r-research:test Rscript -e \
     'write.table(installed.packages()[, c("Package","Version")], stdout(), sep="|", row.names=FALSE, quote=FALSE)'
   ```

Some packages (e.g. ones wrapping system libraries like GDAL/GEOS) may need an `apt-get install` line added to the `Dockerfile` for runtime shared libraries, even when installing from a PPM binary — check the package's CRAN `SystemRequirements` field if the install or a subsequent `library()` call fails.

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
