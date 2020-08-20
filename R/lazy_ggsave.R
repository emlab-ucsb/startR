#' Save a ggplot object as a figure, with some defaults (PNG and PDF only)
#'
#' @param plot A ggplot object
#' @param filename Filename (with no extensions!)
#' @param width Width of the figure (in cm)
#' @param height Height of the figure (in cm)
#'
#' @return Does not return anything, just saves a file to disk
#'
#' @importFrom ggplot2 ggsave
#'
#' @export
#'

lazy_ggsave <- function(plot, filename, width = 14, height = 10){
  # Save as png
  ggplot2::ggsave(plot = plot,
                  filename = here::here("results", "img", paste0(filename, ".png")),
                  width = width,
                  height = height,
                  units = "cm")

  # Save as pdf
  ggplot2::ggsave(plot = plot,
                  filename = here::here("results", "img", paste0(filename, ".pdf")),
                  width = width,
                  height = height,
                  units = "cm")
}
