FROM bioconductor/bioconductor_docker:RELEASE_3_23-R-4.6.1

RUN curl -LO https://github.com/quarto-dev/quarto-cli/releases/download/v1.10.18/quarto-1.10.18-linux-amd64.deb \
    && apt-get update \
    && apt-get install -y --no-install-recommends ./quarto-1.10.18-linux-amd64.deb \
    && rm quarto-1.10.18-linux-amd64.deb \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

COPY install.R .
RUN Rscript install.R

CMD ["R"]
