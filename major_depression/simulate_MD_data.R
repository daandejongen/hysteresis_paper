simulate_depression_time_series <- function(network_thresholds,
                                            network_weights,
                                            number_of_time_points = 1000
                                            ) {
  network_connection_strength <- 1.1
  network_weights <- network_weights * network_connection_strength

  activated_nodes_matrix <- matrix(0, nrow = 14, ncol = number_of_time_points)
  stress_time_series <- z_sim(n_t = number_of_time_points,
                              n_switches = 8)[11:(number_of_time_points + 10)]

  activate_nodes <- function(previous_activated_nodes, current_stress_vector) {
    # Function to compute which nodes are activated at the current time point.
    activation_values <- network_weights %*% previous_activated_nodes +
      current_stress_vector
    activation_probabilities <- 1 / (1 + exp(network_thresholds - activation_values))
    activated_nodes <- rbinom(n = 14, size = 1, prob = activation_probabilities)

    return(activated_nodes)
  }

  set.seed(123)
  for (i in 2:number_of_time_points) {
    # A random selection of the nodes will be exposed to stress.
    stress_vector <- sample(c(stress_time_series[i], 0), size = 14, replace = TRUE)

    activated_nodes_matrix[, i] <- activate_nodes(
      previous_activated_nodes = activated_nodes_matrix[, i - 1],
      current_stress_vector = stress_vector
    )
  }

  depression_time_series <- colSums(activated_nodes_matrix)

  return(data.frame(depression = depression_time_series, stress = stress_time_series))
}
