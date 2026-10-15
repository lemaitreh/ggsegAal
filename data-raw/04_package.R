## =========================================================
## 04_package.R
## Build ggsegAAL package
## =========================================================

source("/data/extra/hlemaitre/aal/scripts/00_config.R")

## =========================================================
## Configuration
## =========================================================

pkg <- file.path(root, "ggsegAal")

## Change before publication
author_email <- "herve.lemaitre@u-bordeaux.fr"


## =========================================================
## 1. Remove previous package
## =========================================================

# Safeguard: rebuilding destroys the existing package directory.
# Explicitly enable replacement in the shell:
# Sys.setenv(GGSEG_AAL_REBUILD = "yes")
if (dir.exists(pkg)) {
  if (Sys.getenv("GGSEG_AAL_REBUILD") != "yes") {
    stop("Existing package at ", pkg,
         ". To rebuild it, run Sys.setenv(GGSEG_AAL_REBUILD = 'yes') ",
         "after backing up the folder.")
  }
  message("Removing previous package: ", pkg)
  unlink(pkg, recursive = TRUE)
}

stopifnot(!dir.exists(pkg))


## =========================================================
## 2. Create package using ggsegverse scaffold
## =========================================================

ggseg.extra::setup_atlas_repo(
  path = pkg,
  open = FALSE,
  rstudio = TRUE,
  github_actions = TRUE
)

usethis::proj_set(pkg)


## =========================================================
## 3. Check package name
## =========================================================

description_file <- file.path(pkg, "DESCRIPTION")

package_name <- read.dcf(
  description_file,
  fields = "Package"
)[1, "Package"]

if (!package_name %in% c("ggsegAal", "ggsegAAL")) {
  stop(
    "Unexpected package name: ",
    package_name,
    ". Expected ggsegAal or ggsegAAL."
  )
}


## =========================================================
## 4. Package metadata
## =========================================================

d <- desc::description$new(description_file)

d$set(
  
  Package = "ggsegAAL",
  
  Title =
    "Automated Anatomical Labeling Atlases for the ggseg Ecosystem",
  
  Version =
    "3.0.0",
  
  URL =
    "https://github.com/lemaitreh/ggsegAal",
  
  BugReports =
    "https://github.com/lemaitreh/ggsegAal/issues",
  
  `Authors@R` = sprintf(
    paste0(
      'person("Hervé", "Lemaître", ',
      'email = "%s", ',
      'role = c("aut", "cre"))'
    ),
    author_email
  ),
  
  Description = paste(
    "Provides cortical, subcortical and cerebellar",
    "representations of the AAL1, AAL2 and AAL3",
    "Automated Anatomical Labeling atlases for the ggseg",
    "ecosystem. AAL1 contains 116 regions, AAL2 contains",
    "120 regions, and the AAL3 representation contains",
    "166 regions. Cortical atlases use the Colin27 surface,",
    "subcortical atlases include cortical anatomical context,",
    "and cerebellar atlases use the SUIT surface and flatmap."
  )
)

d$write()

## =========================================================
## 5. Dependencies
## =========================================================

d <- desc::description$new(description_file)

## Remove unused dependencies added by
## ggseg.extra::setup_atlas_repo()
##
## ggseg.formats is used during atlas construction
## but is not directly called by the package accessors.

for (p in c("ggseg.formats", "vdiffr")) {
  try(
    d$del_dep(p),
    silent = TRUE
  )
}

d$write()


## ---------------------------------------------------------
## Runtime dependencies
## ---------------------------------------------------------

## Used by ggseg3d_aal()
usethis::use_package(
  "ggseg3d",
  type = "Imports"
)


## ---------------------------------------------------------
## Suggested packages
## ---------------------------------------------------------

## Used for 2D visualization
usethis::use_package(
  "ggseg",
  type = "Suggests"
)

usethis::use_package(
  "ggplot2",
  type = "Suggests"
)


## =========================================================
## 6. Copy construction scripts and documentation
## =========================================================

data_raw <- file.path(pkg, "data-raw")

dir.create(
  data_raw,
  recursive = TRUE,
  showWarnings = FALSE
)


## ---------------------------------------------------------
## 6.1. Copy construction scripts to data-raw
## ---------------------------------------------------------

scripts <- c(
  "00_config.R",
  "01_cortical.R",
  "02_basal_ganglia.R",
  "03_cerebellum.R",
  "04_package.R",
  "ggseg_aal_2026.Rmd"
)

