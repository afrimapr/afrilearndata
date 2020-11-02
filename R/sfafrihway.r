#' @name sfafrihway
#' @aliases sflines
#' @title African trans-continental highway network lines
#'
#' @description The object loaded is a \code{sf} object containing simplified lines of planned transcontinental highway
#'
#' @format Formal class 'sf' [package "sf"];
#' \itemize{
#'     \item{Name} {character vector of section names}
#'     \item{geom} {sfc_LINESTRING}
#' }
#' The object is in geographical coordinates using the WGS84 datum.
#'
#' @seealso
#' https://en.wikipedia.org/wiki/Trans-African_Highway_network
#'
#' @source \url{https://www.google.com/maps/d/u/0/viewer?msa=0&mid=1nEU2oBFzSxabx3Z14nTyZP3KSzY&ll=1.9249940151081273%2C12.874260000000021&z=3}
#' @docType data
#' @keywords datasets sf
#' @examples
#' if (requireNamespace("sf", quietly = TRUE)) {
#'   library(sf)
#'   data(sfafrihway)
#'   # or
#'   sfafrihway <- sf::read_sf("inst/extdata/Trans-African Highway Network.kml")
#'   #remove Description column, only has contents in first row
#'   sfafrihway <- sfafrihway[ , which(names(sfafrihway)!='Description')]
#'
#'   plot(sf::st_geometry(sfafrihway))
#' }
"sfafrihway"
