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
  title: "{{ settings.pdf_title }}",
  author: "{{ cv._plain_name }}",
  date: datetime(
    year: {{ settings._resolved_current_date.year }},
    month: {{ settings._resolved_current_date.month }},
    day: {{ settings._resolved_current_date.day }},
  ),
)
#set page(
  paper: "{{ design.page.size }}",
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
#set text(font: "Inter", size: px(13), fill: body-color, lang: "{{ locale.language_iso_639_1 }}")
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
    box(text(size: px(10), weight: 700, fill: accent, tracking: px(2))[{% if cp %}#msi(cp, px(15))#h(px(4)){% endif %}#upper(title)]),
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
{% set education = (cv | section_by_title("Sidebar Education")) or (cv | section_by_title("Education")) %}
{% set skills = (cv | section_by_title("Sidebar Technical Skills")) or (cv | section_by_title("Skills")) %}
{% set english = cv | section_by_title("Sidebar English Proficiency") %}
{% set objective = cv | section_by_title("Sidebar Career Objective") %}
#let sidebar = {
  // side-top: darkened band with avatar
  block(width: 100%, fill: black.transparentize(85%), inset: (top: px(30), bottom: px(24), x: px(30)), stroke: (bottom: px(1) + white.transparentize(92%)))[
    #align(center)[
{% if cv.photo %}
      #box(width: px(110), height: px(110), radius: 50%, clip: true, stroke: px(3) + accent.transparentize(40%))[
        #image("{{ cv.photo.name }}", width: px(110), height: px(110), fit: "cover")
      ]
{% endif %}
    ]
  ]
  block(width: 100%, inset: (top: px(18), bottom: px(24), x: px(28)))[
{% if education %}
    #side-title("{{ education.title|replace('Sidebar ', '') }}", "\u{e80c}", first: true)
{% for entry in education.entries %}
    #text(size: px(13), weight: 600, fill: rgb("#f1f5f9"))[{{ entry.name if entry.name is defined else entry.institution }}]
{% if entry.summary and entry.url is not defined %}
    #linebreak()
    #text(size: px(11.5), fill: side-dim2)[{{ entry.summary }}]
{% endif %}
{% if entry.date_string is defined and entry.date_string %}
    #linebreak()
    #text(size: px(11), fill: muted2)[{{ entry.date_string }}]
{% endif %}
{% if entry.badge is defined %}
    #linebreak()
    #v(px(3))
    #box(fill: accent.transparentize(88%), radius: px(3), inset: (x: px(8), y: px(2)))[#text(size: px(11), weight: 600, fill: accent)[{{ entry.badge }}]]
{% endif %}
{% if entry.url is defined %}
    #linebreak()
    #text(size: px(11), fill: side-dim2)[{{ entry.summary }} #link("{{ entry.url }}")[#text(fill: accent, weight: 600)[\[Verify\]]]]
{% endif %}
    #v(px(12))
{% endfor %}
{% endif %}
{% if skills %}
    #side-title("{{ skills.title|replace('Sidebar ', '') }}", "\u{e86f}")
{% for entry in skills.entries %}
    #text(size: px(10.5), weight: 600, fill: side-dim2, tracking: px(0.8))[#upper[{{ entry.label }}]]
    #v(px(7))
    #set par(leading: px(7))
    {% for tag in entry.details.split(", ") %}#chip{% if entry.strong is defined and tag in entry.strong %}(strong: true){% endif %}[{{ tag }}]#h(px(5)){% endfor %}

    #v(px(10))
{% endfor %}
{% endif %}
{% if english %}
    #side-title("{{ english.title|replace('Sidebar ', '') }}", "\u{e8e2}")
{% for entry in english.entries %}
    #grid(
      columns: (1fr, auto),
      text(size: px(10.5), weight: 500, fill: side-dim)[{{ entry.label }}],
      text(size: px(10.5), weight: 500, fill: muted2)[{{ entry.details }}],
    )
    #v(px(4))
    #box(width: 100%, height: px(3), radius: px(2), fill: white.transparentize(92%), clip: true)[
      #box(width: {{ entry.percent if entry.percent is defined else "70" }}%, height: px(3), fill: gradient.linear(rgb("#2980b9"), accent))
    ]
    #v(px(8))
{% endfor %}
{% endif %}
{% if objective %}
    #side-title("{{ objective.title|replace('Sidebar ', '') }}", "\u{e8e1}")
{% for entry in objective.entries %}
    #text(size: px(11.5), fill: side-dim2)[{{ entry }}]
    #v(px(6))
{% endfor %}
{% endif %}
  ]
}

