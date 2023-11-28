hystar_is_preferred <- function(hystar, tar) {
  result <- Box.test(hystar$residuals_st, type = "L")$p.value > .05 &
    Box.test(tar$residuals_st, type = "L")$p.value <= .05

  return(result)
}


