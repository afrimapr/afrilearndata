## code to prepare data objects from raw files stored in inst/extdata
## keeping the raw files allows the package also to be used to demonstrate reading in data

#############################################################################
# LINES


filename <- r"(inst/extdata/trans-african-highway.kml)" #windows safe paths
afrihighway <- sf::read_sf(filename)

#remove Description column, only has contents in first row
afrihighway <- afrihighway[ , which(names(afrihighway)!='Description')]

usethis::use_data(afrihighway, overwrite = TRUE)

############################################################################
# POLYGONS
# country boundaries from rnaturalearth
# just selected columns, save as shapefile to extdata for reading demos
# maybe simplify using rmapshaper to keep size low

library(rnaturalearth)

africountries <- rnaturalearth::ne_countries(continent = 'Africa', returnclass = 'sf')

columns_to_include <- c('name','name_long','iso_a3','pop_est','gdp_md_est','income_grp','lastcensus')

africountries <- africountries[ , which(names(africountries) %in% columns_to_include) ]

# ensure pop_est is numeric
africountries$pop_est <- as.numeric(africountries$pop_est)

# add columns for french, portuguese,
library(countrycode)

#africountries$name_fr <- countrycode(africountries$iso_a3, origin = 'iso3c', destination = 'iso.name.fr')
africountries$name_fr <- countrycode(africountries$iso_a3, origin = 'iso3c', destination = 'cldr.short.fr')
africountries$name_pt <- countrycode(africountries$iso_a3, origin = 'iso3c', destination = 'cldr.short.pt')
# afrikaans
africountries$name_af <- countrycode(africountries$iso_a3, origin = 'iso3c', destination = 'cldr.short.af')
# swahili
africountries$name_sw <- countrycode(africountries$iso_a3, origin = 'iso3c', destination = 'cldr.short.sw')


#Somlaliland come out as NA so put back in
africountries$name_fr[which(africountries$name=='Somaliland')] <- 'Somaliland'
africountries$name_pt[which(africountries$name=='Somaliland')] <- 'Somaliland'
africountries$name_af[which(africountries$name=='Somaliland')] <- 'Somaliland'
africountries$name_sw[which(africountries$name=='Somaliland')] <- 'Somaliland'

#maybe making sure CRS is correct
africountries <- sf::st_set_crs(africountries,4326)

usethis::use_data(africountries, overwrite = TRUE)

#save to extdata for reading demos
filename <- r"(inst/extdata/africountries.shp)" #windows safe paths
sf::write_sf(africountries, filename)

#TODO check this
# I suspect problem with UTF accents & a high popn. value
# Warning message:
# In CPL_write_ogr(obj, dsn, layer, driver, as.character(dataset_options),  :
#                      GDAL Message 1: One or several characters couldn't be converted correctly from UTF-8 to ISO-8859-1.  This warning will not be emitted anymore.
# In CPL_write_ogr(obj, dsn, layer, driver, as.character(dataset_options),  :
#                      GDAL Message 1: Value 149229090 of field pop_est of feature 33 not successfully written. Possibly due to too larger number with respect to field width

#####################################################################################
# African continent

#https://gis.stackexchange.com/questions/92221/extract-raster-from-raster-using-polygon-shapefile-in-r

#sfworldland <- rnaturalearth::ne_download(scale='small',category='physical',type='land', returnclass = 'sf')
#sfworldlandmed <- rnaturalearth::ne_download(scale='medium',category='physical',type='land', returnclass = 'sf')

#see geocomputation
#BUT getting internal lines current issue
africountries$continent <- "Africa"
africontinent = africountries %>%
        group_by(continent) %>%
        summarize()

plot(sf::st_geometry(africontinent))

#twitter example & set_precision fix
sfcountries<- rnaturalearth::ne_countries(continent='Africa', returnclass='sf')
africontinent<- sfcountries %>%
        group_by(continent) %>%
        st_set_precision(10) %>% # edzers suggestion was 10000
        summarize()
plot(sf::st_geometry(africontinent))

#TODO may want to add some missing islands to the continent e.g. cape verde, comoros

usethis::use_data(africontinent, overwrite = TRUE)

#save to extdata for reading demos
filename <- r"(inst/extdata/africontinent.shp)" #windows safe paths
sf::write_sf(africontinent, filename)