ok <- file.copy(
  from = file.path(root, "scripts", scripts),
  to = file.path(data_raw, scripts),
  overwrite = TRUE
)

if (!all(ok)) {
  stop(
    "Some construction scripts could not be copied: ",
    paste(scripts[!ok], collapse = ", ")
  )
}


## ---------------------------------------------------------
## 6.2. Copy README.qmd to package root
## ---------------------------------------------------------

readme_source <- file.path(
  root,
  "scripts",
  "README.qmd"
)

if (!file.exists(readme_source)) {
  stop("README.qmd not found: ", readme_source)
}

ok <- file.copy(
  from = readme_source,
  to = file.path(pkg, "README.qmd"),
  overwrite = TRUE
)

if (!ok) {
  stop("Could not copy README.qmd")
}


## ---------------------------------------------------------
## 6.3. Copy _pkgdown.yml to package root
## ---------------------------------------------------------

pkgdown_source <- file.path(
  root,
  "scripts",
  "_pkgdown.yml"
)

if (!file.exists(pkgdown_source)) {
  stop("_pkgdown.yml not found: ", pkgdown_source)
}

ok <- file.copy(
  from = pkgdown_source,
  to = file.path(pkg, "_pkgdown.yml"),
  overwrite = TRUE
)

if (!ok) {
  stop("Could not copy _pkgdown.yml")
}


## ---------------------------------------------------------
## 6.4. Build exclusions
## ---------------------------------------------------------

## Keep data-raw in GitHub but exclude from R package build
usethis::use_build_ignore(
  "data-raw",
  escape = TRUE
)

## README.qmd is used to generate README.md
usethis::use_build_ignore(
  "README.qmd",
  escape = TRUE
)

## pkgdown configuration is for website generation
usethis::use_build_ignore(
  "_pkgdown.yml",
  escape = TRUE
)


## =========================================================
## 7. Read validated atlas objects
## =========================================================

read_atlas <- function(version, type) {
  
  folder <- switch(
    type,
    cor = cor_out,
    bg  = bg_out,
    cer = cer_out,
    stop("Unknown atlas type: ", type)
  )
  
  file <- file.path(
    folder,
    version,
    paste0(version, "_", type, ".rds")
  )
  
  if (!file.exists(file))
    stop("Atlas not found: ", file)
  
  message("Reading: ", file)
  
  readRDS(file)
}


## ---------------------------------------------------------
## AAL1
## 82 cortical + 8 subcortical + 26 cerebellar = 116
## ---------------------------------------------------------

.aal1_cor <- read_atlas("aal1", "cor")
.aal1_bg  <- read_atlas("aal1", "bg")
.aal1_cer <- read_atlas("aal1", "cer")


## ---------------------------------------------------------
## AAL2
## 86 cortical + 8 subcortical + 26 cerebellar = 120
## Additional orbitofrontal parcellation relative to AAL1
## ---------------------------------------------------------

.aal2_cor <- read_atlas("aal2", "cor")
.aal2_bg  <- read_atlas("aal2", "bg")
.aal2_cer <- read_atlas("aal2", "cer")


## ---------------------------------------------------------
## AAL3
## 90 cortical + 50 subcortical + 26 cerebellar = 166
## Anterior cingulate and thalamic subdivisions
## ---------------------------------------------------------

.aal3_cor <- read_atlas("aal3", "cor")
.aal3_bg  <- read_atlas("aal3", "bg")
.aal3_cer <- read_atlas("aal3", "cer")


## =========================================================
## 8. Colin27 meshes
## =========================================================

.colin_inflated_meshes <- colin_inflated_meshes
.colin_pial_meshes     <- colin_pial_meshes


## =========================================================
## 9. Save internal package data
## =========================================================

usethis::use_data(
  
  .aal1_cor,
  .aal1_bg,
  .aal1_cer,
  
  .aal2_cor,
  .aal2_bg,
  .aal2_cer,
  
  .aal3_cor,
  .aal3_bg,
  .aal3_cer,
  
  .colin_inflated_meshes,
  .colin_pial_meshes,
  
  internal = TRUE,
  overwrite = TRUE,
  compress = "xz"
)


## =========================================================
## 10. Package-level documentation
## =========================================================

