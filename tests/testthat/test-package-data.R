#TODO add more tests for each datset

test_that("afriairports valid", {
  expect_false("FALSE" %in% (sf::st_is_valid(afriairports)))
})

test_that("africapitals valid", {
  expect_false("FALSE" %in% (sf::st_is_valid(africapitals)))
})

test_that("africontinent valid", {
  expect_false("FALSE" %in% (sf::st_is_valid(africontinent)))
})

test_that("africountries valid", {
  expect_false("FALSE" %in% (sf::st_is_valid(africountries)))
})

test_that("afrihighway valid", {
  expect_false("FALSE" %in% (sf::st_is_valid(afrihighway)))
})

test_that("afripop valid", {
  expect_true(raster::hasValues(afripop2000))
  expect_true(raster::hasValues(afripop2020))
})

test_that("afrilandcover valid", {
  expect_true(raster::hasValues(afrilandcover))
})


