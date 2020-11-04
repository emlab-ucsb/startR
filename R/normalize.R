#' Normalize shipname and callsign
#'
#' @description Performs a series of string normalizations to get a clean shipname or callsign.
#' This was inspired by Jaeyoon Park's Python Module: \url{https://github.com/jaeyoonpark/shipdataprocess}.
#'
#' \code{normalize_shipname} will do the following:
#' \itemize{
#'   \item Make all letters into capital letters
#'   \item Remove leading and trailing whitespaces
#'   \item Remove linebreaks
#'   \item Remove all references to vessel codes (\emph{i.e.} \code{MFV} stands for Marine Fishing Vessel)
#'   \item Convert numbers expressed as letters to numbers (\emph{i.e.} \code{ONE} becomes \code{1})
#'   \item Convert roman numerals to arabic numbers
#'   \item Remove \code{NO.} when it references a number (\emph{i.e.} \code{BOAT NO.5} becomes \code{BOAT5})
#'   \item Remove all special characters
#' }
#'
#' \code{normalize_callsign} will:
#' \itemize{
#'   \item Make all letters into capital letters
#'   \item Remove leading and trailing whitespaces
#'   \item Remove linebreaks
#'   \item Remove leading zeroes (\emph{i.e.} \code{007JAMESBOND} becomes \code{7JAMESBOND})
#'   \item Remove all special characters
#' }
#'
#' @param name A character string (or vector of strings) to be normalized
#' @param callsign A character string (or vector of strings) to be normalized
#' @param economic_unit A character string (or vector of strings) to be normalized
#' @param ... Any other arguments
#'
#' @return A normmalized shipname or callsign
#'
#' @importFrom UnidecodeR unidecode get_transliterations
#' @importFrom stringr str_squish str_trim str_remove str_remove_all str_replace str_detect str_split str_extract
#' @importFrom magrittr %>%
#' @importFrom utils as.roman browseURL
#'
#' @aliases normalize_shipname normalize_callsign
#' @examples
#' # Normalize a shipname that contains special
#' # characters and roman numerals.
#' library(startR)
#' shipname <- "weird-+%()<>$;!&'`#/boat name IV"
#' normalize_shipname(shipname)
#'
#' # Normalize a callsign starting with zeros
#' # and weird characters
#' callsign <- "0020300a-+%()<>$;!&'`#/"
#' normalize_callsign(callsign)
#' @name normalize
NULL

