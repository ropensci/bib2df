
<!-- README.md is generated from README.Rmd. Please edit that file -->
[![Travis-CI Build Status](https://travis-ci.org/ottlngr/bib2df.svg?branch=master)](https://travis-ci.org/ottlngr/bib2df)

`bib2df` - Parse a BibTeX file to a tibble
------------------------------------------

Everyone writing reports and articles with LaTeX has probably used BibTeX before. BibTeX is the de facto standard for reference management and grounds its functionality on a list of references stored in local text file. Depending on the reference type, several fields are necessary to define a reference properly. An exemplary BibTeX entry looks as follows:

    @Article{Binmore2008,
      Title = {Do Conventions Need to Be Common Knowledge?},
      Author = {Binmore, Ken},
      Journal = {Topoi},
      Year = {2008},
      Number = {1},
      Pages = {17--27},
      Volume = {27}
    }

Parse the BibTeX file to a tibble
---------------------------------

The BibTeX format is not convenient for any kind of analysis or visualization. Many R applications require a `data.frame`, or its revised version, the `tibble`. `bib2df` offers a straightforward framework to parse a BibTeX file to a `tibble`.

``` r
library(bib2df)
path <- system.file("extdata", "biblio.bib", package = "bib2df")
bib <- bib2df(path)
bib
#> # A tibble: 3 × 26
#>       CATEGORY              BIBTEXKEY  ADDRESS ANNOTE    AUTHOR
#>          <chr>                  <chr>    <chr>  <chr>    <list>
#> 1      ARTICLE            Binmore2008     <NA>   <NA> <chr [1]>
#> 2         BOOK            Osborne1994     <NA>   <NA> <chr [2]>
#> 3 INCOLLECTION BrandenburgerDekel1989 New York   <NA> <chr [2]>
#> # ... with 21 more variables: BOOKTITLE <chr>, CHAPTER <chr>,
#> #   CROSSREF <chr>, EDITION <chr>, EDITOR <list>, HOWPUBLISHED <chr>,
#> #   INSTITUTION <chr>, JOURNAL <chr>, KEY <chr>, MONTH <chr>, NOTE <chr>,
#> #   NUMBER <chr>, ORGANIZATION <chr>, PAGES <chr>, PUBLISHER <chr>,
#> #   SCHOOL <chr>, SERIES <chr>, TITLE <chr>, TYPE <chr>, VOLUME <chr>,
#> #   YEAR <dbl>
```

The `df2bib()` function makes it possible to write this tibble back to disk, enabling programmatic manipulation of a .bib file.

Installation
------------

The latest version of `bib2df` can be installed from GitHub using `devtools::install_github()`:

    devtools::install_github("ottlngr/bib2df")

Version 0.1.1 is now available on **CRAN**:

    install.packages("bib2df")
