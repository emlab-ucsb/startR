#' Render Document
#'
#' @description Calls \code{rmarkdown::render()} to produce the output of a given rmd file
#'
#' @param file A character vector specifying the file name
#' @param rmd_dir The directory where the file lives, specified as a character vector
#' @param output_dir The output directory, where the knitted versions will be placed
#'
#' @export
#'
#' @examples
#'
#' I have a file called \code{"manuscript.rmd"} that lives in my \code{"repo/rmd/"} directory.
#' \dontrun{
#' render_doc(file = "manuscript.rmd")
#' }
#'
render_doc <- function(file, rmd_dir = "rmd", output_dir = "docs", ...){
  file <- file.path(rmd_dir, file)
  output <- file.path("..",output_dir)
  rmarkdown::render(file, output_dir = output_dir, encoding = "UTF-8", ...)

  browseURL(here::here(output_dir, file), browser = "C:/Program Files/RStudio/bin/sumatra/SumatraPDF.exe")
}