#' @export
#' @rdname normalize
normalize_shipname <- function(name, ...) {
  if (is.na(name) | (name != name) | (name == "")){
    return(NA)
  }

  # Translate weird characters
  name <- unidecode(name, language = "all")

  ## turn to upper cases
  name <- toupper(name)

  ## remove nasty charcters, white space
  name <- enc2utf8(name)
  name <- str_squish(name)
  name <- str_trim(name)
  name <- str_remove(name, "\n")
  name <- str_remove(name, "\r")

  ## remove fishing vessel code
  name <-stringr::str_remove(name, "MFV[^\\w]+")  ## fishing vessel code in English
  name <-stringr::str_remove(name, "MPV[^\\w]+")  ## fishing vessel code in English
  name <-stringr::str_remove(name, "HMS[^\\w]+")  ## fishing vessel code in English
  name <-stringr::str_remove(name, "LPG[/|C]*[\\W]*|LNG[/|C]*[\\W]*")  ## LPG/LNG variations
  name <-stringr::str_remove(name, "(\\s|^)F[^\\w\\s]*V[^\\w]*")   ## fishing vessel code in English (F/V, F-V, F.V, FV: etc)
  name <-stringr::str_remove(name, "^F[^\\w\\s]*B[^\\w]+")   ## fishing vessel code in English
  name <- stringr::str_remove(name, " F[^\\w\\s]*B[^\\w]*(\\s|$)")
  name <- stringr::str_remove(name, "^M[^\\w\\s]*P[^\\w]+")   ## fishing vessel code in Italy/Spain
  name <- stringr::str_remove(name, " M[^\\w\\s]*P[^\\w]*(\\s|$)")
  name <- stringr::str_remove(name, "^M[^\\w\\s]*B[^\\w]+")   ## fishing vessel code in Italy/Spain
  name <- stringr::str_remove(name, " M[^\\w\\s]*B[^\\w]*(\\s|$)")
  name <- stringr::str_remove(name, "^G[^\\w\\s]*V[^\\w]+")   ## mostly in UK
  name <- stringr::str_remove(name, "S+F+[^\\w]+G[^\\w\\s]*V[^\\w]*")
  name <- stringr::str_remove(name, " G[^\\w\\s]*V[^\\w]*(\\s|$)")
  name <- stringr::str_remove(name, "^M[^\\w\\s]*V[^\\w]+")   ## in English
  name <- stringr::str_remove(name, " M[^\\w\\s]*V[^\\w]*(\\s|$)")
  name <- stringr::str_remove(name, "^M[^\\w\\s]+S[^\\w]+")   ## Merchant Ship
  name <- stringr::str_remove(name, " M[^\\w\\s]+S[^\\w]*(\\s|$)")
  name <- stringr::str_remove(name, "^M[^\\w\\s]*K[^\\w]+")   ## mostly in northern europe
  name <- stringr::str_remove(name, " M[^\\w\\s]+K[^\\w]*(\\s|$)")
  name <- stringr::str_remove(name, "^R[^\\w\\s]*V[^\\w]+")   ## Research Vessel
  name <- stringr::str_remove(name, " R[^\\w\\s]*V[^\\w]*(\\s|$)")

  ## Other prefixes
  name <- stringr::str_remove(name, "^T[^\\w\\s]*T[^\\w]+")   ## Tender To
  name <- stringr::str_remove(name, " T[^\\w\\s]*T[^\\w]*($)")
  name <- stringr::str_remove(name, "^S[^\\w\\s]*Y[^\\w]+")   ## Steam Yacht
  name <- stringr::str_remove(name, " S[^\\w\\s]*Y[^\\w]*($)")
  name <- stringr::str_remove(name, "^M[^\\w\\s]*F[^\\w]+")   ## Motor Ferry
  name <- stringr::str_remove(name, " M[^\\w\\s]*F[^\\w]*($)")
  name <- stringr::str_remove(name, "^S[^\\w\\s]*S[^\\w]+")   ## Steam Ship
  name <- stringr::str_remove(name, " S[^\\w\\s]*S[^\\w]*($)")
  name <- stringr::str_remove(name, "^S[^\\w\\s]*V[^\\w]+")   ## Sailing Vessel
  name <- stringr::str_remove(name, " S[^\\w\\s]*V[^\\w]*($)")
  name <- stringr::str_remove(name, "^M[^\\w\\s]*T[^\\w]+")   ## Motor Tanker
  name <- stringr::str_remove(name, " M[^\\w\\s]*T[^\\w]*($)")
  name <- stringr::str_remove(name, "^M[^\\w\\s]+Y[^\\w]+")   ## Motor Yacht
  name <- stringr::str_remove(name, " M[^\\w\\s]+Y[^\\w]*($)")
  name <- stringr::str_remove(name, "^[A-Z]/[A-Z][^\\w]+")   ## All other types of X/X
  name <- stringr::str_remove(name, " [A-Z]/[A-Z]($)")
  name <- stringr::str_remove(name, "^[A-Z]\\\\[A-Z][^\\w]+")   ## All other types of X\X
  name <- stringr::str_remove(name, " [A-Z]\\\\[A-Z]($)")

  ## All additional information in parentheses and brackets
  name <- stringr::str_remove(name, "\\(.+\\)")
  name <- stringr::str_remove(name, "\\[.+\\]")
  name <- stringr::str_trim(name)

  ## Extract numbers from letters
  name <- stringr::str_replace(name, " ONE($)| UNO($)| UN($)", " 1")
  name <- stringr::str_replace(name, " TWO($)| DOS($)| DEUX($)", " 2")
  name <- stringr::str_replace(name, " THREE($)| TRES($)| TROIS($)", " 3")
  name <- stringr::str_replace(name, " FOUR($)| CUATRO($)| QUATRE($)", " 4")
  name <- stringr::str_replace(name, " FIVE($)| CINCO($)| CINQ($)", " 5")
  name <- stringr::str_replace(name, " SIX($)| SEIS($)| SIX($)", " 6")
  name <- stringr::str_replace(name, " SEVEN($)| SIETE($)| SEPT($)", " 7")
  name <- stringr::str_replace(name, " EIGHT($)| OCHO($)| HUIT($)", " 8")
  name <- stringr::str_replace(name, " NINE($)| NUEVE($)| NEUF($)", " 9")
  name <- stringr::str_replace(name, " TEN($)| DIEZ($)| DIX($)", " 10")
  name <- stringr::str_replace(name, " ELEVEN($)| ONCE($)| ONZE($)", " 11")
  name <- stringr::str_replace(name, " TWELVE($)| DOCE($)| DOUZE($)", " 12")
  name <- stringr::str_replace(name, " THIRTEEN($)| TRECE($)| TREIZE($)", " 13")
  name <- stringr::str_replace(name, " FOURTEEN($)| CATORCE($)| QUATORZE($)", " 14")
  name <- stringr::str_replace(name, " FIFTEEN($)| QUINCE($)| QUINZE($)", " 15")

  ## country specific appendix (korea)
  name <- stringr::str_replace(name, " HO($)", " ")

  ## remove NO.s such in NO.5, NO5, NO:5, NO. 5, NO 5, N5, N-5 etc
  name <- stringr::str_remove(name, "NO[^\\w\\s]*[\\s]*(?=\\d+)")
  name <- stringr::str_remove(name, "[\\s]+N[\\W_0]*(?=\\d+)")
  name <- stringr::str_remove(name, "NO\\.\\s*(?=[^0-9]+)")

  ## turn "&" to "AND"
  name <- stringr::str_replace(name, "(?<=[A-Z])\\s+&\\s+(?=[A-Z])", " AND ") ## replace "BLACK & WHITE" to "BLACK AND WHITE"

  ## deromanization
  vs <- stringr::str_split(name, "\\s+|-|(?<=[A-Z]{3})\\.")
  ## if last word from the name text has L/C/D/M then do not deromanize
  if (!str_detect(vs[[1]][length(vs[[1]])], "[LCDM]")){
    if(str_detect(vs[[1]][length(vs[[1]])], "[IVX]")){
      if(length(vs[[1]]) > 1){
        vs[[1]][length(vs[[1]])] <- as.roman(vs[[1]][length(vs[[1]])])
        if(!is.na(vs[[1]][length(vs[[1]])])){
          vs[[1]][length(vs[[1]])] <- as.numeric(vs[[1]][length(vs[[1]])])
          ## attach the deromanized digits to the end
          name <- paste(vs[[1]], collapse = " ")
        }
      }
    }
  }

  ## check if the name starts with digits, if yes move it to the end
  if(str_detect(name, "^\\d")){
    name <- paste(str_remove(name, "^\\d+"), stringr::str_extract(name, "^\\d+"))
  }

  ## remove 0s from the numbers starting with 0s
  if(str_detect(name, "\\d+$")){
    sufix <- stringr::str_extract(name, "\\d+$")
    non_zeros <- stringr::str_remove_all(sufix, "^0+")
    name <- stringr::str_replace(name, sufix, non_zeros)
  }

  ## now, remove all special characters, squish, and trim
  name <- stringr::str_remove_all(name, "[^[:alnum:]]")
  name <- stringr::str_squish(name)
  name <- stringr::str_trim(name)

  if (name == ""){return(NA)}

  return(name)
}

