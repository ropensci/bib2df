#' @importFrom stringr str_replace_all
#' @export bib2df_read
bib2df_read <- function(file) {
  bib <- readLines(file)
  bib <- str_replace_all(bib, "[^[:graph:]]", " ")
  return(bib)
}
