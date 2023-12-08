# Prerequisites for hystar paper R scripts.

# The `hystar` package, to simulate from and estimate the hystar model.
if (!("hystar" %in% installed.packages()) ||
    packageVersion("hystar") < package_version("1.1.0")) {
  devtools::install_github("daandejongen/hystar")
}

# The `foreign` package, to load .sav data files (SPSS).
if (!("foreign" %in% installed.packages()) ||
  packageVersion("foreign") < package_version("0.8.82")) {
  install.packages("foreign")
}

# The `xtable` package, to transform R matrices to LaTeX tables.
if (!("xtable" %in% installed.packages()) ||
    packageVersion("xtable") < package_version("1.8.4")) {
  install.packages("xtable")
}


