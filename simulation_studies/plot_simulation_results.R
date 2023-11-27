plot_simulation_results <- function(parameter,
                                    colors = c("grey75", "grey55", "grey30"),
                                    plot_height = 2.5,
                                    plot_width = 3.4,
                                    small_margin = .05,
                                    large_margin = .7,
                                    save = FALSE) {
  graphics.off()

  if (save) {
    pdf(file = paste0("output/simulation_results_", parameter, ".pdf"),
        width = plot_width * 3,
        height = plot_height * 2)
  }

  set_plot_sizes(plot_height, plot_width,
                 small_margin, large_margin)

  bias_ygrid <- round(seq(from = -.3, to = .3, by = .1), 1)
  variance_ygrid <- round(
    seq(from = 0, to = if ("phi10" %in% parameter) .6 else .4, by = .1),
    1
  )

  plot_settings <- data.frame(
    r1 = rep(c(0, .25, .5), 2),
    main = c("r = (0, 0]", "r = (-0.25, 0.25]", "r = (-0.5, 0.5]", "", "", ""),
    xaxis = c(FALSE, FALSE, FALSE, TRUE, TRUE, TRUE),
    yaxis = c(TRUE, FALSE, TRUE, TRUE, FALSE, TRUE),
    ymin = c(rep(min(bias_ygrid), 3), 0, 0, 0),
    ymax = c(rep(max(bias_ygrid), 3), rep(max(variance_ygrid), 3)),
    ylab = c("Bias", "", "Bias", "Variance", "", "Variance"),
    yaxis_loc = c(2, NA, 4, 2, NA, 4),
    margin_bottom = c(small_margin, small_margin, small_margin,
                      large_margin, large_margin, large_margin),
    margin_left   = c(large_margin, small_margin, small_margin,
                      large_margin, small_margin, small_margin),
    margin_top    = c(large_margin, large_margin, large_margin,
                      small_margin, small_margin, small_margin),
    margin_right  = c(small_margin, small_margin, large_margin,
                      small_margin, small_margin, large_margin)
  )

  for (i in 1:6) {
    create_one_plot(plot_settings = plot_settings,
                    plot_number = i,
                    parameter = parameter,
                    bias_ygrid = bias_ygrid,
                    variance_ygrid = variance_ygrid,
                    colors = colors)
  }

  par(mar = c(5.1, 4.1, 4.1, 2.1), mfrow = c(1, 1))
  if (save) dev.off()
  invisible()
}



create_one_plot <- function(plot_settings,
                            plot_number,
                            parameter,
                            bias_ygrid, variance_ygrid,
                            colors) {
  if (plot_number < 4) {
    outcomes <- biases
    outcomes_name <- "Bias"
    ygrid <- bias_ygrid
  } else {
    outcomes <- variances
    outcomes_name <- "Variance"
    ygrid <- variance_ygrid
  }

  r1 <- plot_settings[plot_number, "r1"]
  data <- cbind(conditions_overview[, c(1:2, 9:10)], outcomes)[conditions_overview[, "r1"] == r1, ]
  x_labels <- combine_2labels(c(50, 100, 200, 400), c(2, 5, 10))

  margins <- plot_settings[plot_number, c("margin_bottom", "margin_left", "margin_top", "margin_right")]
  par(mai = as.numeric(margins))

  # Create empty plot.
  plot(
    NA,
    ylim = c(plot_settings[plot_number, "ymin"], plot_settings[plot_number, "ymax"]),
    xlim = c(1, 12),
    xaxt = "n", yaxt = "n",
    ylab = "", xlab = ""
  )

  # Create background.
  rect(par("usr")[1], par("usr")[3], par("usr")[2], par("usr")[4], col = "grey90")
  abline(v = 1:12,  lty = 1, lwd = 2, col = "white")
  abline(h = ygrid, lty = 1, lwd = 2, col = "white")
  abline(h = 0, lty = 2)

  # Create axes.
  if (plot_settings[plot_number, "xaxis"])
    axis(side = 1, at = 1:12,  labels = x_labels, las = 2, cex.axis = 1.25)
  if (plot_settings[plot_number, "yaxis"])
    axis(side = plot_settings[plot_number, "yaxis_loc"], at = ygrid, las = 1, cex.axis = 1.25)

  # Create the actual data points
  for (phi_label in 1:3) {
    x <- data[data[, "phi_label"] == phi_label, parameter]
    lines(x, col = colors[phi_label], lwd = 2)
    points(x, pch = 19, col = colors[phi_label], cex = 1.25)
  }

  title(
    main = plot_settings[plot_number, "main"],
    ylab = plot_settings[plot_number, "ylab"],
    cex.main = 2, font.main = 1,
    cex.lab = 2, font.lab = 1
  )

  if (plot_number == 6) {
    legend(x = "topright",
           legend = c("eq-un", "un-un", "un-eq"),
           col = colors,
           pch = 19, lty = 1, lwd = 2,
           cex = 1.25,
           bg = "grey97")
  }
}

set_plot_sizes <- function(plot_height,
                           plot_width,
                           small_margin,
                           large_margin) {
  plot_width_inside <-
    plot_width - (large_margin + small_margin) + 2 * small_margin

  layout(mat = matrix(c(1:6), nrow = 2, ncol = 3, byrow = TRUE),
         widths  = lcm(c(plot_width, plot_width_inside, plot_width,
                         plot_width, plot_width_inside, plot_width) * 2.54),
         heights = lcm(rep(plot_height * 2.54, times = 6))
  )
}

