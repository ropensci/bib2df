context("Import .bib to tibble")

bib <- bib2df(system.file("extdata", "bib2df_testfile_3.bib", package = "bib2df"))

test_that("bib imported as tibble", {
  expect_true(inherits(bib, "tbl"))
})

test_that("bib has correct names", {
  expect_true(all(names(bib2df:::empty) %in% names(bib)))
})

test_that("bib has correct dimensions", {
  expect_true(nrow(bib) == 3L)
  expect_true(ncol(bib) >= 25L)
})

context("Import .bib with one entry to tibble")

bib1 <- bib2df(system.file("extdata", "bib2df_testfile_2.bib", package = "bib2df"))

test_that("bib imported as tibble", {
  expect_true(inherits(bib1, "tbl"))
})

test_that("bib has correct names", {
  expect_true(all(names(bib2df:::empty) %in% names(bib1)))
})

test_that("bib has correct dimensions", {
  expect_true(nrow(bib1) == 1L)
  expect_true(ncol(bib1) >= 25L)
})

context("Export .tbl to .bib")

test_that("df2bib() works", {
  expect_true(file.exists(df2bib(bib, bib2 <- tempfile())))
  expect_true(identical(bib, bib2df(bib2)))
  expect_true(identical(readChar(x <- df2bib(bib, tempfile()), 1), "@"))
})

context("Helper functions")

test_that("capitalize() works", {
  expect_true(capitalize("TEST") == "Test")
  expect_true(capitalize("Test") == "Test")
})

test_that("na_replace() works", {
  df <- data.frame(a = NA, b = 1)
  expect_true(na_replace(df)$a[1] == "")
})

context("Error messages and exception handling")

test_that("df2bib() throws error messages", {
  df <- data.frame()
  expect_error(df2bib(df, 1234),
               "Invalid file path: Non-character supplied.",
               fixed = TRUE)
  expect_error(df2bib(df, "/not/a/valid/file/location.bib"),
               "Invalid file path: File is not writeable.",
               fixed = TRUE)
})

test_that("bib2df() throws error messages", {
  expect_error(bib2df(4),
               "Invalid file path: Non-character supplied.",
               fixed = TRUE)
  expect_error(bib2df("/a/n/y/where/any.bib"),
               "Invalid file path: File is not readable.",
               fixed = TRUE)
  expect_error(bib2df(
    paste(
    "https://www.",
    paste0(sample(x = letters, size = 32, replace = TRUE), collapse = ""),
    ".com/data/x.bib",
    sep = "")
    ),
               "Invalid URL: File is not readable.",
               fixed = TRUE)
})

test_that("bib2df() returns 'empty' data.frame", {
  write("", t <- tempfile())
  expect_true(identical(bib2df(t), bib2df:::empty))
})

context("Allow symbols in fields, especially @ and =")

test_that("bib2df() allows '@' and '=' in fields", {
  bib <- bib2df(system.file("extdata", "bib2df_testfile_1.bib", package = "bib2df"))
  expect_true(identical(bib$TITLE[1], "The C@C60 endohedral complex"))
  expect_true(identical(bib$ABSTRACT[1], "Foo bar (F-st = 0.81, P < 0.001) bla bla."))
})
