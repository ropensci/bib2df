#' @title Export a BibTeX \code{data.frame} to a .bib file
#' @description The BibTeX \code{data.frame} is written to a .bib file
#' @param x \code{data.frame}, returned by \code{\link{df2bib}}.
#' @param file character, path to a .bib file.
#' @param append logical, if \code{TRUE} the \code{data.frame} will be appended to an existing file.
#' @return \code{file} as a character string, invisibly.
#' @author Thomas J. Leeper
#' @references \url{http://www.bibtex.org/Format/}
#' @examples
#' path <- system.file("extdata", "biblio.bib", package = "bib2df")
#' bib <- bib2df(path)
#' df2bib(bib, bib2 <- tempfile())
#' identical(bib, bib2df(bib2))
#' @seealso \code{\link{bib2df}}
#' @export
df2bib <- function(x, file, append = FALSE) {

  if(!is.character(file)) {
    stop("Invalid file path: Non-character supplied.", call. = FALSE)
  }
  if (as.numeric(file.access(dirname(file), mode = 2)) != 0) {
    stop("Invalid file path: File is not writeable.", call. = FALSE)
  }

  if (class(x$AUTHOR[[1]]) == "data.frame") {
    x$AUTHOR <- lapply(x$AUTHOR, na_replace)
    x$AUTHOR <- lapply(x$AUTHOR,
                       function(x) {
                         paste(x$last_name,
                               ", ",
                               x$first_name,
                               " ",
                               x$middle_name,
                               sep = "")
                         }
                       )
    x$AUTHOR <- lapply(x$AUTHOR, trimws)
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
    paste0("  ",
           names(rowfields),
           " = {",
           unname(unlist(rowfields)),
           "}",
           collapse = ",\n")
  })
  cat(paste0("@",
             capitalize(x$Category),
             "{",
             x$Bibtexkey,
             ",\n",
             unlist(fields),
             "\n}\n",
             collapse = "\n\n"),
      file = file,
      append = append)
  invisible(file)
}
