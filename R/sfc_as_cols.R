# Function to extract lon and lat from the geometry listcol
# From https://github.com/r-spatial/sf/issues/231#issuecomment-290817623

#' sfc_as_cols
#'
#' @description Take the geometry column of an sf point object and turn it into columns of the data.frame
#'
#' @param x An object of class df sf
#' @param names The desired names for the x and y columns, a string of \code{c("lon", "lat")} is the default
#'
#' @return a data.frame
#'
#' @importFrom stats setNames
#' @importFrom tibble tibble
#'
#' @export
#'
sfc_as_cols <- function(x, names = c("lon","lat")) {
  ret <- sf::st_coordinates(x)
  ret <- tibble::as_tibble(ret)
  x <- x[ , !names(x) %in% names]
  ret <- setNames(ret,names)
  dplyr::bind_cols(x,ret)
}
