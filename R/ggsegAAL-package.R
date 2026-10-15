
#' ggsegAAL: Automated Anatomical Labeling atlases
#'
#' The ggsegAAL package provides AAL1, AAL2 and AAL3
#' representations for the ggseg ecosystem.
#'
#' The atlas family is divided into cortical, subcortical
#' and cerebellar components.
#'
#' @section Atlas composition:
#'
#' * **AAL1:** 82 cortical + 8 subcortical +
#'   26 cerebellar = **116 regions**.
#'
#' * **AAL2:** 86 cortical, including the AAL2
#'   orbitofrontal parcellation, + 8 subcortical +
#'   26 cerebellar = **120 regions**.
#'
#' * **AAL3:** 90 cortical, including anterior cingulate
#'   subdivisions, + 50 subcortical, including thalamic
#'   subdivisions, + 26 cerebellar = **166 regions**.
#'
#' @section Representations:
#'
#' Cortical atlases are represented on the Colin27
#' cortical surface.
#'
#' Subcortical atlases include a contextual cortical
#' representation for 2D plotting.
#'
#' Cerebellar atlases are transformed to SUIT space and
#' provide flatmap and 3D representations.
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
#' @docType package
#' @name ggsegAAL-package
#' @keywords internal
"_PACKAGE"

