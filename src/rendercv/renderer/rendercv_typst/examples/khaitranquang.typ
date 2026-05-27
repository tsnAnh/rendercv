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
    year: 2026,
    month: 5,
    day: 27,
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
    #side-title("Education", "\u{e80c}", first: true)
    #text(size: px(13), weight: 600, fill: rgb("#f1f5f9"))[Princeton University]
    #v(px(12))
    #text(size: px(13), weight: 600, fill: rgb("#f1f5f9"))[Boğaziçi University]
    #v(px(12))
    #side-title("Skills", "\u{e86f}")
    #text(size: px(10.5), weight: 600, fill: side-dim2, tracking: px(0.8))[#upper[Languages]]
    #v(px(7))
    #set par(leading: px(7))
#chip[Python]#h(px(5))#chip[C++]#h(px(5))#chip[CUDA]#h(px(5))#chip[Rust]#h(px(5))#chip[Julia]#h(px(5))
    #v(px(10))
    #text(size: px(10.5), weight: 600, fill: side-dim2, tracking: px(0.8))[#upper[ML Frameworks]]
    #v(px(7))
    #set par(leading: px(7))
#chip[PyTorch]#h(px(5))#chip[JAX]#h(px(5))#chip[TensorFlow]#h(px(5))#chip[Triton]#h(px(5))#chip[ONNX]#h(px(5))
    #v(px(10))
    #text(size: px(10.5), weight: 600, fill: side-dim2, tracking: px(0.8))[#upper[Infrastructure]]
    #v(px(7))
    #set par(leading: px(7))
#chip[Kubernetes]#h(px(5))#chip[Ray]#h(px(5))#chip[distributed training]#h(px(5))#chip[AWS]#h(px(5))#chip[GCP]#h(px(5))
    #v(px(10))
    #text(size: px(10.5), weight: 600, fill: side-dim2, tracking: px(0.8))[#upper[Research Areas]]
    #v(px(7))
    #set par(leading: px(7))
#chip[Neural architecture search]#h(px(5))#chip[model compression]#h(px(5))#chip[efficient inference]#h(px(5))#chip[multi-agent RL]#h(px(5))
    #v(px(10))
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
#text(weight: 600, fill: rgb("#334155"))[Email:] john.doe\@email.com#h(px(20))#linebreak()#text(weight: 600, fill: rgb("#334155"))[Location:] San Francisco, CA]
#set par(leading: px(6))
#v(px(20))
#box(width: 100%, height: px(2), fill: border-soft)

#main-title("Welcome to RenderCV", "\u{f0d3}")
#text(size: px(13), fill: body-color)[RenderCV reads a CV written in a YAML file, and generates a PDF with professional typography.]
#v(px(6))
#text(size: px(13), fill: body-color)[Each section title is arbitrary.]
#v(px(6))
#text(size: px(13), fill: body-color)[You can choose any of the 9 entry types for each section.]
#v(px(6))
#text(size: px(13), fill: body-color)[Markdown syntax is supported everywhere. This is #strong[bold], #emph[italic], and #link("https://example.com")[link].]
#v(px(6))


