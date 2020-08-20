#' Map theme
#'
#' @description Creates a standard theme for all my maps
#'
#' @param base_size Base size for the fonts
#'
#' @importFrom ggplot2 theme element_text rel element_blank element_rect element_line
#'
#' @export
#'
ggtheme_map <- function(base_size = 9) {
  theme(
    text = element_text(#family = "Helvetica",
      color = "gray30",
      size = base_size),
    plot.title = element_text(
      size = rel(1.25),
      hjust = 0,
      face = "bold"),
    panel.background = element_blank(),
    legend.position = "right",
    strip.background = element_rect(
      fill = "transparent"),
    panel.border = element_blank(),
    panel.grid.minor = element_blank(),
    panel.grid.major = element_line(
      color = "transparent"),
    axis.ticks = element_blank(),
    axis.text = element_blank(),
    axis.title = element_blank(),
    legend.key = element_rect(
      colour = NA,
      fill = NA),
    axis.line = element_blank()
    )
}
