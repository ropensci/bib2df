#' export bib2df_tidy
bib2df_tidy <- function(bib) {
  if ("Author" %in% colnames(bib)) {
    bib$Author <- strsplit(bib$Author, " and ", fixed = T)
  }
  if ("Editor" %in% colnames(bib)) {
    bib$Editor <- strsplit(bib$Editor, " and ", fixed = T)
  }
  if ("Year" %in% colnames(bib)) {
    bib$Year <- as.numeric(bib$Year)
  }
  return(bib)
}
