#' Title
#'
#' @param pkgs
#'
#' @return
#' @export
#'
#' @examples
usual_suspects <- function(pkgs = NULL){
  if(is.null(pkgs)){
    packages <- c("janitor", "here", "sf", "tidyverse")
  } else {
    packages <- c(pkgs, "janitor", "here", "sf", "tidyverse")
    }
  sapply(packages, library)
}
