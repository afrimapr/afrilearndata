#' @name rastafriwpop2020
#' @aliases rastafriwpop20
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
#'   data(rastafriwpop2020)
#'   # or
#'   filename <- system.file("extdata/rastafriwpop2020.tif", package="afrilearndata")
#'   rastafriwpop2020 <- raster::raster(filename)
#'
#'   plot(rastafriwpop2020)
#' }
"rastafriwpop2020"

#' @name rastafriwpop2000
#' @aliases rastafriwpop00
#' @title modelled population density 2000 per square km from WorldPop aggregated to mean per 20km squares
#'
#' @description a \code{raster} object modelled population density 2000 per square km from WorldPop aggregated to mean per 20km squares
#'
#' @format Formal class 'raster';
#'
#' Geographical coordinates WGS84 datum (CRS EPSG 4326)
#'
#' @seealso
#' https://www.worldpop.org
#'
#' @source \url{https://www.worldpop.org/geodata/summary?id=24757}
#' @docType data
#' @keywords datasets sf
#' @examples
#' if (requireNamespace("raster", quietly = TRUE)) {
#'   library(raster)
#'   data(rastafriwpop2000)
#'   # or
#'   filename <- system.file("extdata/rastafriwpop2000.tif", package="afrilearndata")
#'   rastafriwpop2000 <- raster::raster(filename)
#'
#'   plot(rastafriwpop2000)
#' }
"rastafriwpop2000"
