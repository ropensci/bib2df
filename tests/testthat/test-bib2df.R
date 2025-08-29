# Setup ----
# Load or prepare any necessary data for testing

# Read in all test bib files that do not produce errors
bib_1 <- bib2df(
  system.file("extdata", "bib2df_testfile_1.bib", package = "bib2df")
)
bib_2 <- bib2df(
  system.file("extdata", "bib2df_testfile_2.bib", package = "bib2df")
)
bib_3 <- bib2df(
  system.file("extdata", "bib2df_testfile_3.bib", package = "bib2df")
)
bib_4 <- bib2df(
  system.file("extdata", "bib2df_testfile_4.bib", package = "bib2df")
)
bib_5 <- bib2df(
  system.file("extdata", "bib2df_testfile_5.bib", package = "bib2df"),
  merge_lines = TRUE
)

# bib2df ----
## IO correctness ----

test_that("bib2df() works with correct inputs", {
  #' @description Test that [bib2df()] returns a tibble.
  expect_true(inherits(bib_3, "tbl"))

  #' @description Test that [bib2df()] has the correct column names for the
  #' default bibliography file structure.
  expect_true(all(names(bib2df:::empty) %in% names(bib_3)))

  #' @description Test that `bib_3` has the correct dimensions when read in by
  #' [bib2df()].
  expect_true(nrow(bib_3) == 3L)
  expect_true(ncol(bib_3) >= 25L)

  #' @description Test that a bibliography file with only one entry still leads
  #' to the creation of a tibble, even though it will have just one row, with
  #' the appropriate column names.
  expect_true(inherits(bib_2, "tbl"))
  expect_true(nrow(bib_2) == 1L)
  expect_true(ncol(bib_2) >= 25L)
  expect_true(all(names(bib2df:::empty) %in% names(bib_2)))
})


test_that("df2bib() throws error messages", {
  df <- data.frame()
  expect_error(df2bib(df, 1234),
               "Invalid file path: Non-character supplied.",
               fixed = TRUE)
  expect_error(df2bib(df, "/not/a/valid/file/location.bib"),
               "Invalid file path: File is not writeable.",
               fixed = TRUE)
})


## Edge handling ----

test_that("bib2df() returns correct outputs for edge cases", {
  #' @description Allow non-traditional symbols in different fields because
  #' LaTeX is often present in titles and abstracts. The most widely seen
  #' symbols are @ and =.
  expect_equivalent(
    bib_1[bib_1[["BIBTEXKEY"]] == "bib2df_testitem_1", "TITLE"],
    "The C@C60 endohedral complex"
  )
  expect_equivalent(
    bib_1[bib_1[["BIBTEXKEY"]] == "bib2df_testitem_1", "ABSTRACT"],
    "Foo bar (F-st = 0.81, P < 0.001) bla bla."
  )

  #' @description Test that curly braces around words for capitalization
  #' purposes remain after reading them in. This was brought up in [issue #29](
  #' https://www.github.com/ropensci/bib2df/issues/29).
  expect_equivalent(
    bib_1[bib_1[["BIBTEXKEY"]] == "patz_grammar_2002", "TITLE"],
    "A grammar of the {Kuku} {Yalanji} language of north {Queensland}"
  )
  expect_equivalent(
    bib_1[bib_1[["BIBTEXKEY"]] == "Bourdieu:2014", "ADDRESS"],
    "Cambridge"
  )

  #' @description Test that an empty file returns a tibble with zero rows.
  write("", t <- tempfile())
  expect_equivalent(bib2df(t), bib2df:::empty)
  unlink(t, recursive = TRUE)
  rm(t)

  #' @description Test that [bib2df()] allows any number of blanks before =.
  supplied_cols <- c("AUTHOR", "TITLE", "JOURNAL", "YEAR", "ABSTRACT")
  expect_false(any(is.na(bib_4[supplied_cols])))

  #' @description Test that [bib2df()] allows for _ in tab name.
  expect_false(any(is.na(bib_4["AUTHOR_KEYWORDS"])))

  #' @description Test that [bib2df()] works with "-" in tab name, this is part
  #' of issue [#31](https://www.github.com/ropensci/bib2df/issues/31). As of
  #' today, the "-" is changed to "." in the column name and the multi-line
  #' entries are not merged into a single line leading to warning messages when
  #' the file is read in. If you use the `merge_lines = TRUE` argument, some of
  #' the multi-line entries will appear in the result of [bib2df()] as their
  #' correct values but some will be NA such as ABSTRACT.

  expect_false(is.na(bib_5$AUTHOR[1]))
  expect_false(identical(bib_5$AUTHOR[1], ""))
  expect_false(is.na(bib_5$TITLE[1]))
  expect_false(identical(bib_5$TITLE[1], ""))
  expect_equivalent(
    bib_5$TITLE[1],
    "{Effect of Tabular and Icon Fact Box Formats on Comprehension of Benefits and Harms of Prostate Cancer Screening: A Randomized Trial}"
  )
  expect_false(is.na(bib_5$ABSTRACT[1]))
  expect_false(identical(bib_5$ABSTRACT[1], ""))

})

## Error handling ----

test_that("bib2df() returns correct error messages", {
  #' @description Passing a non-string character results in the appropriate
  #' error message.
  expect_error(
    bib2df(4),
    "Invalid file path: Non-character supplied.",
    fixed = TRUE
  )
  #' @description Passing an invalid file path, i.e., a path to a file that
  #' does not exist results in the appropriate error message.
  expect_error(
    bib2df(file.path("a", "n", "y", "where", "any.bib")),
    "Invalid file path: File is not readable.",
    fixed = TRUE
  )
})
