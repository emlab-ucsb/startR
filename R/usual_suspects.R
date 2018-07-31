#' Package loading
#'
#' @description Loads the usual packages from my every-day workflow
#'
#' @param pkgs A character vector containing the packages that should be loaded. The fedault ones include \code{janitor}, \code{here}, \code{sf}, and \code{tidyverse}
#'
#' @export
#'
usual_suspects <- function(pkgs = NULL){
  if(is.null(pkgs)){
    packages <- c("janitor", "here", "sf", "tidyverse")
  } else {
    packages <- c(pkgs, "janitor", "here", "sf", "tidyverse")
    }
  sapply(packages, library)
}
