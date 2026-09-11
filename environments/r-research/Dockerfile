FROM bioconductor/bioconductor_docker:RELEASE_3_23-R-4.6.1

RUN curl -LO https://github.com/quarto-dev/quarto-cli/releases/download/v1.10.18/quarto-1.10.18-linux-amd64.deb \
    && apt-get update \
    && apt-get install -y --no-install-recommends ./quarto-1.10.18-linux-amd64.deb \
    && rm quarto-1.10.18-linux-amd64.deb \
    && rm -rf /var/lib/apt/lists/*

RUN curl -LO https://github.com/eitsupi/arf/releases/download/v0.5.2/arf-console-x86_64-unknown-linux-gnu.tar.xz \
    && tar -xJf arf-console-x86_64-unknown-linux-gnu.tar.xz \
    && mv arf-console-x86_64-unknown-linux-gnu/arf /usr/local/bin/arf \
    && rm -rf arf-console-x86_64-unknown-linux-gnu arf-console-x86_64-unknown-linux-gnu.tar.xz

RUN pip3 install --break-system-packages --no-cache-dir jupyter_core jupyter_client

WORKDIR /workspace

COPY install.R .
RUN Rscript install.R

CMD ["R"]
