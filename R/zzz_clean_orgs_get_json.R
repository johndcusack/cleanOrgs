
#' clean_orgs_get_json
#'
#' @description
#' This is a memoised wrapper for an internal function that takes a column of NHS organisation codes
#' and returns a list of JSON objects extracted from the Organisational Data Service's API.
#' Memoise is used to cache the results of This is an internal helper function that gets used by clean_orgs_get_json.R, which
#' wraps this function with memoise caching the result of the API call in memory.
#' Caching prevents multiple repeated calls to the API,
#' reduces demand on the API itself and
#' speeds up the function when used repeatedly.
#'
#' @param df the dataframe that has the column containing organisation codes
#' @param code_column the column within the dataframe that has the organisation codes
#'
#' @export

clean_orgs_get_json <-  memoise::memoise(clean_orgs_json_extraction)

