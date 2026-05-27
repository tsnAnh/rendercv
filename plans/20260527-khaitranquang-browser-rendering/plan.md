---
title: "Khaitranquang Browser Rendering Checklist"
description: "Concise repo-specific checklist for switching Khaitranquang PDF/PNG generation to a browser-backed path without changing CLI semantics."
status: pending
priority: P2
effort: 4h
branch: main
tags: [planning, rendering, khaitranquang]
created: 2026-05-27
---

# Goal

Implement browser-backed PDF/PNG generation for the `khaitranquang` theme only, while keeping `rendercv render` flags, output paths, file naming, and skip flags unchanged.

# CLI Contract To Preserve

- Keep `rendercv render CV.yaml` as the entrypoint.
- Keep existing flags and settings keys: `--pdf-path`, `--png-path`, `--dont-generate-pdf`, `--dont-generate-png`, `--dont-generate-typst`, `--dont-generate-html`, `--dont-generate-markdown`.
- Keep current output semantics:
  - PDF stays a single file.
  - PNG stays page-suffixed files like `*_1.png`, `*_2.png`.
  - `-notyp` still disables PDF and PNG.

# File Checklist

## Source: likely modify

- `src/rendercv/cli/render_command/run_rendercv.py`
  - Route Khaitranquang PDF/PNG generation through the new browser path, but keep progress messages and step order stable.
- `src/rendercv/renderer/pdf_png.py`
  - Main backend switch point. Keep current Typst path for all other themes.
- `src/rendercv/renderer/html.py`
  - Confirm HTML generation can produce the exact input artifact the browser renderer needs.
- `src/rendercv/renderer/templater/templater.py`
  - Confirm `khaitranquang/Full.html` gets rendered with all required content and assets.
- `src/rendercv/renderer/templater/templates/khaitranquang/Full.html`
  - Browser print/export CSS or JS tweaks only if PDF/PNG fidelity requires it.
- `scripts/update_examples.py`
  - Regenerate Khaitranquang example PDF/PNG with the new backend.

## Source: inspect first, modify only if forced

- `src/rendercv/cli/render_command/render_command.py`
  - Only touch if help text or flag wiring must change. Default expectation: no change.
- `src/rendercv/schema/models/settings/render_command.py`
  - Only touch if the provided plan introduces a new user-facing setting. Default expectation: no change.
- `src/rendercv/schema/rendercv_model_builder.py`
  - Only touch if any new setting must flow from CLI/YAML into rendering. Default expectation: no change.

## Tests

- `tests/renderer/test_pdf_png.py`
- `tests/renderer/test_html.py`
- `tests/cli/render_command/test_render_command.py`
- `tests/cli/render_command/test_run_rendercv.py`
- `tests/cli/render_command/test_progress_panel.py`
- `tests/test_offline_whl.py`
- `tests/renderer/testdata/test_pdf_png/khaitranquang_full.pdf`
- `tests/renderer/testdata/test_pdf_png/khaitranquang_minimal_1.png`

## Docs / generated assets

- `docs/user_guide/cli_reference.md`
- `docs/user_guide/yaml_input_structure/settings.md`
- `docs/changelog.md`
- `README.md`
- `docs/index.md`
- `docs/assets/images/examples/khaitranquang.png`
- `examples/John_Doe_KhaitranquangTheme_CV.pdf`

## Packaging / runtime

- `pyproject.toml`
- `Dockerfile`

# Data Flow

`CV.yaml` -> `build_rendercv_dictionary_and_model` -> theme HTML (`khaitranquang/Full.html`) -> headless browser render -> PDF + page PNGs -> same output paths now exposed by CLI/tests/examples.

# Phases And Dependencies

1. Lock backend choice and routing in `run_rendercv.py` + `pdf_png.py`.
   Blockers: browser library choice, local/offline install story.
2. Update renderer/template behavior only if Khaitranquang HTML needs print fixes.
   Blocker: phase 1.
3. Update tests, reference files, examples.
   Blocker: phases 1-2.
4. Update packaging/docs only if runtime surface changed.
   Blocker: phase 1.

# Risks

- High: browser dependency breaks offline wheel install or Docker image.
  - Mitigation: update `pyproject.toml`, `Dockerfile`, and `tests/test_offline_whl.py` together.
- High: PDF/PNG filenames or page counts drift from current CLI contract.
  - Mitigation: keep path resolution in `pdf_png.py`; assert suffix numbering in CLI/renderer tests.
- Medium: browser print CSS diverges from current Khaitranquang HTML preview.
  - Mitigation: cover `tests/renderer/test_html.py` and refresh only Khaitranquang reference assets.

# Backwards Compatibility

- No new command required.
- No existing flag removed or renamed.
- All non-Khaitranquang themes stay on the current Typst PDF/PNG path.
- Rollback path: remove theme-specific routing and return Khaitranquang to Typst backend.

# Verification Commands

```bash
just sync
uv run --frozen --all-extras pytest tests/renderer/test_html.py tests/renderer/test_pdf_png.py -x
uv run --frozen --all-extras pytest tests/cli/render_command/test_render_command.py tests/cli/render_command/test_run_rendercv.py tests/cli/render_command/test_progress_panel.py -x
uv run --frozen --all-extras pytest tests/test_offline_whl.py -x
just update-testdata
just update-examples
just check
just build-docs
```

# Success Criteria

- `rendercv render` CLI semantics unchanged.
- Khaitranquang PDF and PNG are generated via browser path.
- Existing tests pass after targeted reference/example refresh.
- Packaging still supports isolated/offline install if a new runtime dependency is added.

# Unresolved Questions

- The provided browser-rendering plan itself was not present in this workspace. Exact backend choice still needs confirmation if it must be something specific.
