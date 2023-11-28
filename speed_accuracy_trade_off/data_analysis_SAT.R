# Main script to conduct the analyses on the speed-accuracy trade-off data,
# the second empirical example.

rm(list = ls()) # clears R environment.

# Loading data.
# (Warning message about duplicated levels can be ignored.)
data_A <- foreign::read.spss("speed_accuracy_trade_off/data/acc_rt_1.sav",
                             to.data.frame = TRUE)
data_B <- foreign::read.spss("speed_accuracy_trade_off/data/acc_rt_2.sav",
                             to.data.frame = TRUE)

source("speed_accuracy_trade_off/fit.R") # A function to fit the hystar model

# Fit models.
fit_A0_hystar <- fit(data_A, session = 0, tar = FALSE)
fit_A1_hystar <- fit(data_A, session = 1, tar = FALSE)
fit_B0_hystar <- fit(data_B, session = 0, tar = FALSE)
fit_B1_hystar <- fit(data_B, session = 1, tar = FALSE)
fit_A0_tar    <- fit(data_A, session = 0, tar = TRUE)
fit_A1_tar    <- fit(data_A, session = 1, tar = TRUE)
fit_B0_tar    <- fit(data_B, session = 0, tar = TRUE)
fit_B1_tar    <- fit(data_B, session = 1, tar = TRUE)

# Run `summary()`, `print()` and/or `confint()` on the model objects
# to inspect results. For example:
summary(fit_A0_hystar)

source("speed_accuracy_trade_off/ljung-box-tests.R")
hystar_is_preferred(fit_A0_hystar, fit_A0_tar)
hystar_is_preferred(fit_A1_hystar, fit_A1_tar)
hystar_is_preferred(fit_B0_hystar, fit_B0_tar)
hystar_is_preferred(fit_B1_hystar, fit_B1_tar)

plot_acf_all(list_of_models = list(fit_A0_hystar, fit_A0_hystar,
                                   fit_A0_hystar, fit_A0_hystar,
                                   fit_A0_hystar, fit_A0_hystar,
                                   fit_A0_hystar, fit_A0_hystar))

# Reproducing the plot from the paper.
# han/acc_rt_1.sav is participant F
# han/acc_rt_2.sav is participant I
data <- data_A
select_rows_up <- data["richting"] == 1
rt_up <- data[select_rows_up, "rt"] / 10
pacc_up <- data[select_rows_up, "pacc"]
means_up <- numeric(24)
for (i in 1:24) means_up[i] <- mean(rt_up[pacc_up == i])
select_rows_down <- data["richting"] == -1
rt_down <- data[select_rows_down, "rt"] / 10
pacc_down <- data[select_rows_down, "pacc"]
means_down <- numeric(25)
for (i in 0:24) means_down[i + 1] <- mean(rt_down[pacc_down == i])
plot(1:24, means_up, "l", ylim = c(0, 630), lty = 2)
lines(1:25, means_down, lty = 1)


