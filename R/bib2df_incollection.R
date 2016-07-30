bib2df_incollection <- function(bib) {
  matches <- "@InCollection"
  df <- bib2df_scrape(bib, matches)
  return(df)
}
