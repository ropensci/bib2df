
<!-- README.md is generated from README.Rmd. Please edit that file -->
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
#> # A tibble: 3 x 13
#>       CATEGORY                                                   TITLE
#>          <chr>                                                   <chr>
#> 1      ARTICLE             Do Conventions Need to Be Common Knowledge?
#> 2         BOOK                                 A Course in Game Theory
#> 3 INCOLLECTION The Role of Common Knowledge Assumptions in Game Theory
#> # ... with 11 more variables: AUTHOR <list>, JOURNAL <chr>, YEAR <dbl>,
#> #   NUMBER <chr>, PAGES <chr>, VOLUME <chr>, PUBLISHER <chr>,
#> #   BOOKTITLE <chr>, ADDRESS <chr>, CHAPTER <chr>, EDITOR <list>
```

Installation
------------

The latest version of `bib2df` can be installed from GitHub using `devtools::install_github()`:

    devtools::install_github("ottlngr/bib2df")

Version 0.1.1 is now available on **CRAN**:

    install.packages("bib2df")
