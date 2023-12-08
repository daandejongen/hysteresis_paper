pre_process_data <- function(data_spss_F, data_spss_I) {
  # 1. Selects the necessary columns/variables,
  # 2. Creates a variable with the log response time,
  # 3. Translates the Dutch variable names to English.
  select_columns <- c("rt", "pacc", "sessie")
  data <- rbind(data_spss_F[, select_columns],
                data_spss_I[, select_columns])
  colnames(data) <- c("response_time", "payoff_accuracy", "session_number")
  data$participant <- c(rep("F", times = nrow(data_spss_F)),
                        rep("I", times = nrow(data_spss_I)))
  data$log_response_time <- log(data$response_time)
  data <- data[, c(4, 5, 1, 2, 3)]

  return(data)
}

# Warning message about duplicated levels can be ignored
data_spss_F <- foreign::read.spss("speed_accuracy_trade_off/data_raw/acc_rt_1.sav",
                             to.data.frame = TRUE)
data_spss_I <- foreign::read.spss("speed_accuracy_trade_off/data_raw/acc_rt_2.sav",
                             to.data.frame = TRUE)

SAT_data <- pre_process_data(data_spss_F, data_spss_I)
write.csv(SAT_data,
          file = "speed_accuracy_trade_off/data_processed/SAT_data.csv",
          row.names = FALSE)

