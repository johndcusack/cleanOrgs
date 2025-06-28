
cleaOrgs_json_extraction <- function(df,code_column) {
  #' Extract ODS json list
  #'
  #' @description
    #' This function takes a column of NHS organisation codes and returns a list of
    #' JSON objects extracted from the Organisational Data Service's API.
    #' This is an internal helper function that gets used by clean_orgs_get_json.R, which
    #' wraps this function with memoise to cache results.
    #' Caching prevents multiple repeated calls to the API,
    #' reduces demand on the API itself and
    #' speeds up the function when used repeatedly.
  #'
  #' @param df the dataframe that has the column containing organisation codes
  #' @param code_column the column within the dataframe that has the organisation codes
  #'
  #' @keywords internal
  #' @import httr2




  if (!code_column %in% names(df)) {
    stop("The specified code_column does not exist in the dataframe.")
  }

  codes <- unique(na.omit(df[[code_column]]))

# list assignment in R is more efficient in lists with a pre-allocated length so
# that's what I'm doing here
  json_list <- vector("list",length = length(codes))
  base_url <- "https://directory.spineservices.nhs.uk/ORD/2-0-0/organisations/"

  for (i in seq_along(codes)) {
    code <- codes[i]
    full_url <-  paste0(base_url,code)

    tryCatch({
    response <-  httr2::request(full_url) |>
      httr2::req_headers(Accept = 'application/json') |>
      httr2::req_perform()

    json_data <- httr2::resp_body_json(response)

    json_list[[i]] <- json_data
    },error = function(e) {
      warning(sprintf("Failed to retrieve data for code %s: %s", code, e$message))
      json_list[[i]] <- NULL
    })
  }
  return(json_list)
}
