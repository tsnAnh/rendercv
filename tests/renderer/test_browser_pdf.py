import pathlib
from datetime import date as Date
from unittest.mock import call, patch

import pytest
from playwright.sync_api import Error as PlaywrightError
from playwright.sync_api import sync_playwright

from rendercv.exception import RenderCVUserError
from rendercv.renderer.browser_pdf import (
    create_browser_rendering_html,
    cv_style_browser_themes,
    generate_browser_pdf,
    generate_browser_png,
    render_html_to_pdf,
)
from rendercv.schema.models.cv.cv import Cv
from rendercv.schema.models.rendercv_model import RenderCVModel
from rendercv.schema.models.settings.settings import Settings


def test_create_browser_rendering_html_stages_local_assets(
    tmp_path: pathlib.Path,
    full_rendercv_model: RenderCVModel,
):
    full_rendercv_model.settings.pdf_title = "NAME - Browser CV YEAR"
    model = RenderCVModel(
        cv=full_rendercv_model.cv,
        design={"theme": "khaitranquang"},
        locale=full_rendercv_model.locale,
        settings=full_rendercv_model.settings,
    )

    html_path = create_browser_rendering_html(model, tmp_path)
    html = html_path.read_text(encoding="utf-8")

    assert "fonts.googleapis.com" not in html
    assert "<title>John Doe - Browser CV 2025</title>" in html
    assert "@font-face" in html
    assert "fonts/Inter/Inter-Regular.ttf" in html
    assert "fonts/MaterialSymbols/MaterialSymbolsRounded-Filled.ttf" in html
    assert "font-display: block" in html
    assert (tmp_path / "fonts" / "Inter" / "Inter-Regular.ttf").exists()
    assert (
        tmp_path / "fonts" / "MaterialSymbols" / "MaterialSymbolsRounded-Filled.ttf"
    ).exists()
    assert isinstance(model.cv.photo, pathlib.Path)
    assert (tmp_path / model.cv.photo.name).exists()


def test_create_cv_style_browser_rendering_html_keeps_source_equivalent_head(
    tmp_path: pathlib.Path,
    minimal_rendercv_model: RenderCVModel,
):
    theme = sorted(cv_style_browser_themes)[0]
    cv = Cv(
        name="Hanh Tran",
        headline="AI-Driven Full-Stack Developer / AI Engineer",
        location="Da Nang, Vietnam",
        email="tnnganhanh@gmail.com",
    )
    model = RenderCVModel(
        cv=cv,
        design={"theme": theme},
        locale=minimal_rendercv_model.locale,
        settings=minimal_rendercv_model.settings,
    )

    html_path = create_browser_rendering_html(model, tmp_path)
    html = html_path.read_text(encoding="utf-8")

    assert html == pathlib.Path("new_templates", f"{theme}.html").read_text(
        encoding="utf-8"
    )
    assert "@font-face" not in html
    assert not (tmp_path / "fonts").exists()


def test_create_cv_style_browser_rendering_html_uses_user_photo(
    tmp_path: pathlib.Path,
    full_rendercv_model: RenderCVModel,
):
    theme = sorted(cv_style_browser_themes)[0]
    model = RenderCVModel(
        cv=full_rendercv_model.cv,
        design={"theme": theme},
        locale=full_rendercv_model.locale,
        settings=full_rendercv_model.settings,
    )

    html_path = create_browser_rendering_html(model, tmp_path)
    html = html_path.read_text(encoding="utf-8")

    assert isinstance(model.cv.photo, pathlib.Path)
    assert model.cv.photo.name in html
    assert "mpmmge6e-IMG_3238-_1_.jpg" not in html
    assert "ui-avatars.com" not in html
    assert (tmp_path / model.cv.photo.name).exists()


def test_render_html_to_pdf_reports_missing_chromium(
    tmp_path: pathlib.Path,
):
    html_path = tmp_path / "cv.html"
    html_path.write_text("<html><body>CV</body></html>", encoding="utf-8")

    with patch("playwright.sync_api.sync_playwright") as sync_playwright:
        playwright = sync_playwright.return_value.__enter__.return_value
        playwright.chromium.launch.side_effect = PlaywrightError(
            "Executable doesn't exist at /path/to/chromium. "
            "Please run `playwright install`."
        )

        with pytest.raises(RenderCVUserError) as exc_info:
            render_html_to_pdf(html_path, tmp_path / "cv.pdf")

    assert "python -m playwright install chromium" in str(exc_info.value.message)


def test_browser_rendering_html_renders_material_symbol_glyphs(
    tmp_path: pathlib.Path,
    full_rendercv_model: RenderCVModel,
):
    model = RenderCVModel(
        cv=full_rendercv_model.cv,
        design={"theme": "khaitranquang"},
        locale=full_rendercv_model.locale,
        settings=full_rendercv_model.settings,
    )
    html_path = create_browser_rendering_html(model, tmp_path)

    with sync_playwright() as playwright:
        browser = playwright.chromium.launch()
        try:
            page = browser.new_page()
            page.goto(html_path.as_uri(), wait_until="networkidle")
            page.evaluate("() => document.fonts.ready")
            icon = page.locator(".msi").first
            icon_width = icon.evaluate("element => element.getBoundingClientRect().width")
            font_family = icon.evaluate("element => getComputedStyle(element).fontFamily")
        finally:
            browser.close()

    assert "Material Symbols Rounded" in font_family
    assert icon_width < 20


