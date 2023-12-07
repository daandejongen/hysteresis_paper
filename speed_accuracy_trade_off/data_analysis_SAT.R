# Main script to conduct the analyses on the speed-accuracy trade-off data,
# the second empirical example
# Author: Daan de Jong

rm(list = ls()) # clears R environment
if (!("foreign" %in% installed.packages())) install.packages("foreign")
library("hystar")
source("speed_accuracy_trade_off/fit.R")
source("speed_accuracy_trade_off/ljung-box-tests.R")
source("speed_accuracy_trade_off/plot.R")

# Warning message about duplicated levels can be ignored
data_F <- foreign::read.spss("speed_accuracy_trade_off/data/acc_rt_1.sav",
                             to.data.frame = TRUE)
data_I <- foreign::read.spss("speed_accuracy_trade_off/data/acc_rt_2.sav",
                             to.data.frame = TRUE)

# Fit models
fit_F0_hystar <- fit(data_F, session = 0, tar = FALSE)
fit_F1_hystar <- fit(data_F, session = 1, tar = FALSE)
fit_I0_hystar <- fit(data_I, session = 0, tar = FALSE)
fit_I1_hystar <- fit(data_I, session = 1, tar = FALSE)
fit_F0_tar    <- fit(data_F, session = 0, tar = TRUE)
fit_F1_tar    <- fit(data_F, session = 1, tar = TRUE)
fit_I0_tar    <- fit(data_I, session = 0, tar = TRUE)
fit_I1_tar    <- fit(data_I, session = 1, tar = TRUE)

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

