## =========================================================
## 01_cortical.R
## AAL1 / AAL2 / AAL3 cortical atlases on Colin27
## =========================================================

source("/data/extra/hlemaitre/aal/scripts/00_config.R")

## ---------------------------------------------------------
## Colin27 projection instead of standard ggseg mesh
## ---------------------------------------------------------

project_colin <- function(components, hemisphere, views,
                          tolerance = 0, smooth_refinements = 2,
                          verbose = FALSE, ...) {
  
  hd <- setNames(lapply(hemisphere, function(h) {
    
    m <- colin_inflated_meshes[[h]]
    
    list(
      mesh = m,
      labels = ggseg.extra:::build_vertex_label_vector(
        components$vertices_df,
        nrow(m$vertices),
        h
      )
    )
    
  }), hemisphere)
  
  x <- expand.grid(
    hemi = hemisphere,
    view = views,
    stringsAsFactors = FALSE
  )
  
  z <- lapply(seq_len(nrow(x)), function(i) {
    
    h <- x$hemi[i]
    v <- x$view[i]
    
    cam <- ggseg.extra:::camera_presets[[paste(h, v, sep = "_")]]
    
    if (is.null(cam))
      return(NULL)
    
    if (verbose)
      message("Projecting ", h, " ", v)
    
    ggseg.extra:::project_mesh_view(
      hd[[h]]$mesh,
      hd[[h]]$labels,
      cam,
      h,
      v
    )
  })
  
  do.call(rbind, Filter(Negate(is.null), z))
}


## ---------------------------------------------------------
## Temporarily replace ggseg.extra projection function
## ---------------------------------------------------------

create_cortical_colin <- function(...) {
  
  ns  <- asNamespace("ggseg.extra")
  fun <- "project_mesh_to_polygons"
  old <- get(fun, ns)
  
  unlockBinding(fun, ns)
  assign(fun, project_colin, ns)
  lockBinding(fun, ns)
  
  on.exit({
    unlockBinding(fun, ns)
    assign(fun, old, ns)
    lockBinding(fun, ns)
  })
  
  ggseg.extra::create_cortical_from_annotation(...)
}


## ---------------------------------------------------------
## Build cortical atlas function
## ---------------------------------------------------------

make_cortex <- function(version) {
  
  x   <- atlases[[version]]
  out <- file.path(cor_out, version)
  
  dir.create(out, recursive = TRUE, showWarnings = FALSE)
  
  message("\n--- ", toupper(version), " cortical atlas ---")
  
  atlas <- create_cortical_colin(
    input_annot = x$annot,
    atlas_name = paste0(version, "_cor"),
    output_dir = out,
    skip_existing = FALSE,
    cleanup = FALSE,
    verbose = TRUE
  )
  
  saveRDS(
    atlas,
    file.path(out, paste0(version, "_cor.rds"))
  )
  
  atlas
}


## ---------------------------------------------------------
## Build AAL1 / AAL2 / AAL3
## ---------------------------------------------------------

# display is not proper as it is not projected to the colin mesh yet

aal1_cor <- make_cortex("aal1")
aal2_cor <- make_cortex("aal2")
aal3_cor <- make_cortex("aal3")


## ---------------------------------------------------------
## Display
## ---------------------------------------------------------

# plot 2D

ggplot() +
  geom_brain(
    atlas = aal1_cor,
    aes(fill = label)
  ) +
  scale_fill_manual(
    values = atlas_palette(aal1_cor)
  ) +
  theme_brain() +
  theme(legend.position = "none")

ggplot() +
  geom_brain(
    atlas = aal2_cor,
    aes(fill = label)
  ) +
  scale_fill_manual(
    values = atlas_palette(aal2_cor)
  ) +
  theme_brain() +
  theme(legend.position = "none")

ggplot() +
  geom_brain(
    atlas = aal3_cor,
    aes(fill = label)
  ) +
  scale_fill_manual(
    values = atlas_palette(aal3_cor)
  ) +
  theme_brain() +
  theme(legend.position = "none")

# plot 3D

ggseg3d(
  atlas = aal1_cor,
  brain_meshes = colin_inflated_meshes
)

ggseg3d(
  atlas = aal2_cor,
  brain_meshes = colin_inflated_meshes
)

ggseg3d(
  atlas = aal3_cor,
  brain_meshes = colin_inflated_meshes
)

