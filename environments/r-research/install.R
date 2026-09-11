options(repos = c(CRAN = "https://packagemanager.posit.co/cran/__linux__/noble/2026-09-10"))

install.packages(c(
  "remotes",
  "tidyverse",
  "glmnet",
  "lme4",
  "broom",
  "bigsnpr",
  "bigstatsr",
  "ggrepel",
  "ggVennDiagram",
  "data.table"
))

remotes::install_github(
  "chrchang/plink-ng",
  subdir = "2.0/pgenlibr",
  ref = "278e9df0453d5375e7399874e74d3b0560b770ad"
)
