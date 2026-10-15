## =========================================================
## create-atlas.R
## Create internal data for ggsegAAL
## =========================================================

source("/data/extra/hlemaitre/aal/scripts/00_config.R")

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

