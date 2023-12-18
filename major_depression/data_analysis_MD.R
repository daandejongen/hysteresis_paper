# Code to produce the (semi) empirical example in the paper
# 'Detecting hysteresis with the HysTAR model' about major depression
# time series simulated from a network model.

rm(list = ls())
library("hystar")
source("major_depression/simulate_MD_data.R")
source("major_depression/plot_MD_data.R")

# Thresholds and weights from supplementary material
# https://figshare.com/projects/Major_depression_as_
# a_complex_dynamic_system_accepted_for_publication_in_PLoS_ONE_/17360
thresholds <- abs(read.delim(
  "major_depression/network_parameters/thresholds.txt",
  header = FALSE))[, ]
weights <- as.matrix(read.delim(
  "major_depression/network_parameters/weights.txt",
  header = TRUE))

MD_data <- simulate_depression_time_series(
  network_thresholds = thresholds,
  network_weights = weights,
  number_of_time_points = 1000
)

saveRDS(MD_data, "major_depression/simulated_MD_data.RDS")
MD_data <- readRDS("major_depression/simulated_MD_data.RDS")

fit_hystar <- hystar_fit(MD_data, d = 0, tar = FALSE)
fit_tar    <- hystar_fit(MD_data, d = 0, tar = TRUE)

Box.test(fit_hystar$residuals_st, type = "L", lag = 1)
Box.test(fit_tar$residuals_st, type = "L", lag = 1)

plot_MD_data() # only saves the plot, does not show it directly.
