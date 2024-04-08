#' @title Export a BibTeX \code{tibble} to a .bib file
#' @description The BibTeX \code{tibble} is written to a .bib file
#' @param x \code{tibble}, in the format as returned by \code{\link{bib2df}}.
#' @param file character, file path to write the .bib file. An empty character string writes to \code{stdout} (default).
#' @param append logical, if \code{TRUE} the \code{tibble} will be appended to an existing file.
#' @param allfields logical, if \code{TRUE} (default), the resulting bib output
#' will include all the BibTeX fields contained in the df object. If \code{FALSE}
#' only the fields with text will be included in the resulting bib object
#' @return \code{file} as a character string, invisibly.
#' @author Thomas J. Leeper
#' @author Gianluca Baio
#' @references \url{https://www.bibtex.org/Format/}
#' @examples
#' # Read from .bib file:
#' path <- system.file("extdata", "bib2df_testfile_3.bib", package = "bib2df")
#' bib <- bib2df(path)
#'
#' # Write to .bib file:
#' # bibFile <- tempfile()
#' # df2bib(bib, bibFile)
#'
#' # Use `append = TRUE` to add lines to an existing .bib file:
#' # df2bib(bib, bibFile, append = TRUE)
#' @seealso \code{\link{bib2df}}
#' @export
df2bib <- function(x, file = "", append = FALSE, allfields = TRUE) {

  if (!is.character(file)) {
    stop("Invalid file path: Non-character supplied.", call. = FALSE)
  }
  if (as.numeric(file.access(dirname(file), mode = 2)) != 0 && file != "") {
    stop("Invalid file path: File is not writeable.", call. = FALSE)
  }

  if (any({df_elements <- sapply(x$AUTHOR, inherits, "data.frame")})) {
    x$AUTHOR[df_elements] <- lapply(x$AUTHOR[df_elements], na_replace)
    x$AUTHOR[df_elements] <- lapply(x$AUTHOR[df_elements],
                       function(x) {
                         paste(x$last_name,
                               ", ",
                               x$first_name,
                               " ",
                               x$middle_name,
                               sep = "")
                         }
                       )
    x$AUTHOR[df_elements] <- lapply(x$AUTHOR[df_elements], trimws)
  }

  #names(x) <- capitalize(names(x))
  names(x) <- toupper(names(x))
  fields <- lapply(seq_len(nrow(x)), function(r) {
    rowfields <- rep(list(character(0)), ncol(x))
    names(rowfields) <- names(x)
    for (i in seq_along(rowfields)) {
      f <- x[[i]][r]
      if (is.list(f)) {
        f <- unlist(f)
      }
      rowfields[[i]] <- if (!length(f) | any(is.na(f))) {
          character(0L)
        } else if (names(x)[i] %in% c("AUTHOR", "EDITOR")) {
          paste(f, collapse = " and ")
        } else {
          paste0(f, collapse = ", ")
        }
    }
    rowfields <- rowfields[lengths(rowfields) > 0]
    rowfields <- rowfields[!names(rowfields) %in% c("CATEGORY", "BIBTEXKEY")]
    ######################################################################################
    # This only uses the non-empty fields for the bib file (adds '[nzchar(rowfields)]')
    # if 'allfields' is set to FALSE
    if(allfields) {
      paste0("  ",
             names(rowfields),
             " = {",
             unname(unlist(rowfields)),
             "}",
             collapse = ",\n")
    } else {
      paste0("  ",
             names(rowfields[nzchar(rowfields)]),
             " = {",
             unname(unlist(rowfields[nzchar(rowfields)])),
             "}",
             collapse = ",\n")
    }
    ######################################################################################
  })
  cat(paste0("@",
             capitalize(x$CATEGORY),
             "{",
             x$BIBTEXKEY,
             ",\n",
             unlist(fields),
             "\n}\n",
             collapse = "\n\n"),
      file = file,
      append = append)
  invisible(file)
}
