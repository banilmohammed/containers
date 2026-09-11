options(repos = c(CRAN = "https://packagemanager.posit.co/cran/__linux__/noble/2026-09-10"))

install.packages(c(
  "Seurat",
  "SeuratObject",
  "hdf5r",
  "patchwork"
))

remotes::install_github(
  "mojaveazure/seurat-disk",
  ref = "877d4e18ab38c686f5db54f8cd290274ccdbe295"
)
