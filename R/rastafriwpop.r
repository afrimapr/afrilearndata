#' @name rastafriwpop
#' @aliases raster
#' @title modelled population density 2020 per square km from WorldPop aggregated to mean per 20km squares
#'
#' @description a \code{raster} object modelled population density 2020 per square km from WorldPop aggregated to mean per 20km squares
#'
#' @format Formal class 'raster';
#'
#' Geographical coordinates WGS84 datum (CRS EPSG 4326)
#'
#' @seealso
#' https://www.worldpop.org
#'
#' @source \url{https://www.worldpop.org/geodata/summary?id=24777}
#' @docType data
#' @keywords datasets sf
#' @examples
#' if (requireNamespace("raster", quietly = TRUE)) {
#'   library(raster)
#'   data(rastafriwpop)
#'   # or
#'   rastafriwpop <- raster::raster(system.file("extdata/rastafriwpop.tif", package="afrilearndata"))
#'
#'   plot(rastafriwpop)
#' }
"rastafriwpop"
