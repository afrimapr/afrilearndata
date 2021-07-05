#' @name afrilandcover
#' @aliases afrilandcover
#' @title landcover raster for Africa, categorical, 20km resolution
#'
#' @description a \code{raster} object storing the majority landcover in 2019 for all 20km squares in Africa.
#' Categorical, 20km resolution from [MODIS](https://lpdaac.usgs.gov/products/mcd12c1v006/).
#' Cell values are numeric, landcover type names are stored in Raster Attribute Table (RAT) that can be accessed via `levels(afrilandcover)`
#' See data-raw/afrilearndata-creation.R for how the data object is created.
#'
#' @format Formal class 'raster';
#'
#' Geographical coordinates WGS84 datum (CRS EPSG 4326)
#'
#' @seealso
#' Friedl, M., D. Sulla-Menashe. MCD12C1 MODIS/Terra+Aqua Land Cover Type Yearly L3 Global 0.05Deg CMG V006. 2015, distributed by NASA EOSDIS Land Processes DAAC, https://doi.org/10.5067/MODIS/MCD12C1.006. Accessed 2021-06-07.#'
#' @source \url{https://lpdaac.usgs.gov/products/mcd12c1v006/}
#' @docType data
#' @keywords datasets sf
#' @examples
#' if (requireNamespace("raster", quietly = TRUE)) {
#'   library(raster)
#'   data(afrilandcover)
#'   # or
#'   filename <- system.file("extdata","afrilandcover.grd", package="afrilearndata", mustWork=TRUE)
#'   afrilandcover <- raster::raster(filename)
#'
#'   plot(afrilandcover)
#' }
#'
#' # interactive plotting with mapview
#' if (requireNamespace("mapview", quietly = TRUE) &
#'     requireNamespace("rgdal", quietly = TRUE)) {
#'   library(mapview)
#'   mapview(afrilandcover,
#'           att="landcover",
#'           col.regions=levels(afrilandcover)[[1]]$colour)
#' }
#'
#'
"afrilandcover"
