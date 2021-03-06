context("sim method")

data("simplePdmp")
obj <- simplePdmp

test_that("the results of 2 simulations with the same seed are equal", {

  out1 <- sim(obj, outSlot = FALSE, seed = 5)
  out2 <- sim(obj, outSlot = FALSE, seed = 5)
  expect_identical(out1, out2)
})

test_that("the results of 2 simulations with different seeds are different", {

  out1 <- sim(obj, outSlot = FALSE, seed = 5)
  out2 <- sim(obj, outSlot = FALSE, seed = 3)
  expect_false(identical(out1, out2))
})

test_that("parameter outSlot behaves correctly", {

  obj <- sim(obj)
  expect_s4_class(obj, "pdmpModel")
  expect_false(is.null(out(obj)))

  out <- sim(obj, outSlot = FALSE)
  expect_s3_class(out, "deSolve")
})

test_that("slot 'main' has no impact on the simulation", {

  out1 <- sim(obj, outSlot = FALSE, seed = 1)
  obj@main <- function(time, init, parms) list(c(0, 0))
  out2 <- sim(obj, outSlot = FALSE, seed = 1)
  expect_identical(out1, out2)
})

test_that("slot 'equations' has no impact on the simulation", {

  out1 <- sim(obj, outSlot = FALSE, seed = 1)
  obj@equations <- list(function(time, init) time*init[1])
  out2 <- sim(obj, outSlot = FALSE, seed = 1)
  expect_identical(out1, out2)
})

test_that("slot 'observer' has no impact on the simulation", {

  out1 <- sim(obj, outSlot = FALSE, seed = 1)
  obj@observer <- function(state){
    print(state)
    return(-state)
  }
  out2 <- sim(obj, outSlot = FALSE, seed = 1)
  expect_identical(out1, out2)
})

test_that("if initialize = TRUE, slot 'initfunc' is called before sim", {

  model1 <- sim(obj, seed = 1)
  obj@initfunc <- function(obj){
    init(obj) <- c("f" = runif(1, max = 20), "d" = 1)
    invisible(obj)
  }
  model2 <- sim(obj, seed = 1, initialize = TRUE)
  model3 <- sim(obj, seed = 1, initialize = FALSE)

  expect_false(identical(out(model1), out(model2)))
  expect_false(identical(init(model1), init(model2)))
  expect_identical(out(model1), out(model3))
})

test_that("outrate = TRUE only affects column 'pdmpsim:negcumrate'", {
  out1 <- sim(obj, seed = 1, outrate = TRUE, outSlot = FALSE)
  out1 <- out1[, -which(colnames(out1) =="pdmpsim:negcumrate")]
  
  out2 <- sim(obj, seed = 1, outrate = FALSE, outSlot = FALSE)
  class(out2) <- "matrix"
  
  expect_identical(out1, out2)
})