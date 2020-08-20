#' Create README
#'
#' @description Creates a README.md file containing the structure of the repository and a footer
#'
#' @param repo (character) The repository name, or any other title, defaults to 'Repository'
#'
#' @export
#'
#' @examples
#'
#' \dontrun{
#' create_readme() # Creates a readme file
#' }
#'
create_readme <- function(repo = "Repository"){
  # Twee was created, of course, by awesome Jenny Brian:
  # https://gist.github.com/jennybc/2bf1dbe6eb1f261dfe60

  twee <- function(path, level = Inf) {

    fad <- list.files(path = path, recursive = TRUE, no.. = TRUE, include.dirs = TRUE)

    fad_split_up <- strsplit(fad, "/")

    too_deep <- lapply(fad_split_up, length) > level
    fad_split_up[too_deep] <- NULL

    jfun <- function(x) {
      n <- length(x)
      if(n > 1)
        x[n - 1] <- "|__"
      if(n > 2)
        x[1:(n - 2)] <- "   "
      x <- if(n == 1) c("-- ", x) else c("   ", x)
      x
    }
    fad_subbed_out <- lapply(fad_split_up, jfun)

    tree <- unlist(lapply(fad_subbed_out, paste, collapse = ""))

    return(tree)
  }

  writeLines(text = c(paste0("# ", repo,"\n\n"),
                      "## Repository structure \n",
                      "```",
                      twee(path = getwd(), level = 3),
                      "```",
                      "\n---------"),
             con = "README.md")
}

