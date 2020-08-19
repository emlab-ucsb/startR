#' Create all
#'
#' @param local_dirs
#' @param emlab_dirs
#' @param setup_script
#' @param readme
#'
#' @description This is a wrapper around \code{create_local_dirs}, \code{create_emlab_dirs}, \code{create_setup_script} and \code{create_readme}
#'
#' @export
#'
create_all <- function(local_dirs = T, emlab_dirs = T, setup_script = T, readme = T){

  # Create local directories
  if(local_dirs){
    print("Creating local directories...")
    create_local_dirs()
    print("Done!")
  }

  # Create emlab directories
  if(emlab_dirs){
    print("Create emlab folders...")
    create_emlab_dirs()
    print("Done!")
  }

  # Create setup script
  if(setup_script){
    print("Create setup script")
    create_setup_script()
    print("Done!")
    print("Adding setup script to Rprofile...")
    call <- paste0('echo ', '"source("scripts/00_setup.R")"', ">> .Rprofile")
    system(command = call)
    print("Done!")
  }

  # Create readme
  if(readme){
    print("Create readme...")
    create_readme()
    print("Done!")
  }

}
