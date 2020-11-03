#' write_metadata
#'
#' @description Generates a metadata file that matches the emLab SOP and asks you a series of questions to fill in (currently only works for .csv and .xlsx)
#'
#' @param file string for the filename you'd like to read in (e.g. "this_datasheet.csv")
#' @param path directory for where that files lives (and where the readme will be saved) (e.g. "Downloads/")
#' @param sheet_names concatenated strings (e.g. c("Macroinverts", "FishLength")) for which sheets of an excel file you'd like to generate a metadata file for; all sheets specified will be kept in the same readme document; if using a csv file or only one sheet is present, set to NULL
#'
#' @importFrom readxl read_excel
#'
#' @export
#'
write_metadata <- function(file, path, sheet_names = NULL){

  # Set file directory and read in file
  if(!grepl("/$", path)) {
    path <- paste0(path, "/")
  }

  # Save output file name for readme in the same location
  filename <- paste0("_readme_",unlist(strsplit(file, "[.]"))[1], ".txt")

  # Figure out file input
  file_type <- unlist(strsplit(file, "[.]"))[2]

  # Read in file if .csv
  if(file_type == "csv") {
    data <- read.csv(paste0(path,file))
  }

  # Read in file or create file list if .xlsx
  sheet_list <- NULL

  if(file_type == "xlsx" & is.null(sheet_names)) {
    data <- read_excel(paste0(path,file))
  }

  if(file_type == "xlsx" & !is.null(sheet_names)) {
    for(sheet in sheet_names) {
      temp <- read_excel(paste0(path,file), sheet = sheet)
      sheet_list[[sheet]] = temp
    }
  }

  # General Information
  name <- readline("What is your name? - ")
  email <- readline("What is your email? - ")
  date <- paste(Sys.Date())
  data_title <- readline("What is the title of this dataset? - ")
  author_name <- readline("Who is the author of this dataset? - ")
  author_email <- readline("What is the author's email? - ")
  pi <- readline("Who is the PI of this project? - ")
  copi <- readline("Who is the Associate or Co-investigator for this project? - ")
  prim_contact <- readline("Who is the primary contact for this project? - ")
  alt_contact <- readline("Who are the alternative contacts for this project? - ")
  data_date <- readline("What was the date of data collection (YYYYMMDD)? - ")
  data_loc <- readline("What was the location of data collection? (City, State, County, Country and/or GPS Coordinates or bounding boxes)? -  ")
  funding <- readline("Information about funding sources or sponsorship that supported data collection? - ")

  # Project Information
  proj_info <- readline("Describe how you have used this data in emLab projects - ")
  proj_name <- readline("emLab project name - ")
  proj_url <- readline("URL to project folder on emLab Team Drive - ")
  proj_desc <- readline("Project description (brief summary of project, how data were used, what data were used) - ")
  git_url <- readline("URL to project github repo - ")

  # Sharing/Access Information
  restcrictions <- readline("Are there any licenses/restrictions placed on the data or any limitations of reuse? - ")
  citation <- readline("What is the recommended citation for the data? - ")
  other_citations <- readline("Any citations/links emLab publications that cite or use the data? - ")
  links <- readline("Links to other publicly accessible locations for the data? - ")
  rel_links <- readline("Links or relationships to other datasets? - ")

  # Data Description/File Overview
  data_desc <- readline("Summary of data contents - ")
  file_list <- readline("Other relevant files/link to where they are stored (for non-secure data) - ")
  rel_desc <- readline("Relationship between files, if important for context - ")
  data_src <- readline("If data was derived from another source, list source - ")
  vers_control <- readline("If there are multiple versions of the dataset, list the file updated, and why the update was made - ")

  # Methods
  methods_desc <- readline("Describe the methods used for the collection/generation of the data - ")
  methods_desc_links <- readline("List any links or references to publications or other documentation containing experimental design or protocols used in data collection - ")
  methods_proc <- readline("Describe how the submitted data were generated from the raw or collected data - ")
  methods_qaqc <- readline("Describe any QAQC that was performed on the data - ")
  methods_people <- readline("List any people involved in the sample collection, processing, and/or submission - ")

  # Data - Specific Information

  # Data descriptions for csv files or files with one sheet
  if(is.null(sheet_names)) {
    cols <- data.frame("columns" = paste(colnames(data)),
                       "description" = NA,
                       "units" = NA,
                       "class" = NA,
                       "examples" = NA)
    for(i in 1:ncol(data)) {
      cols$description[i] <- readline(paste("What does column", colnames(data)[i], "mean? - "))
      cols$units[i] <- readline(paste("What are the units for or format of column", colnames(data)[i], "? - "))
      cols$class[i] <- class(data[[i]])[1]
      cols$examples[i] <- list(paste(head(unique(data[,i]), n = 3)))
    }
    size <- data.frame("n_rows" = nrow(data),
                       "n_cols" = ncol(data))
  }

  # Data descriptions for excel files or files with multiple sheets
  if(file_type == "xlsx" & !is.null(sheet_names)) {
    sheet_cols <- NULL
    sheet_size <- NULL
    for(sheet in sheet_names) {
      data <- sheet_list[[sheet]]
      cols <- data.frame("sheet" = sheet,
                         "columns" = paste(colnames(data)),
                         "units" = NA,
                         "description" = NA,
                         "class" = NA,
                         "examples" = NA)
      for(i in 1:ncol(data)) {
        cols$description[i] <- readline(paste("For Sheet", sheet,"- what does column", colnames(data)[i], "mean? - "))
        cols$units[i] <- readline(paste("For Sheet", sheet,"- what are the units for or format of column", colnames(data)[i], "? - "))
        cols$class[i] <- class(data[[i]])[1]
        cols$examples[i] <- list(paste(head(unique(data[,i]), n = 3)))
      }
      size <- data.frame("sheet" = sheet,
                         "n_rows" = nrow(data),
                         "n_cols" = ncol(data))
      sheet_cols <- rbind(sheet_cols, cols)
      sheet_size <- rbind(sheet_size, size)
    }
  }

missing_data <- readline("Missing data codes - ")
special_format <- readline("Specialized formats or other abbreviations used - ")

# Write File
sink(paste(path,filename), append = FALSE)
writeLines(c("This ",filename," file was generated on ", date,  " by ", name, " (", email, ")"), sep = "")
writeLines("")
writeLines("\n--------------------------")
writeLines("\nGENERAL INFORMATION")
writeLines("\n--------------------------")
writeLines("\n")
writeLines(c("\nTitle of Dataset:", data_title), sep = " ")
writeLines("\n")
writeLines(c("\nAuthor Information:", author_name, "(", author_email, ")"), sep = " ")
writeLines("\n")
writeLines(c("\n\t Principal Investigator:", pi), sep = " ")
writeLines(c("\n\t Associate or Co-investigator:", copi), sep = " ")
writeLines(c("\n\t Primary Contact:", prim_contact), sep = " ")
writeLines(c("\n\t Alternate Contact(s):", alt_contact), sep = " ")
writeLines("\n")
writeLines(c("\nDate of data collection:", data_date), sep = " ")
writeLines("\n")
writeLines(c("\nGeographic location of data collection:", data_loc), sep = " ")
writeLines("\n")
writeLines(c("\nInformation about funding sources or sponsorship that supported the collection of the data:", funding), sep = " ")
writeLines("\n")
writeLines("\n--------------------------")
writeLines("\nPROJECT INFORMATION")
writeLines("\n--------------------------")
writeLines("\n")
writeLines(proj_info)
writeLines(c("\nProject name:", proj_name, "(", proj_url, ")"), sep = " ")
writeLines("\n")
writeLines(c("\nProject Description:", proj_desc), sep = " ")
writeLines("\n")
writeLines(c("\nGitHub:", git_url), sep = " ")
writeLines("\n")
writeLines("\n--------------------------")
writeLines("\nSHARING/ACCESS INFORMATION")
writeLines("\n--------------------------")
writeLines("\n")
writeLines(c("\nLicenses/restrictions placed on the data, or limitations of reuse:", restcrictions), sep = " ")
writeLines("\n")
writeLines(c("\nRecommended citation for the data:", citation), sep = " ")
writeLines("\n")
writeLines(c("\nCitation for and links to publications that cite or use the data:", other_citations), sep = " ")
writeLines("\n")
writeLines(c("\nLinks to other publicly accessible locations of the data:", links), sep = " ")
writeLines("\n")
writeLines(c("\nLinks/relationships to ancillary or related data sets:", rel_links), sep = " ")
writeLines("\n")
writeLines("\n--------------------------")
writeLines("\nDATA DESCRIPTION & FILE OVERVIEW")
writeLines("\n--------------------------")
writeLines("\n")
writeLines(c("\nDescription:", data_desc), sep = " ")
writeLines("\n")
writeLines(c("\nFile list:", file_list), sep = " ")
writeLines("\n")
writeLines(c("\nRelationship between files, if important for context:", rel_desc), sep = " ")
writeLines("\n")
writeLines(c("\nIf data was derived from another source, list source:", data_src), sep = " ")
writeLines("\n")
writeLines(c("\nIf there are there multiple versions of the dataset, list the file updated, when and why update was made:", vers_control), sep = " ")
writeLines("\n")
writeLines("\n--------------------------")
writeLines("\nMETHODOLOGICAL INFORMATION")
writeLines("\n--------------------------")
writeLines("\n")
writeLines(c("\nDescription of methods used for collection/generation of data:", methods_desc), sep = " ")
writeLines("\n")
writeLines(c("\nLinks for method descriptions:", methods_desc_links), sep = " ")
writeLines("\n")
writeLines(c("\nMethods for processing the data:", methods_proc), sep = " ")
writeLines("\n")
writeLines(c("\nDescribe any quality-assurance procedures performed on the data:", methods_qaqc), sep = " ")
writeLines("\n")
writeLines(c("\nPeople involved with sample collection, processing, analysis and/or submission:", methods_people), sep = " ")
writeLines("\n")
writeLines("\n--------------------------")
writeLines("\nDATA SPECIFIC INFORMATION")
writeLines("\n--------------------------")
writeLines("\n")

if(is.null(sheet_names)) {
  writeLines(c("\nNumber of variables:", paste(size$n_cols)), sep = " ")
  writeLines(c("\nNumber of cases/rows:", paste(size$n_rows)), sep = " ")
  writeLines(c("\nColumns:"), sep = " ")
  for(row in 1:nrow(cols)) {
    writeLines(c("\n\t",paste(cols[row,1])), sep = " ")
    writeLines(c("\n\t\tDescription:",paste(cols[row,2])), sep = " ")
    writeLines(c("\n\t\tUnits/Format:",paste(cols[row,3])), sep = " ")
    writeLines(c("\n\t\tData Class:",paste(cols[row,4])), sep = " ")
    writeLines(c("\n\t\tExample Values:",paste(cols[row,5])), sep = " ")
    }
}

if(!is.null(sheet_names)) {
  for(sheet in sheet_names) {
    sheet_size_new <- sheet_size[which(sheet_size$sheet == sheet),]
    sheet_cols_new <- sheet_cols[which(sheet_cols$sheet == sheet),]
    writeLines(c("\n\nSheet:", paste(sheet)), sep = " ")
    writeLines(c("\nNumber of variables:", paste(sheet_size_new$n_cols)), sep = " ")
    writeLines(c("\nNumber of cases/rows:", paste(sheet_size_new$n_rows)), sep = " ")
    writeLines(c("\nColumns:"), sep = " ")
    for(row in 1:nrow(sheet_cols_new)) {
      writeLines(c("\n\t",paste(sheet_cols_new[row,2])), sep = " ")
      writeLines(c("\n\t\tDescription:",paste(sheet_cols_new[row,3])), sep = " ")
      writeLines(c("\n\t\tUnits/Format:",paste(sheet_cols_new[row,4])), sep = " ")
      writeLines(c("\n\t\tData Class:",paste(sheet_cols_new[row,5])), sep = " ")
      writeLines(c("\n\t\tExample Values:",paste(sheet_cols_new[row,6])), sep = " ")
    }
  }
}

writeLines("\n")
writeLines(c("\nMissing data codes:", missing_data), sep = " ")
writeLines(c("\nSpecialized formats or other abbreviations used:", special_format), sep = " ")
sink()

}


