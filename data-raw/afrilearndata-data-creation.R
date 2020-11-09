## code to prepare data objects from raw files stored in inst/extdata
## keeping the raw files allows the package also to be used to demonstrate reading in data


# LINES


filename <- r"(inst/extdata/trans-african-highway.kml)" #windows safe paths
sfafrihway <- sf::read_sf(filename)

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

#maybe making sure CRS is correct
sfafricountries <- sf::st_set_crs(sfafricountries,4326)

usethis::use_data(sfafricountries, overwrite = TRUE)

#save to extdata for reading demos
filename <- r"(inst/extdata/africountries.shp)" #windows safe paths
sf::write_sf(sfafricountries, filename)
#TODO check this
#GDAL Message 1: Value 149229090 of field pop_est of feature 33 not successfully written. Possibly due to too larger number with respect to field width

# potential 2nd polygon dataset of hexagonal equal area cartogram for African countries

#install.packages("geogrid")

library(geogrid)

new_cells <- geogrid::calculate_grid(shape = sfafricountries, grid_type = "hexagonal", seed=4)
sfafrihex <- assign_polygons(sfafricountries, new_cells)

mapview::mapview(sfafrihex, label='name')
# Warning message: sf layer has inconsistent datum (+proj=longlat +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +no_defs).
# Need '+proj=longlat +datum=WGS84'

# don't want 2 cells in madagascar
# can modify random seed
# for (i in 1:6) {
#   new_cells <- calculate_grid(shape = sfafricountries, grid_type = 'hexagonal', seed = i)
#   plot(new_cells, main = paste('Seed', i, sep=' '))
# }

#seeds 5,4,3,1 just have one cell for madagascar
#seed1 has lesotho below s.africa
#seed3 good:s.africa & lesotho in bottom row, bad: Eq. Guinea below Gabon
#seed4 best so far

#to add labels permanently to map
library(tmap)
tmap_mode("view")
tmap::tm_shape(sfafrihex) +
       tm_borders("red") +
       tm_text("name", col='blue')

#potential other tilemaps but gives error I think due to madagascar
#install.packages("tilemaps")
library(tilemaps)
sfafritilemap <- generate_map(sfafricountries, square = FALSE, flat_topped = TRUE)
# although coordinates are longitude/latitude, st_touches assumes that they are planar
# Error in generate_map(sfafricountries, square = FALSE, flat_topped = TRUE) :
#   regions are not contiguous



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

#remove capital column
sfafricapitals <- sfafricapitals[ , which(names(sfafricapitals) != "capital") ]

#rename column country.etc
names(sfafricapitals)[2] <- "countryname"

#convert to sf: 4326 is CRS code for most common lat lon WGS84
sfafricapitals <- sf::st_as_sf(dfafricapitals, coords=c("long","lat"), crs=4326)

usethis::use_data(sfafricapitals, overwrite = TRUE)

#save to extdata for reading demos - as geopackage for example and copes with longer column names
filename <- r"(inst/extdata/africapitals.gpkg)" #windows safe paths
sf::write_sf(sfafricapitals, filename)

#mapview::mapview(sfafricapitals, zcol="name")

# RASTER
# TODO find a small raster datset
#KoeppenGeiger 2017 half degree from kmz

filekmz <- r"(C:\Dropbox\_afrimapr\data\koeppen-geiger\Global_1986-2010_KG_30m.kmz)" #windows safe paths

#filename <- r"(C:\Dropbox\_afrimapr\data\koeppen-geiger\Koeppen-Geiger-ASCII.txt)" #windows safe paths
#filename <- r"(inst/extdata/Koeppen-Geiger-ASCII.txt)" #windows safe paths

library(raster)

rastkg <- raster(filekmz)

#cookie cut to the African continent
#https://gis.stackexchange.com/questions/92221/extract-raster-from-raster-using-polygon-shapefile-in-r
cr <- crop(rastkg, extent(sfafricountries), snap="out")
fr <- rasterize(sfafricountries, cr)
rastafrikg <- mask(x=cr, mask=fr)
plot(rastafrikg)

dim(rastafrikg)
#[1] 434 413   1
extent(rastafrikg)
# xmin       : -17.66667
# xmax       : 51.16667
# ymin       : -34.83333
# ymax       : 37.5
crs(rastafrikg)
#CRS arguments: +proj=longlat +datum=WGS84 +no_defs

#doesn't really show raster attribute table
ratify(rastafrikg)

#seems that may just have integer values 1-255 from the kmz
#there is an alternate way to read in from grd & gri files, but think these may be the higher res version

# ? mapview misses off west of continent
mapview::mapview(rastafrikg)


# maybe try generalising some worldpop data from package wopr instead
# https://github.com/wpgp/wopr

devtools::install_github('wpgp/wopr')
library(wopr)
#but that seems to be all individual countries

#or download 2020 global 30m (1km) data from here
#https://www.worldpop.org/geodata/summary?id=24777
#Estimated total number of people per grid-cell.
#The dataset is available to download in Geotiff format at a resolution of 30 arc (approximately 1km at the equator).

filewpop <- r"(C:\Dropbox\_afrimapr\data\worldpop\ppp_2020_1km_Aggregated.tif)" #windows safe paths

library(raster)

rastwpop <- raster(filewpop)

plot(rastwpop)
#too many pixels for mapview
#mapview(rastwpop)

#cookie cut to the African continent
#https://gis.stackexchange.com/questions/92221/extract-raster-from-raster-using-polygon-shapefile-in-r

sfworldland <- rnaturalearth::ne_download(scale='small',category='physical',type='land', returnclass = 'sf')
sfworldlandmed <- rnaturalearth::ne_download(scale='medium',category='physical',type='land', returnclass = 'sf')

#OR to get continent map I should just be able to aggregate sfafricountries
#see geocomputation
#BUT getting internal lines current issue
sfafricontinent = sfafricountries %>%
     group_by(continent) %>%
     summarize()
#example in geocomputation does work
#world_agg3 = world %>%
sfafricont = world %>%
       group_by(continent) %>%
       filter(continent=='Africa')  %>%
       summarize()


#can I cut world coast by sfafricountries


cr <- crop(rastwpop, extent(sfafricountries), snap="out")
#dim(cr) 8662 8252    1
#fr <- rasterize(sfafricountries, cr, silent=FALSE) #rasterise took >5 mins on 8k*8k grid
fr <- rasterize(sfafricont, cr, silent=FALSE) #rasterise took >5 mins on 8k*8k grid
rastafriwpop <- mask(x=cr, mask=fr)
plot(rastafriwpop)

#still 8k * 8k cells

#now want to aggregate(fact=[num cells in each direction])

rastafriwpop_agg10 <- raster::aggregate(rastafriwpop, fun=mean, fact=10)
#still 800 * 800 cells that mapview doesn't like to display

rastafriwpop_agg20 <- raster::aggregate(rastafriwpop, fun=mean, fact=20)
rastafriwpop_agg50 <- raster::aggregate(rastafriwpop, fun=mean, fact=50)
rastafriwpop_agg100 <- raster::aggregate(rastafriwpop, fun=mean, fact=100)

dim(rastafriwpop_agg20) #434 413   1
dim(rastafriwpop_agg50) #174 166   1

mapview(rastafriwpop_agg20) #BEST? > mapview happy
mapview(rastafriwpop_agg50) #highest density cell in lagos in sea
mapview(rastafriwpop_agg100)

#TODO why does 20km version cut off parts of W of continent ?

#usethis::use_data(DATASET, overwrite = TRUE)
