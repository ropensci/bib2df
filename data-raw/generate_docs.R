
# Read the field data from the CSV file
fields <- read.csv(system.file("extdata", "fields_standard.csv", package = "bib2df"))

# Start building the roxygen documentation
doc <- c(
  "#' Supported Fields for Parsing",
  "#'",
  "#' This document lists all the fields that can be parsed by default in `bib2df`.",
  "#'",
  "#' @name bib2df_fields_list",
  "#' @docType data",
  "#'",
  "#' @section Fields:",
  "#' \\itemize{"
)

# Loop through each field and add it to the documentation
for (i in 1:nrow(fields)) {
  doc <- c(doc, paste0("#'   \\item ", fields$field[i]))
}

# Close the documentation section
doc <- c(doc, "#' }", "NULL")

# Write the generated documentation to a .R file
writeLines(doc, "R/bib2f_fields_list.R")
