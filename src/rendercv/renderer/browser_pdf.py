import importlib
import pathlib
import re
import sys
import tempfile
from collections.abc import Callable
from types import ModuleType

from rendercv.exception import RenderCVInternalError, RenderCVUserError
from rendercv.schema.models.rendercv_model import RenderCVModel

from .ats_clean import prepare_ats_clean_model
from .browser_assets import (
    build_local_font_face_css,
    copy_browser_fonts,
    copy_browser_photo,
)
from .path_resolver import resolve_rendercv_file_path
from .templater.templater import render_full_template, render_html

google_fonts_link_pattern = re.compile(
    r'\s*<link\s+href="https://fonts\.googleapis\.com/[^"]+"\s+rel="stylesheet">\n?'
)

cv_style_browser_themes = {
    "executive-rail",
    "monochrome-editorial",
    "engineering-grid",
    "blueprint-compact",
    "teal-systems",
    "premium-paper",
    "creative-ink",
    "ink-wash-graphite",
    "linear-narrative",
    "kami-paper",
    "architect-mono",
    "linear-sidebar",
    "kami-sidebar",
    "architect-sidebar",
}

browser_rendered_themes = {"khaitranquang", *cv_style_browser_themes}


def is_browser_rendered_theme(rendercv_model: RenderCVModel) -> bool:
    """Return whether PDF/PNG should be rendered through Chromium.

    Why:
        HTML-first built-in themes should use the browser print engine. All
        other themes remain on Typst.
    """
    return rendercv_model.design.theme in browser_rendered_themes


def create_browser_rendering_html(
    rendercv_model: RenderCVModel, output_dir: pathlib.Path
) -> pathlib.Path:
    """Create transient HTML with local assets for browser PDF/PNG rendering.

    Why:
        The public HTML output may use web fonts, but browser-rendered PDF/PNG
        needs deterministic local assets and must work without Google Fonts.
    """
    rendercv_model = prepare_ats_clean_model(rendercv_model)
    output_dir.mkdir(parents=True, exist_ok=True)
    markdown = render_full_template(rendercv_model, "markdown")
    html = render_html(rendercv_model, markdown)
    if rendercv_model.design.theme == "khaitranquang":
        html = google_fonts_link_pattern.sub("\n", html)
        html = html.replace("<style>", f"<style>\n{build_local_font_face_css()}\n", 1)
        copy_browser_fonts(output_dir)

    if not rendercv_model.settings.render_command.ats_clean:
        copy_browser_photo(rendercv_model, output_dir)

    html_path = output_dir / f"{rendercv_model.design.theme}-browser.html"
    html_path.write_text(html, encoding="utf-8")
    return html_path


def generate_browser_pdf(
    rendercv_model: RenderCVModel, html_path: pathlib.Path
) -> pathlib.Path | None:
    """Generate an HTML-first theme PDF from staged HTML with Chromium."""
    if (
        rendercv_model.settings.render_command.dont_generate_typst
        or rendercv_model.settings.render_command.dont_generate_pdf
    ):
        return None

    pdf_path = resolve_rendercv_file_path(
        rendercv_model, rendercv_model.settings.render_command.pdf_path
    )
    render_html_to_pdf(html_path, pdf_path)
    return pdf_path


def generate_browser_png(
    rendercv_model: RenderCVModel,
    html_path: pathlib.Path,
    pdf_path: pathlib.Path | None,
) -> list[pathlib.Path] | None:
    """Generate one PNG per browser-rendered PDF page."""
    if (
        rendercv_model.settings.render_command.dont_generate_typst
        or rendercv_model.settings.render_command.dont_generate_png
    ):
        return None

    if pdf_path is None:
        with tempfile.TemporaryDirectory(prefix="rendercv-browser-pdf-") as temp:
            transient_pdf_path = pathlib.Path(temp) / "browser-rendered.pdf"
            render_html_to_pdf(html_path, transient_pdf_path)
            return rasterize_pdf_to_png_files(rendercv_model, transient_pdf_path)

    return rasterize_pdf_to_png_files(rendercv_model, pdf_path)


def render_html_to_pdf(html_path: pathlib.Path, pdf_path: pathlib.Path) -> None:
    """Render an HTML file to PDF using Playwright Chromium."""
    playwright_error, sync_playwright = import_playwright()

    try:
        with sync_playwright() as playwright:
            browser = playwright.chromium.launch()
            try:
                page = browser.new_page()
                page.goto(html_path.as_uri(), wait_until="networkidle")
                page.emulate_media(media="print")
                page.evaluate("() => document.fonts.ready")
                page.pdf(
                    path=str(pdf_path),
                    print_background=True,
                    prefer_css_page_size=True,
                )
            finally:
                browser.close()
    except playwright_error as e:
        if "Executable doesn't exist" in str(e) or "playwright install" in str(e):
            raise RenderCVUserError(message=missing_chromium_message()) from e
        raise


def import_playwright() -> tuple[type[Exception], Callable]:
    """Import Playwright lazily so missing extras produce a user-facing error."""
    try:
        playwright_module = importlib.import_module("playwright.sync_api")
    except ImportError as e:
        raise RenderCVUserError(
            message=(
                "This HTML-first theme requires Playwright for PDF/PNG output. "
                "Install RenderCV with `rendercv[full]` and run "
                "`python -m playwright install chromium`."
            )
        ) from e

    return playwright_module.Error, playwright_module.sync_playwright


def missing_chromium_message() -> str:
    """Return setup guidance for a missing Playwright Chromium binary."""
    message = (
        "Chromium is not installed for Playwright. Run "
        "`python -m playwright install chromium` and render again."
    )
    if getattr(sys, "frozen", False):
        message += (
            " Standalone executables do not bundle Chromium; use the Docker image "
            "or a Python installation with `rendercv[full]` for HTML-first theme "
            "PDF/PNG output."
        )
    return message


def rasterize_pdf_to_png_files(
    rendercv_model: RenderCVModel, pdf_path: pathlib.Path
) -> list[pathlib.Path] | None:
    """Rasterize a PDF into RenderCV's numbered PNG output files."""
    pymupdf = import_pymupdf()

    png_path = resolve_rendercv_file_path(
        rendercv_model, rendercv_model.settings.render_command.png_path
    )
    for existing_png_file in png_path.parent.glob(f"{png_path.stem}_*.png"):
        if existing_png_file.is_file():
            existing_png_file.unlink()

    png_files: list[pathlib.Path] = []
    document = pymupdf.open(pdf_path)
    for page_number, page in enumerate(document, start=1):
        pixmap = page.get_pixmap(matrix=pymupdf.Matrix(2, 2), alpha=False)
        output_path = png_path.parent / f"{png_path.stem}_{page_number}.png"
        pixmap.save(output_path)
        png_files.append(output_path)
    document.close()

    if not png_files:
        raise RenderCVInternalError("Browser-rendered PDF did not contain pages")
    return png_files


def import_pymupdf() -> ModuleType:
    """Import PyMuPDF lazily so missing extras produce a user-facing error."""
    try:
        return importlib.import_module("pymupdf")
    except ImportError as e:
        raise RenderCVUserError(
            message=(
                "HTML-first themes require PyMuPDF for PNG output. "
                "Install RenderCV with `rendercv[full]`."
            )
        ) from e
