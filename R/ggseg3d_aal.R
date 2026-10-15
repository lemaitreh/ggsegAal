
#' Plot a ggsegAAL atlas in 3D
#'
#' Cortical atlases are rendered using the Colin27 inflated
#' surface. Subcortical and cerebellar atlases can
#' optionally be displayed inside the Colin27 pial surface.
#'
#' @param atlas A ggsegAAL atlas object.
#' @param context Logical. Add Colin27 pial anatomical
#'   context for subcortical or cerebellar atlases.
#' @param opacity Opacity of the contextual pial surface.
#' @param colour Colour of the contextual pial surface.
#' @param ... Additional arguments passed to
#'   [ggseg3d::ggseg3d()].
#'
#' @return A ggseg3d plot.
#'
#' @examples
#' \dontrun{
#' ggseg3d_aal(aal1_cortical())
#'
#' ggseg3d_aal(
#'   aal3_subcortical(),
#'   context = TRUE
#' )
#'
#' ggseg3d_aal(
#'   aal1_cerebellum(),
#'   context = TRUE
#' )
#' }
#'
#' @export
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

