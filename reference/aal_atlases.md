# Automated Anatomical Labeling atlases

Accessors for the AAL1, AAL2 and AAL3 atlas families.

## Usage

``` r
aal1_cortical()

aal1_subcortical()

aal1_cerebellum()

aal2_cortical()

aal2_subcortical()

aal2_cerebellum()

aal3_cortical()

aal3_subcortical()

aal3_cerebellum()

aal()

aal2()
```

## Details

Each atlas is provided as three anatomical components:

- `cortical`: cortical atlas

- `subcortical`: subcortical atlas

- `cerebellum`: cerebellar atlas

## Functions

- `aal1_cortical()`: AAL1 cortical atlas containing 82 cortical regions.

- `aal1_subcortical()`: AAL1 subcortical atlas containing 8 regions.

- `aal1_cerebellum()`: AAL1 cerebellar atlas containing 26 regions.

- `aal2_cortical()`: AAL2 cortical atlas containing 86 cortical regions,
  including the AAL2 orbitofrontal parcellation.

- `aal2_subcortical()`: AAL2 subcortical atlas containing 8 regions.

- `aal2_cerebellum()`: AAL2 cerebellar atlas containing 26 regions.

- `aal3_cortical()`: AAL3 cortical atlas containing 90 cortical regions,
  including anterior cingulate subdivisions.

- `aal3_subcortical()`: AAL3 subcortical atlas containing 50 regions,
  including thalamic subdivisions.

- `aal3_cerebellum()`: AAL3 cerebellar atlas containing 26 regions.

- `aal()`: Backwards-compatible alias for the original AAL cortical
  atlas.

- `aal2()`: Backwards-compatible alias for the AAL2 cortical atlas.

## Atlas composition

- AAL1: 82 cortical + 8 subcortical + 26 cerebellar = 116 regions.

- AAL2: 86 cortical + 8 subcortical + 26 cerebellar = 120 regions.

- AAL3: 90 cortical + 50 subcortical + 26 cerebellar = 166 regions.

## References

Rolls, E. T., Huang, C. C., Lin, C. P., Feng, J., & Joliot, M. (2020).
Automated anatomical labelling atlas 3. *NeuroImage*, 206.
[PubMed](https://pubmed.ncbi.nlm.nih.gov/31521825/)

Rolls, E. T., Joliot, M., & Tzourio-Mazoyer, N. (2015). Implementation
of a new parcellation of the orbitofrontal cortex in the automated
anatomical labeling atlas. *NeuroImage*, 122, 1-5.
[PubMed](https://pubmed.ncbi.nlm.nih.gov/26241684/)

Tzourio-Mazoyer, N., Landeau, B., Papathanassiou, D., Crivello, F.,
Étard, O., Delcroix, N., Mazoyer, B., & Joliot, M. (2002). Automated
Anatomical Labeling of Activations in SPM Using a Macroscopic Anatomical
Parcellation of the MNI MRI Single-Subject Brain. *NeuroImage*, 15,
273-289. [PubMed](https://pubmed.ncbi.nlm.nih.gov/11771995/)
