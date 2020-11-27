
<!-- README.md is generated from README.Rmd. Please edit that file -->

<!-- used devtools::build_readme() to update the md -->

# afrilearndata

<!-- badges: start -->

<!-- badges: end -->

afrilearndata provides small African datasets to help with learning and
teaching of spatial techniques and mapping.

## Installation

Install the development version of afrilearndata with:

``` r

    # install.packages("remotes") # if not already installed
    
    remotes::install_github("afrimapr/afrilearndata")
    
    library(afrilearndata)
```

## Outline

The package contains the following objects

1.  `africountries` polygons, country boundaries
2.  `africontinent` polygons, continent outline including madagascar
3.  `afrihighway` lines, trans african highway network
4.  `africapitals` points, capital cities
5.  `afripop2020` raster grid, population density 2020 from
    [WorldPop](https://www.worldpop.org/) aggregated to 20km squares
6.  `afripop2000` raster grid, population density 2000 from
    [WorldPop](https://www.worldpop.org/) aggregated to 20km squares

Lazy loading means that the objects should be accessible once
`library(afrilearndata)` is used.

If they are not recognised you can use e.g. `data(africountries)` to
make sure the objects are loaded.

Firstly, here are all the data shown together. The `tmap` code to create
this plot is shown later in the readme.

<img src="man/figures/README-tmap-all-the-data-1.png" width="100%" />

Now looking at the data layers individually plotted with packages `sf`
or `raster`

``` r

library(afrilearndata)
library(sf)

# polygons
plot(sf::st_geometry(africountries))
```

<img src="man/figures/README-countries-1.png" width="100%" />

``` r

# lines
plot(sf::st_geometry(afrihighway))
```

<img src="man/figures/README-highway-1.png" width="100%" />

``` r

# points
plot(sf::st_geometry(africapitals))
```

<img src="man/figures/README-capitals-1.png" width="100%" />

Population density data are from WorldPop clipped to Africa and
aggregated to 20km resolution to make them more manageable.
[WorldPop](https://www.worldpop.org/) datasets are licensed under
[Creative Commons Attribution 4.0
International](https://creativecommons.org/licenses/by/4.0/).

``` r

# raster grid
# install.packages("raster") # if not already installed
library(raster)
plot(afripop2020)
```

<img src="man/figures/README-population-grid-1.png" width="100%" />

The `africountries` data has country names in French, Portuguese,
Swahili, Afrikaans and English, that can be used to label maps as
follows.

``` r

library(afrilearndata)

# install.packages("tmap") # if not already installed
library(tmap)

tm_shape(africountries) +
     tm_borders("grey", lwd = .5) +
     tm_text("name_fr", auto.placement=FALSE, remove.overlap=FALSE, just='centre', col='red4', size=0.7 )
```

<img src="man/figures/README-french-country-names-1.png" width="100%" />

Interactive maps can be created using the `mapview` package.

``` r

# install.packages("mapview") # if not already installed

library(mapview)
mapview::mapview(africountries, zcol="name")  
  
```

Here is a repeat of the map shown at the start of the readme, together
with the code used to create it.

``` r

library(afrilearndata)

# install.packages("tmap") # if not already installed
library(tmap)

# tmap_mode("view") to set to tmap interactive viewing mode

tm_shape(afripop2020) +
    tm_raster(palette = rev(viridisLite::magma(5)), breaks=c(0,2,20,200,2000,25000)) +
tm_shape(africountries) +
    tm_borders("white", lwd = .5) +
tm_shape(afrihighway) +
    tm_lines(col = "black") + 
tm_shape(africapitals) +
    tm_symbols(col = "blue", alpha=0.4, scale = .6 )+
tm_legend(show = FALSE)
```

<img src="man/figures/README-tmap-code-1.png" width="100%" />
