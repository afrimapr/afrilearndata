#' @name afriairports
#' @aliases afriairports
#' @title African airports
#'
#' @description a \code{sf} object points of African airports.
#' See data-raw/afrilearndata-creation.R for how the data object is created.
#'
#' @format Formal class 'sf'; 50 rows 5 columns
#' \itemize{
#'     \item{id} {id numeric}
#'     \item{ident} {ident XXXX}
#'     \item{type} {large_airport medium_airport small_airport}
#'     \item{name} {airport name}
# for info : coordinates from csv are moved to the geometry column in the sf object
#     \item{latitude_deg} {latitude decimal degrees}
#     \item{longitude_deg} {longtude decimal degrees}
#'     \item{elevation_ft} {elevation in feet}
#'     \item{continent} {continent code AF}
#'     \item{country_name} {country name}
#'     \item{iso_country} {country code two letters capitalised}
#'     \item{region_name} {name of region}
#'     \item{iso_region} {iso region code incl country XX-YY}
#'     \item{local_region} {region code excl country YY}
#'     \item{municipality} {municipality}
#'     \item{scheduled_service} {scheduled_service 1=yes, 2=no}
#'     \item{gps_code} {gps charecter code}
#'     \item{iata_code} {iata character code}
#'     \item{local_code} {local code}
#'     \item{home_link} {web page url}
#'     \item{wikipedia_link} {wikipedia url}
#'     \item{keywords} {keywords}
#'     \item{score} {score}
#'     \item{last_updated} {last update}
#'     \item{geometry} {coordinates of the point sfc_POINT}
#' }
#'
#' Geographical coordinates WGS84 datum (CRS EPSG 4326)
#'
#'
#' @source \url{https://ourairports.com/continents/AF/airports.csv}
#' @docType data
#' @keywords datasets sf
#' @examples
#' if (requireNamespace("sf", quietly = TRUE)) {
#'   library(sf)
#'   data(afriairports)
#'
#'   # or read from the csv file which is stored in package as example to work with
#'   # filename <- system.file("extdata","afriairports.csv", package="afrilearndata", mustWork=TRUE)
#'   # dfairports <- readr::read_csv(filename)
#'   # and convert to sf object
#'   # afriairports <- sf::st_as_sf(dfairports, coords=c("longitude_deg", "latitude_deg"), crs=4326)
#'
#'   #plot(sf::st_geometry(afriairports))
#' }
"afriairports"
