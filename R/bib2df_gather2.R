#' @importFrom plyr rbind.fill
#' @importFrom tibble as_data_frame
#' @export bib2df_gather2
bib2df_gather2 <- function(bib, keys) {
  items <- sapply(keys, function(x) bib2df_scrape(bib, x))
  items <- rbind.fill(lapply(items, data.frame))
  items <- as_data_frame(items)
  return(items)
}
