#' Get Filestream path
#'
#' @description Identifies the operative system in which we are running, and returns the correct path to where Filestream is mounted
#'
#' @return The OS-specific mounting of FIleStream
#' @export
#'
get_filestream_path <- function(){
  system <- Sys.info()["sysname"]
  if(system == "Windows") {
    path <- "G:"
  } else {
      path <- "~/Google Drive File Stream"
  }

  return(path)
}
