cleanOrgs_update_names <- function(df,code_column,name_column,verbose=TRUE) {

  #' Update organisation names
  #'
  #' This function adds or replaces a column in a dataframe with the current
  #' organisation name as recorded by the Organisation Data Service (ODS).
  #' It uses an organisation code column in the dataframe, retrieves JSON data
  #' for each code using the ODS API (`cached_ods_json_list()`), and constructs
  #' a lookup table via `create_ods_table()`.
  #'
  #' Note: This function does not merge or update superseded trusts and will use
  #' their most recent recorded name. To account for mergers, use
  #' `cleanOrgs_replace_succeeded()` before calling this function.
  #'
  #' @param df A dataframe containing organisation codes.
  #' @param code_column A string. The name of the column in `df` that contains organisation codes.
  #' @param name_column A string. The name of the column to be added/overwritten with organisation names.
  #' @param verbose Logical. If TRUE, prints the number of unrecognised codes.
  #'
  #' @return A dataframe identical to `df`, with an additional or updated `name_column`.
  #'
  #' @importFrom dplyr coalesce
  #'
  #' @export


  if (!code_column %in% names(df)) {
    stop("The specified code_column does not exist in the dataframe.")
  }

  org_list <- cleanOrgs_get_json(df,code_column)
  ods_table <-  cleanOrgs_create_ods_table(org_list) |> dplyr::select(-successor_code)


  org_lookup <- stats::setNames(ods_table$org_name, ods_table$org_code)

  df[[name_column]] <-dplyr::coalesce(
    unname(org_lookup[as.character(df[[code_column]])]),
    "Unknown"
  )

  if (verbose){
    unknowns <- sum(df[[name_column]] == "Unknown", na.rm = TRUE)
    message(unknowns, " unrecognised organisation codes, ",name_column," set to 'Unknown'.")
  }
  return(df)
}