# potential 2nd polygon dataset of hexagonal equal area cartogram for African countries

#install.packages("geogrid")

library(geogrid)

new_cells <- geogrid::calculate_grid(shape = africountries, grid_type = "hexagonal", seed=4)
afrihex <- assign_polygons(africountries, new_cells)

mapview::mapview(afrihex, label='name')
# Warning message: sf layer has inconsistent datum (+proj=longlat +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +no_defs).
# Need '+proj=longlat +datum=WGS84'

# don't want 2 cells in madagascar
# can modify random seed
# for (i in 1:6) {
#   new_cells <- calculate_grid(shape = africountries, grid_type = 'hexagonal', seed = i)
#   plot(new_cells, main = paste('Seed', i, sep=' '))
# }

#seeds 5,4,3,1 just have one cell for madagascar
#seed1 has lesotho below s.africa
#seed3 good:s.africa & lesotho in bottom row, bad: Eq. Guinea below Gabon
#seed4 best so far

#to add labels permanently to map
library(tmap)
tmap_mode("view")
tmap::tm_shape(afrihex) +
       tm_borders("red") +
       tm_text("name", col='blue')

#potential other tilemaps but gives error I think due to madagascar
#install.packages("tilemaps")
library(tilemaps)
afritilemap <- generate_map(africountries, square = FALSE, flat_topped = TRUE)
# although coordinates are longitude/latitude, st_touches assumes that they are planar
# Error in generate_map(africountries, square = FALSE, flat_topped = TRUE) :
#   regions are not contiguous


############################################################################
# POINTS capitals
# needs to go after polygons because uses country names from that

library(maps)
data(world.cities)
library(countrycode) # to aid in matching country names in world.cities

dfcapitals <- world.cities[ which(world.cities$capital==1), ]

# may have problems with countrynames being different
# this gets 45
#dfafricapitals <- dfcapitals[ which(dfcapitals$country.etc %in% africountries$name_long), ]

#convert to iso3 using countrycode
dfcapitals$iso3c <- countrycode::countrycode(dfcapitals$country.etc, origin = 'country.name', destination = 'iso3c')
#use iso3c to identify capitals in Africa
# now gets 52
dfafricapitals <- dfcapitals[ which(dfcapitals$iso3c %in% africountries$iso_a3), ]
# but that does include Serbia(iso3c NA) & Netherlands Antilles(iso3c NA) & Micronesia
# down to 49
dfafricapitals <- dfafricapitals[ !is.na(dfafricapitals$iso3c), ]

#remove capital column
dfafricapitals <- dfafricapitals[ , which(names(dfafricapitals) != "capital") ]

#rename column country.etc
names(dfafricapitals)[1] <- "capitalname"
names(dfafricapitals)[2] <- "countryname"

#which capitals not included ?
#africountries$name_long[ -which(africountries$iso_a3 %in% africapitals$iso3c)]
#[1] "South Sudan" "Somaliland"
#TODO add capitals for "South Sudan" "Somaliland"

#https://geohack.toolforge.org/geohack.php?pagename=Juba&params=4_51_N_31_36_E_region:SS_type:city(525953)
dfss <- data.frame(capitalname="Juba",
                   countryname="South Sudan",
                   pop=NA,
                   lat=4.85,
                   long=31.6,
                   iso3c="SSD")

dfafricapitals <- rbind(dfafricapitals, dfss)

#Somaliland should probably be part of Somalia according to international recognition
#but given it is in africountries I should add the capital too
#https://geohack.toolforge.org/geohack.php?pagename=Somaliland&params=9_33_N_44_03_E_type:city
dfso <- data.frame(capitalname="Hargeysa",
                   countryname="Somaliland",
                   pop=NA,
                   lat=9.55,
                   long=44.05,
                   iso3c="Somaliland")

dfafricapitals <- rbind(dfafricapitals, dfso)

#?world.cities says pop is approximate population (as at January 2006)
#I could try to update or find better source


#convert to sf: 4326 is CRS code for most common lat lon WGS84
africapitals <- sf::st_as_sf(dfafricapitals, coords=c("long","lat"), crs=4326)

usethis::use_data(africapitals, overwrite = TRUE)

#save to extdata for reading demos - as geopackage for example and copes with longer column names
filename <- r"(inst/extdata/africapitals.gpkg)" #windows safe paths
sf::write_sf(africapitals, filename)

