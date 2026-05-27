// khaitranquang theme — faithful Typst reproduction of the on-screen HTML CV at
// https://khaitranquang-cntt.github.io/ . The whole 1060px-wide "sheet" is scaled
// uniformly to the A4 page width so proportions and line-wrapping match the screen.

// ===== Uniform px->pt scale (sheet fills A4 width inside the 20px side margins) =====
#let s = 0.5412
#let px(n) = n * s * 1pt

// ===== Palette (from the screen CSS) =====
#let accent = rgb("#3498db")
#let navy = rgb("#1e3a5f")
#let nm = rgb("#0f172a")
#let body-color = rgb("#334155")
#let muted = rgb("#475569")
#let muted2 = rgb("#64748b")
#let card = rgb("#f8fafc")
#let border = rgb("#e2e8f0")
#let border-soft = rgb("#f1f5f9")
#let side-text = rgb("#e2e8f0")
#let side-dim = rgb("#cbd5e1")
#let side-dim2 = rgb("#94a3b8")

#let sheet-margin = px(20)
#let sheet-top = px(40)
#let sidebar-w = px(310)

// ===== Dotted page background (#dde3ea field + #b8c4d0 dots on a 28px grid) =====
#let dotbg = tiling(size: (px(28), px(28)))[
  #place(top + left, rect(width: px(28), height: px(28), fill: rgb("#dde3ea")))
  #place(center + horizon, circle(radius: px(1.5), fill: rgb("#b8c4d0")))
]

// ===== Sheet drawn on every page: rounded white card + gradient navy sidebar band =====
#let sheet-bg = place(
  top + left,
  dx: sheet-margin,
  dy: sheet-top,
  box(
    width: 100% - 2 * sheet-margin,
    height: 100% - 2 * sheet-top,
    radius: px(16),
    clip: true,
    fill: white,
    place(
      top + left,
      rect(
        width: sidebar-w,
        height: 100%,
        fill: gradient.linear(
          (rgb("#1a3352"), 0%),
          (rgb("#1e3d63"), 60%),
          (rgb("#162d4a"), 100%),
          dir: ttb,
        ),
      ),
    ),
  ),
)

#set document(
  title: "John Doe - CV",
  author: "John Doe",
  date: datetime(
    year: 2025,
    month: 11,
    day: 30,
  ),
)
#set page(
  paper: "a4",
  // Margins position the flowing main column; the sidebar is placed absolutely.
  margin: (
    left: sheet-margin + sidebar-w + px(42),
    right: sheet-margin + px(42),
    top: sheet-top + px(40),
    bottom: sheet-top + px(40),
  ),
  fill: dotbg,
  background: sheet-bg,
)
#set text(font: "Inter", size: px(13), fill: body-color, lang: "en")
#set par(justify: false, leading: px(6))
#show link: it => text(fill: accent, it)

#let msi(cp, sz) = text(font: "Material Symbols Rounded", size: sz, fill: accent, cp)

// Sidebar section header: icon + uppercase label + trailing rule.
#let side-title(title, cp, first: false) = {
  v(if first { px(2) } else { px(22) })
  grid(
    columns: (auto, 1fr),
    column-gutter: px(8),
    align: horizon,
    box(text(size: px(9.5), weight: 700, fill: accent, tracking: px(1.8))[#msi(cp, px(12))#h(px(4))#upper(title)]),
    line(length: 100%, stroke: px(1) + accent.transparentize(70%)),
  )
  v(px(11))
}

// Main section header: icon + uppercase label + trailing gradient rule.
#let main-title(title, cp) = {
  v(px(28))
  grid(
    columns: (auto, 1fr),
    column-gutter: px(10),
    align: horizon,
    box(text(size: px(10), weight: 700, fill: accent, tracking: px(2))[#upper(title)]),
    box(width: 100%, height: px(1.5), fill: gradient.linear(border, border.transparentize(100%))),
  )
  v(px(15))
}

#let chip(label, strong: false) = box(
  inset: (x: px(9), y: px(3)),
  radius: px(3),
  fill: if strong { accent.transparentize(85%) } else { white.transparentize(94%) },
  stroke: px(1) + (if strong { accent.transparentize(65%) } else { white.transparentize(88%) }),
  text(
    size: px(10.5),
    fill: if strong { side-text } else { side-dim },
    weight: if strong { 500 } else { "regular" },
    label,
  ),
)

#let summary-card(label, val) = block(
  width: 100%,
  fill: card,
  inset: (x: px(12), y: px(10)),
  radius: (top-right: px(6), bottom-right: px(6)),
  stroke: (left: px(3) + accent, rest: px(1) + border),
)[
  #text(size: px(9.5), weight: 700, fill: accent, tracking: px(0.8))[#upper(label)]
  #v(px(4))
  #text(size: px(12), fill: body-color)[#val]
]

#let date-pill(label) = box(
  fill: accent,
  radius: px(20),
  inset: (x: px(10), y: px(2)),
  text(size: px(11.5), weight: 500, fill: white, label),
)

// ===== Sidebar (rendered once, on page 1) =====
#let sidebar = {
  // side-top: darkened band with avatar
  block(width: 100%, fill: black.transparentize(85%), inset: (top: px(30), bottom: px(24), x: px(30)), stroke: (bottom: px(1) + white.transparentize(92%)))[
    #align(center)[
    ]
  ]
  block(width: 100%, inset: (top: px(18), bottom: px(24), x: px(28)))[
  ]
}


// Draw the sidebar on every page via the page background (mirrors the sticky
// on-screen sidebar that stays visible while scrolling the main column).
#set page(background: {
  sheet-bg
  place(top + left, dx: sheet-margin, dy: sheet-top, block(width: sidebar-w, sidebar))
})

// ===== Main column (flows across pages) =====
#text(size: px(30), weight: 700, fill: nm, tracking: px(1))[JOHN DOE]
#v(px(14))
#set par(leading: px(7))
#text(size: px(11.5), fill: muted)[
]
#set par(leading: px(6))
#v(px(20))
#box(width: 100%, height: px(2), fill: border-soft)



#main-title("Experience", "\u{e943}")
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(
    columns: (1fr, auto),
    column-gutter: px(12),
    align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[],
    [],
  )
  #v(px(4))
  #grid(
    columns: (auto, 1fr),
    column-gutter: px(8),
    align: horizon,
    box[
    ],
    [],
  )
  #v(px(10))
  #grid(
    columns: (1fr, 1fr),
    column-gutter: px(20),
    align: top,
    [
    ],
    [
    ],
  )
]

