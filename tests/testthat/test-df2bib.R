# Setup ----
# Load or prepare any necessary data for testing

# Create a temporary file
temp_bib <- tempfile()
fake_bib <- dplyr::tibble(
  CATEGORY = "ARTICLE",
  BIBTEXKEY = "test",
  AUTHOR = list(c("John R. Smith", "Jane Doe")),
  TITLE = "My fake title",
  JOURNAL = "Fisheries Research",
  YEAR = 2011,
  VOLUME = "2"
)

# df2bib ----
## IO correctness ----
test_that("df2bib() works with correct inputs", {
  #' @description Test that a simple tibble with one bib entry can be written
  #' to the disk and read back in with the same attributes. Though, more
  #' columns are added when it is read back in.
  expect_true(file.exists(df2bib(fake_bib, temp_bib)))
  temp_bib_read_in <- bib2df(temp_bib)

  expect_equivalent(
    fake_bib[, colnames(temp_bib_read_in)[colnames(temp_bib_read_in) %in% colnames(fake_bib)]],
    temp_bib_read_in[, !is.na(temp_bib_read_in[1, ])[1, ]]
  )
  expect_equivalent(readChar(x <- df2bib(fake_bib, tempfile()), 1), "@")
})

## Edge handling ----

test_that("df2bib() returns correct outputs for edge cases", {
  #' @description Test that passing a data frame instead of a tibble to `x`
  #' works.
  expect_no_message(df2bib(as.data.frame(fake_bib), file = temp_bib))
})

## Error handling ----

test_that("df2bib() returns correct error messages", {
  #' @description Test that you have to provide a value for `x`.
  expect_error(
    df2bib(),
    "\"x\" is missing, with no default"
  )

  #' @description Test that `file` must be a writeable file path.
  expect_error(
    df2bib(fake_bib, file = 1L),
    "Invalid file path"
  )
  expect_error(
    df2bib(fake_bib, file = file.path("c:", "happy")),
    "Invalid file path"
  )
})
