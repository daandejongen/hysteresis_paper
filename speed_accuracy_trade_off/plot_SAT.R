plot_SAT_data <- function(model, save_plot = TRUE) {
  model_name <- deparse(substitute(model))
  participant_name <- substr(model_name, start = 5, stop = 5)
  session_name <- substr(model_name, start = 6, stop = 6)

  if (save_plot) pdf(paste0("manuscript/images/SAT_plot_",
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

  invisible(NULL)
}

