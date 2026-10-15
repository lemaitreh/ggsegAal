## =========================================================
## 03_cerebellum.R
## AAL1 / AAL2 / AAL3 cerebellar atlases
## =========================================================

source("/data/extra/hlemaitre/aal/scripts/00_config.R")

## ---------------------------------------------------------
## SUIT deformation field
## ---------------------------------------------------------
## Default choice for standard MNI-like AAL inputs.
## If needed, you can change this template later.
suit_template <- "MNI152NLin6AsymC"

suit_xfm <- ggseg.extra::suit_deformation_field(
  template = suit_template
)

## ---------------------------------------------------------
## Build cerebellum atlas function
## ---------------------------------------------------------

make_cerebellum <- function(version, deformation_field = suit_xfm) {
  
  x   <- atlases[[version]]
  out <- file.path(cer_out, version)
  
  dir.create(out, recursive = TRUE, showWarnings = FALSE)
  
  # cerebellar volume
  cer_vol <- file.path(
    x$vol,
    paste0(x$prefix, "_cer.nii.gz")
  )
  
  # LUT with labels
  lut_file <- file.path(
    x$vol,
    paste0(x$prefix, "_sub.ctab")
  )
  
  stopifnot(
    file.exists(cer_vol),
    file.exists(lut_file)
  )
  
  message("\n--- ", toupper(version), " cerebellum ---")
  
  # transform MNI -> SUIT
  suit_vol <- ggseg.extra::transform_mni_to_suit(
    input_volume = cer_vol,
    deformation_field = deformation_field,
    interpolation = "nearest",
    output_file = file.path(out, paste0(version, "_cer_SUIT.nii.gz"))
  )
  
  # Keep only LUT entries actually present after transform
  ids <- sort(unique(as.integer(
    RNifti::readNifti(suit_vol)
  )))
  
  ids <- ids[ids != 0L]
  
  lut <- ggseg.extra::get_lut(lut_file) |>
    dplyr::filter(idx %in% ids)
  
  message(
    "Cerebellar labels: ",
    paste(lut$label, collapse = ", ")
  )
  
  if (!setequal(ids, lut$idx)) {
    stop(
      "Some cerebellar labels in the volume are missing from the LUT."
    )
  }
  
  ##  build cerebellar atlas (flatmap + 3D)
  atlas <- ggseg.extra::create_cerebellar_from_volume(
    input_volume = suit_vol,
    input_lut = lut,
    atlas_name = paste0(version, "_cer"),
    output_dir = out,
    cleanup = FALSE,
    skip_existing = FALSE,
    verbose = TRUE
  )
  
  ## Restore Vermis names
  ii <- grepl("^vermis_", atlas$core$label, ignore.case = TRUE)
  
  atlas$core$region[ii] <- paste0(
    "Vermis_",
    sub("^vermis_", "", atlas$core$label[ii], ignore.case = TRUE)
  )
  
  saveRDS(
    atlas,
    file.path(out, paste0(version, "_cer.rds"))
  )
  
  atlas
}

## ---------------------------------------------------------
## Build AAL1 / AAL2 / AAL3
## ---------------------------------------------------------

aal1_cer <- make_cerebellum("aal1")
aal2_cer <- make_cerebellum("aal2")
aal3_cer <- make_cerebellum("aal3")

## ---------------------------------------------------------
## Display
## ---------------------------------------------------------

# plot 2D
ggplot() +
  geom_brain(atlas = aal1_cer)
plot(aal1_cer)

ggplot() +
  geom_brain(atlas = aal2_cer)
plot(aal2_cer)

ggplot() +
  geom_brain(atlas = aal3_cer)
plot(aal3_cer)

# plot 3D with contextual
ggseg3d::ggseg3d(
  atlas = aal1_cer
) |>
  ggseg3d::add_glassbrain(
    brain_meshes = colin_pial_meshes,
    opacity = 0.15,
    colour = "grey"
  )

ggseg3d::ggseg3d(
  atlas = aal2_cer
) |>
  ggseg3d::add_glassbrain(
    brain_meshes = colin_pial_meshes,
    opacity = 0.15,
    colour = "grey"
  )

ggseg3d::ggseg3d(
  atlas = aal3_cer
) |>
  ggseg3d::add_glassbrain(
    brain_meshes = colin_pial_meshes,
    opacity = 0.15,
    colour = "grey"
  )
