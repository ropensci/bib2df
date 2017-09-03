#' @importFrom dplyr "%>%"
#' @importFrom dplyr mutate
#' @importFrom dplyr select
#' @importFrom humaniformat format_reverse
#' @importFrom humaniformat format_period
#' @importFrom humaniformat parse_names

bib2df_tidy <- function(bib, separate_names = FALSE) {

  if (dim(bib)[1] == 0) {
    return(bib)
  }

  AUTHOR <- EDITOR <- YEAR <- CATEGORY <- NULL
  if ("AUTHOR" %in% colnames(bib)) {
    bib <- bib %>%
      mutate(AUTHOR = strsplit(AUTHOR, " and ", fixed = TRUE))
    if (separate_names) {
      bib$AUTHOR <- lapply(bib$AUTHOR, function(x) x %>%
                             format_reverse() %>%
                             format_period() %>%
                             parse_names())
    }
  }
  if ("EDITOR" %in% colnames(bib)) {
    bib <- bib %>%
      mutate(EDITOR = strsplit(EDITOR, " and ", fixed = TRUE))
    if (separate_names) {
      bib$EDITOR <- lapply(bib$EDITOR, function(x) x %>%
                             format_reverse() %>%
                             format_period() %>%
                             parse_names())
    }
  }
  if ("YEAR" %in% colnames(bib)) {
    if (sum(is.na(as.numeric(bib$YEAR))) == 0) {
      bib <- bib %>%
        mutate(YEAR = as.numeric(YEAR))
    } else {
      message("Column `YEAR` contains character strings.
              No coercion to numeric applied.")
    }
  }
  bib <- bib %>%
    select(CATEGORY, dplyr::everything())
  return(bib)
}
