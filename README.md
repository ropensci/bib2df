
```R
devtools::install_github("ottlngr/bib2df")
library(bib2df)
tmp <- system.file("extdata", "biblio.bib", package = "bib2df")
bib <- bib2df_read(tmp)
bib2df_gather(bib)
```
