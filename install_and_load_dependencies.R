# Prerequisites for hystar paper R scripts.

rm(list = ls()) # clears the environment.

# The `hystar` package, to simulate from and estimate the hystar model.
if (!("hystar" %in% installed.packages()) || packageVersion("hystar") != "1.1.0") {
  devtools::install_github("daandejongen/hystar")
}
library("hystar")

# The `foreign` package, to load .sav data files (SPSS).
if (!("foreign" %in% installed.packages())) {
  install.packages("foreign")
}
library("foreign")
