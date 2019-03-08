#' Create manuscript
#'
#' @param type A string that specifies the type of manuscript between \code{html_document} (the default) and \code{pdf_document}
#'
#' @export
#'
create_manuscript <- function(type = "html"){

  if(type == "html"){
    rmarkdown::draft(file = "docs/manuscript",
                     template = "html_manuscript",
                     package = "startR",
                     edit = F)
  }
  if(type == "pdf"){
    rmarkdown::draft(file = "docs/manuscript",
                     template = "pdf_manuscript",
                     package = "startR",
                     edit = F)
  }
  if(type == "eds"){
    rmarkdown::draft(file = "docs/manuscript",
                     template = "eds_manuscript",
                     package = "startR",
                     edit = F)
  }
}
