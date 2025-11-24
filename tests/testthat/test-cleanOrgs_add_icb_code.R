test_that("add_icb_code adds correct ICB code for known org", {

  df <- data.frame(org_code = c("RTH"), stringsAsFactors = FALSE)

  out <- cleanOrgs::cleanOrgs_add_icb_code(
    df,
    code_column = "org_code"
  )

  # Column created
  expect_true("icb_code" %in% names(out))

  # Row count unchanged
  expect_equal(nrow(out), nrow(df))

  expect_equal(out$icb_code[df$org_code == "RTH"], "QU9")
})


test_that("add_icb_code correctly handles unknown org codes", {

  df <- data.frame(org_code = c("XYZ"), stringsAsFactors = FALSE)

  out <- cleanOrgs::cleanOrgs_add_icb_code(
    df,
    code_column = "org_code"
  )

  # Column created
  expect_true("icb_code" %in% names(out))

  # Row count unchanged
  expect_equal(nrow(out), nrow(df))

  # Unknown code returns Unknown
  expect_equal(out$icb_code[df$org_code == "XYZ"], "Unknown")
})