def test_render_html_to_pdf_waits_for_fonts_before_printing(
    tmp_path: pathlib.Path,
):
    html_path = tmp_path / "cv.html"
    html_path.write_text("<html><body>CV</body></html>", encoding="utf-8")

    with patch("playwright.sync_api.sync_playwright") as sync_playwright:
        playwright = sync_playwright.return_value.__enter__.return_value
        browser = playwright.chromium.launch.return_value
        page = browser.new_page.return_value

        render_html_to_pdf(html_path, tmp_path / "cv.pdf")

    page.evaluate.assert_called_once_with("() => document.fonts.ready")
    page.pdf.assert_called_once()
    font_wait_call_index = page.mock_calls.index(
        call.evaluate("() => document.fonts.ready")
    )
    pdf_call_index = next(
        index for index, mock_call in enumerate(page.mock_calls) if mock_call[0] == "pdf"
    )
    assert font_wait_call_index < pdf_call_index


def test_render_html_to_pdf_closes_browser_when_pdf_fails(
    tmp_path: pathlib.Path,
):
    html_path = tmp_path / "cv.html"
    html_path.write_text("<html><body>CV</body></html>", encoding="utf-8")

    with patch("playwright.sync_api.sync_playwright") as sync_playwright:
        playwright = sync_playwright.return_value.__enter__.return_value
        browser = playwright.chromium.launch.return_value
        page = browser.new_page.return_value
        page.pdf.side_effect = PlaywrightError("PDF render failed")

        with pytest.raises(PlaywrightError, match="PDF render failed"):
            render_html_to_pdf(html_path, tmp_path / "cv.pdf")

    browser.close.assert_called_once()


def test_generate_khaitranquang_browser_pdf_and_png_semantics(
    tmp_path: pathlib.Path,
):
    pymupdf = pytest.importorskip("pymupdf")
    cv = Cv(
        name="John Doe",
        sections={
            "Welcome to RenderCV": [
                "Software Engineer at Company X, 2020-2023",
            ]
        },
    )
    model = RenderCVModel(
        cv=cv,
        design={"theme": "khaitranquang"},
        settings=Settings(
            current_date=Date(2025, 11, 30),
            pdf_title="NAME - Browser Resume YEAR",
        ),
    )
    model.settings.render_command.pdf_path = tmp_path / "John_Doe_CV.pdf"
    model.settings.render_command.png_path = tmp_path / "John_Doe_CV.png"

    html_path = create_browser_rendering_html(model, tmp_path / "browser")
    pdf_path = generate_browser_pdf(model, html_path)
    png_paths = generate_browser_png(model, html_path, pdf_path)

    assert pdf_path is not None
    assert pdf_path.read_bytes().startswith(b"%PDF-")

    document = pymupdf.open(pdf_path)
    assert document.metadata["title"] == "John Doe - Browser Resume 2025"
    text = "\n".join(page.get_text() for page in document)
    assert "JOHN DOE" in text
    assert "Software Engineer at Company X" in text

    assert png_paths is not None
    assert document.page_count == len(png_paths)
    for png_path in png_paths:
        assert png_path.name.startswith("John_Doe_CV_")
        assert png_path.stat().st_size > 0
    document.close()


def test_generate_cv_style_browser_pdf_contains_user_content(
    tmp_path: pathlib.Path,
):
    pymupdf = pytest.importorskip("pymupdf")
    cv = Cv(
        name="Jane Roe",
        sections={
            "Experience": [
                "Principal Engineer at Example Labs, 2024-present",
            ]
        },
    )
    model = RenderCVModel(
        cv=cv,
        design={"theme": "executive-rail"},
        settings=Settings(current_date=Date(2025, 11, 30)),
    )
    model.settings.render_command.pdf_path = tmp_path / "Jane_Roe_CV.pdf"

    html_path = create_browser_rendering_html(model, tmp_path / "browser")
    pdf_path = generate_browser_pdf(model, html_path)

    assert pdf_path is not None
    document = pymupdf.open(pdf_path)
    text = "\n".join(page.get_text() for page in document)
    document.close()

    assert "Jane Roe" in text
    assert "Principal Engineer at Example Labs" in text
    assert "Hanh Tran" not in text
    assert "carrotcake AI" not in text


def test_generate_khaitranquang_png_when_pdf_output_is_disabled(
    tmp_path: pathlib.Path,
):
    cv = Cv(
        name="John Doe",
        sections={"Welcome to RenderCV": ["Software Engineer at Company X"]},
    )
    model = RenderCVModel(
        cv=cv,
        design={"theme": "khaitranquang"},
        settings=Settings(current_date=Date(2025, 11, 30)),
    )
    model.settings.render_command.dont_generate_pdf = True
    model.settings.render_command.pdf_path = tmp_path / "John_Doe_CV.pdf"
    model.settings.render_command.png_path = tmp_path / "John_Doe_CV.png"

    html_path = create_browser_rendering_html(model, tmp_path / "browser")
    png_paths = generate_browser_png(model, html_path, pdf_path=None)

    assert not (tmp_path / "John_Doe_CV.pdf").exists()
    assert png_paths is not None
    assert len(png_paths) >= 1
    for png_path in png_paths:
        assert png_path.stat().st_size > 0
