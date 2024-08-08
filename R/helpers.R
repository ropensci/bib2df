capitalize <- function(string) {
  paste0(substr(string, 1, 1),
         tolower(substr(string, 2, nchar(string))))
}

na_replace <- function(df) {
  df[is.na(df)] <- ""
  return(df)
}

text_between_curly_brackets <- function(string) {
  min <- min(gregexpr("\\{", string)[[1]])
  max <- max(gregexpr("\\}", string)[[1]])
  if (min == -1 | is.na(min)){
    return(string)
  } else {
    content <- substring(string, min + 1, max - 1)
  }
  return(content)
}

text_between_quotes <- function(string) {
  min <- min(gregexpr('\\"', string)[[1]])
  max <- max(gregexpr('\\"', string)[[1]])
  content <- substring(string, min + 1, max - 1)
  if (min == -1 | is.na(min)){
    return(string)
  } else {
    content <- substring(string, min + 1, max - 1)
  }
  return(content)
  return(content)
}
