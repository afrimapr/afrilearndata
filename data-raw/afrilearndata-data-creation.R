## code to prepare data objects from raw files stored in inst/extdata
## keeping the raw files allows the package also to be used to demonstrate reading in data


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

# POINTS
# needs to go after polygons because uses country names from that

library(maps)
data(world.cities)
library(countrycode) # to aid in matching country names in world.cities

dfcapitals <- world.cities[ which(world.cities$capital==1), ]

# may have problems with countrynames being different
# this gets 45
#dfafricapitals <- dfcapitals[ which(dfcapitals$country.etc %in% sfafricountries$name_long), ]

#convert to iso3 using countrycode
dfcapitals$iso3c <- countrycode::countrycode(dfcapitals$country.etc, origin = 'country.name', destination = 'iso3c')
#use iso3c to identify capitals in Africa
# now gets 52
dfafricapitals <- dfcapitals[ which(dfcapitals$iso3c %in% sfafricountries$iso_a3), ]
# but that does include Serbia(iso3c NA) & Netherlands Antilles(iso3c NA) & Micronesia
# down to 49
dfafricapitals <- dfafricapitals[ !is.na(dfafricapitals$iso3c), ]

#which capitals not included ?
#sfafricountries$name_long[ -which(sfafricountries$iso_a3 %in% dfafricapitals$iso3c)]
#[1] "South Sudan" "Somaliland"
#TODO add capitals for "South Sudan" "Somaliland"

#TODO rename column country.etc

#convert to sf: 4326 is CRS code for most common lat lon WGS84
sfafricapitals <- sf::st_as_sf(dfafricapitals, coords=c("long","lat"), crs=4326)

usethis::use_data(sfafricapitals, overwrite = TRUE)

#mapview::mapview(sfafricapitals, zcol="name")

# RASTER
# todo find a small raster datset

#usethis::use_data(DATASET, overwrite = TRUE)
