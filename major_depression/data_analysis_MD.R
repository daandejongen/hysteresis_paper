# Code to produce the (semi) empirical example in the paper
# 'Detecting hysteresis with the HysTAR model' about major depression
# time series simulated from a network model.

library("hystar")

# Thresholds and weights from supplementary material
# https://figshare.com/projects/Major_depression_as_
# a_complex_dynamic_system_accepted_for_publication_in_PLoS_ONE_/17360
file_path <- "major_depression/network_parameters/"
data <- simulate_depression_time_series(
  network_thresholds = abs(read.delim(paste0(file_path, "thresholds.txt"),
                                      header = FALSE))[, ],
  network_weights = as.matrix(read.delim(paste0(file_path, "weights.txt"),
                                         header = TRUE)),
  number_of_time_points = 1000
)

fit_hystar <- hystar_fit(data, d = 0:1, tar = FALSE)
fit_tar    <- hystar_fit(data, d = 0:1, tar = TRUE)

Box.test(fit_hystar$residuals_st, type = "L", lag = 1)
Box.test(fit_tar$residuals_st, type = "L", lag = 1)

