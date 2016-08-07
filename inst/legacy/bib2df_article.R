bib2df_article <- function(bib) {
  matches <- c("@Article", "@article")
  df <- bib2df_scrape(bib, matches)
  return(df)
}
