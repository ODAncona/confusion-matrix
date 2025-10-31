// Demo document for the confusion-matrix Typst package.
//
// This demo imports the reusable function from confusion.typ and renders
// the same example as in the original cm.typ, with a different colormap.

#import "confusion.typ": confusion-matrix

#let labels = ("Covered", "ConditionUnmet", "NotCovered", "Uncertain")
#let M = (
  (10, 3, 6, 2),
  (2, 4, 3, 2),
  (1, 0, 1, 1),
  (2, 2, 0, 0),
)

#set page(margin: 1.5cm)

= Confusion Matrix Demo

#confusion-matrix(
  labels,
  M,
  title-row: "Predicted",
  title-col: "Ground Truth",
  colormap-name: "viridis",
  cell-size: 1.3,
  show-colorbar: true,
)

// Optional: a second rendering with different options for comparison.
// Uncomment if you want to preview different styles.

#pagebreak()
#confusion-matrix(
  labels,
  M,
  title-row: "Predicted",
  title-col: "Ground Truth",
  colormap-name: "viridis",
  cell-size: 1.1,
  show-colorbar: false,
  label-rotate: -20deg,
  value-font-size: 8.5pt,
)
