# The "workers" are functions that do things like fit the model within an
# iteration, extract model results and store them appropriately, do all iterations
# within a given condition.

get_estimates <- function(condition_values) {
  generated_data <- generate_zy(condition_values)
  fit_hystar     <- hystar_fit(generated_data, tar = FALSE)
  fit_tar        <- hystar_fit(generated_data, tar = TRUE)
  rm(generated_data)

  return(c(extract_parameter_estimates(fit_hystar),
           extract_ics(fit_hystar),
           extract_ljung_box_pvalue(fit_hystar),
           extract_ics(fit_tar),
           extract_ljung_box_pvalue(fit_tar)))
}

generate_zy <- function(condition_values) {
  z <- z_sim(n_t = condition_values["n_t"], n_switches = condition_values["n_switches"])
  sim <- hystar_sim(z = z,
                    r = condition_values[c("r0", "r1")],
                    d = 0,
                    phi_R0 = condition_values[c("phi00", "phi01")],
                    phi_R1 = condition_values[c("phi10", "phi11")])

  return(sim$data[, c("y", "z")])
}

extract_parameter_estimates <- function(fitted_hystar_object) {
  return(c(fitted_hystar_object$coefficients,
           fitted_hystar_object$thresholds,
           fitted_hystar_object$resvar,
           fitted_hystar_object$st_errors))
}

extract_ics <- function(fitted_hystar_object) {
  threshold_penalty <- if (fitted_hystar_object$tar) 6 else 12
  aic_cp <- unname(fitted_hystar_object$ic["aic"] + threshold_penalty)
  ics <- c(fitted_hystar_object$ic, "aiccp" = aic_cp)

  if (fitted_hystar_object$tar) names(ics) <- paste0(names(ics), "_tar")
  if (!fitted_hystar_object$tar) names(ics) <- paste0(names(ics), "_hystar")

  return(ics)
}

extract_ljung_box_pvalue <- function(fitted_hystar_object) {
  pvalue <- Box.test(fitted_hystar_object$residuals_st, type = "Ljung-Box")$p.value
  names(pvalue) <- if (fitted_hystar_object$tar) "lbox_tar" else "lbox_hystar"

  return(pvalue)
}


