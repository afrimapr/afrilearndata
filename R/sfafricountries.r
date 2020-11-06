#' @name sfafricountries
#' @aliases sfpolygons
#' @title African country boundaries
#'
#' @description a \code{sf} object containing low resolution African country boundaries
#'
#' @format Formal class 'sf' [package "sf"];
#' \itemize{
#'     \item{name} {character vector country names}
#'     \item{name_long} {character vector country names long}
#'     \item{pop_est} {numeric estimated population}
#'     \item{gdp_md_est} {numeric estimated gdp}
#'     \item{lastcensus} {numeric year of last census}
#'     \item{income_grp} {character vector income group}
#'     \item{iso_a3} {character vector ISO 3 letter country code}
#'     \item{geometry} {sfc_MULTIPOLYGON}
#' }
#' The object is in geographical coordinates using the WGS84 datum.
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
#'   data(sfafricountries)
#'   # or
#'   sfafricountries <- sf::read_sf(system.file("extdata/africountries.gpkg", package="afrilearndata"))
#'
#'   plot(sf::st_geometry(sfafricountries))
#' }
"sfafricountries"
