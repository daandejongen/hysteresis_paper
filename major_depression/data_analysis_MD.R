# Code to produce the (semi) empirical example in the paper
# 'Detecting hysteresis with the HysTAR model' about major depression
# time series simulated from a network model.

if (!("hystar" %in% installed.packages()) || packageVersion("hystar") != "1.2.0") {
  devtools::install_github("daandejongen/hystar")
}
library("hystar")

# Thresholds and weights from supplementary material
# https://figshare.com/projects/Major_depression_as_
# a_complex_dynamic_system_accepted_for_publication_in_PLoS_ONE_/17360
file_path <- "major_depression/MD_network_parameters/"
network_thresholds <- abs(read.delim(paste0(file_path, "thresholds.txt"), header = FALSE))[, ]
network_weights_raw <- as.matrix(read.delim(paste0(file_path, "weights.txt"), header = TRUE))
network_connection_strength <- 1.1
network_weights <- network_weights_raw * network_connection_strength
number_of_time_points <- 1000

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
data <- data.frame(depression = depression_time_series, stress = stress_time_series)

fit_hystar <- hystar_fit(data, d = 0:1, tar = FALSE)
fit_tar    <- hystar_fit(data, d = 0:1, tar = TRUE)

pdf(file = "major_depression/output/time_series_plot.pdf",
    width = 7, height = 4)
plot(fit_hystar,
     main = "Depression time series from a network model",
     xlab = "time",
     zlab = "Stress",
     ylab = "Depression",
     show_legend = FALSE)
dev.off()
summary(fit_hystar)

acf(fit_tar$residuals, main = "TAR residuals", lag.max = 15)
acf(fit_hystar$residuals, main = "HysTAR residuals", lag.max = 15)

Box.test(fit_hystar$residuals_st, type = "L", lag = 1)
Box.test(fit_tar$residuals_st, type = "L", lag = 1)

