#' Rotate an sf object
#'
#' @description This takes an sf object with coordinates in -180 to 180
#' and converts it to an object 0 to 360 (like the ones used in climate
#' model outpt)
#'
#' @param an sf object
#'
#' @return the same object, with coordinates rotated
#'
#' @export
#'
st_rotate <- function(x){
  x2 <- (sf::st_geometry(x) + c(360,90)) %% c(360) - c(0,90)
  x3 <- sf::st_wrap_dateline(sf::st_set_crs(x2 - c(180,0), 4326)) + c(180,0)
  x4 <- sf::st_set_crs(x3, 4326)

  x <- sf::st_set_geometry(x, x4)

  return(x)
}
