#' Create all
#' @param project_codename The code name used for the project. It should match the name used in the "current project" directory at emLab
#' @param local_dirs Create local directories?
#' @param emlab_dirs Create emlab directories?
#' @param setup_script Create setup scritp?
#' @param readme Create readme?
#'
#' @description This is a wrapper around \code{create_local_dirs}, \code{create_emlab_dirs}, \code{create_setup_script} and \code{create_readme}
#'
#' @export
#'
create_all <- function(project_codename, local_dirs = T, emlab_dirs = T, setup_script = T, readme = T){

  # Create local directories
  if(local_dirs){
    print("Creating local directories...")
    create_local_dirs()
    print("Done!")
  }

  # Create emlab directories
  if(emlab_dirs){
    print("Create emlab folders...")
    create_emlab_dirs(project_codename)
    print("Done!")
  }

  # Create setup script
  if(setup_script){
    print("Create setup script in root directory")
    create_setup_script(project_codename)
    print("Done!")
  }

  # Create readme
  if(readme){
    print("Create readme...")
    create_readme()
    print("Done!")
  }

}
