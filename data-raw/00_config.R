## =========================================================
## 00_config.R
## =========================================================

library(devtools)
library(usethis)
library(ggplot2)
library(ggseg)
library(ggseg3d)
library(ggseg.extra)
library(ggseg.formats)
library(freesurferformats)
library(gifti)
library(dplyr)
library(RNifti)
library(desc)

## ---------------------------------------------------------
## Paths
## ---------------------------------------------------------

root  <- "/data/extra/hlemaitre/aal"
raw   <- file.path(root, "raw")
build <- file.path(root, "build")

fs   <- file.path(root, "freesurfer", "colin27_t1_tal_lin_reg")
surf <- file.path(fs, "surf")

cor_out <- file.path(build, "cortical")
bg_out  <- file.path(build, "basal_ganglia")
cer_out <- file.path(build, "cerebellum")

for (x in c(cor_out, bg_out, cer_out))
  dir.create(x, recursive = TRUE, showWarnings = FALSE)

## ---------------------------------------------------------
## Atlas configuration
## ---------------------------------------------------------

atlases <- list(
  
  aal1 = list(
    raw    = file.path(raw, "aal"),
    vol    = file.path(raw, "aal_cortical_subcortical"),
    prefix = "AAL1_116",
    annot  = c(
      lh = file.path(fs, "label", "lh.AAL1_116_recipe.annot"),
      rh = file.path(fs, "label", "rh.AAL1_116_recipe.annot")
    )
  ),
  
  aal2 = list(
    raw    = file.path(raw, "aal2"),
    vol    = file.path(raw, "aal2_cortical_subcortical"),
    prefix = "aal2",
    annot  = c(
      lh = file.path(fs, "label", "lh.aal2_recipe.annot"),
      rh = file.path(fs, "label", "rh.aal2_recipe.annot")
    )
  ),
  
  aal3 = list(
    raw    = file.path(raw, "aal3"),
    vol    = file.path(raw, "aal3_cortical_subcortical"),
    prefix = "AAL3v1",
    annot  = c(
      lh = file.path(fs, "label", "lh.AAL3v1_recipe.annot"),
      rh = file.path(fs, "label", "rh.AAL3v1_recipe.annot")
    )
  )
)

## ---------------------------------------------------------
## Colin27 mesh reader
## ---------------------------------------------------------

read_mesh <- function(file) {
  x <- freesurferformats::read.fs.surface(file)
  
  list(
    vertices = setNames(
      as.data.frame(x$vertices),
      c("x", "y", "z")
    ),
    faces = setNames(
      as.data.frame(x$faces - 1L),
      c("i", "j", "k")
    )
  )
}

## ---------------------------------------------------------
## Colin27 meshes for cortical 3D rendering
## ---------------------------------------------------------

colin_inflated_meshes <- list(
  lh = read_mesh(file.path(surf, "lh.inflated")),
  rh = read_mesh(file.path(surf, "rh.inflated"))
)

colin_pial_meshes <- list(
  lh = read_mesh(file.path(surf, "lh.pial")),
  rh = read_mesh(file.path(surf, "rh.pial"))
)

## ---------------------------------------------------------
## Generic volume helpers
## ---------------------------------------------------------


get_files <- function(version, type) {
  
  x <- atlases[[version]]
  
  if (!type %in% c("cortex", "sub", "bg", "cer"))
    stop("Unknown type: ", type)
  
  p <- file.path(
    x$vol,
    paste0(x$prefix, "_", type)
  )
  
  ctab <- switch(
    type,
    cortex = file.path(
      x$vol,
      paste0(x$prefix, "_cortex.ctab")
    ),
    sub = file.path(
      x$vol,
      paste0(x$prefix, "_sub.ctab")
    ),
    bg = file.path(
      x$vol,
      paste0(x$prefix, "_sub.ctab")
    ),
    cer = file.path(
      x$vol,
      paste0(x$prefix, "_sub.ctab")
    )
  )
  
  list(
    vol  = paste0(p, ".nii.gz"),
    mask = paste0(p, "_mask.nii.gz"),
    ctab = ctab
  )
}

## Examples:
# get_files("aal1", "sub")
# get_files("aal2", "bg")
# get_files("aal3", "cer")

## ---------------------------------------------------------
## Checks
## ---------------------------------------------------------

stopifnot(
  dir.exists(raw),
  dir.exists(fs),
  dir.exists(surf),
  
  all(vapply(
    atlases,
    \(x) dir.exists(x$raw) && dir.exists(x$vol),
    logical(1)
  )),
  
  all(vapply(
    atlases,
    \(x) all(file.exists(x$annot)),
    logical(1)
  )),
  
  file.exists(file.path(surf, "lh.inflated")),
  file.exists(file.path(surf, "rh.inflated")),
  file.exists(file.path(surf, "lh.pial")),
  file.exists(file.path(surf, "rh.pial"))
)