#mapview::mapview(africapitals, zcol="name")
#mapview(africountries, zcol="name") + mapview(africapitals, label="capitalname")

############################################################################
# POINTS CSV airports

# can read directly from the website
filename <- "https://ourairports.com/continents/AF/airports.csv"

dfairall <- readr::read_csv(filename)

nrow(dfairall)
#[1] 3526

names(dfairall)
# [1] "id"                "ident"             "type"              "name"              "latitude_deg"
# [6] "longitude_deg"     "elevation_ft"      "continent"         "country_name"      "iso_country"
# [11] "region_name"       "iso_region"        "local_region"      "municipality"      "scheduled_service"
# [16] "gps_code"          "iata_code"         "local_code"        "home_link"         "wikipedia_link"
# [21] "keywords"          "score"             "last_updated"

unique(dfairall$type)
#[1] "large_airport"  "medium_airport" "small_airport"  "closed"         "heliport"       "seaplane_base"

dfairall %>% group_by(type) %>% summarise(count = n())
# 1 closed           107
# 2 heliport          70
# 3 large_airport     48
# 4 medium_airport   448
# 5 seaplane_base      1
# 6 small_airport   2852

#496
#dfairports_ml <- dplyr::filter(dfairall, type=="large_airport" | type=="medium_airport" )

#3348
dfairports <- dplyr::filter(dfairall, grepl("airport",dfairall$type))

#having small, medium large will be nice !! e.g. for plotting by country with different symbols
#and 3k is not too many points I think
#also potential for challenges for learners - e.g. small airports obscure all at continental scale

# get into sf
afriairports <- sf::st_as_sf(dfairports, coords=c("longitude_deg", "latitude_deg"), crs=4326)

mapview(afriairports, zcol='type', label='name', cex=2)

# example filtering by type & country
afriair <- filter(afriairports, type=="large_airport" | type=="medium_airport" )
afriair <- filter(afriairports, country_name == "South Sudan" )

mapview(afriair, zcol='type', label='name')

#save sf object in package
usethis::use_data(afriairports, overwrite = TRUE)

# save as csv in the package
filename <- r"(inst/extdata/afriairports.csv)" #windows safe paths
# needed to specify utf encoding otherwise accents get messed up
write.csv(dfairports, filename, row.names=FALSE, fileEncoding="UTF-8")


##########################################################################
# RASTER
# aggregated worldpop data

#download 2020 global 30m (1km) data from here
#Unconstrained global mosaics
#2020
#https://www.worldpop.org/geodata/summary?id=24777
#2000
#https://www.worldpop.org/geodata/summary?id=24757
#Estimated total number of people per grid-cell.
#The dataset is available to download in Geotiff format at a resolution of 30 arc (approximately 1km at the equator).

#include 2 years to allow calculation of pop change
afripop2000 <- afripop2020 <- NULL

for( year in c(2020,2000))
{
  cat(year,"\n")

  if (year==2020)
     filewpop <- r"(C:\Dropbox\_afrimapr\data\worldpop\ppp_2020_1km_Aggregated.tif)" #windows safe paths
  else
     filewpop <- r"(C:\Dropbox\_afrimapr\data\worldpop\ppp_2000_1km_Aggregated.tif)" #windows safe paths

  rastwpop <- raster(filewpop)

  #plot(rastwpop)

  #crop to the bbox
  cr <- crop(rastwpop, extent(africountries), snap="out")
  #dim(cr) 8662 8252

  #rsaterize the continent
  fr <- rasterize(africontinent, cr, silent=FALSE) #rasterise takes >5 mins on 8k*8k grid
  #mask by the continent
  afripop <- mask(x=cr, mask=fr)
  #plot(afripop)

  #still 8k * 8k cells
  #now want to aggregate(fact=[num cells in each direction])

  #afripop_agg10 <- raster::aggregate(afripop, fun=mean, fact=10)
  #still 800 * 800 cells that mapview doesn't like to display

  afripop_agg20 <- raster::aggregate(afripop, fun=mean, fact=20)
  #afripop_agg50 <- raster::aggregate(afripop, fun=mean, fact=50)
  #afripop_agg100 <- raster::aggregate(afripop, fun=mean, fact=100)

  dim(afripop_agg20) #434 413   1
  #dim(afripop_agg50) #174 166   1

  #mapview(afripop_agg20) #BEST? > mapview happy
  #mapview(afripop_agg50) #highest density cell in lagos in sea

  #why does 20km version cut off parts of W of continent ?
  #it doesn't when displayed in tmap

  #sometimes needed to make sure data are associated with object (rather than being in file)
  afripop_agg20 <- readAll(afripop_agg20)

  if (year==2020)
      afripop2020 <- afripop_agg20
  else
      afripop2000 <- afripop_agg20
}

