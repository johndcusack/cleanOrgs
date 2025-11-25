test_that("update_names adds full organisation names for known codes", {

  df <- data.frame(org_code = c("RTH"), stringsAsFactors = FALSE)

  out <- cleanOrgs::cleanOrgs_update_names(
    df,
    code_column = "org_code",
    name_column = "org_name_full"
  )

  # Check that the new column exists
  expect_true("org_name_full" %in% names(out))

  # Check that the name is correct
  # Replace "Royal Berkshire NHS Foundation Trust" with the actual expected value
  expect_equal(out$org_name_full[df$org_code == "RTH"],
               "Oxford University Hospitals NHS Foundation Trust")

  # Row count unchanged
  expect_equal(nrow(out), nrow(df))
})

test_that("update_names returns NA for unknown codes", {

  df <- data.frame(org_code = c("XYZ"), stringsAsFactors = FALSE)

  out <- cleanOrgs::cleanOrgs_update_names(
    df,
    code_column = "org_code",
    name_column = "org_name_full"
  )

  expect_true("org_name_full" %in% names(out))
  expect_equal(out$org_name_full[df$org_code == "XYZ"], "Unknown")

  # Row count unchanged
  expect_equal(nrow(out), nrow(df))
})
