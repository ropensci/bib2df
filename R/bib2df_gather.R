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

other_allowed_fields <- c(
  "AFFILIATION",
  "ABSTRACT",
  "DOI",
  "EID",
  "FILE",
  "CONTENTS",
  "COPYRIGHT",
  "COLLABORATOR",
  "ISBN",
  "ISSN",
  "KEYWORDS",
  "LANGUAGE",
  "LOCATION",
  "LCCN",
  "MRNUMBER",
  "PMC",
  "PMID",
  "PRICE",
  "SIZE",
  "TRANSLATOR",
  "URL",
  "AUTHOR_KEYWORDS"
)

#' Parse a single BibTeX entry
#'
#' @param entry (char) a BibTeX entry
#' @importFrom stringr str_extract_all
#' @importFrom stringr str_extract
#' @importFrom stringr str_split_fixed
#' @importFrom stringr str_remove

parse_entry <- function(entry) {
  entry <- paste(entry, collapse = " ")

  category <- str_extract(entry, "(?<=@)[^\\{]+")

  key <- str_extract(entry, "(?<=\\{)[^,]*")

  # remove the leading @category and key
  fields_prep <- sub(paste0("^@", category, "\\{", key, ","), "", entry) %>%
    trimws()

  field_names <- str_extract_all(fields_prep, "\\b\\w+(?=\\s*=)")[[1]]
  field_names <- field_names[tolower(field_names) %in% c(tolower(colnames(empty)), tolower(other_allowed_fields))]
  values <- list()
  # loop through each name to extract the data
  for (i in seq_along(field_names)) {
    name <- field_names[i]

    if (i < length(field_names)){
      next_name <- field_names[i + 1]
      pattern <- paste0(name, '\\s*=\\s*(.+?)', "(?=", next_name, ")")
      eoe <- FALSE
    } else {
      pattern <- paste0(name, '\\s*=\\s*(.+?)\\s*\\}$')
      eoe <- TRUE
    }

    value <- str_extract(fields_prep, pattern)

    value_clean <- str_remove(value, paste0(name, '\\s*=\\s*'))
    if (eoe) {
      value_clean <- gsub("\\}$", "", value_clean)
    }

    values[[name]] <- value_clean
  }

  # bit of a mess here trying to clean up all that might remain
  values <- lapply(values, trimws)
  values <- lapply(values, text_between_curly_brackets)
  values <- lapply(values, text_between_quotes)
  values <- lapply(values, trimws)
  values <- lapply(values, function(x) {gsub(",$", "", x)})

  # combine data into a named list
  entry_data <- c(CATEGORY = toupper(category), BIBTEXKEY = key, setNames(values, toupper(names(values))))

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

