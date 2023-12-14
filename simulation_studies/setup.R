# The set_up contains settings like number of iterations, random seed,
# names of the estimates, etc.

n_iterations <- 500
set.seed(41114)

conditions_n_t <- c(50, 100, 200, 400)
conditions_n_switches <- c(2, 5, 10)
conditions_phi <- matrix(c(0, 0.6, 0, 0.2,
                           0, 0.6, 3, 0.2,
                           0, 0.4, 3, 0.4),
                         byrow = TRUE, nrow = 3, ncol = 4)
conditions_thresholds <- c(0, 0.25, 0.5) # abs values of thresholds r0 and r1

n1 <- length(conditions_n_t)
n2 <- length(conditions_n_switches)
n3 <- nrow(conditions_phi)
n4 <- length(conditions_thresholds)

# Make crossings of all conditions by crossing their indices.
conditions_indices <- matrix(c(
  rep(1:n1, each = n2 * n3 * n4),
  rep(rep(1:n2, each = n3 * n4), times = n1),
  rep(rep(1:n3, each = n4), times = n1 * n2),
  rep(1:n4, times = n1 * n2 * n3)
), byrow = FALSE, ncol = 4)
colnames(conditions_indices) <- c("n_t", "n_switches", "phi", "thresholds")
# check whether all condition-crossings are present
nrow(unique(conditions_indices)) == n1 * n2 * n3 * n4

conditions <- array(NA, dim = c(nrow(conditions_indices), 8, n_iterations))
dimnames(conditions) <- list(
  paste0("cond-", 1:nrow(conditions_indices)),
  c("n_t", "n_switches", "phi00", "phi01", "phi10", "phi11", "r0", "r1"),
  paste0("iter-", 1:n_iterations)
)

for (i in 1:nrow(conditions_indices)) {
  conditions[i, , 1] <- c(
    conditions_n_t[conditions_indices[i, "n_t"]],
    conditions_n_switches[conditions_indices[i, "n_switches"]],
    conditions_phi[conditions_indices[i, "phi"], ],
    - conditions_thresholds[conditions_indices[i, "thresholds"]],
    conditions_thresholds[conditions_indices[i, "thresholds"]]
  )
}

conditions[, , 2:n_iterations] <- rep(conditions[, , "iter-1"], times = n_iterations - 1)

conditions_overview <- cbind(conditions[, , 1, drop = TRUE],
                             phi_label = conditions_indices[, "phi"],
                             true_model = ifelse(conditions_indices[, "thresholds"] == 1,
                                                 yes = 0, no = 1),
                             n_z_values = compute_unique_z()[, "n_unique_z_values"])
# true model is 0 if tar, 1 if hystar

phi_labels <- c("equal_means_unequal_ar" = 1,
                "unequal_means_unequal_ar" = 2,
                "unequal_means_equal_ar" = 3)








