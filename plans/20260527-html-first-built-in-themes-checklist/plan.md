---
title: "HTML-First Built-In Themes Checklist"
description: "Concise repo-specific checklist for turning new_templates/cv-style-*.html into built-in browser-rendered themes."
status: pending
priority: P2
effort: 1-2d
branch: main
tags: [planning, themes, html, browser-rendering]
created: 2026-05-27
---

# Scope

Convert `new_templates/cv-style-*.html` into built-in RenderCV themes without changing CLI flags or output semantics. This plan supersedes the older khaitranquang-only checklist: current routing lives in `src/rendercv/cli/render_command/render_outputs.py` and `src/rendercv/renderer/browser_pdf.py`, not `run_rendercv.py`.

# Data Flow

`CV.yaml` -> `RenderCVModel` -> built-in theme discovery from `src/rendercv/schema/models/design/other_themes/*.yaml` -> theme `Full.html` render -> transient staged HTML with local fonts/photo -> Playwright Chromium PDF -> PyMuPDF PNG pages -> standard output paths from `render_command`.

# Checklist

1. Lock public theme IDs before code.
   - Decide whether to keep raw slugs like `cv-style-01-executive-rail`.
   - Current file stems become public `theme` values, example filenames, docs asset names, and CLI values.

2. Generalize browser-theme routing.
   - Likely change: `src/rendercv/renderer/browser_pdf.py`
   - Likely change: `src/rendercv/cli/render_command/render_outputs.py`
   - Replace khaitranquang-only checks, temp filenames, and error strings with multi-theme browser-theme logic.

3. Add built-in theme definitions.
   - New files likely required: `src/rendercv/schema/models/design/other_themes/<theme-id>.yaml` for each accepted theme.
   - `src/rendercv/schema/models/design/built_in_design.py` should auto-discover them; no code change needed unless naming/metadata strategy changes.
   - `src/rendercv/schema/models/design/design.py` should stay untouched unless browser-rendered status becomes model metadata instead of code-side routing.

4. Convert raw prototypes into data-bound templates.
   - New files likely required: `src/rendercv/renderer/templater/templates/<theme-id>/Full.html`
   - Each `new_templates/*.html` is static HTML with hardcoded content, image names, and inline scripts; it is not a Jinja template today.
   - Only add `Full.j2.md` / `Full.j2.typ` overrides when default Markdown/Typst output is not acceptable for that theme’s section ordering/content.

5. Make browser assets deterministic.
   - Likely change: `src/rendercv/renderer/browser_assets.py`
   - Current staging only bundles `Inter` and `Material Symbols`.
   - New templates reference `Aptos`, `Segoe UI`, `SF Pro Display`, `Sohne`, and `IBM Plex Sans`; byte-stable PDF/PNG needs bundled local fonts or template normalization to bundled fonts.

6. Update tests for multiple browser themes.
   - Likely change: `tests/renderer/test_browser_pdf.py`
   - Likely change: `tests/renderer/test_html.py`
   - Likely change: `tests/renderer/test_pdf_png.py`
   - Likely change: `tests/renderer/test_typst.py`
   - Likely change: `tests/renderer/test_markdown.py`
   - Likely change: `tests/cli/render_command/test_render_outputs.py`
   - Likely change: `tests/cli/render_command/test_render_command_khaitranquang.py`
   - Likely change: `tests/test_generated_files.py`
   - Likely change: `tests/schema/models/design/test_built_in_design.py`
   - Likely change: `tests/schema/test_sample_generator.py`

7. Regenerate committed artifacts.
   - Likely required: `schema.json`
   - Likely required: `examples/John_Doe_<Theme>Theme_CV.yaml`
   - Likely required: `examples/John_Doe_<Theme>Theme_CV.pdf`
   - Likely required: `docs/assets/images/examples/<theme-id>.png`
   - Likely required: `src/rendercv/renderer/rendercv_typst/examples/<theme-id>.typ`
   - Likely required if tests keep reference-byte comparisons: `tests/renderer/testdata/test_typst/<theme-id>_{minimal,full}.typ`
   - Likely required if browser PDF/PNG gets fixture coverage: `tests/renderer/testdata/test_pdf_png/<theme-id>_full.pdf`, `<theme-id>_minimal.pdf`, `<theme-id>_minimal_1.png`

8. Update docs only where current generators do not cover new themes.
   - Likely manual touches: `README.md`, `docs/index.md`, `docs/changelog.md`
   - Inspect-only: `docs/user_guide/cli_reference.md`, `docs/user_guide/yaml_input_structure/design.md`, `docs/docs_templating.py`
   - Likely change only if skill should mention new themes: `scripts/rendercv_skill/generate.py` because `SKILL_THEMES` is hardcoded.

# Test Matrix

- Unit: browser-theme detection/routing, local font CSS injection, staged HTML/photo copy, output-path semantics.
- Integration: render each accepted browser theme to HTML/PDF/PNG from sample models.
- Generated-file validation: schema, example YAMLs, example PDFs/PNGs, typst example snapshots.
- E2E CLI: `rendercv render` with default paths, custom `pdf_path`/`png_path`, and all `dont_generate_*` combinations for at least one browser theme.

# Main Risks / Mitigation

- High: raw prototypes depend on non-bundled system fonts.
  - Mitigation: bundle fonts locally or normalize templates to existing bundled fonts before adding byte-based PDF/PNG fixtures.
- High: prototypes contain hardcoded photo filenames plus remote avatar fallback.
  - Mitigation: replace with Jinja-bound `cv.photo`; remove network fallback for offline deterministic rendering.
- High: `tests/renderer/test_pdf_png.py` excludes only `khaitranquang`.
  - Mitigation: generalize the browser-theme exclusion set before adding new built-in themes.
- Medium: sticky-sidebar JS and `ResizeObserver` create render-time variance.
  - Mitigation: prefer print-safe CSS over runtime JS for PDF output.
- Medium: raw HTML byte-matching against `new_templates/*.html` is unrealistic after Jinja conversion.
  - Mitigation: snapshot rendered outputs, not the source prototype files.

# Backwards Compatibility / Rollback

- Preserve existing CLI flags and file naming.
- Preserve Typst-backed PDF/PNG for non-browser themes.
- Rollback is isolated: remove new theme YAML/template files and shrink the browser-theme allowlist/set.

# Done Means

- New themes appear in `available_themes` and `rendercv new --theme ...`.
- Browser themes render HTML/PDF/PNG through Chromium with local deterministic assets.
- Example/docs/generated artifacts are refreshed and tests pass without special-casing local developer fonts.

# Unresolved Questions

- Final public theme slugs not chosen yet.
- Whether all 14 prototypes should ship, or only the subset that can be made deterministic with bundled fonts and no runtime JS.
