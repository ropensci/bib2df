bib2df_book <- function(bib) {
  matches <- c("@Book", "@book")
  df <- bib2df_scrape(bib, matches)
  return(df)
}
