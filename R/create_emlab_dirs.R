#' Create emLab directories
#'
#' @description Creates a set of standard directories in the emLab "current projects" foler: raw_data, processed_data, output_data
#'
#'@param project_codename The code name used for the project. It should match the name used in the "current project" directory at emLab
#' @param other_dirs If needed, a character vector containing the names for extra directories.
#'
#' @export
#'
#' @examples
#'
#' \dontrun{
#' create_dirs() # This creates default directories
#'
#' create_dirs(other_dirs = "reports") # Creates all default directories and an "reports" directory
#' }
#'
#'
create_emlab_dirs <- function(project_codename, other_dirs = NULL){

  # Directory where all projects live
  projects_path <- file.path(get_filestream_path(), "Shared drives/emlab/projects/current-projects")

  # Directory where this project will live
  project_path <- file.path(projects_path, project_codename)
  dir.create(path = project_path)

  # Standard directories
  standard_dirs <- c("raw_data", "processed_data", "output_data")
  sapply(file.path(project_path, standard_dirs), dir.create)

  if(!is.null(other_dirs)){
    sapply(file.path(project_path, other_dirs), dir.create)
  }

}
