
#' Automated Anatomical Labeling atlases
#'
#' Accessors for the AAL1, AAL2 and AAL3 atlas families.
#'
#' Each atlas is provided as three anatomical components:
#'
#' * `cortical`: cortical atlas
#' * `subcortical`: subcortical atlas
#' * `cerebellum`: cerebellar atlas
#'
#' @section Atlas composition:
#'
#' * AAL1: 82 cortical + 8 subcortical +
#'   26 cerebellar = 116 regions.
#'
#' * AAL2: 86 cortical + 8 subcortical +
#'   26 cerebellar = 120 regions.
#'
#' * AAL3: 90 cortical + 50 subcortical +
#'   26 cerebellar = 166 regions.
#'
#' @references
#' Rolls, E. T., Huang, C. C., Lin, C. P., Feng, J.,
#' & Joliot, M. (2020).
#' Automated anatomical labelling atlas 3.
#' \emph{NeuroImage}, 206.
#' \href{https://pubmed.ncbi.nlm.nih.gov/31521825/}{PubMed}
#'
#' Rolls, E. T., Joliot, M., & Tzourio-Mazoyer, N. (2015).
#' Implementation of a new parcellation of the orbitofrontal
#' cortex in the automated anatomical labeling atlas.
#' \emph{NeuroImage}, 122, 1-5.
#' \href{https://pubmed.ncbi.nlm.nih.gov/26241684/}{PubMed}
#'
#' Tzourio-Mazoyer, N., Landeau, B., Papathanassiou, D.,
#' Crivello, F., Étard, O., Delcroix, N., Mazoyer, B.,
#' & Joliot, M. (2002).
#' Automated Anatomical Labeling of Activations in SPM
#' Using a Macroscopic Anatomical Parcellation of the
#' MNI MRI Single-Subject Brain.
#' \emph{NeuroImage}, 15, 273-289.
#' \href{https://pubmed.ncbi.nlm.nih.gov/11771995/}{PubMed}
#'
#' @family ggseg_atlases
#' @name aal_atlases
NULL


#' @describeIn aal_atlases
#' AAL1 cortical atlas containing 82 cortical regions.
#' @export
aal1_cortical <- function() .aal1_cor


#' @describeIn aal_atlases
#' AAL1 subcortical atlas containing 8 regions.
#' @export
aal1_subcortical <- function() .aal1_bg


#' @describeIn aal_atlases
#' AAL1 cerebellar atlas containing 26 regions.
#' @export
aal1_cerebellum <- function() .aal1_cer


#' @describeIn aal_atlases
#' AAL2 cortical atlas containing 86 cortical regions,
#' including the AAL2 orbitofrontal parcellation.
#' @export
aal2_cortical <- function() .aal2_cor


#' @describeIn aal_atlases
#' AAL2 subcortical atlas containing 8 regions.
#' @export
aal2_subcortical <- function() .aal2_bg


#' @describeIn aal_atlases
#' AAL2 cerebellar atlas containing 26 regions.
#' @export
aal2_cerebellum <- function() .aal2_cer


#' @describeIn aal_atlases
#' AAL3 cortical atlas containing 90 cortical regions,
#' including anterior cingulate subdivisions.
#' @export
aal3_cortical <- function() .aal3_cor


#' @describeIn aal_atlases
#' AAL3 subcortical atlas containing 50 regions,
#' including thalamic subdivisions.
#' @export
aal3_subcortical <- function() .aal3_bg


#' @describeIn aal_atlases
#' AAL3 cerebellar atlas containing 26 regions.
#' @export
aal3_cerebellum <- function() .aal3_cer


#' @describeIn aal_atlases
#' Backwards-compatible alias for the original AAL cortical atlas.
#' @export
aal <- function() aal1_cortical()


#' @describeIn aal_atlases
#' Backwards-compatible alias for the AAL2 cortical atlas.
#' @export
aal2 <- function() aal2_cortical()

