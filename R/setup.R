#' Setup
#'
#' @description Sets everything up by \code{calling usual_suspects} and setting some knitr options
#'
#' @export
#'
#'
setup <- function(){
  usual_suspects()

  knitr::opts_chunk$set(echo = FALSE,
                        message = FALSE,
                        warning = FALSE)
}
