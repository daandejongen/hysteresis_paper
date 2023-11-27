rm(list = ls())
if (!("hystar" %in% installed.packages()) || packageVersion("hystar") != "1.1.0") {
  devtools::install_github("daandejongen/hystar")
}
if (!("foreign" %in% installed.packages())) {
  install.packages("foreign")
}
library("hystar")

data_F <- foreign::read.spss(file = "han/acc_rt_1.sav", to.data.frame = TRUE)
data_I <- foreign::read.spss(file = "han/acc_rt_2.sav", to.data.frame = TRUE)
# Warning message about duplicated levels can be ignored.

fit_data <- function(data, participant, session, tar, plot = FALSE) {
  # A function to
  select_session <- data["sessie"] == session
  y <- log(data[select_session, "rt"])
  z <- data[select_session, "pacc"]
  fit <- hystar_fit(data.frame(y, z), d = 0:1, tar = tar)
  if (plot) {
    plot(fit,
         main = paste0("Speed-accuracy trade-off for participant ",
                       participant, " session ", session),
         zlab = "Acc. Payoff",
         ylab = "Resp. time",
         xlab = "Trial",
         regime_names = c("G", "SC"),
         show_legend = FALSE)
  }
  return(fit)
}

fit_F0_hystar <- fit_data(data = data_F, "F", session = 0, tar = FALSE)
fit_F1_hystar <- fit_data(data = data_F, "F", session = 1, tar = FALSE)
fit_I0_hystar <- fit_data(data = data_I, "I", session = 0, tar = FALSE)
fit_I1_hystar <- fit_data(data = data_I, "I", session = 1, tar = FALSE)

fit_F0_tar <- fit_data(data = data_F, "F", session = 0, tar = TRUE)
fit_F1_tar <- fit_data(data = data_F, "F", session = 1, tar = TRUE)
fit_I0_tar <- fit_data(data = data_I, "I", session = 0, tar = TRUE)
fit_I1_tar <- fit_data(data = data_I, "I", session = 1, tar = TRUE)

summary(fit_I0_hystar)
confint(fit_I0_hystar)

hystar_is_preferred <- function(hystar, tar) {
  result <- Box.test(hystar$residuals_st, type = "L")$p.value > .05 &
    Box.test(tar$residuals_st, type = "L")$p.value <= .05

  return(result)
}

hystar_is_preferred(fit_F0_hystar, fit_F0_tar)
hystar_is_preferred(fit_F1_hystar, fit_F1_tar)
hystar_is_preferred(fit_I0_hystar, fit_I0_tar)
hystar_is_preferred(fit_I1_hystar, fit_I1_tar)

residuals_acf_plot <- function(fit_object, participant, session,
                               yaxt, xaxt) {
  model_name <- if (fit_object$tar) "TAR" else "HysTAR"
  pdf(file = paste0(model_name, "_resplot_", participant, session, ".pdf"))
  acf(fit_object$residuals, lag.max = 15, ylim = c(-.2, 1), xlab = NA, ylab = NA,
      yaxt = yaxt, xaxt = xaxt, main = "")
  dev.off()
}
par(mar = c(0, 2, 0, 0))
residuals_acf_plot(fit_F0_tar, "F", "0", NULL, "n")
par(mar = c(0, 0, 0, 0))
residuals_acf_plot(fit_F1_tar, "F", "1", "n", "n")
residuals_acf_plot(fit_I0_tar, "I", "0", "n", "n")
residuals_acf_plot(fit_I1_tar, "I", "1", "n", "n")
par(mar = c(2, 2, 0, 0))
residuals_acf_plot(fit_F0_hystar, "F", "0", NULL, NULL)
par(mar = c(2, 0, 0, 0))
residuals_acf_plot(fit_F1_hystar, "F", "1", "n", NULL)
residuals_acf_plot(fit_I0_hystar, "I", "0", "n", NULL)
residuals_acf_plot(fit_I1_hystar, "I", "1", "n", NULL)

# Reproducing the plot from the paper.
# han/acc_rt_1.sav is participant F
# han/acc_rt_2.sav is participant I
data <- data_F
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


