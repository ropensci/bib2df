#' @title Parse a BibTeX file to a tibble.
#' @description The BibTeX file is read, parsed, tidied and written to a tibble.
#' @details Uses the internal \code{bib2df_read()}, \code{bib2df_gather()} and \code{bib2df_tidy()}. No magic, just a wrapper.
#' @param file character, path to a .bib file.
#' @return A tibble.
#' @author Philipp Ottolinger
#' @export bib2df
#' @examples
#' path <- system.file("extdata", "biblio.bib", package = "bib2df")
#' bib2df(path)
bib2df <- function(file) {
  bib <- bib2df_read(file)
  bib <- bib2df_gather(bib)
  bib <- bib2df_tidy(bib)
  return(bib)
}
