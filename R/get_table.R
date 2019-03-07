get_table <- function(project = "ucsb-gfw", dataset = NULL, table = NULL, allowLargeResults = TRUE) {

  if(is.null(dataset)){stop("Please provide the name of the dataset")}
  if(is.null(table)){stop("Please provide the name of the table")}

  BQc <- bigrquery::dbConnect(drv = bigrquery::bigquery(),
                              project = project,
                              dataset = dataset,
                              allowLargeResults = allowLargeResults)

  DBI::dbListTables(BQc)

  table <- dplyr::tbl(BQc, table) %>%
    collect()

  return(table)
}
