capitalize <- function(string) {
  paste0(substr(string, 1, 1),
         tolower(substr(string, 2, nchar(string))))
}

na_replace <- function(df) {
  df[is.na(df)] <- ""
  return(df)
}
