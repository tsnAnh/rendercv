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
      #box(width: px(110), height: px(110), radius: 50%, clip: true, stroke: px(3) + accent.transparentize(40%))[
        #image("profile_picture.jpg", width: px(110), height: px(110), fit: "cover")
      ]
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
#linebreak()
#v(px(6))
#text(size: px(15), weight: 700, fill: navy, tracking: px(0.2))[AI Researcher and Entrepreneur]
#v(px(14))
#set par(leading: px(7))
#text(size: px(11.5), fill: muted)[
#text(weight: 600, fill: rgb("#334155"))[Phone:] +90 541 999 99 99#h(px(20))#text(weight: 600, fill: rgb("#334155"))[Email:] john_doe\@example.com#h(px(20))#linebreak()#text(weight: 600, fill: rgb("#334155"))[Location:] Istanbul, Turkey]
#set par(leading: px(6))
#v(px(20))
#box(width: 100%, height: px(2), fill: border-soft)




#main-title("Text Entries", none)
#text(size: px(13), fill: body-color)[This is a #emph[TextEntry]. It is only a text and can be useful for sections like #strong[Summary]. To showcase the TextEntry completely, this sentence is added, but it doesn't contain any information.]
#v(px(6))
#text(size: px(13), fill: body-color)[Another text entry with #emph[markdown] and #strong[bold] text. This is the second text entry.]
#v(px(6))
#text(size: px(13), fill: body-color)[Third text with #link("https://example.com")[link] and more content.]
#v(px(6))
#main-title("Publication Entries", none)
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Magneto-Thermal Thin Shell Approximation for 3D Finite Element Analysis of No-Insulation Coils],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[J. Doe, #strong[#emph[H. Tom]], S. Doe, A. Andsurname, S. Doe, A. Andsurname]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Magneto-Thermal Thin Shell Approximation for 3D Finite Element Analysis of No-Insulation Coils],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[J. Doe, #strong[#emph[H. Tom]], S. Doe, A. Andsurname, S. Doe, A. Andsurname]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Magneto-Thermal Thin Shell Approximation for 3D Finite Element Analysis of No-Insulation Coils],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[J. Doe, #strong[#emph[H. Tom]], S. Doe, A. Andsurname, S. Doe, A. Andsurname]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Magneto-Thermal Thin Shell Approximation for 3D Finite Element Analysis of No-Insulation Coils],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[J. Doe, #strong[#emph[H. Tom]], S. Doe, A. Andsurname, S. Doe, A. Andsurname]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Magneto-Thermal Thin Shell Approximation for 3D Finite Element Analysis of No-Insulation Coils],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[J. Doe, #strong[#emph[H. Tom]], S. Doe, A. Andsurname, S. Doe, A. Andsurname · IEEE Transactions on Applied Superconductivity]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Magneto-Thermal Thin Shell Approximation for 3D Finite Element Analysis of No-Insulation Coils],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[J. Doe, #strong[#emph[H. Tom]], S. Doe, A. Andsurname, S. Doe, A. Andsurname]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Magneto-Thermal Thin Shell Approximation for 3D Finite Element Analysis of No-Insulation Coils],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[J. Doe, #strong[#emph[H. Tom]], S. Doe, A. Andsurname, S. Doe, A. Andsurname]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Magneto-Thermal Thin Shell Approximation for 3D Finite Element Analysis of No-Insulation Coils],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[J. Doe, #strong[#emph[H. Tom]], S. Doe, A. Andsurname, S. Doe, A. Andsurname]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Magneto-Thermal Thin Shell Approximation for 3D Finite Element Analysis of No-Insulation Coils],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[J. Doe, #strong[#emph[H. Tom]], S. Doe, A. Andsurname, S. Doe, A. Andsurname · IEEE Transactions on Applied Superconductivity]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Magneto-Thermal Thin Shell Approximation for 3D Finite Element Analysis of No-Insulation Coils],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[J. Doe, #strong[#emph[H. Tom]], S. Doe, A. Andsurname, S. Doe, A. Andsurname]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Magneto-Thermal Thin Shell Approximation for 3D Finite Element Analysis of No-Insulation Coils],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[J. Doe, #strong[#emph[H. Tom]], S. Doe, A. Andsurname, S. Doe, A. Andsurname]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Magneto-Thermal Thin Shell Approximation for 3D Finite Element Analysis of No-Insulation Coils],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[J. Doe, #strong[#emph[H. Tom]], S. Doe, A. Andsurname, S. Doe, A. Andsurname · IEEE Transactions on Applied Superconductivity]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Magneto-Thermal Thin Shell Approximation for 3D Finite Element Analysis of No-Insulation Coils],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[J. Doe, #strong[#emph[H. Tom]], S. Doe, A. Andsurname, S. Doe, A. Andsurname]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Magneto-Thermal Thin Shell Approximation for 3D Finite Element Analysis of No-Insulation Coils],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[J. Doe, #strong[#emph[H. Tom]], S. Doe, A. Andsurname, S. Doe, A. Andsurname · IEEE Transactions on Applied Superconductivity]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Magneto-Thermal Thin Shell Approximation for 3D Finite Element Analysis of No-Insulation Coils],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[J. Doe, #strong[#emph[H. Tom]], S. Doe, A. Andsurname, S. Doe, A. Andsurname]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Magneto-Thermal Thin Shell Approximation for 3D Finite Element Analysis of No-Insulation Coils],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[J. Doe, #strong[#emph[H. Tom]], S. Doe, A. Andsurname, S. Doe, A. Andsurname · IEEE Transactions on Applied Superconductivity]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Magneto-Thermal Thin Shell Approximation for 3D Finite Element Analysis of No-Insulation Coils],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[J. Doe, #strong[#emph[H. Tom]], S. Doe, A. Andsurname, S. Doe, A. Andsurname]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Magneto-Thermal Thin Shell Approximation for 3D Finite Element Analysis of No-Insulation Coils],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[J. Doe, #strong[#emph[H. Tom]], S. Doe, A. Andsurname, S. Doe, A. Andsurname · IEEE Transactions on Applied Superconductivity]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Magneto-Thermal Thin Shell Approximation for 3D Finite Element Analysis of No-Insulation Coils],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[J. Doe, #strong[#emph[H. Tom]], S. Doe, A. Andsurname, S. Doe, A. Andsurname]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Magneto-Thermal Thin Shell Approximation for 3D Finite Element Analysis of No-Insulation Coils],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[J. Doe, #strong[#emph[H. Tom]], S. Doe, A. Andsurname, S. Doe, A. Andsurname · IEEE Transactions on Applied Superconductivity]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Magneto-Thermal Thin Shell Approximation for 3D Finite Element Analysis of No-Insulation Coils],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[J. Doe, #strong[#emph[H. Tom]], S. Doe, A. Andsurname, S. Doe, A. Andsurname]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Magneto-Thermal Thin Shell Approximation for 3D Finite Element Analysis of No-Insulation Coils],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[J. Doe, #strong[#emph[H. Tom]], S. Doe, A. Andsurname, S. Doe, A. Andsurname · IEEE Transactions on Applied Superconductivity]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Magneto-Thermal Thin Shell Approximation for 3D Finite Element Analysis of No-Insulation Coils],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[J. Doe, #strong[#emph[H. Tom]], S. Doe, A. Andsurname, S. Doe, A. Andsurname · IEEE Transactions on Applied Superconductivity]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Magneto-Thermal Thin Shell Approximation for 3D Finite Element Analysis of No-Insulation Coils],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[J. Doe, #strong[#emph[H. Tom]], S. Doe, A. Andsurname, S. Doe, A. Andsurname]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Magneto-Thermal Thin Shell Approximation for 3D Finite Element Analysis of No-Insulation Coils],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[J. Doe, #strong[#emph[H. Tom]], S. Doe, A. Andsurname, S. Doe, A. Andsurname · IEEE Transactions on Applied Superconductivity]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Magneto-Thermal Thin Shell Approximation for 3D Finite Element Analysis of No-Insulation Coils],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[J. Doe, #strong[#emph[H. Tom]], S. Doe, A. Andsurname, S. Doe, A. Andsurname · IEEE Transactions on Applied Superconductivity]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Magneto-Thermal Thin Shell Approximation for 3D Finite Element Analysis of No-Insulation Coils],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[J. Doe, #strong[#emph[H. Tom]], S. Doe, A. Andsurname, S. Doe, A. Andsurname · IEEE Transactions on Applied Superconductivity]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Magneto-Thermal Thin Shell Approximation for 3D Finite Element Analysis of No-Insulation Coils],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[J. Doe, #strong[#emph[H. Tom]], S. Doe, A. Andsurname, S. Doe, A. Andsurname]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Magneto-Thermal Thin Shell Approximation for 3D Finite Element Analysis of No-Insulation Coils],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[J. Doe, #strong[#emph[H. Tom]], S. Doe, A. Andsurname, S. Doe, A. Andsurname · IEEE Transactions on Applied Superconductivity]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Magneto-Thermal Thin Shell Approximation for 3D Finite Element Analysis of No-Insulation Coils],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[J. Doe, #strong[#emph[H. Tom]], S. Doe, A. Andsurname, S. Doe, A. Andsurname · IEEE Transactions on Applied Superconductivity]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Magneto-Thermal Thin Shell Approximation for 3D Finite Element Analysis of No-Insulation Coils],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[J. Doe, #strong[#emph[H. Tom]], S. Doe, A. Andsurname, S. Doe, A. Andsurname · IEEE Transactions on Applied Superconductivity]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Magneto-Thermal Thin Shell Approximation for 3D Finite Element Analysis of No-Insulation Coils],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[J. Doe, #strong[#emph[H. Tom]], S. Doe, A. Andsurname, S. Doe, A. Andsurname · IEEE Transactions on Applied Superconductivity]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#main-title("Experience Entries", none)
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    date-pill[2020-06],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer · Istanbul, Turkey]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer · Istanbul, Turkey]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer · Istanbul, Turkey]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    date-pill[2020-06],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer · Istanbul, Turkey]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    date-pill[2020-06],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    date-pill[2020-06],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer · Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer · Istanbul, Turkey]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer · Istanbul, Turkey]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer · Istanbul, Turkey]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer · Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer · Istanbul, Turkey]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer · Istanbul, Turkey]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer · Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer · Istanbul, Turkey]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    date-pill[2020-06],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer · Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    date-pill[2020-06],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer · Istanbul, Turkey]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    date-pill[2020-06],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer · Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer · Istanbul, Turkey]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer · Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer · Istanbul, Turkey]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer · Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer · Istanbul, Turkey]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer · Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer · Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer · Istanbul, Turkey]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer · Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    date-pill[2020-06],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer · Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer · Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer · Istanbul, Turkey]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer · Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer · Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer · Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Some Company],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Software Engineer · Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#main-title("Education Entries", none)
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2020-06],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering · Istanbul, Turkey]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2020-06],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering · Istanbul, Turkey]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering · Istanbul, Turkey]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering · Istanbul, Turkey]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2020-06],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering · Istanbul, Turkey]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2020-06],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2020-06],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering · Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering · Istanbul, Turkey]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering · Istanbul, Turkey]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering · Istanbul, Turkey]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2020-06],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering · Istanbul, Turkey]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2020-06],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2020-06],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering · Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering · Istanbul, Turkey]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering · Istanbul, Turkey]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering · Istanbul, Turkey]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering · Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering · Istanbul, Turkey]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering · Istanbul, Turkey]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering · Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering · Istanbul, Turkey]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2020-06],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering · Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2020-06],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering · Istanbul, Turkey]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2020-06],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering · Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering · Istanbul, Turkey]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering · Istanbul, Turkey]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering · Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering · Istanbul, Turkey]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering · Istanbul, Turkey]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering · Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering · Istanbul, Turkey]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2020-06],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering · Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2020-06],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering · Istanbul, Turkey]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2020-06],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering · Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering · Istanbul, Turkey]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering · Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering · Istanbul, Turkey]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering · Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering · Istanbul, Turkey]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering · Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering · Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering · Istanbul, Turkey]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering · Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2020-06],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering · Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering · Istanbul, Turkey]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering · Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering · Istanbul, Turkey]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering · Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering · Istanbul, Turkey]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering · Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering · Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering · Istanbul, Turkey]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering · Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2020-06],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering · Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering · Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering · Istanbul, Turkey]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering · Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering · Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering · Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering · Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering · Istanbul, Turkey]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering · Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering · Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering · Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Mechanical Engineering · Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Boğaziçi University],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[BS · Mechanical Engineering · Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#main-title("Normal Entries", none)
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    [],
  )
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    date-pill[2021-09],
  )
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    [],
  )
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    date-pill[2020-06],
  )
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Istanbul, Turkey]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    [],
  )
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    [],
  )
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    date-pill[2021-09],
  )
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    date-pill[2021-09],
  )
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Istanbul, Turkey]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    date-pill[2021-09],
  )
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    date-pill[2021-09],
  )
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    [],
  )
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Istanbul, Turkey]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    [],
  )
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    [],
  )
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    date-pill[2020-06],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Istanbul, Turkey]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    date-pill[2020-06],
  )
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    date-pill[2020-06],
  )
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Istanbul, Turkey]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    [],
  )
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    date-pill[2021-09],
  )
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Istanbul, Turkey]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    date-pill[2021-09],
  )
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    date-pill[2021-09],
  )
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Istanbul, Turkey]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    date-pill[2021-09],
  )
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    date-pill[2021-09],
  )
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Istanbul, Turkey]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    date-pill[2021-09],
  )
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Istanbul, Turkey]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    [],
  )
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    [],
  )
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Istanbul, Turkey]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    [],
  )
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    date-pill[2020-06],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    date-pill[2020-06],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Istanbul, Turkey]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    date-pill[2020-06],
  )
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Istanbul, Turkey]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    date-pill[2021-09],
  )
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    date-pill[2021-09],
  )
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Istanbul, Turkey]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    date-pill[2021-09],
  )
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Istanbul, Turkey]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    date-pill[2021-09],
  )
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Istanbul, Turkey]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    [],
  )
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    date-pill[2020-06],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Istanbul, Turkey]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    date-pill[2021-09],
  )
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[My Project],
    date-pill[2021-09],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Istanbul, Turkey]
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Did #emph[this] and this is a #strong[bold] #link("https://example.com")[link]. But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. - Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
  - Did that. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.
]
#main-title("One Line Entries", none)
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Programming],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Python, C++, JavaScript, MATLAB]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Programming],
    [],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Python, C++, JavaScript, MATLAB]
]
#main-title("Bullet Entries", none)
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[This is a bullet entry.],
    [],
  )
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[This is a bullet entry.],
    [],
  )
]
#main-title("Numbered Entries", none)
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[This is a numbered entry.],
    [],
  )
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[This is a numbered entry.],
    [],
  )
]
#main-title("Reversed Numbered Entries", none)
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[This is a reversed numbered entry.],
    [],
  )
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[This is a reversed numbered entry.],
    [],
  )
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[This is a reversed numbered entry.],
    [],
  )
]
#main-title("A Section & with \% Special Characters", none)
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[A Section & with \% Special Characters],
    [],
  )
]
#main-title("Empty Section", none)
