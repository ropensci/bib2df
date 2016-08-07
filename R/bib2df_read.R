#' @title Read a .bib file.
#' @description \code{bib2df_read()} reads a .bib file to a character vector.
#' @details \code{bib2df_read()} uses \code{base::readLines()} to read from a local .bib file. UTF-8 compatibility is ensured.
#' @param file character, path to a .bib file.
#' @return A character vector.
#' @author Philipp Ottolinger
#' @importFrom stringr str_replace_all
#' @export bib2df_read
#' @examples
#' path <- system.file("extdata", "biblio.bib", package = "bib2df")
#' bib <- bib2df_read(path)
#' bib
bib2df_read <- function(file) {
  bib <- readLines(file)
  bib <- str_replace_all(bib, "[^[:graph:]]", " ")
  return(bib)
}