#' @export
#' @rdname normalize
normalize_callsign <- function(callsign, ...) {
  if (is.na(callsign) | (callsign != callsign) | (callsign == "")){
    return(NA)
  }

  ## turn to upper cases
  callsign <- toupper(callsign)

  ## remove nasty charcters, white space
  callsign <- unidecode(callsign, language = "all")
  callsign <- enc2utf8(callsign)
  callsign <- stringr::str_squish(callsign)
  callsign <- stringr::str_trim(callsign)
  callsign <- stringr::str_remove(callsign, "\n")
  callsign <- stringr::str_remove(callsign, "\r")
  callsign <- stringr::str_remove_all(callsign, "[^[:alnum:]]") # Remove non-alphanumeric characters
  callsign <- stringr::str_remove(callsign, "^0+") # Remove zeroes at the start

  if(callsign == ""){return(NA)}

  return(callsign)
}

#' @export
#' @rdname normalize
normalize_economic_unit <- function(economic_unit, ...) {
  economic_unit <- economic_unit %>%
    stringr::str_to_upper() %>%
    stringr::str_replace_all(pattern = "Ñ", replacement = "N") %>%
    stringr::str_replace(pattern = "PE¿ASCO", replacement = "PENASCO") %>%
    stringr::str_replace(pattern = "COMPA¿¿A", replacement = "COMPANIA") %>%
    stringr::str_replace(pattern = "PENA", replacement = "") %>%
    stringr::str_replace(pattern = "CAJ¿N DOM¿NGUEZ", replacement = "CAJAN DOMINGUEZ") %>%
    stringr::str_replace(pattern = "RUISE¿OR", replacement = "RUISENOR") %>%
    stringr::str_replace(pattern = "MAR¿AS", replacement = "MARIAS") %>%
    stringr::str_replace(pattern = "ART¿CULO", replacement = "ARTICULO") %>%
    stringr::str_replace(pattern = "PROGRESE¿O", replacement = "PROGRESENO") %>%
    stringr::str_remove_all(pattern = "[^[:alnum:]|\\s]") %>%
    stringr::str_remove(pattern = " DE RL MI DE IP Y CV") %>%
    stringr::str_remove(pattern = "SC DE RL DE CV") %>%
    stringr::str_remove(pattern = "S DE RL DE C V") %>%
    stringr::str_remove(pattern = "S DE R L DE CV") %>%
    stringr::str_remove(pattern = "SC DE RL DE CV") %>%
    stringr::str_remove(pattern = "S DE RL DE CV") %>%
    stringr::str_remove(pattern = "SAPI DE CV") %>%
    stringr::str_remove(pattern = "S DE RL MI") %>%
    stringr::str_remove(pattern = "SCL DE CV") %>%
    stringr::str_remove(pattern = "SPR DE RI") %>%
    stringr::str_remove(pattern = "SRL DE CV") %>%
    stringr::str_remove(pattern = "SA DE C V") %>%
    stringr::str_remove(pattern = "S C DE RL") %>%
    stringr::str_remove(pattern = "S  DE C V") %>%
    stringr::str_remove(pattern = "SC DE RL") %>%
    stringr::str_remove(pattern = "SA DE CV") %>%
    stringr::str_remove(pattern = "SC RL CV") %>%
    stringr::str_remove(pattern = "SC DE CV") %>%
    stringr::str_remove(pattern = "RL DE CV") %>%
    stringr::str_remove(pattern = "SCL Y CV") %>%
    stringr::str_remove(pattern = "S DE CV") %>%
    stringr::str_remove(pattern = "S  DE CV") %>%
    stringr::str_remove(pattern = "SADE CV") %>%
    stringr::str_remove(pattern = "RLDE CV") %>%
    stringr::str_remove(pattern = "SCRLCV") %>%
    stringr::str_remove(pattern = "SC RL$") %>%
    stringr::str_remove(pattern = "^SCPP") %>%
    stringr::str_remove(pattern = "DE RL") %>%
    stringr::str_remove(pattern = "SA CV") %>%
    stringr::str_remove(pattern = "SC L$") %>%
    stringr::str_remove(pattern = "SPR$") %>%
    stringr::str_remove(pattern = " AC$") %>%
    stringr::str_remove(pattern = " SC$") %>%
    stringr::str_remove(pattern = " C$") %>%
    stringr::str_remove(pattern = "SRL") %>%
    stringr::str_remove(pattern = "SCL") %>%
    stringr::str_remove(pattern = "^SC") %>%
    stringr::str_remove(pattern = "SSS") %>%
    stringr::str_remove(pattern = " [:digit:]$") %>%
    stringr::str_trim()

  economic_unit[economic_unit == ""] <- NA

  return(economic_unit)

}


















