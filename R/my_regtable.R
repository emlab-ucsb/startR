#' Customized \code{stargazer} regression table
#'
#' @description Creates a stargazer table that fits my prefered design
#'
#' @param model_list A list of models
#' @param type A character vector specifying if the table should be latex or html
#' @param single.row A logical indicating if standard errors should be shown next to coefficients instead of below
#' @param omit.stat Regression statistics to omit from the table. For a full list, see stargazer::stargazer_stat_code_list
#' @param ... Other parameters to pass to \code{stargazer}
#'
#' @export
#'
#' @examples
#'
#' \dontrun{
#' m1 <- lm(mpg ~ cyl, mtcars)
#' m2 <- lm(mpg ~ cyl + hp, mtcars)
#'
#' moels <- list(m1, m2)
#'
#' my_regtable(model_list = models)
#'
#' }
#'
my_regtable <- function(model_list, type = "latex", single.row = T, omit.stat = c("adj.rsq", "ser"), ...){
  stargazer::stargazer(model_list,
                       type = type,
                       header = F,
                       single.row = single.row,
                       t.auto = T,
                       f.auto = T,
                       omit.stat = omit.stat,
                       intercept.bottom = F,
                       intercept.top = T,
                       se = commarobust::makerobustseslist(model_list),
                       ...)
}
