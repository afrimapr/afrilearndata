#' @name africontinent
#' @aliases sfpolygon
#' @title African country boundaries
#'
#' @description a \code{sf} object containing low resolution African continent outline
#'
#' @format Formal class 'sf';
#' \itemize{
#'     \item{name} {character vector continent name}
#'     \item{geometry} {sfc_MULTIPOLYGON}
#' }
#'
#' Geographical coordinates WGS84 datum (CRS EPSG 4326)
#'
#' @seealso
#' https://cran.r-project.org/web/packages/rnaturalearth/
#'
#' @source \url{https://www.naturalearthdata.com/downloads/110m-cultural-vectors/}
#' @docType data
#' @keywords datasets sf
#' @examples
#' if (requireNamespace("sf", quietly = TRUE)) {
#'   library(sf)
#'   data(africontinent)
#'   # or
#'   africontinent <- sf::read_sf(system.file("extdata/africontinent.shp", package="afrilearndata"))
#'
#'   plot(sf::st_geometry(africontinent))
#' }
"africontinent"