#main-title("Experience", "\u{e943}")
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(
    columns: (1fr, auto),
    column-gutter: px(12),
    align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Nexus AI],
    [],
  )
  #v(px(4))
  #grid(
    columns: (auto, 1fr),
    column-gutter: px(8),
    align: horizon,
    box[
#text(size: px(12.5), weight: 600, fill: accent)[San Francisco, CA]#h(px(8))#text(fill: rgb("#cbd5e1"))[·]#h(px(8))#text(size: px(12), fill: muted2, style: "italic")[Co-Founder & CTO]    ],
    [],
  )
  #v(px(10))
  #grid(columns: (1fr, 1fr), column-gutter: px(20), row-gutter: px(4),
    text(size: px(12), fill: body-color)[• Built foundation model infrastructure serving 2M+ monthly API requests with 99.97\% uptime],
    text(size: px(12), fill: body-color)[• Raised \$18M Series A led by Sequoia Capital, with participation from a16z and Founders Fund],
    text(size: px(12), fill: body-color)[• Scaled engineering team from 3 to 28 across ML research, platform, and applied AI divisions],
    text(size: px(12), fill: body-color)[• Developed proprietary inference optimization reducing latency by 73\% compared to baseline],
  )
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(
    columns: (1fr, auto),
    column-gutter: px(12),
    align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[NVIDIA Research],
    [],
  )
  #v(px(4))
  #grid(
    columns: (auto, 1fr),
    column-gutter: px(8),
    align: horizon,
    box[
#text(size: px(12.5), weight: 600, fill: accent)[Santa Clara, CA]#h(px(8))#text(fill: rgb("#cbd5e1"))[·]#h(px(8))#text(size: px(12), fill: muted2, style: "italic")[Research Intern]    ],
    [],
  )
  #v(px(10))
  #grid(columns: (1fr, 1fr), column-gutter: px(20), row-gutter: px(4),
    text(size: px(12), fill: body-color)[• Designed sparse attention mechanism reducing transformer memory footprint by 4.2x],
    text(size: px(12), fill: body-color)[• Co-authored paper accepted at NeurIPS 2022 (spotlight presentation, top 5\% of submissions)],
  )
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(
    columns: (1fr, auto),
    column-gutter: px(12),
    align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Google DeepMind],
    [],
  )
  #v(px(4))
  #grid(
    columns: (auto, 1fr),
    column-gutter: px(8),
    align: horizon,
    box[
#text(size: px(12.5), weight: 600, fill: accent)[London, UK]#h(px(8))#text(fill: rgb("#cbd5e1"))[·]#h(px(8))#text(size: px(12), fill: muted2, style: "italic")[Research Intern]    ],
    [],
  )
  #v(px(10))
  #grid(columns: (1fr, 1fr), column-gutter: px(20), row-gutter: px(4),
    text(size: px(12), fill: body-color)[• Developed reinforcement learning algorithms for multi-agent coordination],
    text(size: px(12), fill: body-color)[• Published research at top-tier venues with significant academic impact - ICML 2022 main conference paper, cited 340+ times within two years - NeurIPS 2022 workshop paper on emergent communication protocols - Invited journal extension in JMLR (2023)],
  )
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(
    columns: (1fr, auto),
    column-gutter: px(12),
    align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Apple ML Research],
    [],
  )
  #v(px(4))
  #grid(
    columns: (auto, 1fr),
    column-gutter: px(8),
    align: horizon,
    box[
#text(size: px(12.5), weight: 600, fill: accent)[Cupertino, CA]#h(px(8))#text(fill: rgb("#cbd5e1"))[·]#h(px(8))#text(size: px(12), fill: muted2, style: "italic")[Research Intern]    ],
    [],
  )
  #v(px(10))
  #grid(columns: (1fr, 1fr), column-gutter: px(20), row-gutter: px(4),
    text(size: px(12), fill: body-color)[• Created on-device neural network compression pipeline deployed across 50M+ devices],
    text(size: px(12), fill: body-color)[• Filed 2 patents on efficient model quantization techniques for edge inference],
  )
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(
    columns: (1fr, auto),
    column-gutter: px(12),
    align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Microsoft Research],
    [],
  )
  #v(px(4))
  #grid(
    columns: (auto, 1fr),
    column-gutter: px(8),
    align: horizon,
    box[
#text(size: px(12.5), weight: 600, fill: accent)[Redmond, WA]#h(px(8))#text(fill: rgb("#cbd5e1"))[·]#h(px(8))#text(size: px(12), fill: muted2, style: "italic")[Research Intern]    ],
    [],
  )
  #v(px(10))
  #grid(columns: (1fr, 1fr), column-gutter: px(20), row-gutter: px(4),
    text(size: px(12), fill: body-color)[• Implemented novel self-supervised learning framework for low-resource language modeling],
    text(size: px(12), fill: body-color)[• Research integrated into Azure Cognitive Services, reducing training data requirements by 60\%],
  )
]

#main-title("Projects", none)
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[#link("https://github.com/")[FlashInfer]],
    [],
  )
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Open-source library for high-performance LLM inference kernels]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Achieved 2.8x speedup over baseline attention implementations on A100 GPUs
  - Adopted by 3 major AI labs, 8,500+ GitHub stars, 200+ contributors
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[#link("https://github.com/")[NeuralPrune]],
    date-pill[2021],
  )
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[Automated neural network pruning toolkit with differentiable masks]
  ]
  #v(px(8))
  #set text(size: px(12), fill: body-color)
  - Reduced model size by 90\% with less than 1\% accuracy degradation on ImageNet
  - Featured in PyTorch ecosystem tools, 4,200+ GitHub stars
]
#main-title("Publications", none)
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Sparse Mixture-of-Experts at Scale: Efficient Routing for Trillion-Parameter Models],
    date-pill[2023-07],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[#emph[John Doe], Sarah Williams, David Park · NeurIPS 2023]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Neural Architecture Search via Differentiable Pruning],
    date-pill[2022-12],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[James Liu, #emph[John Doe] · NeurIPS 2022, Spotlight]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Multi-Agent Reinforcement Learning with Emergent Communication],
    date-pill[2022-07],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[Maria Garcia, #emph[John Doe], Tom Anderson · ICML 2022]
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[On-Device Model Compression via Learned Quantization],
    date-pill[2021-05],
  )
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[#emph[John Doe], Kevin Wu · ICLR 2021, Best Paper Award]
]
#main-title("Selected Honors", none)
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[MIT Technology Review 35 Under 35 Innovators (2024)],
    [],
  )
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Forbes 30 Under 30 in Enterprise Technology (2024)],
    [],
  )
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[ACM Doctoral Dissertation Award Honorable Mention (2023)],
    [],
  )
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Google PhD Fellowship in Machine Learning (2020 – 2023)],
    [],
  )
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Fulbright Scholarship for Graduate Studies (2018)],
    [],
  )
]
#main-title("Patents", none)
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Adaptive Quantization for Neural Network Inference on Edge Devices (US Patent 11,234,567)],
    [],
  )
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Dynamic Sparsity Patterns for Efficient Transformer Attention (US Patent 11,345,678)],
    [],
  )
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Hardware-Aware Neural Architecture Search Method (US Patent 11,456,789)],
    [],
  )
]
#main-title("Invited Talks", none)
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Scaling Laws for Efficient Inference — Stanford HAI Symposium (2024)],
    [],
  )
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Building AI Infrastructure for the Next Decade — TechCrunch Disrupt (2024)],
    [],
  )
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[From Research to Production: Lessons in ML Systems — NeurIPS Workshop (2023)],
    [],
  )
]
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[Efficient Deep Learning: A Practitioner's Perspective — Google Tech Talk (2022)],
    [],
  )
]
