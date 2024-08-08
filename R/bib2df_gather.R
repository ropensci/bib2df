#' Parse and gather the BibTex entries into a data.frame
#'
#' @param bib (char) BibTeX doc as a string
#'
#' @importFrom stringr str_detect
#' @importFrom dplyr bind_rows
#' @importFrom dplyr as_tibble
#' @importFrom stats setNames
bib2df_gather <- function(bib) {
  from <- which(str_detect(bib, "^@"))
  to <- c(from[-1] - 1, length(bib))

  entries <- parse_entries(bib, from, to)
  dat <- bind_rows(c(list(empty), entries))
  dat <- as_tibble(dat)
  return(dat)
}

empty <- tibble::tibble(
  CATEGORY = character(0L),
  BIBTEXKEY = character(0L),
  ADDRESS = character(0L),
  ANNOTE = character(0L),
  AUTHOR = character(0L),
  BOOKTITLE = character(0L),
  CHAPTER = character(0L),
  CROSSREF = character(0L),
  EDITION = character(0L),
  EDITOR = character(0L),
  HOWPUBLISHED = character(0L),
  INSTITUTION = character(0L),
  JOURNAL = character(0L),
  KEY = character(0L),
  MONTH = character(0L),
  NOTE = character(0L),
  NUMBER = character(0L),
  ORGANIZATION = character(0L),
  PAGES = character(0L),
  PUBLISHER = character(0L),
  SCHOOL = character(0L),
  SERIES = character(0L),
  TITLE = character(0L),
  TYPE = character(0L),
  VOLUME = character(0L),
  YEAR = character(0L),
  stringsAsFactors = FALSE
)


#' Parse a single BibTeX entry
#'
#' @param entry (char) a BibTeX entry
#' @importFrom stringr str_extract_all
#' @importFrom stringr str_extract
#' @importFrom stringr str_split_fixed

parse_entry <- function(entry) {
  entry <- paste(entry, collapse = " ")

  category <- str_extract(entry, "(?<=@)[^\\{]+")

  key <- str_extract(entry, "(?<=\\{)[^,]+")

  # Remove the leading @category, key, and trailing brace
  fields_prep <- sub(paste0("^@", category, "\\{", key, ","), "", entry)
  fields_prep <- sub("\\}$", "", fields_prep)

  # extract fields and split on first equal sign
  fields <- str_extract_all(entry, "(?<=[,\\s])\\w+\\s*=\\s*(\\{[^{}]*(?:\\{[^{}]*\\}[^{}]*)*\\}|\"[^\"]*\")")[[1]]
  fields <- str_split_fixed(fields, "\\s*=\\s*", n = 2)


  # create named vector for fields and values, removing curly braces
  values <- fields[, 2]
  values <- lapply(values, text_between_curly_brackets)
  names(values) <- toupper(fields[, 1])

  # combine data into a named list
  entry_data <- c(CATEGORY = toupper(category), BIBTEXKEY = key, setNames(values, names(values)))

  return(entry_data)
}

#' Parse all BibTeX entries
#'
#' @param bib (char) BibTeX doc as a string
#' @param from (int) list of line numbers where each entry starts
#' @param to (int) list of line numbers where each entry ends

parse_entries <- function(bib, from, to) {
  if (all(is.na(from)) | all(is.na(to))) {
    return(list())
  }
  entries <- mapply(function(x, y) {
    entry <- bib[x:y]
    parse_entry(entry)
  }, from, to, SIMPLIFY = FALSE)
  return(entries)
}

