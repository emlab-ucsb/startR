#' Save a ggplot object as a figure, with some defaults (PNG and PDF only)
#'
#' @param plot A ggplot object
#' @param filename Filename (with no extensions!)
#' @param width Width of the figure (in cm)
#' @param height Height of the figure (in cm)
#'
#' @return Does not return anything, just saves a file to disk

#' @export
#'
#' @examples

lazy_ggsave <- function(plot, filename, width = 7, height = 5){
  # Save as png
  ggsave(plot = plot,
         filename = here("results", "img", paste0(filename, ".png")),
         width = width,
         height = height,
         units = "cm")

  # Save as pdf
  ggsave(plot = plot,
         filename = here("results", "img", paste0(filename, ".pdf")),
         width = width,
         height = height,
         units = "cm")
}
