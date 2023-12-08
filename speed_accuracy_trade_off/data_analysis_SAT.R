# Main script to conduct the analyses on the speed-accuracy trade-off data,
# the second empirical example
# Author: Daan de Jong

rm(list = ls()) # clears R environment
library("hystar")
source("speed_accuracy_trade_off/fit.R")
source("speed_accuracy_trade_off/ljung-box-tests.R")
source("speed_accuracy_trade_off/plot.R")

data <- read.csv("speed_accuracy_trade_off/data_processed/SAT_data.csv")
head(data)

# Fit models
fit_F0_hystar <- fit(data, participant = "F", session = 0, tar = FALSE)
fit_F1_hystar <- fit(data, participant = "F", session = 1, tar = FALSE)
fit_I0_hystar <- fit(data, participant = "I", session = 0, tar = FALSE)
fit_I1_hystar <- fit(data, participant = "I", session = 1, tar = FALSE)
fit_F0_tar    <- fit(data, participant = "F", session = 0, tar = TRUE)
fit_F1_tar    <- fit(data, participant = "F", session = 1, tar = TRUE)
fit_I0_tar    <- fit(data, participant = "I", session = 0, tar = TRUE)
fit_I1_tar    <- fit(data, participant = "I", session = 1, tar = TRUE)

# Run `summary()`, `print()` and/or `confint()` on the model objects
# to inspect results. For example:
summary(fit_F0_hystar)

# Compare model fit with information criteria
fit_F0_hystar$ic < fit_F0_tar$ic
fit_F1_hystar$ic < fit_F1_tar$ic
fit_I0_hystar$ic < fit_I0_tar$ic
fit_I0_hystar$ic < fit_I0_tar$ic

# Ljung-Box tests on the residuals
hystar_is_preferred(fit_F0_hystar, fit_F0_tar)
hystar_is_preferred(fit_F1_hystar, fit_F1_tar)
hystar_is_preferred(fit_I0_hystar, fit_I0_tar)
hystar_is_preferred(fit_I1_hystar, fit_I1_tar)

# Make plots
plot_data(model = fit_F0_hystar, save = TRUE)
plot_data(model = fit_F1_hystar, save = TRUE)
plot_data(model = fit_I0_hystar, save = TRUE)
plot_data(model = fit_I1_hystar, save = TRUE)

