#' @export bib2df_tidy
#' @import dplyr
bib2df_tidy <- function(bib) {
  if (sum(c("Title", "title") %in% colnames(bib)) == 2) {
    bib <- bib %>%
      mutate(Title = ifelse(is.na(Title), title, Title)) %>%
      select(-title)
  }

  # if ("Author" %in% colnames(bib)) {
  #   bib$Author <- strsplit(bib$Author, " and ", fixed = T)
  # }
  # if ("Editor" %in% colnames(bib)) {
  #   bib$Editor <- strsplit(bib$Editor, " and ", fixed = T)
  # }
  # if ("Year" %in% colnames(bib)) {
  #   bib$Year <- as.numeric(bib$Year)
  # }
  return(bib)
}
