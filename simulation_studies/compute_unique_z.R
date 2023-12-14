compute_unique_z <- function() {
  output_matrix <- matrix(
    c(rep(conditions_n_t, each = length(conditions_n_switches)),
      rep(conditions_n_switches, times = length(conditions_n_t)),
      rep(NA, times = length(conditions_n_t) * length(conditions_n_switches))),
    ncol = 3, byrow = FALSE
  )
  colnames(output_matrix) <- c("n_t", "n_switches", "n_unique_z_values")

  for (i in 1:nrow(output_matrix)) {
    output_matrix[i, "n_unique_z_values"] <- get_r_search(
      n_t = output_matrix[i, "n_t"],
      n_switches = output_matrix[i, "n_switches"]
    )
  }

  return(output_matrix)
}

get_r_search <- function(n_t, n_switches) {
  # Number of z values that is considered for the threshold estimate per
  # `n_t` and `n_switches`
  z <- z_sim(n_t = n_t, n_switches = n_switches)
  sim <- hystar_sim(z, r = c(0, 0), d = 0, phi_R0 = 0, phi_R1 = 0)
  fit <- hystar_fit(sim$data)

  return(length(fit$r_search))
}


