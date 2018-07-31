#' Lazy repository settup
#'
#' @description This is a wrapper arround \code{create_dirs} and \code{create_readme} that performs both opperations
#'
#' @export
#'
im_lazy <- function(first_doc = FALSE, ...){
  create_dirs()
  create_readme()
  if(first_doc){
    create_manuscript(...)
  }
}
