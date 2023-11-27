# Main script of the simulation study of the project
# Detecting hysteresis with the HysTAR model
# Author: Daan de Jong
# Date: October 2023
# -----------------------------------------------------------------------------

# If you need to, first clean the Global Environment.
rm(list = ls())

# We need the hystar package to generate data and fit the TAR and HysTAR models.
if (!("hystar" %in% installed.packages()) || packageVersion("hystar") != "1.1.0") {
  devtools::install_github("daandejongen/hystar")
}
library("hystar")

# The set_up contains settings like number of iterations, random seed,
# names of the estimates, etc.
source("setup.R")
# `conditions` is an array of dimension n_conditions X n_parameters X n_iterations.

source("generate_example_plots.R")
generate_example_plots()

source("inspect_r_search.R")
inspect_r_search()

# The "workers" are functions that do things like fit the model within an
# iteration, extract model results and store them appropriately, do all iterations
# within a given condition.
source("workers.R")

# Get the parameter estimates within all conditions for all iterations
# You may want to skip this and load the estimates instead.
# Because it will take about one day (on a MacBook Pro 8GB)
estimates <- aperm(
  apply(conditions, MARGIN = c(1, 3), FUN = get_estimates),
  perm = c(2, 1, 3) # estimates are given column-wise in `apply`, but we want them as rows.
)

# Store the estimates for later.
saveRDS(estimates, file = "output/estimates.RDS")

# If you skipped collection of estimates, you can load the estimates here.
estimates <- readRDS(file = "output/estimates.RDS")

# Functions to compute things like the bias, MSE, coverage rate, et cetera.
source("outcome_measures.R")

true_models <- ifelse(conditions_overview[, "r0"] == 0, yes = "tar", no = "hystar")

biases <- compute_outcomes("bias")
variances <- compute_outcomes("variance")
mses <- compute_outcomes("mse")
coverage_rates <- compute_CI_coverage_rates()
model_selection <- compute_model_selections_ic()
model_selection_lbox <- compute_model_selections_lbox(alpha = .05)

source("create_table.R")
if (!("xtable" %in% installed.packages())) install.packages("xtable")
library("xtable")

# Table 1 in paper
table_r1_0 <- create_table_small(
  rows_var_1 = "n_t", rows_var_2 = "n_switches", cols_var_1 = "phi_label",
  parameters = c("bic", "aiccp"), outcomes = model_selection, r1 = 0
  )
table_r1_25 <- create_table_small(
  rows_var_1 = "n_t", rows_var_2 = "n_switches", cols_var_1 = "phi_label",
  parameters = c("bic", "aiccp"), outcomes = model_selection, r1 = 0.25
  )
table_r1_5 <- create_table_small(
  rows_var_1 = "n_t", rows_var_2 = "n_switches", cols_var_1 = "phi_label",
  parameters = c("bic", "aiccp"), outcomes = model_selection, r1 = 0.5
  )
model_selection_table <- rbind(table_r1_0, table_r1_25, table_r1_5)
write(print(xtable(model_selection_table)),
      file = "output/model_selection_rawtable.tex")

table_parameter_estimation <- join_tables(
  create_table(
    rows_var_1 = "n_t", rows_var_2 = "n_switches", cols_var_1 = "r1", cols_var_2 = "phi_label",
    parameters = c("r0", "r1"), outcomes = biases)[, 7:18],
  create_table(
    rows_var_1 = "n_t", rows_var_2 = "n_switches", cols_var_1 = "r1", cols_var_2 = "phi_label",
    parameters = c("r0", "r1"), outcomes = variances)[, 7:18],
  names = c("bi", "va")
)
write(print(xtable(table_parameter_estimation)),
      file = "output/parameter_estimation_rawtable.tex")

source("plot_simulation_results.R")
plot_simulation_results("r0", save = TRUE)
plot_simulation_results("r1", save = TRUE)

mean(estimates[true_models == "tar", "lbox_tar", ])
mean(estimates[true_models == "tar", "lbox_hystar", ])
mean(estimates[true_models == "hystar", "lbox_tar", ])
mean(estimates[true_models == "hystar", "lbox_hystar", ])

z <- z_sim(n_t = 200, n_switches = 5, start_regime = 1)
sim <- hystar_sim(z = z, r = c(-.5, .5), d = 2, phi_R0 = c(0, .6), phi_R1 = 1)
plot(sim)
fit <- hystar_fit(sim$data)