usethis::use_data(afripop2000, overwrite = TRUE)
usethis::use_data(afripop2020, overwrite = TRUE)

#save raster as a tif file so reading in can be demonstrated
# write to a new geotiff file (depends on rgdal)
if (require(rgdal)) {
        filename <- r"(inst/extdata/afripop2020.tif)" #windows safe paths
        writeRaster(afripop2020, filename=filename, format="GTiff", overwrite=TRUE)
        filename <- r"(inst/extdata/afripop2000.tif)" #windows safe paths
        writeRaster(afripop2000, filename=filename, format="GTiff", overwrite=TRUE)
}

#######################################################################
# csv of francophone country populations by name

# that can be used to demo joining
# to plot a map of Francophone countries to promote useR2021 tutorial

library(readr)
library(dplyr)

francophone_africa <- read_csv("inst/extdata/francophone-africa.csv",
                               locale = locale(encoding = "ISO-8859-1"))

#join
sf_franc <- dplyr::left_join(africountries, francophone_africa, "name_long" )

library(ggplot2)
library(ggrepel)

ggplot(sf_franc) +
  geom_sf(aes(fill = popn)) +
  scale_fill_viridis_c() +
  theme_void() +
  geom_text_repel(aes(label=name_fr, geometry=geometry),
                  stat="sf_coordinates",
                  point.padding = NA, #allows points to overlap centroid
                  colour='darkgrey', size=3
  ) +
  labs(title = "", fill = "Population")


#######################################################################
#landcover raster submitted by Chris Littleboy
#https://github.com/chrislittleboy/publicdata/blob/main/afrimapr%20modis.R
# > dim(africalowres)
# [1] 2106 2373    1
# > africalowres_agg4 <- raster::aggregate(africalowres, fun=modal, fact=4)
# > dim(africalowres_agg4)
# [1] 527 594   1 1
# > africalowres_agg3 <- raster::aggregate(africalowres, fun=modal, fact=3)
# > dim(africalowres_agg3)
# [1] 702 791   1

library(MODIS)
library(raster)

##### Download data #####

# EarthdataLogin(usr = "usernamehere", pwd = "passwordhere")

# you need to create an account with EarthData to access products and use the above to set up a hidden file with the details

template_raster <- raster(choose.files())
# selects a template raster for the download
# mine uses afripop data from here (https://www.worldpop.org/doi/10.5258/SOTON/WP00004), but this could be anything
# The data downloaded will have the same resolution and extent as the template

#### WARNING, this takes a lot of time and a good internet connection...
# runGdal(product = "MCD12C1", # gets MODIS land cover data https://lpdaac.usgs.gov/products/mcd12c1v006/
#         begin = "2019-01-01", # gets latest map from date range (it is a time series)
#         extent = template_raster) # sets the extent, resolution and projection of template raster)

runGdal(product = "MCD12C1", # gets MODIS land cover data https://lpdaac.usgs.gov/products/mcd12c1v006/
        begin = "2019-01-01", # gets latest map from date range (it is a time series)
        extent = afripop2020) # sets the extent, resolution and projection of template raster)

# TODO : maybe I don't want to download at the low res, i.e. based on

# outProj          =  +proj=longlat +datum=WGS84 +no_defs  (if applicable, derived from Raster*/Spatial*/sf* object)
# pixelSize        =  0.1666667 0.1666667  (if applicable, derived from Raster* object)
# resamplingType   =  near
# Output directory =  C:/Users/andy.south/AppData/Local/Temp/RtmpwLMEUp/MODIS_ARC/PROCESSED/MCD12C1.006_20210525103645  (no 'job' name specified, generated (date/time based))

