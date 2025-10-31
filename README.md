# confusion-matrix (Typst)

Reusable confusion matrix renderer for Typst, built on @preview/cetz.

- Main file: `confusion.typ` (exports the function `confusion-matrix`)
- Demo: `demo.typ`
- License: see `LICENSE`

Prerequisites

- Typst installed
- Access to the package `@preview/cetz:0.4.2` (used internally by `confusion.typ`)

Installation / Local usage

- Copy `confusion.typ` into your project (or place it in a local packages folder if you use one).
- Import and call the function as shown below.

Import (Typst Universe)

```typst
#import "@preview/confusion-matrix:0.1.0": confusion-matrix
```

Dependency (fetched automatically)

```typst
#import "@preview/cetz:0.4.2"
```

Import (local)

```
#import "confusion.typ": confusion-matrix
```

API

```
#let confusion-matrix(
  labels,                         // tuple/list of n labels
  M,                              // n×n matrix (tuple of tuples) of values >= 0
  title-row: "Predicted",         // column axis title
  title-col: "Ground Truth",      // row axis title
  colormap-name: "viridis",       // "viridis" | "magma" | "inferno" | "plasma" | "cividis"
  cell-size: 1.3,                 // cell size (canvas units)
  show-colorbar: true,            // display the color bar
  label-rotate: -35deg,           // rotation for column labels
  value-font-size: 9pt,           // text size for cell values
  tick-scale: 0.07,               // tick length as a proportion of cell-size
)
```

Minimal example

```typst
#import "@preview/confusion-matrix:0.1.0": confusion-matrix

#let labels = ("Covered", "ConditionUnmet", "NotCovered", "Uncertain")
#let M = (
  (10, 3, 6, 2),
  (2, 4, 3, 2),
  (1, 0, 1, 1),
  (2, 2, 0, 0),
)

#confusion-matrix(
  labels,
  M,
  title-row: "Predicted",
  title-col: "Ground Truth",
  colormap-name: "magma",
  cell-size: 1.3,
  show-colorbar: true,
)
```

Demo

- Compile the demo:

```
typst compile demo.typ
```

Notes

- Supported colormaps: `viridis`, `magma`, `inferno`, `plasma`, `cividis`. Any other value falls back to `viridis`.
- If `max(M) == 0`, a uniform color is used and the colorbar shows no irrelevant ticks.
- Cell text color (black/white) is adjusted automatically for contrast based on the background.

Good practices and possible extensions

- Validate that `len(labels) == n`, `M` is square, and size is `n × n`.
- Future option: `normalize: "none" | "row" | "column"` to display percentages.
- Fine customization (sizes, thicknesses, margins) can be added via new parameters.

Publishing (Typst Universe)

- There is no official CLI yet to publish directly. The standard path is to open a PR on the `typst/packages` repository.
- Option A — Manual PR:
  1. Fork `typst/packages`.
  2. Create `packages/preview/confusion-matrix/0.1.0/` and place `typst.toml`, `README.md`, `LICENSE`, and your entrypoint file (`confusion.typ`) there.
  3. Open a PR.
- Option B — With Tyler (semi-automated):
  - From the package root (with `typst.toml` present):

    ```bash
    tyler build -p
    ```

  - Tyler validates, creates the `preview/<name>/<version>` tree, and guides you to open the PR.

Credits

- Rendering based on `@preview/cetz:0.4.2` (canvas/draw).
