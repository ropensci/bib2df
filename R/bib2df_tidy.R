#' @title Tidy a bib2df \code{data.frame}..
#' @description \code{bib2df_tidy()} aims to tidy a \code{data.frame}. resulting from \code{bib2df_gather()}.
#' @details If multiple Authors or Editors are supplied, the respective character string is split up into a list. The year of publication is converted to \code{as.numeric()}. The \code{CATEGORY} column moves to the very left of the tibble.
#' @param bib, resulting from \code{bib2df_gather()}.
#' @param separateNames logical, should authors' and editors' names be separated into first and given name?
#' @author Philipp Ottolinger
#' @return A \code{data.frame}.
#' @export bib2df_tidy
#' @import dplyr
#' @import humaniformat
#' @examples
#' path <- system.file("extdata", "biblio.bib", package = "bib2df")
#' bib <- bib2df_read(path)
#' bib <- bib2df_gather(bib)
#' bib <- bib2df_tidy(bib)
#' bib
bib2df_tidy <- function(bib, separateNames = c(FALSE, TRUE)) {
  AUTHOR <- EDITOR <- YEAR <- CATEGORY <- NULL
  if ("AUTHOR" %in% colnames(bib)) {
    bib <- bib %>%
      mutate(AUTHOR = strsplit(AUTHOR, " and ", fixed = T))
    if (separateNames) {
      bib$AUTHOR <- lapply(bib$AUTHOR, function(x) x %>% format_reverse() %>% format_period() %>% parse_names())
    }
  }
  if ("EDITOR" %in% colnames(bib)) {
    bib <- bib %>%
      mutate(EDITOR = strsplit(EDITOR, " and ", fixed = T))
    if (separateNames) {
      bib$EDITOR <- lapply(bib$EDITOR, function(x) x %>% format_reverse() %>% format_period() %>% parse_names())
    }
  }
  if ("YEAR" %in% colnames(bib)) {
    bib <- bib %>%
      mutate(YEAR = as.numeric(YEAR))
  }
  bib <- bib %>%
    select(CATEGORY, everything())
  return(bib)
}
