#' Get tables from GoogleBigQuery
#'
#' @description This function downloads tables from GoogleBigQuery and brings them into memory as a normal r data.frame. The first time it is ran, you will have to authenticate into your GBQ account.
#'
#' @param project Name of the project, defaults to \code{ucsb-gfw}
#' @param dataset Name of the dataset where the table lives
#' @param table Name of the table to download
#' @param allowLargeResults Allow large results?
#' @param show_tables Show all tables within the dataset before downloading?
#'
#' @return An object of clas \code{tbl.df}
#' @export
#'
#' @examples
#'
#'\dontrun{
#' my_data <- get_table(dataset = "foreign_fishing_ren",
#'                      table = "annual_foreign_fishing")
#' }
#'
get_table <- function(project = "ucsb-gfw", dataset = NULL, table = NULL, allowLargeResults = TRUE, show_tables = TRUE) {

  if(is.null(dataset)){stop("Please provide the name of the dataset")}
  if(is.null(table)){stop("Please provide the name of the table")}

  BQc <- bigrquery::dbConnect(drv = bigrquery::bigquery(),
                              project = project,
                              dataset = dataset,
                              allowLargeResults = allowLargeResults)

  if(show_tables) {DBI::dbListTables(BQc)}

  table <- dplyr::tbl(BQc, table) %>%
    collect()

  return(table)
}
