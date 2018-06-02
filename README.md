
<!-- README.md is generated from README.Rmd. Please edit that file -->
[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/bib2df)](https://cran.r-project.org/package=bib2df) [![Travis-CI Build Status](https://travis-ci.org/ropensci/bib2df.svg?branch=master)](https://travis-ci.org/ropensci/bib2df) [![Build status](https://ci.appveyor.com/api/projects/status/6k3q7272ddnjh20o?svg=true)](https://ci.appveyor.com/project/ottlngr/bib2df) [![](http://cranlogs.r-pkg.org/badges/bib2df)](http://cran.rstudio.com/web/packages/bib2df/index.html) [![codecov](https://codecov.io/gh/ropensci/bib2df/branch/master/graph/badge.svg)](https://codecov.io/gh/ropensci/bib2df) [![](https://badges.ropensci.org/124_status.svg)](https://github.com/ropensci/onboarding/issues/124)

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

The BibTeX format is not convenient for any kind of analysis or visualization. Many R applications require a `data.frame` (or `tibble`) and `bib2df` offers a straightforward framework to parse a BibTeX file to a `tibble`.

``` r
library(bib2df)
path <- system.file("extdata", "bib2df_testfile_3.bib", package = "bib2df")
bib <- bib2df(path)
bib
#> # A tibble: 3 x 26
#>   CATEGORY  BIBTEXKEY  ADDRESS ANNOTE AUTHOR BOOKTITLE    CHAPTER CROSSREF
#>   <chr>     <chr>      <chr>   <chr>  <list> <chr>        <chr>   <chr>   
#> 1 ARTICLE   Binmore20… <NA>    <NA>   <chr … <NA>         <NA>    <NA>    
#> 2 BOOK      Osborne19… <NA>    <NA>   <chr … <NA>         <NA>    <NA>    
#> 3 INCOLLEC… Brandenbu… New Yo… <NA>   <chr … The Economi… 3       <NA>    
#> # ... with 18 more variables: EDITION <chr>, EDITOR <list>,
#> #   HOWPUBLISHED <chr>, INSTITUTION <chr>, JOURNAL <chr>, KEY <chr>,
#> #   MONTH <chr>, NOTE <chr>, NUMBER <chr>, ORGANIZATION <chr>,
#> #   PAGES <chr>, PUBLISHER <chr>, SCHOOL <chr>, SERIES <chr>, TITLE <chr>,
#> #   TYPE <chr>, VOLUME <chr>, YEAR <dbl>
```

The `df2bib()` function makes it possible to write this `tibble` back to disk, enabling programmatic manipulation of a .bib file.

Installation
------------

The latest version of `bib2df` can be installed from GitHub using `devtools::install_github()`:

    devtools::install_github("ropensci/bib2df")

Version 1.0.1 is now available on **CRAN**:

    install.packages("bib2df")

Community Guidelines
--------------------

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.

------------------------------------------------------------------------

[![ropensci\_footer](./ropensci_footer.png)](https://ropensci.org)
