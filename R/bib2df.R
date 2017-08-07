#' @title Parse a BibTeX file to a \code{data.frame}
#' @description The BibTeX file is read, parsed, tidied and written to a \code{data.frame}
#' @details For simplicity \code{bib2df()} unifies the reading, parsing and tidying of a BibTeX file while being aware of a standardized output format, different BibTeX styles and missing values in the BibTeX file.
#' @param file character, path or URL to a .bib file.
#' @param separate_names logical, should authors' and editors' names be separated into first and given name?
#' @return A \code{tibble}.
#' @author Philipp Ottolinger
#' @examples
#' path <- system.file("extdata", "biblio.bib", package = "bib2df")
#' bib2df(path)
#' @seealso \code{\link{df2bib}}
#' @export
bib2df <- function(file, separate_names = FALSE) {
  bib <- bib2df_read(file)
  bib <- bib2df_gather(bib)
  bib <- bib2df_tidy(bib, separate_names)
  return(bib)
}