# it did take > 1 hour probably < 3
# [1] "C:/Users/ANDY~1.SOU/AppData/Local/Temp/RtmpwLMEUp/MODIS_ARC/PROCESSED/MCD12C1.006_20210525103645/MCD12C1.A2019001.Majority_Land_Cover_Type_1.tif"
# [2] "C:/Users/ANDY~1.SOU/AppData/Local/Temp/RtmpwLMEUp/MODIS_ARC/PROCESSED/MCD12C1.006_20210525103645/MCD12C1.A2019001.Majority_Land_Cover_Type_1_Assessment.tif"
# [3] "C:/Users/ANDY~1.SOU/AppData/Local/Temp/RtmpwLMEUp/MODIS_ARC/PROCESSED/MCD12C1.006_20210525103645/MCD12C1.A2019001.Land_Cover_Type_1_Percent.tif"
# [4] "C:/Users/ANDY~1.SOU/AppData/Local/Temp/RtmpwLMEUp/MODIS_ARC/PROCESSED/MCD12C1.006_20210525103645/MCD12C1.A2019001.Majority_Land_Cover_Type_2.tif"
# [5] "C:/Users/ANDY~1.SOU/AppData/Local/Temp/RtmpwLMEUp/MODIS_ARC/PROCESSED/MCD12C1.006_20210525103645/MCD12C1.A2019001.Majority_Land_Cover_Type_2_Assessment.tif"
# [6] "C:/Users/ANDY~1.SOU/AppData/Local/Temp/RtmpwLMEUp/MODIS_ARC/PROCESSED/MCD12C1.006_20210525103645/MCD12C1.A2019001.Land_Cover_Type_2_Percent.tif"
# [7] "C:/Users/ANDY~1.SOU/AppData/Local/Temp/RtmpwLMEUp/MODIS_ARC/PROCESSED/MCD12C1.006_20210525103645/MCD12C1.A2019001.Majority_Land_Cover_Type_3.tif"
# [8] "C:/Users/ANDY~1.SOU/AppData/Local/Temp/RtmpwLMEUp/MODIS_ARC/PROCESSED/MCD12C1.006_20210525103645/MCD12C1.A2019001.Majority_Land_Cover_Type_3_Assessment.tif"
# [9] "C:/Users/ANDY~1.SOU/AppData/Local/Temp/RtmpwLMEUp/MODIS_ARC/PROCESSED/MCD12C1.006_20210525103645/MCD12C1.A2019001.Land_Cover_Type_3_Percent.tif"


##### Load and process the data #####

#filename <- "C:/Users/ANDY~1.SOU/AppData/Local/Temp/RtmpwLMEUp/MODIS_ARC/PROCESSED/MCD12C1.006_20210525103645/MCD12C1.A2019001.Majority_Land_Cover_Type_1.tif"

filename <- "C:\\Dropbox\\_afrimapr\\data\\landcover-modis\\MCD12C1.A2019001.Majority_Land_Cover_Type_1.tif"

# values=TRUE needed to make sure values are stored in the object
afrilandcover <- raster(filename, values=TRUE)


dim(afrilandcover)
# [1] 434 413   1 Cool this is the same as afripop2020

# rename the name for the layer stored in the object
names(afrilandcover) <- "landcover"


library(plotKML)
data(worldgrids_pal) # loads package with the colour palette for IGBP classification system
afrilandcover <- ratify(afrilandcover)
rat <- levels(afrilandcover)[[1]] # creates a raster attribute table using the classification system
igbp <- as.data.frame(as.list(worldgrids_pal)[7]) # extracts igbp classification info

rat$landcover <- rownames(igbp)[rat$ID+1]
rat$colour <- igbp$IGBP[rat$ID+1]

levels(afrilandcover) <- rat

#TODO crop to the continent boundary to remove seacells




#TODO is there a better way to get mapview to recognise the colours ?
mapview(afrilandcover, att="landcover", col.regions=levels(afrilandcover)[[1]]$colour)


# this is how rasterVis plots using the rat
# BUT this uses rat in separate file, also seems not to be able to use
# one stored in the raster object
library(rasterVis)
levelplot(afrilandcover,
          col.regions = rat$colour,
          main = "Land Cover in Africa (Source: MODIS MCD12C1)")

