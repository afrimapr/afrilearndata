#' @name afripop2020
#' @aliases afripop20
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
#' WorldPop datasets are licensed under Creative Commons Attribution 4.0 International (CC BY 4.0) https://creativecommons.org/licenses/by/4.0/
#'
#' @source \url{https://www.worldpop.org/geodata/summary?id=24777}
#' @docType data
#' @keywords datasets sf
#' @examples
#' if (requireNamespace("raster", quietly = TRUE)) {
#'   library(raster)
#'   data(afripop2020)
#'   # or
#'   filename <- system.file("extdata","afripop2020.tif", package="afrilearndata", mustWork=TRUE)
#'   afripop2020 <- raster::raster(filename)
#'
#'   plot(afripop2020)
#' }
"afripop2020"

#' @name afripop2000
#' @aliases afripop00
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
#' WorldPop datasets are licensed under Creative Commons Attribution 4.0 International (CC BY 4.0) https://creativecommons.org/licenses/by/4.0/
#'
#' @source \url{https://www.worldpop.org/geodata/summary?id=24757}
#' @docType data
#' @keywords datasets sf
#' @examples
#' if (requireNamespace("raster", quietly = TRUE)) {
#'   library(raster)
#'   data(afripop2000)
#'   # or
#'   filename <- system.file("extdata","afripop2000.tif", package="afrilearndata", mustWork=TRUE)
#'   afripop2000 <- raster::raster(filename)
#'
#'   plot(afripop2000)
#' }
"afripop2000"
