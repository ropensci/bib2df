#' Tidy up data frame
#'
#' Trims ws of all fields, removes extra braces in double bracing situations,
#' and tidy up editor, author, and year fields.
#'
#' @param bib (data.frame) dataframe of .bib document
#' @param separate_names (logical) whether to separate names in author and editor fields
#'
#' @importFrom dplyr "%>%"
#' @importFrom dplyr mutate
#' @importFrom dplyr select
#' @importFrom dplyr across
#' @importFrom dplyr where
#' @importFrom humaniformat format_reverse
#' @importFrom humaniformat format_period
#' @importFrom humaniformat parse_names
#' @importFrom stringr str_detect
#' @importFrom stringr str_sub

bib2df_tidy <- function(bib, separate_names = FALSE) {

  if (dim(bib)[1] == 0) {
    return(bib)
  }

  bib <- bib %>%
    mutate(across(where(~ is.character(.) & length(.) == 1), ~ ifelse(
      str_detect(., "^\\{.*\\}$"),
      str_sub(., 2, -2),
      .
    )))

  AUTHOR <- EDITOR <- YEAR <- CATEGORY <- NULL
  if ("AUTHOR" %in% colnames(bib)) {
    bib <- bib %>%
      mutate(AUTHOR = ifelse(!is.na(AUTHOR), strsplit(AUTHOR, " and ", fixed = TRUE), NA))
    if (separate_names) {
      bib$AUTHOR <- lapply(bib$AUTHOR, function(x) x %>%
                             format_reverse() %>%
                             format_period() %>%
                             parse_names())
    }
  }
  if ("EDITOR" %in% colnames(bib)) {
    bib <- bib %>%
      mutate(EDITOR = ifelse(!is.na(EDITOR), strsplit(EDITOR, " and ", fixed = TRUE), NA))
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
