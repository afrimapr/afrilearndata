#' @name africountries
#' @aliases sfpolygons
#' @title African country boundaries
#'
#' @description a \code{sf} object containing low resolution African country boundaries
#'
#' @format Formal class 'sf'; 51 rows, 8 columns
#' \itemize{
#'     \item{name} {character vector country names}
#'     \item{name_long} {character vector country names long}
#'     \item{pop_est} {numeric estimated population}
#'     \item{gdp_md_est} {numeric estimated gdp}
#'     \item{lastcensus} {numeric year of last census}
#'     \item{income_grp} {character vector income group}
#'     \item{iso_a3} {character vector ISO 3 letter country code}
#'     \item{geometry} {sfc_MULTIPOLYGON}
#'     \item{name_fr} {character vector French country names}
#'     \item{name_pt} {character vector Portuguese country names}
#'     \item{name_af} {character vector Afrikaans country names}
#'     \item{name_sw} {character vector Swahili country names}
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
#'   data(africountries)
#'   # or
#'   filename <- system.file("extdata","africountries.shp", package="afrilearndata", mustWork=TRUE)
#'   africountries <- sf::read_sf(filename)#'
#'   plot(sf::st_geometry(africountries))
#' }
"africountries"
