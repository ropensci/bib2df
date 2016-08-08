#' @title Parse a .bib file.
#' @description \code{bib2df_gather} parses a .bib file and returns each BibTeX-item as a row in a tibble.
#' @details \code{bib2df_gather} extracts the BibTeX entry types, fields and the respective values. Each item is presented as a row in a data_frame whereas the entry type (column \code{CATEGORY}) is added to each row.
#' @param bib, a character vector resulting from \code{bib2df_read()}.
#' @return A tibble.
#' @author Philipp Ottolinger
#' @importFrom stringr str_match
#' @importFrom stringr str_extract
#' @importFrom plyr rbind.fill
#' @importFrom stats complete.cases
#' @export bib2df_gather
#' @examples
#' path <- system.file("extdata", "biblio.bib", package = "bib2df")
#' bib <- bib2df_read(path)
#' bib <- bib2df_gather(bib)
bib2df_gather <- function(bib) {
  from <- which(!is.na(str_match(bib, "@")))
  to  <- c(from[-1], length(bib))
  if (length(from) > 1) {
    items <- mapply(function(x,y) return(bib[x:y]), x = from, y = to - 1)
    keys <- lapply(items, function(x) str_extract(x[1], "(?<=@).*(?=\\{)"))
    keys <- lapply(keys, toupper)
    categories <- lapply(items, function(x) str_extract(x, ".+?(?==)"))
    categories <- lapply(categories, trimws)
    values <- lapply(items, function(x) str_extract(x, "(?<==).*"))
    values <- lapply(values, function(x) str_extract(x, "(?<=[\"\\{]).*"))
    values <- lapply(values, function(x) str_extract(x, ".*(?=[\"\\}])"))
    values <- lapply(values, trimws)
    items <- mapply(cbind, categories, values)
    items <- lapply(items, function(x) x <- cbind(toupper(x[,1]), x[,2]))
    items <- lapply(items, function(x) x[complete.cases(x),])
    items <- mapply(function(x,y) rbind(x, c("CATEGORY", y)), x = items, y = keys)
    items <- lapply(items, t)
    items <- lapply(items, function(x) { colnames(x) <- x[1,]; x <- x[-1,]; return(x) })
    items <- lapply(items, function(x) {x <- t(x); x <- data.frame(x, stringsAsFactors = F); return(x) } )
    df <- rbind.fill(items)
    df <- as_data_frame(df)
  }
  return(df)
}
