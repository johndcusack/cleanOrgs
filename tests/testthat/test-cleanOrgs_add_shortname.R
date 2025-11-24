test_that("add_shortname creates a shortname column correctly", {

  df <- data.frame(org_code = c("RTH"), stringsAsFactors = FALSE)

  out <- cleanOrgs::cleanOrgs_add_shortname(
    df,
    code_column = "org_code",
    new_col_name = "org_short_name"
  )

  # Column created
  expect_true("org_short_name" %in% names(out))

  # Row count unchanged
  expect_equal(nrow(out), nrow(df))

  # Check that the shortname is correct
  expect_equal(out$org_short_name[df$org_code == "RTH"], "OUH")
})

test_that("add_shortname handles unknown codes correctly", {

  df <- data.frame(org_code = c("XYZ"), stringsAsFactors = FALSE)

  out <- cleanOrgs::cleanOrgs_add_shortname(
    df,
    code_column = "org_code",
    new_col_name = "org_short_name"
  )

  # Column created
  expect_true("org_short_name" %in% names(out))

  # Row count unchanged
  expect_equal(nrow(out), nrow(df))

  # Check that the code produces "Unknown"
  expect_equal(out$org_short_name[df$org_code == "XYZ"], "Unknown")
})


test_that("add_shortname works with multiple rows", {

  df <- data.frame(org_code = c("RTH", "RN5"), stringsAsFactors = FALSE)

  out <- cleanOrgs::cleanOrgs_add_shortname(
    df,
    code_column = "org_code",
    new_col_name = "org_short_name"
  )

  expect_equal(nrow(out), nrow(df))
  expect_true(all(c("org_code", "org_short_name") %in% names(out)))

  expect_equal(out$org_short_name[df$org_code == "RTH"], "OUH")
  expect_equal(out$org_short_name[df$org_code == "RN5"], "HHFT")
})
