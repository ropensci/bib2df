bib2df_inbook <- function(bib) {
  matches <- "@InBook"
  df <- bib2df_scrape(bib, matches)
  return(df)
}
