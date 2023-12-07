# Main script of the simulation study of the project
# Detecting hysteresis with the HysTAR model
# Author: Daan de Jong

rm(list = ls()) # clears R environment.
library("hystar") # to generate data and fit the (Hys)TAR model.
library("xtable") # to export R-objects to LaTeX files.
source("simulation_studies/setup.R")
source("simulation_studies/generate_example_plots.R")
source("simulation_studies/inspect_r_search.R")
source("simulation_studies/workers.R")
source("simulation_studies/outcome_measures.R")
source("simulation_studies/create_table.R")

# Figure in Simulation Study 1 of the paper.
generate_example_plots()

# You may want to skip this and load the estimates instead.
# Because it will take about one day (on a MacBook Pro 8GB)
estimates <- aperm(
  apply(conditions, MARGIN = c(1, 3), FUN = get_estimates),
  perm = c(2, 1, 3) # estimates are given column-wise in `apply`, but we want them as rows.
)

# Store the estimates for later.
saveRDS(estimates, file = "simulation_studies/output/estimates.RDS")

# If you skipped collection of estimates, you can load the estimates here.
estimates <- readRDS(file = "simulation_studies/output/estimates.RDS")

true_models <- ifelse(conditions_overview[, "r0"] == 0, yes = "tar", no = "hystar")
biases <- compute_outcomes("bias")
variances <- compute_outcomes("variance")
mses <- compute_outcomes("mse")
coverage_rates <- compute_CI_coverage_rates()
model_selection <- compute_model_selections_ic()
model_selection_lbox <- compute_model_selections_lbox(alpha = .05)

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

source("simulation_studies/plot_simulation_results.R")pl
plot_simulation_results(parameters = c("r0", "r1"), r1_condition = .25, save = TRUE)
plot_simulation_results(parameters = c("r0", "r1"), r1_condition = .5, save = TRUE)
plot_simulation_results("r1", save = TRUE)

mean(estimates[true_models == "tar", "lbox_tar", ])
mean(estimates[true_models == "tar", "lbox_hystar", ])
mean(estimates[true_models == "hystar", "lbox_tar", ])
mean(estimates[true_models == "hystar", "lbox_hystar", ])

z <- z_sim(n_t = 200, n_switches = 5, start_regime = 1)
sim <- hystar_sim(z = z, r = c(-.5, .5), d = 2, phi_R0 = c(0, .6), phi_R1 = 1)
plot(sim)
fit <- hystar_fit(sim$data)


