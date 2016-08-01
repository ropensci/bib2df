bib2df_gather2 <- function(bib, keys) {
  items <- sapply(keys, function(x) bib2df_scrape(bib, x))
  items <- rbind.fill(items)
  items <- as_data_frame(items)
  return(items)
}
