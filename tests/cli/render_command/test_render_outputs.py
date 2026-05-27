import pathlib
from datetime import date as Date
from unittest.mock import patch

from rendercv.cli.render_command.progress_panel import ProgressPanel
from rendercv.cli.render_command.render_outputs import render_outputs
from rendercv.renderer.browser_pdf import cv_style_browser_themes
from rendercv.schema.models.cv.cv import Cv
from rendercv.schema.models.rendercv_model import RenderCVModel
from rendercv.schema.models.settings.settings import Settings


def create_minimal_model() -> RenderCVModel:
    cv = Cv(
        name="John Doe",
        sections={
            "Experience": [
                "Software Engineer at Company X, 2020-2023",
            ]
        },
    )
    return RenderCVModel(cv=cv, settings=Settings(current_date=Date(2025, 11, 30)))


def test_khaitranquang_pdf_uses_browser_renderer_not_typst_compiler(
    tmp_path: pathlib.Path,
):
    minimal_rendercv_model = create_minimal_model()
    model = RenderCVModel(
        cv=minimal_rendercv_model.cv,
        design={"theme": "khaitranquang"},
        locale=minimal_rendercv_model.locale,
        settings=minimal_rendercv_model.settings,
    )
    html_path = tmp_path / "browser.html"
    html_path.write_text("<html></html>", encoding="utf-8")
    pdf_path = tmp_path / "cv.pdf"
    png_path = tmp_path / "cv_1.png"

    with (
        patch(
            "rendercv.cli.render_command.render_outputs.generate_typst",
            return_value=tmp_path / "cv.typ",
        ),
        patch(
            "rendercv.cli.render_command.render_outputs.generate_markdown",
            return_value=tmp_path / "cv.md",
        ),
        patch("rendercv.cli.render_command.render_outputs.generate_html"),
        patch(
            "rendercv.cli.render_command.render_outputs.create_browser_rendering_html",
            return_value=html_path,
        ) as create_browser_html,
        patch(
            "rendercv.cli.render_command.render_outputs.generate_browser_pdf",
            return_value=pdf_path,
        ) as generate_browser_pdf,
        patch(
            "rendercv.cli.render_command.render_outputs.generate_browser_png",
            return_value=[png_path],
        ) as generate_browser_png,
        patch(
            "rendercv.cli.render_command.render_outputs.generate_pdf"
        ) as generate_pdf,
        patch(
            "rendercv.cli.render_command.render_outputs.generate_png"
        ) as generate_png,
        patch("rendercv.renderer.pdf_png.typst.Compiler") as typst_compiler,
    ):
        render_outputs(model, ProgressPanel(quiet=True))

    create_browser_html.assert_called_once()
    generate_browser_pdf.assert_called_once_with(model, html_path)
    generate_browser_png.assert_called_once_with(model, html_path, pdf_path)
    generate_pdf.assert_not_called()
    generate_png.assert_not_called()
    typst_compiler.assert_not_called()


def test_cv_style_pdf_uses_browser_renderer_not_typst_compiler(
    tmp_path: pathlib.Path,
):
    minimal_rendercv_model = create_minimal_model()
    theme = sorted(cv_style_browser_themes)[0]
    model = RenderCVModel(
        cv=minimal_rendercv_model.cv,
        design={"theme": theme},
        locale=minimal_rendercv_model.locale,
        settings=minimal_rendercv_model.settings,
    )
    html_path = tmp_path / "browser.html"
    html_path.write_text("<html></html>", encoding="utf-8")
    pdf_path = tmp_path / "cv.pdf"
    png_path = tmp_path / "cv_1.png"

    with (
        patch(
            "rendercv.cli.render_command.render_outputs.generate_typst",
            return_value=tmp_path / "cv.typ",
        ),
        patch(
            "rendercv.cli.render_command.render_outputs.generate_markdown",
            return_value=tmp_path / "cv.md",
        ),
        patch("rendercv.cli.render_command.render_outputs.generate_html"),
        patch(
            "rendercv.cli.render_command.render_outputs.create_browser_rendering_html",
            return_value=html_path,
        ) as create_browser_html,
        patch(
            "rendercv.cli.render_command.render_outputs.generate_browser_pdf",
            return_value=pdf_path,
        ) as generate_browser_pdf,
        patch(
            "rendercv.cli.render_command.render_outputs.generate_browser_png",
            return_value=[png_path],
        ) as generate_browser_png,
        patch(
            "rendercv.cli.render_command.render_outputs.generate_pdf"
        ) as generate_pdf,
        patch(
            "rendercv.cli.render_command.render_outputs.generate_png"
        ) as generate_png,
        patch("rendercv.renderer.pdf_png.typst.Compiler") as typst_compiler,
    ):
        render_outputs(model, ProgressPanel(quiet=True))

    create_browser_html.assert_called_once()
    generate_browser_pdf.assert_called_once_with(model, html_path)
    generate_browser_png.assert_called_once_with(model, html_path, pdf_path)
    generate_pdf.assert_not_called()
    generate_png.assert_not_called()
    typst_compiler.assert_not_called()


def test_khaitranquang_dont_generate_typst_suppresses_browser_pdf_png(
    tmp_path: pathlib.Path,
):
    minimal_rendercv_model = create_minimal_model()
    model = RenderCVModel(
        cv=minimal_rendercv_model.cv,
        design={"theme": "khaitranquang"},
        locale=minimal_rendercv_model.locale,
        settings=minimal_rendercv_model.settings,
    )
    model.settings.render_command.dont_generate_typst = True

    with (
        patch("rendercv.cli.render_command.render_outputs.generate_typst"),
        patch(
            "rendercv.cli.render_command.render_outputs.generate_markdown",
            return_value=tmp_path / "cv.md",
        ),
        patch("rendercv.cli.render_command.render_outputs.generate_html"),
        patch(
            "rendercv.cli.render_command.render_outputs.create_browser_rendering_html"
        ) as create_browser_html,
        patch(
            "rendercv.cli.render_command.render_outputs.generate_browser_pdf"
        ) as generate_browser_pdf,
        patch(
            "rendercv.cli.render_command.render_outputs.generate_browser_png"
        ) as generate_browser_png,
    ):
        render_outputs(model, ProgressPanel(quiet=True))

    create_browser_html.assert_not_called()
    generate_browser_pdf.assert_not_called()
    generate_browser_png.assert_not_called()
