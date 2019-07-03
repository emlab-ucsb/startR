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
#' @param ... Any other arguments
#'
#' @return A normmalized shipname or callsign
#'
#' @importFrom UnidecodeR unidecode
#' @importFrom stringr str_squish str_trim str_remove str_remove_all str_replace str_detect str_split str_extract
#'
#' @aliases normalize_shipname2 normalize_callsign2
#' @examples
#' # Normalize a shipname that contains special
#' # characters and roman numerals.
#' shipname <- "weird -+%()<>$;!&'`\\.#/boat name IV"
#' normalize_shipname(shipname)
#'
#' # Normalize a callsign starting with zeros
#' # and weird characters
#' callsign <- "0020300a-+%()<>$;!&'`\\.#/"
#' normalize_callsign(callsign)
#' @name normalize2
NULL

#' @export
#' @rdname normalize2
normalize_shipname2 <- function(name, ...) {
  if (is.na(name) | (name != name) | (name == "")){
    return(NA)
  }

  ## turn to upper cases
  name <- toupper(name)

  ## remove nasty charcters, white space
  name <- unidecode(name, language = "all")
  name <- enc2utf8(name)
  name <- str_squish(name)
  name <- str_trim(name)
  name <- str_remove(name, "\n")
  name <- str_remove(name, "\r")

  ## remove fishing vessel code
  name <- str_remove(name, "MFV[^\\w]+")  ## fishing vessel code in English
  name <- str_remove(name, "MPV[^\\w]+")  ## fishing vessel code in English
  name <- str_remove(name, "HMS[^\\w]+")  ## fishing vessel code in English
  name <- str_remove(name, "LPG[/|C]*[\\W]*|LNG[/|C]*[\\W]*")  ## LPG/LNG variations
  name <- str_remove(name, "(\\s|^)F[^\\w\\s]*V[^\\w]*")   ## fishing vessel code in English (F/V, F-V, F.V, FV: etc)
  name <- str_remove(name, "^F[^\\w\\s]*B[^\\w]+")   ## fishing vessel code in English
  name <- str_remove(name, " F[^\\w\\s]*B[^\\w]*(\\s|$)")
  name <- str_remove(name, "^M[^\\w\\s]*P[^\\w]+")   ## fishing vessel code in Italy/Spain
  name <- str_remove(name, " M[^\\w\\s]*P[^\\w]*(\\s|$)")
  name <- str_remove(name, "^M[^\\w\\s]*B[^\\w]+")   ## fishing vessel code in Italy/Spain
  name <- str_remove(name, " M[^\\w\\s]*B[^\\w]*(\\s|$)")
  name <- str_remove(name, "^G[^\\w\\s]*V[^\\w]+")   ## mostly in UK
  name <- str_remove(name, "S+F+[^\\w]+G[^\\w\\s]*V[^\\w]*")
  name <- str_remove(name, " G[^\\w\\s]*V[^\\w]*(\\s|$)")
  name <- str_remove(name, "^M[^\\w\\s]*V[^\\w]+")   ## in English
  name <- str_remove(name, " M[^\\w\\s]*V[^\\w]*(\\s|$)")
  name <- str_remove(name, "^M[^\\w\\s]+S[^\\w]+")   ## Merchant Ship
  name <- str_remove(name, " M[^\\w\\s]+S[^\\w]*(\\s|$)")
  name <- str_remove(name, "^M[^\\w\\s]*K[^\\w]+")   ## mostly in northern europe
  name <- str_remove(name, " M[^\\w\\s]+K[^\\w]*(\\s|$)")
  name <- str_remove(name, "^R[^\\w\\s]*V[^\\w]+")   ## Research Vessel
  name <- str_remove(name, " R[^\\w\\s]*V[^\\w]*(\\s|$)")

  ## Other prefixes
  name <- str_remove(name, "^T[^\\w\\s]*T[^\\w]+")   ## Tender To
  name <- str_remove(name, " T[^\\w\\s]*T[^\\w]*($)")
  name <- str_remove(name, "^S[^\\w\\s]*Y[^\\w]+")   ## Steam Yacht
  name <- str_remove(name, " S[^\\w\\s]*Y[^\\w]*($)")
  name <- str_remove(name, "^M[^\\w\\s]*F[^\\w]+")   ## Motor Ferry
  name <- str_remove(name, " M[^\\w\\s]*F[^\\w]*($)")
  name <- str_remove(name, "^S[^\\w\\s]*S[^\\w]+")   ## Steam Ship
  name <- str_remove(name, " S[^\\w\\s]*S[^\\w]*($)")
  name <- str_remove(name, "^S[^\\w\\s]*V[^\\w]+")   ## Sailing Vessel
  name <- str_remove(name, " S[^\\w\\s]*V[^\\w]*($)")
  name <- str_remove(name, "^M[^\\w\\s]*T[^\\w]+")   ## Motor Tanker
  name <- str_remove(name, " M[^\\w\\s]*T[^\\w]*($)")
  name <- str_remove(name, "^M[^\\w\\s]+Y[^\\w]+")   ## Motor Yacht
  name <- str_remove(name, " M[^\\w\\s]+Y[^\\w]*($)")
  name <- str_remove(name, "^[A-Z]/[A-Z][^\\w]+")   ## All other types of X/X
  name <- str_remove(name, " [A-Z]/[A-Z]($)")
  name <- str_remove(name, "^[A-Z]\\\\[A-Z][^\\w]+")   ## All other types of X\X
  name <- str_remove(name, " [A-Z]\\\\[A-Z]($)")

  ## All additional information in parentheses and brackets
  name <- str_remove(name, "\\(.+\\)")
  name <- str_remove(name, "\\[.+\\]")

  ## Extract numbers from letters
  name <- str_replace(name, " ONE($)| UNO($)| UN($)", " 1")
  name <- str_replace(name, " TWO($)| DOS($)| DEUX($)", " 2")
  name <- str_replace(name, " THREE($)| TRES($)| TROIS($)", " 3")
  name <- str_replace(name, " FOUR($)| CUATRO($)| QUATRE($)", " 4")
  name <- str_replace(name, " FIVE($)| CINCO($)| CINQ($)", " 5")
  name <- str_replace(name, " SIX($)| SEIS($)| SIX($)", " 6")
  name <- str_replace(name, " SEVEN($)| SIETE($)| SEPT($)", " 7")
  name <- str_replace(name, " EIGHT($)| OCHO($)| HUIT($)", " 8")
  name <- str_replace(name, " NINE($)| NUEVE($)| NEUF($)", " 9")
  name <- str_replace(name, " TEN($)| DIEZ($)| DIX($)", " 10")
  name <- str_replace(name, " ELEVEN($)| ONCE($)| ONZE($)", " 11")
  name <- str_replace(name, " TWELVE($)| DOCE($)| DOUZE($)", " 12")
  name <- str_replace(name, " THIRTEEN($)| TRECE($)| TREIZE($)", " 13")
  name <- str_replace(name, " FOURTEEN($)| CATORCE($)| QUATORZE($)", " 14")
  name <- str_replace(name, " FIFTEEN($)| QUINCE($)| QUINZE($)", " 15")

  ## country specific appendix (korea)
  name <- str_replace(name, " HO($)", " ")

  ## remove NO.s such in NO.5, NO5, NO:5, NO. 5, NO 5, N5, N-5 etc
  name <- str_remove(name, "NO[^\\w\\s]*[\\s]*(?=\\d+)")
  name <- str_remove(name, "[\\s]+N[\\W_0]*(?=\\d+)")
  name <- str_remove(name, "NO\\.\\s*(?=[^0-9]+)")

  ## turn "&" to "AND"
  name <- str_replace(name, "(?<=[A-Z])\\s+&\\s+(?=[A-Z])", " AND ") ## replace "BLACK & WHITE" to "BLACK AND WHITE"

  ## deromanization
  vs <- str_split(name, "\\s+|-|(?<=[A-Z]{3})\\.")
  ## if last word from the name text has L/C/D/M then do not deromanize
  if (!str_detect(vs[[1]][length(vs[[1]])], "[LCDM]")){
    if(str_detect(vs[[1]][length(vs[[1]])], "[IVX]")){
      vs[[1]][length(vs[[1]])] <- as.roman(vs[[1]][length(vs[[1]])])
      if(!is.na(vs[[1]][length(vs[[1]])])){
        vs[[1]][length(vs[[1]])] <- as.numeric(vs[[1]][length(vs[[1]])])
        ## attach the deromanized digits to the end
        name <- paste(vs[[1]], collapse = " ")
      }
    }
  }

  ## check if the name starts with digits, if yes move it to the end
  if(str_detect(name, "^\\d")){
    name <- paste(str_remove(name, "^\\d+"), str_extract(name, "^\\d+"))
  }

  ## remove 0s from the numbers starting with 0s
  if(str_detect(name, "\\d+$")){
    sufix <- str_extract(name, "\\d+$")
    non_zeros <- str_remove_all(sufix, "^0+")
    name <- str_replace(name, sufix, non_zeros)
  }

  ## now, remove all special characters, squish, and trim
  name <- str_remove_all(name, "[^[:alnum:]]")
  name <- str_squish(name)
  name <- str_trim(name)

  if (name == ""){return(NA)}

  return(name)

}