package_doc <- '
#\' ggsegAAL: Automated Anatomical Labeling atlases
#\'
#\' The ggsegAAL package provides AAL1, AAL2 and AAL3
#\' representations for the ggseg ecosystem.
#\'
#\' The atlas family is divided into cortical, subcortical
#\' and cerebellar components.
#\'
#\' @section Atlas composition:
#\'
#\' * **AAL1:** 82 cortical + 8 subcortical +
#\'   26 cerebellar = **116 regions**.
#\'
#\' * **AAL2:** 86 cortical, including the AAL2
#\'   orbitofrontal parcellation, + 8 subcortical +
#\'   26 cerebellar = **120 regions**.
#\'
#\' * **AAL3:** 90 cortical, including anterior cingulate
#\'   subdivisions, + 50 subcortical, including thalamic
#\'   subdivisions, + 26 cerebellar = **166 regions**.
#\'
#\' @section Representations:
#\'
#\' Cortical atlases are represented on the Colin27
#\' cortical surface.
#\'
#\' Subcortical atlases include a contextual cortical
#\' representation for 2D plotting.
#\'
#\' Cerebellar atlases are transformed to SUIT space and
#\' provide flatmap and 3D representations.
#\'
#\' @references
#\' Rolls, E. T., Huang, C. C., Lin, C. P., Feng, J.,
#\' & Joliot, M. (2020).
#\' Automated anatomical labelling atlas 3.
#\' \\emph{NeuroImage}, 206.
#\' \\href{https://pubmed.ncbi.nlm.nih.gov/31521825/}{PubMed}
#\'
#\' Rolls, E. T., Joliot, M., & Tzourio-Mazoyer, N. (2015).
#\' Implementation of a new parcellation of the orbitofrontal
#\' cortex in the automated anatomical labeling atlas.
#\' \\emph{NeuroImage}, 122, 1-5.
#\' \\href{https://pubmed.ncbi.nlm.nih.gov/26241684/}{PubMed}
#\'
#\' Tzourio-Mazoyer, N., Landeau, B., Papathanassiou, D.,
#\' Crivello, F., Étard, O., Delcroix, N., Mazoyer, B.,
#\' & Joliot, M. (2002).
#\' Automated Anatomical Labeling of Activations in SPM
#\' Using a Macroscopic Anatomical Parcellation of the
#\' MNI MRI Single-Subject Brain.
#\' \\emph{NeuroImage}, 15, 273-289.
#\' \\href{https://pubmed.ncbi.nlm.nih.gov/11771995/}{PubMed}
#\'
#\' @docType package
#\' @name ggsegAAL-package
#\' @keywords internal
"_PACKAGE"
'


writeLines(
  package_doc,
  file.path(
    pkg,
    "R",
    "ggsegAAL-package.R"
  )
)

## Remove duplicate package documentation from scaffold
old_doc <- file.path(pkg, "R", "ggsegAal-package.R")

if (file.exists(old_doc)) {
  unlink(old_doc)
}

## =========================================================
## 11. Public atlas accessors
## =========================================================

data_code <- '
#\' Automated Anatomical Labeling atlases
#\'
#\' Accessors for the AAL1, AAL2 and AAL3 atlas families.
#\'
#\' Each atlas is provided as three anatomical components:
#\'
#\' * `cortical`: cortical atlas
#\' * `subcortical`: subcortical atlas
#\' * `cerebellum`: cerebellar atlas
#\'
#\' @section Atlas composition:
#\'
#\' * AAL1: 82 cortical + 8 subcortical +
#\'   26 cerebellar = 116 regions.
#\'
#\' * AAL2: 86 cortical + 8 subcortical +
#\'   26 cerebellar = 120 regions.
#\'
#\' * AAL3: 90 cortical + 50 subcortical +
#\'   26 cerebellar = 166 regions.
#\'
#\' @references
#\' Rolls, E. T., Huang, C. C., Lin, C. P., Feng, J.,
#\' & Joliot, M. (2020).
#\' Automated anatomical labelling atlas 3.
#\' \\emph{NeuroImage}, 206.
#\' \\href{https://pubmed.ncbi.nlm.nih.gov/31521825/}{PubMed}
#\'
#\' Rolls, E. T., Joliot, M., & Tzourio-Mazoyer, N. (2015).
#\' Implementation of a new parcellation of the orbitofrontal
#\' cortex in the automated anatomical labeling atlas.
#\' \\emph{NeuroImage}, 122, 1-5.
#\' \\href{https://pubmed.ncbi.nlm.nih.gov/26241684/}{PubMed}
#\'
#\' Tzourio-Mazoyer, N., Landeau, B., Papathanassiou, D.,
#\' Crivello, F., Étard, O., Delcroix, N., Mazoyer, B.,
#\' & Joliot, M. (2002).
#\' Automated Anatomical Labeling of Activations in SPM
#\' Using a Macroscopic Anatomical Parcellation of the
#\' MNI MRI Single-Subject Brain.
#\' \\emph{NeuroImage}, 15, 273-289.
#\' \\href{https://pubmed.ncbi.nlm.nih.gov/11771995/}{PubMed}
#\'
#\' @family ggseg_atlases
#\' @name aal_atlases
NULL


