create_table_small <- function(rows_var_1, rows_var_2,
                               cols_var_1,
                               parameters,
                               outcomes, r1,
                               round_by = 2) {
  select_rows <- conditions_overview[, "r1"] == r1
  outcomes <- outcomes[select_rows, ]

  levels_col_1 <- unique(conditions_overview[, cols_var_1])
  levels_row_1 <- unique(conditions_overview[, rows_var_1])
  levels_row_2 <- unique(conditions_overview[, rows_var_2])

  output_matrix <- matrix(
    NA,
    nrow = length(levels_row_1) * length(levels_row_2),
    ncol = length(levels_col_1) * length(parameters)
  )
  colnames(output_matrix) <- combine_2labels(levels_col_1, parameters)
  rownames(output_matrix) <- combine_2labels(levels_row_1, levels_row_2)

  for (col_1 in levels_col_1) {
    for (row_1 in levels_row_1) {
      for (row_2 in levels_row_2) {
        col <- paste(col_1, parameters, sep = "-")
        row <- paste(row_1, row_2, sep = "-")
        outcome_row <- conditions_overview[select_rows, rows_var_1] == row_1 &
          conditions_overview[select_rows, rows_var_2] == row_2 &
          conditions_overview[select_rows, cols_var_1] == col_1
        output_matrix[row, col] <- outcomes[outcome_row, parameters]
      }
    }
  }

  return(round(output_matrix, round_by))
}

create_table <- function(rows_var_1, rows_var_2,
                         cols_var_1, cols_var_2,
                         parameters,
                         outcomes,
                         round_by = 2) {
  levels_col_1 <- unique(conditions_overview[, cols_var_1])
  levels_col_2 <- unique(conditions_overview[, cols_var_2])
  levels_row_1 <- unique(conditions_overview[, rows_var_1])
  levels_row_2 <- unique(conditions_overview[, rows_var_2])

  output_matrix <- matrix(
    NA,
    nrow = length(levels_row_1) * length(levels_row_2),
    ncol = length(levels_col_1) * length(levels_col_2) * length(parameters)
  )
  colnames(output_matrix) <- combine_3labels(levels_col_1, levels_col_2, parameters)
  rownames(output_matrix) <- combine_2labels(levels_row_1, levels_row_2)

  for (col_1 in levels_col_1) {
    for (col_2 in levels_col_2) {
      for (row_1 in levels_row_1) {
        for (row_2 in levels_row_2) {
          col <- paste(col_1, col_2, parameters, sep = "-")
          row <- paste(row_1, row_2, sep = "-")
          outcome_row <- conditions_overview[, rows_var_1] == row_1 &
            conditions_overview[, rows_var_2] == row_2 &
            conditions_overview[, cols_var_1] == col_1 &
            conditions_overview[, cols_var_2] == col_2
          output_matrix[row, col] <- outcomes[outcome_row, parameters]
        }
      }
    }
  }

  return(round(output_matrix, round_by))
}

join_tables <- function(table1, table2, names) {
  # Function to join tables in a way that column 1:2
  # of the output table are column 1:2 of table 1 and
  # column 3:4 of the output table are column 1:2 of table 2, etc.
  if (!all(dim(table1) == dim(table2)))
    stop("Tables must have same dimensions.")
  if (length(names) != 2)
    stop("There can only be 2 names.")

  output_table <- matrix(NA, nrow = nrow(table1), ncol = 2 * ncol(table1))
  rownames(output_table) <- rownames(table1)
  colnames(output_table) <- 1:ncol(output_table)

  indices_in  <- matrix(1:ncol(table1), ncol = 2, byrow = TRUE)
  indices_out <- matrix(1:ncol(output_table), ncol = 4, byrow = TRUE)

  for (i in 1:(ncol(table1)/2)) {
    output_table[, indices_out[i, ]] <- c(
      table1[, indices_in[i, ]],
      table2[, indices_in[i, ]])
    colnames(output_table)[indices_out[i, ]] <-
      paste(rep(colnames(table1)[indices_in[i, ]], times = 2),
            rep(names, each = 2),
            sep = "-")
  }

  return(output_table)
}


combine_2labels <- function(first, second) {
  paste(
    rep(first, each = length(second)),
    rep(second, times = length(first)),
    sep = "-"
    )
}
combine_3labels <- function(first, second, third) {
  paste(
    rep(first, each = length(second) * length(third)),
    rep(second, times = length(first), each = length(third)),
    rep(third, times = length(first) * length(second)),
    sep = "-"
  )
}
combine_4labels <- function(first, second, third, fourth) {
  paste(
    rep(first, each = length(second) * length(third) * length(fourth)),
    rep(second, times = length(first), each = length(third) * length(fourth)),
    rep(third, times = length(first) * length(second), each = length(fourth)),
    rep(fourth, times = length(first) * length(second) * length(fourth)),
    sep = "-"
  )
}
