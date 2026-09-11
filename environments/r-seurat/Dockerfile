FROM ghcr.io/banilmohammed/r-research:latest

WORKDIR /workspace

COPY install.R .
RUN Rscript install.R

CMD ["R"]
