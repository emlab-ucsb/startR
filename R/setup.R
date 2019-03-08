


setup <- function(p1 = "", p2 = "", p3 = "", ...){
  create_dirs()
  create_manuscript(type = "eds")
  create_readme(repo = "GitHub for collaboration.", footer = paste("by: ", p1, p2, p3))
}
