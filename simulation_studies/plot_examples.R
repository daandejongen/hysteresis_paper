generate_example_plots <- function() {
  for (i in 1:3) {
    pdf(file = paste0("manuscript/images/simulation_example_plot_", i, ".pdf"),
        width = 10, height = 6)
    z <- z_sim(n_t = 100, n_switches = conditions_n_switches[i])
    sim <- hystar_sim(z = z,
                      r = c(-conditions_thresholds[i], conditions_thresholds[i]),
                      d = 0,
                      phi_R0 = conditions_phi[i, 1:2],
                      phi_R1 = conditions_phi[i, 3:4])
    plot(sim, main = "", show_legend = FALSE, xlab = "", cex.axis = 1.5, cex.lab = 1.5)
    dev.off()
  }
}
