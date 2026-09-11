# python-dev

General-purpose Python data science development environment.

- **Base:** `python:3.12.14-slim`
- **Package manager:** [uv](https://docs.astral.sh/uv/) (installed from `ghcr.io/astral-sh/uv:0.12.13`), reading `requirements.txt`

## Packages

See [requirements.txt](./requirements.txt) for pinned versions:

numpy, pandas, matplotlib, scipy, jupyterlab, requests

## Usage

### Non-HPC (Docker)

```bash
docker pull ghcr.io/banilmohammed/python-dev:latest
docker run -it --rm -v "$PWD":/workspace ghcr.io/banilmohammed/python-dev:latest
```

### HPC (Hoffman2 / Apptainer)

```bash
apptainer pull python-dev.sif docker://ghcr.io/banilmohammed/python-dev:latest
apptainer shell python-dev.sif
```

Sample job script snippet:

```bash
#!/bin/bash
#$ -cwd
#$ -l h_rt=01:00:00,h_data=4G

apptainer exec python-dev.sif python my_script.py
```
