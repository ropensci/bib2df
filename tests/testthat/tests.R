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
