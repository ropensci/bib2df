# bib2df 1.0.1

* This package versions fixes some issues:
    * `bib2df()` can now read `.bib` files with a single entry
    * `bib2df()` now allows `@` symbol within titles
* This version will be published on CRAN since version 1.0.0 had beed removed from CRAN due to check errors.

# bib2df 1.0.0

* This package version went successfully through the `rOpenSci` onboarding process.
* The package now support AppVeyor builds.
* This version contains aditional unit tests.

# bib2df 0.2.2

* Changes due to the ropensci review process:
    * Improved behavior on malformed .bib files and entries
    * Improved behavior on type conversion
    * `df2bib()` is now able to append to an existing file
    * Minor changes in documentation and vignette

# bib2df 0.2.1

* Changes due to the ropensci review process:
    * Improved formatting
    * Removed exports of internal functions
    * Improved vignette

# bib2df 0.2

* Standardized return value for `bib2df()` (#5, @leeper)
* Added functionality to write `data.frame` back to BibTeX file (`df2bib()`) (#5, @leeper)
* Adds a testthat-based tests for both `bib2df()` and `df2bib()` (#5, @leeper)
* Added functionality of the `humaniformat` package to split up names (#4)
