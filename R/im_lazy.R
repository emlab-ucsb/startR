#' Lazy repository settup
#'
#' @description This is a wrapper arround \code{create_dirs} and \code{create_readme} that performs both opperations
#'
#' @export
#'
#' @examples
im_lazy <- function(){
  create_dirs()
  create_readme()
}
