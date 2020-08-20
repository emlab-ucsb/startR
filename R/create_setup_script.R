#' Create setup script
#'
#' @param project_codename The code name used for the project. It should match the name used in the "current project" directory at emLab
#'
#' @export
#'

create_setup_script <- function(project_codename) {
  writeLines(
    text = c(
      '##########################\n## Paths to directories ##\n##########################\n',
      '# Check for OS',
      'sys_path <- get_filestream_path()\n',
      '# Path to emLab data folder',
      'data_path <- file.path(sys_path,"Shared drives/emlab/data")\n',
      '# Path to this project folder',
      paste0('project_path <- file.path(sys_path,"Shared drives/emlab/projects/current-projects/', project_codename, '")')
    ),
    con = "00_setup.R"
  )
}
