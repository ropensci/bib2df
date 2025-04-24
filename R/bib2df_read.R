#' @importFrom stringr str_replace_all
#' @importFrom stringi stri_enc_detect
#' @importFrom readrr guess_encoding

bib2df_read <- function(file) {

encoding <- readr::guess_encoding("test.bib")[[1]]

if(encoding != "ASCII" &
   encoding != "UTF-8"&
   encoding == "UT-16"){
  warning("The file encoding is probably not in ASCII, UTF-8 or UTF-16. This may cause problems with some characters.")
  bib <- readLines(file)
}

if(encoding == "ASCII"){
  bib <- readLines(file, encoding = "ASCII")
}

if(encoding == "UTF-8"){
  bib <- readLines(file, encoding = "UTF-8")
}

if(encoding == "UTF-16"){
  bib <- readLines(file, encoding = "UTF-16")
}


  bib <- str_replace_all(bib, "[^[:graph:]]", " ")
  bib <- str_replace_all(bib, "=", " = ") # add desired spaces
  bib <- str_replace_all(bib, "  ", " ")   # remove double spaces in case you have it
  return(bib)
}