{% set header_section = cv | section_by_title("Header Details") %}
{% set header_entry = header_section.entries[0] if header_section and header_section.entries else none %}
{% set summary = (cv | section_by_title("Summary")) or (cv | section_by_title("Welcome to RenderCV")) %}
{% set ai = cv | section_by_title("AI Strategy & Innovation") %}
{% set experience = cv | section_by_title("Experience") %}
{% set rendered_section_titles = [
    "Header Details",
    "Sidebar Education",
    "Sidebar Technical Skills",
    "Sidebar English Proficiency",
    "Sidebar Career Objective",
    "Education",
    "Skills",
    "Summary",
    "Welcome to RenderCV",
    "AI Strategy & Innovation",
    "Experience",
] %}

// Draw the sidebar on every page via the page background (mirrors the sticky
// on-screen sidebar that stays visible while scrolling the main column).
#set page(background: {
  sheet-bg
  place(top + left, dx: sheet-margin, dy: sheet-top, block(width: sidebar-w, sidebar))
})

// ===== Main column (flows across pages) =====
{% if cv.name %}
#text(size: px(30), weight: 700, fill: nm, tracking: px(1))[{{ cv.name.upper() }}]
{% endif %}
{% if cv.headline %}
#linebreak()
#v(px(6))
#text(size: px(15), weight: 700, fill: navy, tracking: px(0.2))[{{ cv.headline }}]
{% endif %}
{% if header_entry and header_entry.tagline is defined %}
#linebreak()
#v(px(5))
#text(size: px(12), fill: accent, tracking: px(0.3))[{{ header_entry.tagline }}]
{% endif %}
#v(px(14))
#set par(leading: px(7))
#text(size: px(11.5), fill: muted)[
{% if header_entry and header_entry.date_of_birth is defined %}#text(weight: 600, fill: rgb("#334155"))[Date of Birth:] {{ header_entry.date_of_birth }}#h(px(20)){% endif %}
{% if cv.phone %}#text(weight: 600, fill: rgb("#334155"))[Phone:] {{ cv.phone|replace("tel:", "")|replace("-", " ") }}#h(px(20)){% endif %}
{% if cv.email %}#text(weight: 600, fill: rgb("#334155"))[Email:] {{ cv.email|replace("@", "\\@") }}#h(px(20)){% endif %}
{% if header_entry and header_entry.experience is defined %}#text(weight: 600, fill: rgb("#334155"))[Experience:] {{ header_entry.experience }}{% endif %}
{% if cv.location %}#linebreak()#text(weight: 600, fill: rgb("#334155"))[Location:] {{ cv.location }}{% endif %}
]
#set par(leading: px(6))
#v(px(20))
#box(width: 100%, height: px(2), fill: border-soft)

{% if summary %}
#main-title("{{ summary.title }}", "\u{f0d3}")
{% if summary.entries and summary.entries[0] is string %}
{% for entry in summary.entries %}
#text(size: px(13), fill: body-color)[{{ entry }}]
#v(px(6))
{% endfor %}
{% elif summary.entries and summary.entries[0].summary is defined %}
#set par(leading: px(10))
#text(size: px(13), fill: body-color)[{{ summary.entries[0].summary }}]
#set par(leading: px(6))
#v(px(14))
#grid(columns: (1fr, 1fr), gutter: px(10),
{% for entry in summary.entries[1:] %}
{% if entry.wide is defined %}
  grid.cell(colspan: 2, summary-card("{{ entry.name }}", [{{ entry.summary }}])),
{% else %}
  summary-card("{{ entry.name }}", [{{ entry.summary }}]),
{% endif %}
{% endfor %}
)
{% endif %}
{% endif %}

{% if ai %}
#main-title("{{ ai.title }}", "\u{f06c}")
{% for entry in ai.entries %}
#block(
  width: 100%,
  fill: rgb("#f0f7ff"),
  inset: (x: px(16), y: px(14)),
  radius: (top-right: px(8), bottom-right: px(8)),
  stroke: (left: px(3) + accent, rest: px(1) + rgb("#bfdbfe")),
)[
{% if entry.summary %}
  #text(size: px(12.5), fill: navy)[{{ entry.summary }}]
{% endif %}
{% if entry.highlights %}
  #v(px(8))
  #set text(size: px(12), fill: body-color)
{% for item in entry.highlights %}
  - {{ item }}
{% endfor %}
{% endif %}
]
{% endfor %}
{% endif %}

