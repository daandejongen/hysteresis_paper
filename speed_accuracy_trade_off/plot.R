plot_data <- function(model, save_plot = TRUE) {
  model_name <- deparse(substitute(model))
  participant_name <- substr(model_name, start = 5, stop = 5)
  session_name <- substr(model_name, start = 6, stop = 6)

  if (save_plot) pdf(paste0("speed_accuracy_trade_off/output/SAT_plot",
                            participant_name,
                            session_name,
                            ".pdf"),
                     width = 7, height = 4)
  plot(model,
       main = paste0("Speed-accuracy trade-off for participant ",
                     participant_name, " session ", session_name),
       zlab = "Acc. Payoff",
       ylab = "Resp. time",
       xlab = "Trial")

  if (save_plot) dev.off()
}

small_margin <- 2
large_margin <- 5
plot_settings <- data.frame(
  main = rep(c(TRUE, FALSE), times = 4),
  xaxt = c(rep("n", times = 4), rep("s", times = 4)),
  yaxt = rep(c("s", "n", "n", "n"), times = 2),
  ylab = c("HysTAR", "", "", "", "TAR", "", "", ""),
  xlab = c(rep("", times = 4), rep("lag", times = 4)),
  margin_bottom = c(small_margin, small_margin, small_margin, small_margin,
                    large_margin, large_margin, large_margin, large_margin),
  margin_left   = c(large_margin, small_margin, small_margin, small_margin,
                    large_margin, small_margin, small_margin, small_margin),
  margin_top    = c(large_margin, large_margin, large_margin, small_margin,
                    small_margin, small_margin, small_margin, small_margin),
  margin_right  = c(small_margin, small_margin, large_margin, small_margin,
                    small_margin, small_margin, small_margin, large_margin)
)

residuals_acf_plot <- function(model, plot_number) {
  model_name <- deparse(substitute(model))
  participant_name <- substr(model_name, start = 4, stop = 4)
  session_name <- substr(model_name, start = 5, stop = 5)

  main <- if (plot_settings[plot_number, "main"]) {
    paste0("Participant ", participant_name, ", session ", session_name)
  } else {
    ""
  }

  margins = plot_settings[plot_number,
                          c("margin_bottom",
                            "margin_left",
                            "margin_top",
                            "margin_right")]
  par(mar = as.numeric(margins))

  acf(model$residuals,
      lag.max = 15,
      ylim = c(-.2, 1),
      xlab = plot_settings[plot_number, "xlab"],
      ylab = plot_settings[plot_number, "ylab"],
      yaxt = plot_settings[plot_number, "yaxt"],
      xaxt = plot_settings[plot_number, "xaxt"],
      main = main)
}

plot_acf_all <- function(list_of_models) {
  par(mfrow = c(2, 4))
  #pdf("acf_plots.pdf", width = 7, height = 5)
  for (i in 1:8) {
    residuals_acf_plot(model = list_of_models[[i]], plot_number = i)
  }
}

plot_acf_all(list_of_models = list(fit_A0_hystar, fit_A0_hystar,
                                   fit_A0_hystar, fit_A0_hystar,
                                   fit_A0_hystar, fit_A0_hystar,
                                   fit_A0_hystar, fit_A0_hystar))

