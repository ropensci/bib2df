#' @importFrom stringr str_replace_all

bib2df_read <- function(file) {
  bib <- readLines(file)
  bib <- str_replace_all(bib, "[^[:graph:]]", " ")
  bib <- str_replace_all(bib, "=", " = ") # add desired spaces
  bib <- str_replace_all(bib, "  ", " ")   # remove double spaces in case you have it
  return(bib)
}
