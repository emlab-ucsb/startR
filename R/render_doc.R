#' Title
#'
#' @param file
#' @param rmd_dir
#' @param output_dir
#'
#' @return
#' @export
#'
#' @examples
render_doc <- function(file, rmd_dir = "rmd", output_dir = "docs", ...){
  file <- file.path(rmd_dir, file)
  output <- file.path("..",output_dir)
  rmarkdown::render(file, output_dir = output_dir, encoding = "UTF-8", ...)
}
