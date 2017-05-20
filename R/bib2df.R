#' @title Parse a BibTeX file to a \code{data.frame}..
#' @description The BibTeX file is read, parsed, tidied and written to a \code{data.frame}..
#' @details Uses the internal \code{bib2df_read()}, \code{bib2df_gather()} and \code{bib2df_tidy()}. No magic, just a wrapper.
#' @param file character, path to a .bib file.
#' @param separateNames logical, should authors' and editors' names be separated into first and given name?
#' @return A \code{data.frame}.
#' @author Philipp Ottolinger
#' @examples
#' path <- system.file("extdata", "biblio.bib", package = "bib2df")
#' bib2df(path)
#' @seealso \code{\link{df2bib}}
#' @export
bib2df <- function(file, separateNames = c(FALSE, TRUE)) {
  bib <- bib2df_read(file)
  bib <- bib2df_gather(bib)
  bib <- bib2df_tidy(bib, separateNames)
  return(bib)
}
