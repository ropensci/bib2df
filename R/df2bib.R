#' @title Export a BibTeX data.frame to a .bib file.
#' @description The BibTeX data.frame is written to a .bib file
#' @param x data.frame, returned by \code{\link{df2bib}}.
#' @param file character, path to a .bib file.
#' @return \code{file} as a character string, invisibly.
#' @author Thomas J. Leeper
#' @examples
#' path <- system.file("extdata", "biblio.bib", package = "bib2df")
#' bib <- bib2df(path)
#' df2bib(bib, bib2 <- tempfile())
#' identical(bib, bib2df(bib2))
#' @seealso \code{\link{bib2df}}
#' @export
df2bib <- function(x, file) {
  capitalize <- function(string) {
    paste0(substr(string, 1, 1),
           tolower(substr(string, 2, nchar(string) )))
  }
  names(x) <- capitalize(names(x))
  fields <- lapply(seq_len(nrow(x)), function(r) {
    rowfields <- rep(list(character(0)), ncol(x))
    names(rowfields) <- names(x)
    for (i in seq_along(rowfields)) {
      f <- x[[i]][r]
      if (is.list(f)) {
        f <- unlist(f)
      }
      rowfields[[i]] <- if (!length(f) || is.na(f)) {
          character(0L)
        } else if (names(x)[i] %in% c("Author", "Editor")) {
          paste(f, collapse = " and ")
        } else {
          paste0(f, collapse = ", ")
        }
    }
    rowfields <- rowfields[lengths(rowfields) > 0]
    rowfields <- rowfields[!names(rowfields) %in% c("Category", "Bibtexkey")]
    paste0("  ", names(rowfields), " = {", unname(unlist(rowfields)), "}", collapse = ",\n")
  })
  cat(paste0("@", capitalize(x$Category), "{", x$Bibtexkey, ",\n", unlist(fields), "\n}\n", collapse = "\n\n"), file = file)
  invisible(file)
}
