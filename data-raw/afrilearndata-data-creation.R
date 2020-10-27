## code to prepare data objects from raw files stored in inst/extdata
## keeping the raw files allows the package also to be used to demonstrate reading in data


# POINTS


# LINES
sfafrihway <- sf::read_sf("inst/extdata/Trans-African Highway Network.kml")

#remove Description column, only has contents in first row
sfafrihway <- sfafrihway[ , which(names(sfafrihway)!='Description')]

usethis::use_data(sfafrihway, overwrite = TRUE)


# POLYGONS
# country boundaries from rnaturalearth
# just selected columns, save as shapefile to extdata for reading demos
# maybe simplify using rmapshaper to keep size low

library(rnaturalearth)

sfafricountries <- rnaturalearth::ne_countries(continent = 'Africa', returnclass = 'sf')

columns_to_include <- c('name','name_long','iso_a3','pop_est','gdp_md_est','income_grp','lastcensus')

sfafricountries <- sfafricountries[ , which(names(sfafricountries) %in% columns_to_include) ]

usethis::use_data(sfafricountries, overwrite = TRUE)

#save to extdata for reading demos
sf::write_sf(sfafricountries,"inst/extdata/africountries.shp")
#TODO check this
#GDAL Message 1: Value 149229090 of field pop_est of feature 33 not successfully written. Possibly due to too larger number with respect to field width

# RASTER
# todo find a small raster datset

#usethis::use_data(DATASET, overwrite = TRUE)
