compute_outcomes <- function(type = c("bias", "variance", "mse")) {
  parameters <- c("phi00", "phi01", "phi10", "phi11", "r0", "r1")
  n_conditions <- nrow(conditions_overview)
  outcome_matrix <- matrix(NA, nrow = n_conditions, ncol = length(parameters))
  colnames(outcome_matrix) <- parameters
  rownames(outcome_matrix) <- rownames(conditions_overview)

  compute_outcome <- function() {
    if (type == "bias")     return(mean(ests) - true_value)
    if (type == "variance") return(mean((mean(ests) - ests)**2))
    if (type == "mse")      return(mean((true_value - ests)**2))
  }

  for (cond in rownames(outcome_matrix)) {
    for (para in parameters) {
      ests <- estimates[cond, para, ]
      true_value <- conditions_overview[cond, para]
      outcome_matrix[cond, para] <- compute_outcome()
    }
  }

  return(outcome_matrix)
}

compute_CI_coverage_rates <- function(alpha = .05) {
  parameters <- c("phi00", "phi01", "phi10", "phi11")
  n_conditions <- nrow(conditions_overview)
  rates <- matrix(NA, nrow = n_conditions, ncol = length(parameters))
  colnames(rates) <- parameters
  rownames(rates) <- rownames(conditions_overview)
  z_value <- qnorm(1 - alpha/2, mean = 0, sd = 1)

  compute_rate <- function(true_value, estimate, st_error) {
    mean(estimate - z_value * st_error <= true_value &
           estimate + z_value * st_error >= true_value)
  }

  for (cond in rownames(rates)) {
    for (para in parameters) {
      rates[cond, para] <- compute_rate(
        true_value = conditions_overview[cond, para],
        estimate = estimates[cond, para, ],
        st_error = estimates[cond, paste0("SE_", para), ]
        )
    }
  }

  return(rates)
}

inspect_SE_performance <- function() {
  # Computes the correlation between a) the standard deviations
  # of the estimates for a phi parameter within each condition
  # (i.e., the empirical standard error) and b) the means of the
  # estimated standard errors within each condition. When the
  # estimation method performs well, this correlation should be
  # very high.
  sd_estimates_phi <- apply(
    estimates[, c("phi00", "phi01", "phi10", "phi11"), ],
    MARGIN = c(1, 2), FUN = sd
    )
  mean_estimates_SE <- apply(
    estimates[, c("SE_phi00", "SE_phi01", "SE_phi10", "SE_phi11"), ],
    MARGIN = c(1, 2), FUN = mean
  )

  return(diag(cor(sd_estimates_phi, mean_estimates_SE)))
}

compute_model_selections_ic <- function() {
  methods <- c("aic", "bic", "aicc", "aiccp")
  results <- matrix(NA, nrow = nrow(conditions_overview), ncol = length(methods))
  rownames(results) <- rownames(conditions_overview)
  colnames(results) <- methods

  get_selection_ic <- function(true_model) {
    ics_hystar <- ests[paste0(ic, "_hystar"), ]
    ics_tar <- ests[paste0(ic, "_tar"), ]
    choices <- ifelse(ics_hystar < ics_tar, yes = "hystar", no = "tar")

    return(mean(choices == true_model))
  }

  for (i in rownames(results)) {
    ests <- estimates[i, , ]
    for (ic in methods) {
      results[i, ic] <- get_selection_ic(true_models[i])
    }
  }

  return(results)
}

compute_model_selections_lbox <- function(alpha = 0.05) {
  results <- matrix(NA, nrow = nrow(conditions_overview), ncol = 5)
  rownames(results) <- rownames(conditions_overview)
  colnames(results) <- c("correct", "wrong", "undecided", "precision", "n_positives")

  get_selection_lbox <- function(true_model, alpha) {
    choose_model_with_lbox <- function(p_values, alpha) {
      choose_hystar <- p_values["lbox_hystar"] > alpha
      choose_tar <- p_values["lbox_tar"] > alpha
      if ((choose_hystar && choose_tar) || (!choose_hystar && !choose_tar)) {
        return("undecided")
      } else {
        return(c("hystar", "tar")[c(choose_hystar, choose_tar)])
      }
    }
    choices <- apply(ests[c("lbox_hystar", "lbox_tar"), ],
                     MARGIN = 2, FUN = choose_model_with_lbox, alpha = alpha)
    correct <- mean(choices == true_model)
    undecided <- mean(choices == "undecided")
    wrong <- round(1 - correct - undecided, 3)
    precision <- mean((choices == true_model)[choices == "hystar"])
    n_positives <- sum(choices == "hystar")

    return(c(correct, wrong, undecided, precision, n_positives))
  }

  for (i in rownames(results)) {
    ests <- estimates[i, , ]
    results[i, ] <- get_selection_lbox(true_models[i], alpha)
  }

  return(results)
}







