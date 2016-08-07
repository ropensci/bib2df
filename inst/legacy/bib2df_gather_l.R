bib2df_gather <- function(bib) {
  article <- bib2df_article(bib)
  article$Category <- "Article"
  book <- bib2df_book(bib)
  book$Category <- "Book"
  incollection <- bib2df_incollection(bib)
  incollection$Category <- "InCollection"
  inbook <- bib2df_inbook(bib)
  inbook$Category <- "InBook"
  items <- rbind.fill(list(article, book, incollection, inbook))
  items <- as_data_frame(items)
  return(items)
}
