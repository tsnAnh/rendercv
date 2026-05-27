import pathlib
import tempfile

from rendercv.renderer.browser_pdf import (
    create_browser_rendering_html,
    generate_browser_pdf,
    generate_browser_png,
    is_browser_rendered_theme,
)
from rendercv.renderer.html import generate_html
from rendercv.renderer.markdown import generate_markdown
from rendercv.renderer.pdf_png import generate_pdf, generate_png
from rendercv.renderer.typst import generate_typst
from rendercv.schema.models.rendercv_model import RenderCVModel

from .progress_panel import ProgressPanel
from .run_timing import timed_step


def render_outputs(rendercv_model: RenderCVModel, progress: ProgressPanel) -> None:
    """Generate all requested output files for a RenderCV model.

    Why:
        Khaitranquang keeps Typst source output but uses browser HTML for PDF
        and PNG. Keeping that branch here prevents the command entry workflow
        from absorbing renderer-specific sequencing.
    """
    if is_browser_rendered_theme(rendercv_model):
        render_browser_theme_outputs(rendercv_model, progress)
        return

    render_typst_theme_outputs(rendercv_model, progress)


def render_typst_theme_outputs(
    rendercv_model: RenderCVModel, progress: ProgressPanel
) -> None:
    """Generate outputs for themes that use Typst for PDF and PNG."""
    typst_path = timed_step(
        "Generated Typst",
        progress,
        generate_typst,
        rendercv_model,
    )
    timed_step(
        "Generated PDF",
        progress,
        generate_pdf,
        rendercv_model,
        typst_path,
    )
    timed_step(
        "Generated PNG",
        progress,
        generate_png,
        rendercv_model,
        typst_path,
    )
    markdown_path = timed_step(
        "Generated Markdown",
        progress,
        generate_markdown,
        rendercv_model,
    )
    timed_step(
        "Generated HTML",
        progress,
        generate_html,
        rendercv_model,
        markdown_path,
    )


def render_browser_theme_outputs(
    rendercv_model: RenderCVModel, progress: ProgressPanel
) -> None:
    """Generate outputs for themes that use Chromium for PDF and PNG."""
    timed_step(
        "Generated Typst",
        progress,
        generate_typst,
        rendercv_model,
    )
    markdown_path = timed_step(
        "Generated Markdown",
        progress,
        generate_markdown,
        rendercv_model,
    )
    timed_step(
        "Generated HTML",
        progress,
        generate_html,
        rendercv_model,
        markdown_path,
    )

    if not should_create_browser_html(rendercv_model):
        return

    with tempfile.TemporaryDirectory(prefix="rendercv-khaitranquang-html-") as temp:
        html_path = create_browser_rendering_html(rendercv_model, pathlib.Path(temp))
        pdf_path = timed_step(
            "Generated PDF",
            progress,
            generate_browser_pdf,
            rendercv_model,
            html_path,
        )
        timed_step(
            "Generated PNG",
            progress,
            generate_browser_png,
            rendercv_model,
            html_path,
            pdf_path,
        )


def should_create_browser_html(rendercv_model: RenderCVModel) -> bool:
    """Return whether browser PDF/PNG generation needs transient HTML."""
    render_command = rendercv_model.settings.render_command
    return not (
        render_command.dont_generate_typst
        or (render_command.dont_generate_pdf and render_command.dont_generate_png)
    )