{% if experience %}
#main-title("{{ experience.title }}", "\u{e943}")
{% for entry in experience.entries %}
{% set entry_title = entry|entry_title %}
{% set date_value = entry.date_string if (entry.date_string is defined and entry.date_string) else (entry.date if (entry.date is defined and entry.date) else none) %}
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
  #grid(
    columns: (1fr, auto),
    column-gutter: px(12),
    align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[{{ entry_title }}],
{% if date_value %}
    date-pill[{{ date_value }}],
{% else %}
    [],
{% endif %}
  )
  #v(px(4))
  #grid(
    columns: (auto, 1fr),
    column-gutter: px(8),
    align: horizon,
    box[
{% if entry.location %}#text(size: px(12.5), weight: 600, fill: accent)[{{ entry.location }}]{% endif %}
{% if entry.position is defined %}#h(px(8))#text(fill: rgb("#cbd5e1"))[·]#h(px(8))#text(size: px(12), fill: muted2, style: "italic")[{{ entry.position }}]{% endif %}
    ],
{% if entry.team_size is defined %}
    box(align(right, box(fill: card, radius: px(10), inset: (x: px(8), y: px(1)), stroke: px(1) + border)[#text(size: px(11), fill: side-dim2)[#msi("\u{ea21}", px(11))#h(px(3)){{ entry.team_size }}]])),
{% else %}
    [],
{% endif %}
  )
{% if entry.summary %}
  #v(px(10))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[#text(weight: 600, fill: rgb("#334155"))[Project:] {{ entry.summary }}]
  ]
{% endif %}
  #v(px(10))
{% if (entry.single_column is defined or (entry.project_management is not defined and entry.technical is not defined)) and entry.highlights %}
  #grid(columns: (1fr, 1fr), column-gutter: px(20), row-gutter: px(4),
{% for item in entry.highlights %}
    text(size: px(12), fill: body-color)[• {{ item }}],
{% endfor %}
  )
{% else %}
  #grid(
    columns: (1fr, 1fr),
    column-gutter: px(20),
    align: top,
    [
{% if entry.project_management is defined %}
      #text(size: px(10), weight: 700, fill: muted2, tracking: px(1))[#upper[{{ entry.project_management_title if entry.project_management_title is defined else "Project Management" }}]]
      #v(px(5))
      #line(length: 100%, stroke: px(1) + border-soft)
      #v(px(5))
      #set text(size: px(12), fill: body-color)
{% for item in entry.project_management %}
      - {{ item }}
{% endfor %}
{% endif %}
    ],
    [
{% if entry.technical is defined %}
      #text(size: px(10), weight: 700, fill: muted2, tracking: px(1))[#upper[Technical]]
      #v(px(5))
      #line(length: 100%, stroke: px(1) + border-soft)
      #v(px(5))
      #set text(size: px(12), fill: body-color)
{% for item in entry.technical %}
      - {{ item }}
{% endfor %}
{% endif %}
    ],
  )
{% endif %}
{% if entry.stack is defined %}
  #v(px(10))
  #text(size: px(11.5), fill: muted)[#text(weight: 600, fill: rgb("#1e293b"))[Stack:] {{ entry.stack }}]
{% endif %}
]
{% endfor %}
{% endif %}

{% for section in cv.rendercv_sections %}
{% if section.title not in rendered_section_titles %}
#main-title("{{ section.title }}", none)
{% for entry in section.entries %}
{% set entry_title = entry|entry_title %}
{% set details = entry|entry_details %}
{% set highlights = entry|entry_highlights %}
{% if entry is string %}
#text(size: px(13), fill: body-color)[{{ entry }}]
#v(px(6))
{% else %}
{% set date_value = entry.date_string if (entry.date_string is defined and entry.date_string) else (entry.date if (entry.date is defined and entry.date) else none) %}
#block(breakable: false, below: px(22), stroke: (bottom: px(1) + border-soft), inset: (bottom: px(22)))[
{% if entry_title %}
  #grid(columns: (1fr, auto), column-gutter: px(12), align: (left, right + top),
    text(size: px(15), weight: 700, fill: nm)[{{ entry_title }}],
{% if date_value %}
    date-pill[{{ date_value }}],
{% else %}
    [],
{% endif %}
  )
{% endif %}
{% if details %}
  #v(px(4))
  #text(size: px(12), fill: muted2, style: "italic")[{{ details|join(" · ") }}]
{% endif %}
{% if entry.summary is defined and entry.summary %}
  #v(px(8))
  #block(width: 100%, fill: card, inset: (x: px(12), y: px(8)), radius: (top-right: px(4), bottom-right: px(4)), stroke: (left: px(2) + border))[
    #text(size: px(12), fill: muted)[{{ entry.summary }}]
  ]
{% endif %}
{% if highlights %}
  #v(px(8))
  #set text(size: px(12), fill: body-color)
{% for item in highlights %}
  - {{ item }}
{% endfor %}
{% endif %}
]
{% endif %}
{% endfor %}
{% endif %}
{% endfor %}
