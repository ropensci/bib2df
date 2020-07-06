#' @importFrom stringr str_detect
#' @importFrom stringr str_split
#' @importFrom stringr str_squish


bib2df_merge_lines <- function(bib){

  # The function identifies entries that span several lines and merges them

  # ---- Load dependencies ----
  library(stringr)
  library(dplyr)

  # Identify entries that contain linebreaks
  lines_wo_end <- !str_detect(bib, "\\}$|\\},$") & !str_detect(bib, "@") & bib!="" & !str_detect(bib, "^%")

  # Get index for those lines
  lines_wo_end_index <- which(lines_wo_end)

  # Gen. list with index consecutive numbers
  indx <- split(lines_wo_end_index, cumsum(c(1, diff(lines_wo_end_index) != 1)))

  # Add 1 more line number to entries
  for(i in 1:length(indx)){indx[[i]] <- c(indx[[i]], last(indx[[i]])+1)}

  # Paste lines together list index
  # Adapted from: https://stackoverflow.com/questions/32338758/r-paste-together-some-string-vector-elements-based-on-list-of-indexes
  # Author: https://stackoverflow.com/users/1756702/a-webb
  bib <- c(na.omit(Reduce(function(s,i)
    replace(s,i,c(paste(s[i],collapse=" "),rep(NA,length(i)-1))),indx,bib)))

  # Delete white space across all elements
  for(i in 1:length(bib)){
    # split when =
    if(str_detect(bib[i], "=")){
      splitted <- str_split(bib[i], "=")
      splitted[[1]][2] <- str_squish(splitted[[1]][2])
      bib[i] <- paste(splitted[[1]][1], splitted[[1]][2], sep="= ")
    }

  }
  return(bib)
}
