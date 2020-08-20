#' Create local directories
#'
#' @description Creates a set of standard directories in the repository: scripts, results (and subdirectories for img and tab)
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
#' create_dirs(other_dirs = "app") # Creates all default directories and an "app" directory
#' }
#'
create_local_dirs <- function(other_dirs = NULL){

  standard_dirs <- c("scripts", "results", "results/img", "results/tab")
  sapply(standard_dirs, dir.create)

  if(!is.null(other_dirs)){
    sapply(other_dirs, dir.create)
  }

}
