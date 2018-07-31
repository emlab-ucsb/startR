#' Create directories
#'
#' @description Creates a set of standard directories: raw_data, data, rmd, docs, scripts
#'
#' @param other_dirs If needed, a character vector containing the names for extra directories.
#'
#' @export
#'
#' @examples
#'
#' \dontrun{
#' create_dirs() # This creates default directories
#'
#' create_dirs(other_dirs = "figures") # Creates all default directories and a figures directory
#' }
#'
#'
create_dirs <- function(other_dirs = NULL){
  if(is.null(other_dirs)){
    folder_names <- c("raw_data", "data", "rmd", "docs", "scripts")
  } else {
    folder_names <- c("raw_data", "data", "rmd", "docs", "scripts", other_dirs)
  }
  sapply(folder_names, dir.create)
}
