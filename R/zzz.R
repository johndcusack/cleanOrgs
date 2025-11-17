# R/zzz.R
# This file is used to register global variables for R CMD check

if (getRversion() >= "2.15.1") {
  utils::globalVariables(
    c(
      # Variables used in create_ods_table()
      "OrgId", "extension", "Name", "Succs", "Succ", "Target", "Type",
      # Variables used in replace_succeeded()
      "org_name", "check", "successor_code",
      # Variables used in update_names()
      "successor_code"
    )
  )
}
