#' @title Parse a BibTeX file to a \code{data.frame}
#' @description The BibTeX file is read, parsed, tidied and written to a \code{data.frame}
#' @details For simplicity \code{bib2df()} unifies the reading, parsing and tidying of a BibTeX file while being aware of a standardized output format, different BibTeX styles and missing values in the BibTeX file.
#' @details When \code{separate_names = TRUE}, the respective columns contain a \code{data.frame} for each row. When \code{FALSE}, the respective columns contain character strings.
#' @param file character, path or URL to a .bib file.
#' @param separate_names logical, should authors' and editors' names be separated into first and given name?
#' @return A \code{tibble}.
#' @author Philipp Ottolinger
#' @examples
#' # Read from .bib file:
#' path <- system.file("extdata", "biblio.bib", package = "bib2df")
#' bib <- bib2df(path)
#' str(bib)
#'
#' # Read from .bib file and separate authors' and editors' names:
#' bib <- bib2df(path, separate_names = TRUE)
#' str(bib)
#' @seealso \code{\link{df2bib}}
#' @export
bib2df <- function(file, separate_names = FALSE) {
  bib <- bib2df_read(file)
  bib <- bib2df_gather(bib)
  bib <- bib2df_tidy(bib, separate_names)
  return(bib)
}
