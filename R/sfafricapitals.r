#' @name sfafricapitals
#' @aliases sfpoints
#' @title African capital city points
#'
#' @description a \code{sf} object points of African capital cities
#'
#' @format Formal class 'sf'; 49 rows 5 columns
#' \itemize{
#'     \item{name} {character vector capital city names}
#'     \item{countryname} {character vector country names}
#'     \item{pop} {numeric estimated population}
#'     \item{iso3c} {character vector ISO 3 letter country code}
#'     \item{geometry} {sfc_POINT}
#' }
#'
#' Geographical coordinates WGS84 datum (CRS EPSG 4326)
#'
#'
#' @source \url{https://cran.r-project.org/web/packages/maps/}
#' @docType data
#' @keywords datasets sf
#' @examples
#' if (requireNamespace("sf", quietly = TRUE)) {
#'   library(sf)
#'   data(sfafricapitals)
#'   # or
#'   sfafricapitals <- sf::read_sf(system.file("extdata/africapitals.gpkg", package="afrilearndata"))
#'   #safe paths but I don't want to make complicated
#'   #r"(extdata/africapitals.gpkg)"
#'
#'   #plot(sf::st_geometry(sfafricapitals))
#' }
"sfafricapitals"
