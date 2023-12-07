fit <- function(data, session, tar) {
  # A function to fit the hystar model given the SAT-data
  select_session <- data["sessie"] == session
  participant <- substr(deparse(substitute(data)), start = 6, stop = 6)
  y <- log(data[select_session, "rt"])
  z <- data[select_session, "pacc"]
  fit <- hystar_fit(data.frame(y, z), d = 0:1, tar = tar)

  return(fit)
}