# using tmap
tm_shape(afrilandcover) + tm_raster("landcover")
#fails w or w/out quotes
#tm_shape(afrilandcover) + tm_raster("landcover", palette="colour")
tm_shape(afrilandcover) + tm_raster("landcover", palette=levels(afrilandcover)[[1]]$colour)
#can't quite get it to display both the colours & the labels
tm_shape(afrilandcover) + tm_raster("landcover", style="cat",palette=levels(afrilandcover)[[1]]$colour, labels=levels(afrilandcover)[[1]]$landcover)

# maybe I should try stars for afrilandcover instead ?
# can I get a stars object to save the rastr attribute table with th colours ?
# or terra ?
# terra can save raster attribute tables incl. colour palette as indicated here :
# https://geocompr.robinlovelace.net/attr.html

library(terra)
afrilandcoverterra <- terra::rast(filename)


# write file to package, as grd file to preserve raster attribute table
filename <- r"(inst/extdata/afrilandcover.grd)" #windows safe paths
writeRaster(afrilandcover, filename, overwrite=TRUE) # writes as grd to preserve rat

# save data object in package
# IMPORTANT this seems to have to go after writeRaster()
# otherwise raster::plot(afrilandcover) gives: Error in .local(.Object, ...)
usethis::use_data(afrilandcover, overwrite = TRUE)

# test reading in again
filename <- system.file("extdata","afrilandcover.grd", package="afrilearndata", mustWork=TRUE)
testlc <- raster::raster(filename)
mapview(testlc, att="landcover", col.regions=levels(testlc)[[1]]$colour)


#now I see that tmap has a global landcover as a stars object
#but doesn't have the colour palette saved in the object
data(land)
pal8 <- c("#33A02C", "#B2DF8A", "#FDBF6F", "#1F78B4", "#999999", "#E31A1C", "#E6E6E6", "#A6CEE3")
tm_shape(land, ylim = c(-88,88)) +
  tm_raster("cover_cls", palette = pal8, title = "Global Land Cover")

# test reading in as a stars object

#proxy=FALSE ensures data are loaded but probably not necessary for this small grid
afrilandstars <- stars::read_stars(filename, proxy=FALSE)

# it gives Warning message: ignoring unrecognized unit: class number
# which is from here in stars :
# https://github.com/r-spatial/stars/blob/ed1e36ff9ea317fd9d9c2fc9d360c06cb7258555/R/dimensions.R

#using RAT should get it to create a categorical stars object but not working ??
afrilandstars <- stars::read_stars(filename, proxy=FALSE, RAT=rownames(igbp)[rat$ID+1])

#TODO can I get stars to store & plot the colours ?
# nearly working but not quite ...

#seems from here that a colour attribute can be set
#https://github.com/r-spatial/stars/issues/392#issuecomment-788812130
#attr(r$f, "colors") = c("#b41614", "#3cfa96")
afrilandstars$landcover <- rownames(igbp)[rat$ID+1]
attr(afrilandstars$landcover, "colors") = igbp$IGBP[rat$ID+1]

#stars plots the categories well, but does not seem to retain the colours ?
#and the labels get truncated
plot(afrilandstars)
#mapview likewise
mapview(afrilandstars)

#or just try converting the raster object
afrilandstars2 <- st_as_stars(afrilandcover)

tm_shape(afrilandstars2) + tm_raster("landcover")

tm_shape(afrilandstars2) + tm_raster("landcover", style="cat",palette=levels(afrilandcover)[[1]]$colour, labels=levels(afrilandcover)[[1]]$landcover)


#but how can it be read from the grd file ?
#or maybe I should save as a tiff like above too ?


# TODO I think stars is way to go - like in tmap
# but just need to work out how to get it to create the categorical raster
# how does tmap create land ?
# https://github.com/r-tmap/tmap/blob/bab938b2bffb040638b635ffd99e7bce8143e7f3/build/create_land.R



# potential different approach to get the same data
# https://rspatialdata.github.io/land_cover.html
# library(MODIStsp)
# MODIStsp(gui             = FALSE,
#          out_folder      = "LandCoverData",
#          out_folder_mod  = "LandCoverData",
#          selprod         = "LandCover_Type_Yearly_500m (MCD12Q1)",
#          bandsel         = "LC1",
#          user            = "mstp_test" ,
#          password        = "MSTP_test_01",
#          start_date      = "2019.01.01",
#          end_date        = "2019.12.31",
#          verbose         = FALSE,
#          spatmeth        = "file",
#          spafile         = spatial_filepath,
#          out_format      = "GTiff")

