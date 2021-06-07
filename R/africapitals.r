#' @name africapitals
#' @aliases sfpoints
#' @title African capital city points
#'
#' @description a \code{sf} object points of African capital cities
#' See data-raw/afrilearndata-creation.R for how the data object is created.
#'
#' @format Formal class 'sf'; 50 rows 5 columns
#' \itemize{
#'     \item{capitalname} {character vector capital city names}
#'     \item{countryname} {character vector country names}
#'     \item{pop} {numeric estimated population 2006}
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
#'   data(africapitals)
#'   # or
#'   filename <- system.file("extdata","africapitals.gpkg", package="afrilearndata", mustWork=TRUE)
#'   africapitals <- sf::read_sf(filename)
#'
#'   #plot(sf::st_geometry(africapitals))
#' }
"africapitals"
