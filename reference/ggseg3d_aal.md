# Plot a ggsegAAL atlas in 3D

Cortical atlases are rendered using the Colin27 inflated surface.
Subcortical and cerebellar atlases can optionally be displayed inside
the Colin27 pial surface.

## Usage

``` r
ggseg3d_aal(atlas, context = FALSE, opacity = 0.15, colour = "grey", ...)
```

## Arguments

- atlas:

  A ggsegAAL atlas object.

- context:

  Logical. Add Colin27 pial anatomical context for subcortical or
  cerebellar atlases.

- opacity:

  Opacity of the contextual pial surface.

- colour:

  Colour of the contextual pial surface.

- ...:

  Additional arguments passed to
  [`ggseg3d::ggseg3d()`](https://ggsegverse.github.io/ggseg3d/reference/ggseg3d.html).

## Value

A ggseg3d plot.

## Examples

``` r
if (FALSE) { # \dontrun{
ggseg3d_aal(aal1_cortical())

ggseg3d_aal(
  aal3_subcortical(),
  context = TRUE
)

ggseg3d_aal(
  aal1_cerebellum(),
  context = TRUE
)
} # }
```
