#' @importFrom stringr str_extract
#' @importFrom tibble as_data_frame
#' @importFrom plyr rbind.fill
#' @export bib2df_scrape
bib2df_scrape <- function(bib, matches) {
  from <- which(!is.na(str_match(bib,paste("@",matches, sep=""))))
  #to <- which(bib == "}")
  to <- which(!is.na(str_match(bib, "@")))
  to <- c(to, length(bib))
  to <- sapply(from, function(x) min(to[to>x]))
  if (length(to) < 1) {
    break
  } else if (length(to) == 1) {
    raw <- bib[from:to]
    raw <- raw[2:(length(raw)-1)]
    categories <- str_extract(raw, ".+?(?==)")
    categories <- trimws(categories)
    values <- str_extract(raw, "(?<==).*")
    values <- str_extract(values, "(?<=\\{).*")
    values <- str_extract(values, ".*(?=\\})")
    values <- trimws(values)
    items <- data.frame(categories, values, stringsAsFactors = F)
    colnames(items) <- c("Categories", "Values")
    items <- data.frame(t(items), stringsAsFactors = F)
    colnames(items) <- items[1,]
    items <- items[-1,]
    df <- as_data_frame(items, validate = F)
  } else {
    raw <- mapply(function(x,y) return(bib[x:y]), x = from, y = to)
    raw <- lapply(raw, function(x) x[2:(length(x)-1)])
    categories <- lapply(raw, function(x) str_extract(x, ".+?(?==)"))
    categories <- lapply(categories, trimws)
    values <- lapply(raw, function(x) str_extract(x, "(?<==).*"))
    values <- lapply(values, function(x) str_extract(x, "(?<=[\"\\{]).*"))
    values <- lapply(values, function(x) str_extract(x, ".*(?=[\"\\}])"))
    values <- lapply(values, trimws)
    items <- mapply(data.frame, categories, values, SIMPLIFY = F)
    items <- lapply(items, function(x) {names(x) <- c("Categories", "Values"); return(x)})
    items <- lapply(items, t)
    items <- lapply(items, data.frame)
    items <- lapply(items, function(x) sapply(x, as.character))
    items <- lapply(items, function(x) data.frame(x, stringsAsFactors = F))
    items <- lapply(items, function(x) {colnames(x) <- x[1,]; x <- x[-1,]; return(x)})
    items <- lapply(items, data.frame)
    df <- rbind.fill(items)
    df <- as_data_frame(df)
  }
  return(df)
}
