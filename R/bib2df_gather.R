#' Parse and gather the BibTex entries into a data.frame
#'
#' @param bib (char) BibTeX doc as a string
#' @param extra_fields (char) A list of additional fields to parse, passed from `bib2df()`
#'
#' @importFrom stringr str_detect
#' @importFrom dplyr bind_rows
#' @importFrom dplyr as_tibble
#' @importFrom stats setNames
bib2df_gather <- function(bib, extra_fields) {
  from <- which(str_detect(bib, "^@"))
  to <- c(from[-1] - 1, length(bib))

  entries <- parse_entries(bib, from, to, extra_fields)
  empty <- load_standard_df()
  dat <- bind_rows(c(list(empty), entries))
  dat <- as_tibble(dat)
  return(dat)
}

#' Parse a single BibTeX entry
#'
#' @param entry (char) a BibTeX entry
#' @param extra_fields (char) A list of additional fields to parse, passed from `bib2df()`
#' @importFrom stringr str_extract_all
#' @importFrom stringr str_extract
#' @importFrom stringr str_remove

parse_entry <- function(entry, extra_fields) {
  entry <- paste(entry, collapse = " ")

  category <- str_extract(entry, "(?<=@)[^\\{]+")

  key <- str_extract(entry, "(?<=\\{)[^,]*")

  # remove the leading @category and key
  fields_prep <- sub(paste0("^@", category, "\\{", key, ","), "", entry) %>%
    trimws()

  other_allowed_fields <- load_non_standard()
  empty <- load_standard_df()

  if (length(extra_fields) > 0){
    other_allowed_fields <- c(other_allowed_fields, extra_fields)
  }

  field_names_all <- str_extract_all(fields_prep, "\\b\\w+(?=\\s*=)")[[1]]
  field_names <- field_names_all[tolower(field_names_all) %in% c(tolower(colnames(empty)), tolower(other_allowed_fields))]
  unlisted <- field_names_all[!(tolower(field_names_all) %in% c(tolower(colnames(empty)), tolower(other_allowed_fields)))]
  if (length(unlisted > 0)){
    warning(paste("The following fields were found, but are not recognized:", unlisted, ". Examine your bib file to ensure correct parsing.", collapse = ", "))
  }
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
#' @param extra_fields (char) A list of additional fields to parse, passed from `bib2df()`

parse_entries <- function(bib, from, to, extra_fields) {
  if (all(is.na(from)) | all(is.na(to))) {
    return(list())
  }
  entries <- mapply(function(x, y) {
    entry <- bib[x:y]
    parse_entry(entry, extra_fields)
  }, from, to, SIMPLIFY = FALSE)
  return(entries)
}

#' Load an empty tibble with standard fields
#'
#' @importFrom dplyr filter
#' @importFrom tibble tibble
#' @importFrom utils read.csv
load_standard_df <- function(){
  df <- read.csv(system.file("extdata", "fields_standard.csv", package = "bib2df")) %>%
    filter(standard = TRUE)
  empty <- tibble(!!!df$field, .rows = 0, .name_repair = ~ df$field)
  return(empty)
}


#' Load an empty tibble with standard fields
#'
#' @importFrom dplyr filter
#' @importFrom tibble tibble
#' @importFrom utils read.csv
load_non_standard <- function(){
  df <- read.csv(system.file("extdata", "fields_standard.csv", package = "bib2df")) %>%
    filter(standard = FALSE)
  other_allowed_fields <- df$field
  return(other_allowed_fields)
}

