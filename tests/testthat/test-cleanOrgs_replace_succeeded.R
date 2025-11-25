test_that("cleanOrgs_replace_succeeded replaces superseded codes", {
  df <- data.frame(org_code = c("R1C"), stringsAsFactors = FALSE)

  out <- cleanOrgs::cleanOrgs_replace_succeeded(df, code_column = "org_code")

  expect_equal(out$org_code[df$org_code == "R1C"], "RW1")

  # Row count unchanged
  expect_equal(nrow(out), nrow(df))
})

test_that("cleanOrgs_replace_succeeded leaves non-superseded codes unchanged", {
  df <- data.frame(org_code = c("RTH"), stringsAsFactors = FALSE)

  out <- cleanOrgs::cleanOrgs_replace_succeeded(df, code_column = "org_code")

  expect_equal(out$org_code[df$org_code == "RTH"], "RTH")

  # Row count unchanged
  expect_equal(nrow(out), nrow(df))
})
