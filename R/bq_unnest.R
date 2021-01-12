#' bq_unnest
#'
#' @description Unnest an array column and cross joins it to the table
#'
#' @param input_tbl A tbl object
#' @param select_columns Normal columns to select
#' @param array_column Array column to unnest
#' @param unnested_columns Columns contained in the array that must be selected
#'
#' @return A tbl
#' @export
#'
#' @examples
#' \dontrun{
#' # A classic example from the vessel info tables in GFW
#' # The following corresponds to:
#' # <SQL>
#' # SELECT ssvid, un.value, un.count
#' # FROM
#' # `vi_ssvid_v20201209`
#' # CROSS JOIN
#' # UNNEST(ais_identity.n_imo) AS un

#' # Define a connection
#' con <- connection_open(
#'   bigquery(),
#'   project = "world-fishing-827",
#'   dataset = "gfw_research",
#'   billing = "emlab-gcp",
#'   use_legacy_sql = FALSE,
#'   allowLargeResults = TRUE)
#'
#' # Define a tbl
#' vessel_info <- tbl(con, "vi_ssvid_v20201209")
#'
#' # Unnest the tbl
#' vessel_info_unnested <-
#'   bq_unnest(input_tbl = vessel_info,                  # Define tbl
#'             select_columns = "ssvid",                 # Columns to select
#'             array_column = "ais_identity.n_imo",      # Array column
#'             unnested_columns = c("value", "count"))   # Columns to select once unnested
#'
#' # Inspect the SQL code
#' dbplyr::show_query(vessel_info_unnested)
#'
#' # Get the top 10 elements
#' head(vessel_info_unnested, 10)
#' }

bq_unnest <- function(input_tbl, select_columns, array_column, unnested_columns){

  # extract connection
  db_connection <- input_tbl$src$con

  # Modify vectors so that they work in context
  select_columns <- paste0(select_columns, collapse = ", ")
  unnested_columns <- paste0(paste0("un.", unnested_columns), collapse = ", ")

  # build SQL unnest query
  sql_query <- dbplyr::build_sql(
    con = db_connection
    ,"SELECT ", dbplyr::sql(select_columns), ", ",  dbplyr::sql(unnested_columns), "\n"
    ,"FROM \n"
    ,dbplyr::sql(input_tbl$ops$x),"\n"
    ,"CROSS JOIN \n"
    ,"UNNEST(",dbplyr::sql(array_column), ") AS un"
  )

  # Return the tbl
  return(dplyr::tbl(db_connection, dbplyr::sql(sql_query)))
}
