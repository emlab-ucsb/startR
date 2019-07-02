#' Create README
#'
#' @description Creates a README.md file containing the structure of the repository and a footer
#'
#' @param repo (character) The repository name, or any other title, defaults to 'Repository'
#' @param footer (character) Text to be included in the footer. Defaults to my orcid
#'
#' @export
#'
#' @examples
#'
#' \dontrun{
#' create_readme() # Creates a readme file
#' }
#'
create_readme <- function(repo = "Repository", footer = '<a href="https://orcid.org/0000-0003-1245-589X" target="orcid.widget" rel="noopener noreferrer" style="vertical-align:top;"><img src="https://orcid.org/sites/default/files/images/orcid_16x16.png" style="width:1em;margin-right:.5em;" alt="ORCID iD icon">orcid.org/0000-0003-1245-589X</a>'){

  # Twee was created, of course, by awesome Jenny Brian:
  # https://gist.github.com/jennybc/2bf1dbe6eb1f261dfe60

  twee <- function(path = getwd(), level = Inf) {

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
                      twee(level = 2),
                      "```",
                      "\n--------- \n",
                      footer), con = "README.md")
}

