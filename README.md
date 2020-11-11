
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
    
```

## First use

The package contains the following objects

1.  `sfafricountries` polygons, country boundaries
2.  `sfafricontinent` polygons, continent outline including madagascar
3.  `sfafrihway` lines, trans african highway network
4.  `sfafricapitals` points, capital cities
5.  `rastafriwpop` raster grid, modelled population density per square
    km aggregated to 20km squares

Lazy loading means that the objects should be accessible once
`library(afrilearndata)` is used.

If they are not recognised you can use e.g. `data(sfafricountries)` to
make sure the objects are loaded.

``` r

library(afrilearndata)
library(sf)
#> Warning: package 'sf' was built under R version 4.0.3
#> Linking to GEOS 3.8.0, GDAL 3.0.4, PROJ 6.3.1

# polygons
plot(sf::st_geometry(sfafricountries))
```

<img src="man/figures/README-countries-1.png" width="100%" />

``` r

# lines
plot(sf::st_geometry(sfafrihway))
```

<img src="man/figures/README-highway-1.png" width="100%" />

``` r

# points
plot(sf::st_geometry(sfafricapitals))
```

<img src="man/figures/README-capitals-1.png" width="100%" />

``` r

# raster grid
# install.packages("raster") # if not already installed
library(raster)
#> Loading required package: sp
plot(rastafriwpop)
```

<img src="man/figures/README-population grid-1.png" width="100%" />

Interactive maps can be created using the `mapview` package.

``` r

# install.packages("mapview") # if not already installed
if (FALSE) {
  
  library(mapview)
  mapview::mapview(sfafricountries, zcol="name")  
  
}
```
