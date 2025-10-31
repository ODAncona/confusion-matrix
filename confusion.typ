#import "@preview/cetz:0.4.2": canvas, draw

// Confusion matrix rendering as a reusable Typst function.
// Usage:
//   #import "confusion.typ": confusion-matrix
//   #confusion-matrix(labels, M, ...options)
//
// Params:
// - labels: tuple/list of n labels
// - M: n×n matrix (tuple of tuples) of non-negative values
// - title-row: column axis title
// - title-col: row axis title
// - colormap-name: one of "viridis" | "magma" | "inferno" | "plasma" | "cividis"
// - cell-size: cell size in canvas units
// - show-colorbar: display colorbar on the right
// - label-rotate: rotation for column labels
// - value-font-size: value text size inside cells
// - tick-scale: tick length factor relative to cell size
#let confusion-matrix(
  labels,
  M,
  title-row: "Predicted",
  title-col: "Ground Truth",
  colormap-name: "viridis",
  cell-size: 1.3,
  show-colorbar: true,
  label-rotate: -35deg,
  value-font-size: 9pt,
  tick-scale: 0.07,
) = {
  canvas({
    import draw: content, line, rect

    // Basic geometry
    let n = labels.len()
    let cell = cell-size
    let left = 0
    let top = 0
    let tick = tick-scale * cell

    // Find max value
    let maxv = 0
    for row in M {
      for v in row {
        if v > maxv { maxv = v }
      }
    }

    // Select colormap
    let cmap-base = if colormap-name == "viridis" { color.map.viridis } else if colormap-name == "magma" {
      color.map.magma
    } else if colormap-name == "inferno" { color.map.inferno } else if colormap-name == "plasma" {
      color.map.plasma
    } else if colormap-name == "cividis" { color.map.cividis } else { color.map.viridis }

    let colormap = gradient.linear(..cmap-base, angle: 270deg, relative: "self")
    let sample_map(v, max) = {
      if max == 0 { colormap.sample(0%) } else { colormap.sample((v / max) * 100%) }
    }

    // Contrast-aware text color
    let text_on(bg) = {
      let L = color.oklab(bg).components().at(0)
      if L > 65% { black } else { white }
    }

    // Cells + values
    for (i, row) in M.enumerate() {
      for (j, v) in row.enumerate() {
        let x1 = left + (j + 1) * cell
        let y1 = top - (i + 1) * cell
        let x2 = left + (j + 2) * cell
        let y2 = top - (i + 2) * cell

        let bg = sample_map(v, maxv)
        rect((x1, y1), (x2, y2), fill: bg, stroke: none)

        let cx = (x1 + x2) / 2
        let cy = (y1 + y2) / 2
        content((cx, cy), text(size: value-font-size, weight: "bold", fill: text_on(bg))[#v], anchor: "center")
      }
    }

    // Outer border
    let x0 = left + cell
    let y0 = top - cell
    let xN = left + (n + 1) * cell
    let yN = top - (n + 1) * cell
    rect(
      (x0, yN),
      (xN, y0),
      fill: none,
      stroke: (thickness: .7pt, cap: "square", join: "miter"),
    )

    // Tick marks
    for i in range(0, n) {
      let y = top - (i + 1.5) * cell
      line((x0 - tick, y), (x0, y), stroke: (thickness: 0.6pt, cap: "square"))
    }
    for j in range(0, n) {
      let x = left + (j + 1.5) * cell
      line((x, yN), (x, yN - tick), stroke: (thickness: 0.6pt, cap: "square"))
    }

    // Column labels
    for (j, lab) in labels.enumerate() {
      let x = left + (j + 1.5) * cell
      content(
        (x, yN - 0.6 * cell - tick),
        rotate(label-rotate)[#text(size: 8pt, weight: "bold")[#lab]],
        anchor: "east",
      )
    }

    // Row labels
    for (i, lab) in labels.enumerate() {
      let x = left + cell - tick - 0.06 * cell
      let y = top - (i + 1.5) * cell
      content(
        (x, y),
        text(size: 8pt, weight: "bold")[#lab],
        anchor: "east",
      )
    }

    // Headers
    content(
      (left + (n / 2 + 1) * cell, y0 + 0.2 * cell),
      smallcaps[#title-row],
      anchor: "center",
    )
    let max_label_size = 2.2
    content(
      (x0 - tick - 0.2 * cell - max_label_size, (y0 + yN) / 2),
      rotate(-90deg)[#smallcaps[#title-col]],
      anchor: "center",
    )

    // Colorbar
    if show-colorbar {
      let lg_w = 0.35
      let lg_h = y0 - yN
      let lg_x0 = xN + 0.4 * cell
      let lg_y0 = yN

      rect(
        (lg_x0, lg_y0),
        (lg_x0 + lg_w, lg_y0 + lg_h),
        fill: colormap,
        stroke: (thickness: .5pt, cap: "square", join: "miter"),
      )

      let tlen = 0.15
      let tx = lg_x0 + lg_w
      if maxv > 0 {
        for s in range(0, maxv + 1) {
          let t = s / maxv
          let y = lg_y0 + t * lg_h
          line((tx, y), (tx + tlen, y), stroke: (thickness: 0.4pt, cap: "square"))
          content((tx + tlen + 0.1, y), text(size: 7pt)[#s], anchor: "west")
        }
      }
    }
  })
}
