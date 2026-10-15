## =========================================================
## 02_basal_ganglia.R
## AAL1 / AAL2 / AAL3 basal ganglia
## with cortical context
## =========================================================

source("/data/extra/hlemaitre/aal/scripts/00_config.R")

## ---------------------------------------------------------
## Build basal ganglia atlas function
## ---------------------------------------------------------


make_bg <- function(version) {
  
  x   <- atlases[[version]]
  out <- file.path(bg_out, version)
  
  dir.create(out, recursive = TRUE, showWarnings = FALSE)
  
  message(
    "\n--- ", toupper(version),
    " basal ganglia + cortical context ---"
  )
  
  
  ## -------------------------------------------------------
  ## Input
  ## -------------------------------------------------------
  
  bg_vol <- file.path(
    x$vol,
    paste0(x$prefix, "_bg_context.nii.gz")
  )
  
  bg_lut_file <- file.path(
    x$vol,
    paste0(x$prefix, "_sub.ctab")
  )
  
  stopifnot(
    file.exists(bg_vol),
    file.exists(bg_lut_file)
  )
  
  
  ## -------------------------------------------------------
  ## Labels present in the context volume
  ##
  ## 1      = Cortex
  ## others = BG labels
  ## -------------------------------------------------------
  
  ids <- sort(unique(as.integer(
    RNifti::readNifti(bg_vol)
  )))
  
  ids <- ids[ids != 0L]
  
  message(
    "Labels present: ",
    paste(ids, collapse = ", ")
  )
  
  
  ## -------------------------------------------------------
  ## BG LUT
  ## -------------------------------------------------------
  
  bg_lut <- ggseg.extra::get_lut(bg_lut_file) |>
    filter(idx %in% ids)
  
  
  ## -------------------------------------------------------
  ## Add cortical context
  ## -------------------------------------------------------
  
  cortex_lut <- data.frame(
    idx   = 1L,
    label = "Cortex",
    R     = 180L,
    G     = 180L,
    B     = 180L,
    A     = 0L
  )
  
  lut <- bind_rows(
    cortex_lut,
    bg_lut
  ) |>
    distinct(idx, .keep_all = TRUE)
  
  
  ## -------------------------------------------------------
  ## Create subcortical atlas
  ## -------------------------------------------------------
  
  atlas <- ggseg.extra::create_subcortical_from_volume(
    input_volume = bg_vol,
    input_lut = lut,
    atlas_name = paste0(version, "_bg"),
    output_dir = out,
    cleanup = FALSE,
    skip_existing = FALSE,
    verbose = TRUE
  )
  
  
  ## -------------------------------------------------------
  ## Cortex = contextual region
  ## -------------------------------------------------------
  
  atlas <- ggseg.formats::atlas_region_contextual(
    atlas,
    pattern = "^Cortex$",
    match_on = "label"
  )
  
  
  ## -------------------------------------------------------
  ## Save
  ## -------------------------------------------------------
  
  saveRDS(
    atlas,
    file.path(
      out,
      paste0(version, "_bg.rds")
    )
  )
  
  atlas
}

## =========================================================
## Build AAL1 / AAL2 / AAL3
## =========================================================

aal1_bg <- make_bg("aal1")
aal2_bg <- make_bg("aal2")
aal3_bg <- make_bg("aal3")

## =========================================================
## Display with contextual
## =========================================================

# plot 2D with contextual
ggplot() +
  geom_brain(atlas = aal1_bg)
plot(aal1_bg)

ggplot() +
  geom_brain(atlas = aal2_bg)
plot(aal2_bg)

ggplot() +
  geom_brain(atlas = aal3_bg)
plot(aal3_bg)

# plot 3D with contextual
ggseg3d::ggseg3d(
  atlas = aal1_bg
) |>
  ggseg3d::add_glassbrain(
    brain_meshes = colin_pial_meshes,
    opacity = 0.15,
    colour = "grey"
  )

ggseg3d::ggseg3d(
  atlas = aal2_bg
) |>
  ggseg3d::add_glassbrain(
    brain_meshes = colin_pial_meshes,
    opacity = 0.15,
    colour = "grey"
  )

ggseg3d::ggseg3d(
  atlas = aal3_bg
) |>
  ggseg3d::add_glassbrain(
    brain_meshes = colin_pial_meshes,
    opacity = 0.15,
    colour = "grey"
  )





