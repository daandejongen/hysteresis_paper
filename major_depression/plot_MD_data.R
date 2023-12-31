plot_MD_data <- function() {
  pdf(file = "manuscript/images/MD_plot.pdf",
    width = 7, height = 4)
  plot(fit_hystar,
     main = "Depression time series from a network model",
     xlab = "time",
     zlab = "Stress",
     ylab = "Depression",
     show_legend = FALSE)
  dev.off()
}
