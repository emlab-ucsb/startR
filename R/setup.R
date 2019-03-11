#' Set up repository
#'
#' @description Creates all the files and stuff needed for the repository to work
#'
#' @param p1 Name of person 1
#' @param p2 Name of person 2
#' @param p3 Name of persion 3
#' @param ... Any additional parameters are ignored
#'
#' @export
#'
#' @examples
#'
#' setup("Jamie", "Tracey", "JC")
#'
setup <- function(p1 = "Tracey", p2 = "JC", ...){
  # Create directories
  print("Creating directories")
  create_dirs()
  print("Directories created")

  # Create data
  write.csv(x = iris,
            file = "raw_data/iris.csv",
            row.names = F)

  # Create manuscript
  print("Creating manuscript from template")
  create_manuscript(type = "eds")
  print("Manuscript created")

  # Create readme
  print("Creating README.md file")
  create_readme(repo = "GitHub for collaboration.",
                footer = paste("by: ", p1, p2))
  print("Created README.md file")

  # Final message
  print("Let's get to it!")
}
