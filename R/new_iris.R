#' New iris
#'
#' @description Creates a set of 50 lines with data from Ryan Anderson: https://dreamtolearn.com/ryan/data_analytics_viz/18, who made up some 50 new values for a fictional species: Iris mythica
#'
#' @importFrom magrittr %>%
#' @name %>%
#' @rdname pipe
#'
#' @param ... Ignores all parameters
#'
#' @export
#'
new_iris <- function(...) {
  # Load new data
  iris4 <- read.csv("data/iris_mythica.csv") %>%
    dplyr::select(Sepal.Length = sepal.length,
                  Sepal.Width = sepal.width,
                  Petal.Length = petal.length,
                  Petal.Width = petal.width,
                  Species = class) %>%
    dplyr::filter(Species == "Iris-mythica") %>%
    mutate(Species = "mythica")

  # Create data
  write.csv(x = iris4,
            file = "raw_data/iris_mythica.csv",
            row.names = F)
}
