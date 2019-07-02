#' Normalize shipname and callsign
#'
#' @description Performs a series of string normalizations to get a clean shipname or callsign.
#' This was inspired by Jaeyoon Park's Python Module \url{https://github.com/jaeyoonpark/shipdataprocess}.
#'
#' @param name A character string (or vector of strings) to be normalized
#' @param callsign A character string (or vector of strings) to be normalized
#' @param ... Any other arguments
#'
#' @return A normmalized shipname or callsign
#'
#' @importFrom  UnidecodeR unidecode
#' @importFrom  stringr str_squish str_trim str_remove str_remove_all str_replace str_detect str_split str_extract
#' @importFrom magrittr %>%
#' @name %>%
#' @rdname pipe
#'
#' @aliases normalize_shipname normalize_callsign
#'
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
#' @name normalize
NULL

#' @export
#' @rdname normalize
normalize_shipname <- function(name, ...) {
  if (is.na(name) | (name != name) | (name == "")){
    return(NA)
  }

  ## turn to upper cases
  name <- toupper(name)

  ## remove nasty charcters, white space
  name <- unidecode(name, language = "all") %>%
    enc2utf8() %>%
    str_squish() %>%
    str_trim() %>%
    str_remove("\n") %>%
    str_remove("\r")

  ## remove fishing vessel code
  name <- str_remove(name, "MFV[^\\w]+") %>%  ## fishing vessel code in English
    str_remove("MPV[^\\w]+") %>%  ## fishing vessel code in English
    str_remove("HMS[^\\w]+") %>%  ## fishing vessel code in English
    str_remove("LPG[/|C]*[\\W]*|LNG[/|C]*[\\W]*") %>%  ## LPG/LNG variations
    str_remove("(\\s|^)F[^\\w\\s]*V[^\\w]*") %>%   ## fishing vessel code in English (F/V, F-V, F.V, FV: etc)
    str_remove("^F[^\\w\\s]*B[^\\w]+") %>%   ## fishing vessel code in English
    str_remove(" F[^\\w\\s]*B[^\\w]*(\\s|$)") %>%
    str_remove("^M[^\\w\\s]*P[^\\w]+") %>%   ## fishing vessel code in Italy/Spain
    str_remove(" M[^\\w\\s]*P[^\\w]*(\\s|$)") %>%
    str_remove("^M[^\\w\\s]*B[^\\w]+") %>%   ## fishing vessel code in Italy/Spain
    str_remove(" M[^\\w\\s]*B[^\\w]*(\\s|$)") %>%
    str_remove("^G[^\\w\\s]*V[^\\w]+") %>%   ## mostly in UK
    str_remove("S+F+[^\\w]+G[^\\w\\s]*V[^\\w]*") %>%
    str_remove(" G[^\\w\\s]*V[^\\w]*(\\s|$)") %>%
    str_remove("^M[^\\w\\s]*V[^\\w]+") %>%   ## in English
    str_remove(" M[^\\w\\s]*V[^\\w]*(\\s|$)") %>%
    str_remove("^M[^\\w\\s]+S[^\\w]+") %>%   ## Merchant Ship
    str_remove(" M[^\\w\\s]+S[^\\w]*(\\s|$)") %>%
    str_remove("^M[^\\w\\s]*K[^\\w]+") %>%   ## mostly in northern europe
    str_remove(" M[^\\w\\s]+K[^\\w]*(\\s|$)") %>%
    str_remove("^R[^\\w\\s]*V[^\\w]+") %>%   ## Research Vessel
    str_remove(" R[^\\w\\s]*V[^\\w]*(\\s|$)")

  ## Other prefixes
  name <- str_remove(name, "^T[^\\w\\s]*T[^\\w]+") %>%   ## Tender To
    str_remove(" T[^\\w\\s]*T[^\\w]*($)") %>%
    str_remove("^S[^\\w\\s]*Y[^\\w]+") %>%   ## Steam Yacht
    str_remove(" S[^\\w\\s]*Y[^\\w]*($)") %>%
    str_remove("^M[^\\w\\s]*F[^\\w]+") %>%   ## Motor Ferry
    str_remove(" M[^\\w\\s]*F[^\\w]*($)") %>%
    str_remove("^S[^\\w\\s]*S[^\\w]+") %>%   ## Steam Ship
    str_remove(" S[^\\w\\s]*S[^\\w]*($)") %>%
    str_remove("^S[^\\w\\s]*V[^\\w]+") %>%   ## Sailing Vessel
    str_remove(" S[^\\w\\s]*V[^\\w]*($)") %>%
    str_remove("^M[^\\w\\s]*T[^\\w]+") %>%   ## Motor Tanker
    str_remove(" M[^\\w\\s]*T[^\\w]*($)") %>%
    str_remove("^M[^\\w\\s]+Y[^\\w]+") %>%   ## Motor Yacht
    str_remove(" M[^\\w\\s]+Y[^\\w]*($)") %>%
    str_remove("^[A-Z]/[A-Z][^\\w]+") %>%   ## All other types of X/X
    str_remove(" [A-Z]/[A-Z]($)") %>%
    str_remove("^[A-Z]\\\\[A-Z][^\\w]+") %>%   ## All other types of X\X
    str_remove(" [A-Z]\\\\[A-Z]($)")

  ## All additional information in parentheses and brackets
  name <- str_remove(name, "\\(.+\\)") %>%
    str_remove("\\[.+\\]")

  ## Extract numbers from letters
  name <- str_replace(name, " ONE($)| UNO($)| UN($)", " 1") %>%
    str_replace(" TWO($)| DOS($)| DEUX($)", " 2") %>%
    str_replace(" THREE($)| TRES($)| TROIS($)", " 3") %>%
    str_replace(" FOUR($)| CUATRO($)| QUATRE($)", " 4") %>%
    str_replace(" FIVE($)| CINCO($)| CINQ($)", " 5") %>%
    str_replace(" SIX($)| SEIS($)| SIX($)", " 6") %>%
    str_replace(" SEVEN($)| SIETE($)| SEPT($)", " 7") %>%
    str_replace(" EIGHT($)| OCHO($)| HUIT($)", " 8") %>%
    str_replace(" NINE($)| NUEVE($)| NEUF($)", " 9") %>%
    str_replace(" TEN($)| DIEZ($)| DIX($)", " 10") %>%
    str_replace(" ELEVEN($)| ONCE($)| ONZE($)", " 11") %>%
    str_replace(" TWELVE($)| DOCE($)| DOUZE($)", " 12") %>%
    str_replace(" THIRTEEN($)| TRECE($)| TREIZE($)", " 13") %>%
    str_replace(" FOURTEEN($)| CATORCE($)| QUATORZE($)", " 14") %>%
    str_replace(" FIFTEEN($)| QUINCE($)| QUINZE($)", " 15")

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

  ## now, remove all special characters
  name <- str_remove(name, "[\\W_]")

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

  name <- str_remove_all(name, "[^[:alnum:]]") %>%
    str_squish() %>%
    str_trim()

  if (name == ""){return(NA)}

  return(name)

}

#' @export
#' @rdname normalize
normalize_callsign <- function(callsign) {
  if (is.na(callsign) | (callsign != callsign) | (callsign == "")){
    return(NA)
  }

  ## turn to upper cases
  callsign <- toupper(callsign)

  ## remove nasty charcters, white space
  callsign <- unidecode(callsign, language = "all") %>%
    enc2utf8() %>%
    str_squish() %>%
    str_trim() %>%
    str_remove("\n") %>%
    str_remove("\r") %>%
    str_remove_all("[^[:alnum:]]") %>% # Remove non-alphanumeric characters
    str_remove("^0+") # Remove zeroes at the start

  if(callsign == ""){return(NA)}

  return(callsign)
}
