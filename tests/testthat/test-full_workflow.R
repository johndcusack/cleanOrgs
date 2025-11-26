test_that("full workflow works end-to-end", {
  skip("Skipping full workflow test, see note in test for rationale")

  # NOTE: Full workflow test is intentionally skipped
  # The full workflow depends on live API calls to the NHS ODS service.
  # - Automated tests that hit the live API are fragile and non-replicable by others.
  # - Cached API tests could pass even if live API behavior changes.
  # - Individual unit tests for each function (replace_succeeded, update_names,
  #   add_shortname, add_icb_code) already verify core functionality.
  #
  # The workflow has been manually validated with live data,so the author retains
  # confidence in its correctness without an automated end-to-end test.

  df <- tibble::tibble(
    org_code = c("R1C", "RTH", "XYZ"),
    activity = c(10, 20, 30)
  )

  out <- df |>
    cleanOrgs::cleanOrgs_replace_succeeded(code_column = "org_code") |>
    cleanOrgs::cleanOrgs_update_names(code_column = "org_code", name_column = "org_name_full") |>
    cleanOrgs::cleanOrgs_add_shortname(code_column = "org_code", new_col_name = "org_short_name") |>
    cleanOrgs::cleanOrgs_add_icb_code(code_column = "org_code") |>
    cleanOrgs::cleanOrgs_add_shortname(code_column = "icb_code", new_col_name = "icb_short_name")

  # Row count unchanged
  expect_equal(nrow(out), nrow(df))

  # Columns exist
  expect_true(all(c("org_code", "org_name_full", "org_short_name", "icb_code", "icb_short_name", "activity") %in% names(out)))

  # Superseded code replaced
  expect_equal(out$org_code[df$org_code == "R1C"], "RW1")  # Solent > HIOWFT

  # Names correct
  expect_equal(out$org_name_full[df$org_code == "RW1"], "Hampshire and Isle of Wight NHS Foundation Trust")
  expect_equal(out$org_name_full[df$org_code == "RTH"], "Oxford University Hospitals NHS Foundation Trust")
  expect_equal(out$org_name_full[df$org_code == "XYZ"], "Unknown")

  # Short names correct
  expect_equal(out$org_short_name[df$org_code == "RW1"], "HIOW FT")
  expect_equal(out$org_short_name[df$org_code == "RTH"], "OUH")
  expect_equal(out$org_short_name[df$org_code == "XYZ"], "Unknown")

  # ICB codes correct
  expect_equal(out$icb_code[df$org_code == "RW1"], "QRL")   # HIOW FT in HIOW
  expect_equal(out$icb_code[df$org_code == "RTH"], "QU9")   # OUH in BOB
  expect_equal(out$icb_code[df$org_code == "XYZ"], "Unknown")

  # ICB short names correct
  expect_equal(out$icb_short_name[df$icb_code == "QRL"], "HIOW ICS")
  expect_equal(out$icb_short_name[df$icb_code == "QU9"], "BOB ICS")
  expect_equal(out$icb_short_name[df$icb_code == "Unknown"], "Unknown")
})
