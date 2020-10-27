
# afrilearndata

<!-- badges: start -->
<!-- badges: end -->

afrilearndata provides small African datasets to help with learning and teaching of spatial techniques and mapping.

## Installation

Install the development version of afrilearndata with:

``` r

    # install.packages("remotes") # if not already installed
    
    remotes::install_github("afrimapr/afrilearndata")
    
```

## First use

The package contains the sf objects `sfafricountries`, `sfafrihway` and `sfafricapitals`.

Lazy loading means that the objects should be accessible once `library(afrilearndata)` is used.

If they are not recognised you can use e.g. `data(sfafricountries)` to make sure the objects are loaded.

``` r
library(afrilearndata)
library(sf)

# polygons
plot(sf::st_geometry(sfafricountries))

# lines
plot(sf::st_geometry(sfafrihway))

# points
plot(sf::st_geometry(sfafricapitals))

library(mapview)
mapview::mapview(sfafricapitals, zcol="name")

```

