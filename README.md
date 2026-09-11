# containers

Personal Dockerfiles for development environments, built by GitHub Actions and published to [GitHub Container Registry](https://ghcr.io). Pull the image on whatever machine you're working on — no local build needed, which matters on systems like HPC clusters where you can't build containers at all.

## Environments

| Environment | Description |
|---|---|
| [python-dev](./environments/python-dev/) | General Python data science environment |
| [r-research](./environments/r-research/) | R for general research work
| [r-seurat](./environments/r-seurat/) | r-research + Seurat, for single-cell/spatial transcriptomics |

Each environment has its own README with the full package list and usage details.

## How it works

- Each environment lives in `environments/<name>/` with its own `Dockerfile`.
- Pushing a change to `environments/<name>/**` on `main` triggers a GitHub Actions build for that environment only ([.github/workflows/build.yml](./.github/workflows/build.yml)).
- Images are pushed to `ghcr.io/banilmohammed/<name>`, tagged `latest` and with the short git SHA.
- `r-seurat` builds on top of `r-research`'s published image, so a `r-research` change rebuilds `r-seurat` too.

## Usage

### Non-HPC (Docker)

```bash
docker pull ghcr.io/banilmohammed/<name>:latest
docker run -it --rm -v "$PWD":/workspace ghcr.io/banilmohammed/<name>:latest
```

### HPC (e.g. Hoffman2, no sudo / Apptainer)

```bash
apptainer pull <name>.sif docker://ghcr.io/banilmohammed/<name>:latest
apptainer shell <name>.sif
```

See each environment's README for a sample job script.

## Cost

All images are public, so GitHub Actions build minutes and GHCR storage/bandwidth are free.
