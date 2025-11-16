cleanOrgs_create_ods_table <- function(json_list) {
  #' Create ODS table
  #'
  #' @description This function takes in a list of json files extracted from
  #' the Organisational Data Service API such as the one created by cached_ods_json_list.R
  #' It returns a tibble. The tibble has three fields:
  #' The organisation code,
  #' The current organisation name as registered with the ODS
  #' The successor code for the organisation, if that code has been retired and replaced or merged
  #'
  #' @param json_list an ODS json file
  #'
  #' @export


  output_list <- vector("list",length = length(json_list))

  for (i in seq_along(json_list)){
    json_data <- json_list[[i]]
    json_data_df <- tibble::tibble(json_data)

    org_code <- json_data_df |>
      tidyr::unnest_wider(json_data) |>
      tidyr::unnest_wider(rlang::.data$OrgId) |>
      dplyr::pull(rlang::.data$extension) |>
      dplyr::first()

    org_name <- json_data_df |>
      tidyr::hoist(json_data,"Name") |>
      dplyr::pull(rlang::.data$Name) |>
      dplyr::first() |>
      stringr::str_to_title() |>
      stringr::str_replace("Nhs","NHS")

    successor_check <- json_data_df |>
      tidyr::unnest_wider(json_data)

    successor_check <-  if (!'Succs' %in% names(successor_check)) {
      tibble::tibble()
    } else{
      successor_check |>
        dplyr::select(rlang::.data$Succs) |>
        tidyr::unnest_wider(rlang::.data$Succs) |>
        tidyr::unnest_longer(rlang::.data$Succ) |>
        tidyr::unnest_wider(rlang::.data$Succ) |>
        tidyr::unnest_wider(rlang::.data$Target) |>
        tidyr::unnest_wider(rlang::.data$OrgId) |>
        dplyr::filter(rlang::.data$Type == 'Successor') }

    successor_code <- if (nrow(successor_check) == 1){
      dplyr::pull(successor_check, rlang::.data$extension)
    } else if (nrow(successor_check) == 0){
      'None'
    } else {
      'multiple_successors'
    }

    output <- c(org_code,org_name,successor_code)

    output_list[[i]] <- output
  }

  output_df <- suppressWarnings(tibble::as_tibble(do.call(rbind,output_list), .name_repair = 'unique'))
  colnames(output_df) <- c("org_code","org_name","successor_code")

  return(output_df)
}