#\' @describeIn aal_atlases
#\' AAL1 cortical atlas containing 82 cortical regions.
#\' @export
aal1_cortical <- function() .aal1_cor


#\' @describeIn aal_atlases
#\' AAL1 subcortical atlas containing 8 regions.
#\' @export
aal1_subcortical <- function() .aal1_bg


#\' @describeIn aal_atlases
#\' AAL1 cerebellar atlas containing 26 regions.
#\' @export
aal1_cerebellum <- function() .aal1_cer


#\' @describeIn aal_atlases
#\' AAL2 cortical atlas containing 86 cortical regions,
#\' including the AAL2 orbitofrontal parcellation.
#\' @export
aal2_cortical <- function() .aal2_cor


#\' @describeIn aal_atlases
#\' AAL2 subcortical atlas containing 8 regions.
#\' @export
aal2_subcortical <- function() .aal2_bg


#\' @describeIn aal_atlases
#\' AAL2 cerebellar atlas containing 26 regions.
#\' @export
aal2_cerebellum <- function() .aal2_cer


#\' @describeIn aal_atlases
#\' AAL3 cortical atlas containing 90 cortical regions,
#\' including anterior cingulate subdivisions.
#\' @export
aal3_cortical <- function() .aal3_cor


#\' @describeIn aal_atlases
#\' AAL3 subcortical atlas containing 50 regions,
#\' including thalamic subdivisions.
#\' @export
aal3_subcortical <- function() .aal3_bg


#\' @describeIn aal_atlases
#\' AAL3 cerebellar atlas containing 26 regions.
#\' @export
aal3_cerebellum <- function() .aal3_cer


#\' @describeIn aal_atlases
#\' Backwards-compatible alias for the original AAL cortical atlas.
#\' @export
aal <- function() aal1_cortical()


#\' @describeIn aal_atlases
#\' Backwards-compatible alias for the AAL2 cortical atlas.
#\' @export
aal2 <- function() aal2_cortical()
'

writeLines(
  data_code,
  file.path(
    pkg,
    "R",
    "data.R"
  )
)


## =========================================================
## 12. 3D helper
## =========================================================

ggseg3d_code <- '
#\' Plot a ggsegAAL atlas in 3D
#\'
#\' Cortical atlases are rendered using the Colin27 inflated
#\' surface. Subcortical and cerebellar atlases can
#\' optionally be displayed inside the Colin27 pial surface.
#\'
#\' @param atlas A ggsegAAL atlas object.
#\' @param context Logical. Add Colin27 pial anatomical
#\'   context for subcortical or cerebellar atlases.
#\' @param opacity Opacity of the contextual pial surface.
#\' @param colour Colour of the contextual pial surface.
#\' @param ... Additional arguments passed to
#\'   [ggseg3d::ggseg3d()].
#\'
#\' @return A ggseg3d plot.
#\'
#\' @examples
#\' \\dontrun{
#\' ggseg3d_aal(aal1_cortical())
#\'
#\' ggseg3d_aal(
#\'   aal3_subcortical(),
#\'   context = TRUE
#\' )
#\'
#\' ggseg3d_aal(
#\'   aal1_cerebellum(),
#\'   context = TRUE
#\' )
#\' }
#\'
#\' @export
ggseg3d_aal <- function(
    atlas,
    context = FALSE,
    opacity = 0.15,
    colour = "grey",
    ...
) {

  atlas_name <- atlas$atlas

  cortical <- atlas_name %in% c(
    "aal1_cor",
    "aal2_cor",
    "aal3_cor"
  )

  ## Cortical atlas:
  ## use Colin27 inflated surface

  if (cortical) {

    return(
      ggseg3d::ggseg3d(
        atlas = atlas,
        brain_meshes = .colin_inflated_meshes,
        ...
      )
    )
  }

  ## Subcortical / cerebellar atlas

  p <- ggseg3d::ggseg3d(
    atlas = atlas,
    ...
  )

  ## Optional Colin27 pial context

  if (context) {

    p <- ggseg3d::add_glassbrain(
      p,
      brain_meshes = .colin_pial_meshes,
      opacity = opacity,
      colour = colour
    )
  }

  p
}
'

