#' @importFrom stringr str_extract
#' @export bib2df_explore
bib2df_explore <- function(bib) {
  keys <- unique(str_extract(bib, "(?<=@).*(?=\\{)")[!is.na(str_extract(bib, "(?<=@).*(?=\\{)"))])
  s <- c("Article", "article", "book", "Book", "InBook", "inbook", "InCollection", "incollection")
  keys <- keys[keys %in% s]
  return(keys)
}
