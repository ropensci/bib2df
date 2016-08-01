bib2df_explore <- function(bib) {
  keys <- unique(str_extract(bib, "(?<=@).*(?=\\{)")[!is.na(str_extract(bib, "(?<=@).*(?=\\{)"))])
  return(keys)
}
