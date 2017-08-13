context("Import .bib to tibble")

bib <- bib2df(system.file("extdata", "biblio.bib", package = "bib2df"))

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

context("Export .tbl to .bib")

test_that("df2bib() works", {
  expect_true(file.exists(df2bib(bib, bib2 <- tempfile())))
  expect_true(identical(bib, bib2df(bib2)))
  expect_true(identical(readChar(x <- df2bib(bib, tempfile()), 1), "@"))
})

test_that("capitalize() works", {
  expect_true(capitalize("TEST") == "Test")
  expect_true(capitalize("Test") == "Test")
})

test_that("na_replace() works", {
  df <- data.frame(a = NA, b = 1)
  expect_true(na_replace(df)$a[1] == "")
})

test_that("df2bib() throws error messages", {
  df <- data.frame()
  expect_error(df2bib(df, 1234), "Invalid file path: Non-character supplied.", fixed = TRUE)
  expect_error(df2bib(df, "/not/a/valid/file/location.bib"), "Invalid file path: File is not writeable.", fixed = TRUE)
})