writeLines(
  ggseg3d_code,
  file.path(
    pkg,
    "R",
    "ggseg3d_aal.R"
  )
)


## =========================================================
## 13. data-raw/create-atlas.R
##
## Re-package validated build outputs
## =========================================================

create_atlas_code <- sprintf(
  '## =========================================================
## create-atlas.R
## Create internal data for ggsegAAL
## =========================================================

source("%s")

read_atlas <- function(version, type) {

  folder <- switch(
    type,
    cor = cor_out,
    bg  = bg_out,
    cer = cer_out
  )

  file <- file.path(
    folder,
    version,
    paste0(version, "_", type, ".rds")
  )

  if (!file.exists(file))
    stop("Atlas not found: ", file)

  readRDS(file)
}


.aal1_cor <- read_atlas("aal1", "cor")
.aal1_bg  <- read_atlas("aal1", "bg")
.aal1_cer <- read_atlas("aal1", "cer")

.aal2_cor <- read_atlas("aal2", "cor")
.aal2_bg  <- read_atlas("aal2", "bg")
.aal2_cer <- read_atlas("aal2", "cer")

.aal3_cor <- read_atlas("aal3", "cor")
.aal3_bg  <- read_atlas("aal3", "bg")
.aal3_cer <- read_atlas("aal3", "cer")


.colin_inflated_meshes <- colin_inflated_meshes
.colin_pial_meshes     <- colin_pial_meshes


usethis::use_data(

  .aal1_cor,
  .aal1_bg,
  .aal1_cer,

  .aal2_cor,
  .aal2_bg,
  .aal2_cer,

  .aal3_cor,
  .aal3_bg,
  .aal3_cer,

  .colin_inflated_meshes,
  .colin_pial_meshes,

  internal = TRUE,
  overwrite = TRUE,
  compress = "xz"
)
',
file.path(
  root,
  "scripts",
  "00_config.R"
))


writeLines(
  create_atlas_code,
  file.path(
    data_raw,
    "create-atlas.R"
  )
)


## =========================================================
## 14. Remove scaffold placeholder tests
## =========================================================

test_dir <- file.path(
  pkg,
  "tests",
  "testthat"
)

dir.create(
  test_dir,
  recursive = TRUE,
  showWarnings = FALSE
)

old_tests <- list.files(
  test_dir,
  pattern = "^test.*\\.R$",
  full.names = TRUE
)

if (length(old_tests) > 0)
  unlink(old_tests)


## =========================================================
## 15. Atlas tests
## =========================================================

test_code <- '
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
'

writeLines(
  test_code,
  file.path(
    test_dir,
    "test-data.R"
  )
)


## =========================================================
## 16. testthat bootstrap
## =========================================================

writeLines(
  c(
    "library(testthat)",
    "library(ggsegAAL)",
    "",
    'test_check("ggsegAAL")'
  ),
  file.path(
    pkg,
    "tests",
    "testthat.R"
  )
)


## =========================================================
## 17. Generate documentation
## =========================================================

devtools::document(pkg)

## =========================================================
## 18. Final checks
## =========================================================

message("")
message("Package name:")

print(
  read.dcf(
    description_file,
    fields = c(
      "Package",
      "Version"
    )
  )
)

message("")
message("============================================")
message(" ggsegAAL successfully created")
message("============================================")
message("")
message("Package directory:")
message(pkg)
message("")
message("Atlas composition:")
message("  AAL1: 82 + 8 + 26 = 116 regions")
message("  AAL2: 86 + 8 + 26 = 120 regions")
message("  AAL3: 90 + 50 + 26 = 166 regions")
message("")
message("Next:")
message("")
message("devtools::load_all(pkg)")
message("devtools::test(pkg)")
message("devtools::check(pkg)")
message("")