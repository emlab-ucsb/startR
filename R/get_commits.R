#' Get git commits
#'
#' @description This function goes into your github repos and extracts the git commits
#'
#' @param path Path to the folder where you keep your repos (usually Documents/GitHub/)
#' @param target_user Github username(s)
#' @param from Initial date
#' @param export Should the function return a value (de default) or export the data (set this to TRUE)
#'
#' @return Either a data.frame object or nothing
#' @export
#'
#' @examples
#'
#' get_commits(path = "", target_user = "jcvdav", from = "2019-01-01", export = F)
#'
get_commits <- function(path = "~/Documents/GitHub/", target_user, from = "2019-01-01", export = F, filter = F) {

  dirs <- fs::dir_ls(path, type = "directory")

  message("Searching ", length(dirs), " directories...")

  commits <- purrr::map_dfr(dirs, function(dir) {
    message("Processing ", fs::path_file(dir), "...")
    if (git2r::in_repository(dir)) {
      commits_list <- git2r::commits(dir)
      if (length(commits_list) > 0) {
        dir_commits <- purrr::map_dfr(commits_list, function(commit) {
          tibble::tibble(
            SHA  = commit$sha,
            user = commit$author$name,
            date = lubridate::as_datetime(commit$author$when$time)
          )
        })
        dir_commits$repo <- fs::path_file(dir)

        return(dir_commits)
      }
    }
  })

  message("Found ", nrow(commits), " commits")

  message("Selecting distinct SHAs...")
  commits <- dplyr::distinct(commits, SHA, .keep_all = TRUE)
  message("Found ", nrow(commits), " distinct commits")

  message("Filtering dates...")
  commits <- dplyr::filter(commits, date >= from)
  message("Found ", nrow(commits), " from ", from)

  if(filter){
    message("Filtering names...")
    commits <- dplyr::filter(commits, user %in% target_user)
    message("Found ", nrow(commits), " commits by me")
  }

  if(export){
    write.csv(commits, paste0(target_user,".csv"))
  } else {
    return(commits)
    }
}
