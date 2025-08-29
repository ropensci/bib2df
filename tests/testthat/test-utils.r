context("Helper functions")

test_that("na_replace() works", {
  df <- data.frame(a = NA, b = 1)
  expect_true(na_replace(df)$a[1] == "")
  df <- data.frame(a = 1, b = 1)
  expect_false(any(is.na(na_replace(df))))
})
