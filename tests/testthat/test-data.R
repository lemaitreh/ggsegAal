
## Number of non-contextual subcortical regions.
##
## The 2D subcortical atlases contain an additional
## contextual region labelled "Cortex", which must not be
## included in the anatomical region count.

count_subcortical <- function(atlas) {

  sum(
    !grepl(
      "^Cortex$",
      atlas$core$label,
      ignore.case = TRUE
    )
  )
}


test_that("all nine AAL atlas components are available", {

  atlases <- list(
    aal1_cortical(),
    aal1_subcortical(),
    aal1_cerebellum(),

    aal2_cortical(),
    aal2_subcortical(),
    aal2_cerebellum(),

    aal3_cortical(),
    aal3_subcortical(),
    aal3_cerebellum()
  )

  expect_length(atlases, 9)

  for (x in atlases) {

    expect_true(is.list(x))

    expect_true(
      all(
        c(
          "atlas",
          "type",
          "palette",
          "core",
          "data"
        ) %in% names(x)
      )
    )

    expect_gt(
      nrow(x$core),
      0
    )
  }
})


test_that("AAL1 contains 116 regions", {

  expect_equal(
    nrow(aal1_cortical()$core),
    82
  )

  expect_equal(
    count_subcortical(aal1_subcortical()),
    8
  )

  expect_equal(
    nrow(aal1_cerebellum()$core),
    26
  )

  expect_equal(
    nrow(aal1_cortical()$core) +
      count_subcortical(aal1_subcortical()) +
      nrow(aal1_cerebellum()$core),
    116
  )
})


test_that("AAL2 contains 120 regions", {

  expect_equal(
    nrow(aal2_cortical()$core),
    86
  )

  expect_equal(
    count_subcortical(aal2_subcortical()),
    8
  )

  expect_equal(
    nrow(aal2_cerebellum()$core),
    26
  )

  expect_equal(
    nrow(aal2_cortical()$core) +
      count_subcortical(aal2_subcortical()) +
      nrow(aal2_cerebellum()$core),
    120
  )
})


test_that("AAL3 contains 166 regions", {

  expect_equal(
    nrow(aal3_cortical()$core),
    90
  )

  expect_equal(
    count_subcortical(aal3_subcortical()),
    50
  )

  expect_equal(
    nrow(aal3_cerebellum()$core),
    26
  )

  expect_equal(
    nrow(aal3_cortical()$core) +
      count_subcortical(aal3_subcortical()) +
      nrow(aal3_cerebellum()$core),
    166
  )
})


test_that("historical accessors remain available", {
  expect_identical(aal(), aal1_cortical())
  expect_identical(aal2(), aal2_cortical())
})

