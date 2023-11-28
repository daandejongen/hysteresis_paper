# Plots
pdf(file = "major_depression/output/time_series_plot.pdf",
    width = 7, height = 4)
plot(fit_hystar,
     main = "Depression time series from a network model",
     xlab = "time",
     zlab = "Stress",
     ylab = "Depression",
     show_legend = FALSE)
dev.off()

plot_acfs <- function() {
  par(mfrow = c(1, 2))
  acf(fit_tar$residuals, main = "TAR residuals", lag.max = 15)
  acf(fit_hystar$residuals, main = "HysTAR residuals", lag.max = 15)
}

pdf(file = "major_depression/output/acf_plot.pdf",
    width = 7, height = 3)
plot_acfs()
dev.off()
