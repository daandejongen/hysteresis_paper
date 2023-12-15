fit <- function(data, participant, session, tar) {
  data <- data[data$participant == participant & data$session == session,
               c("log_response_time", "payoff_accuracy")]
  return(hystar_fit(data, d = 0, tar = tar))
}
