FROM python:3.12.14-slim

COPY --from=ghcr.io/astral-sh/uv:0.12.13 /uv /uvx /usr/local/bin/

WORKDIR /workspace

COPY requirements.txt .
RUN uv pip install --system --no-cache -r requirements.txt

CMD ["bash"]
