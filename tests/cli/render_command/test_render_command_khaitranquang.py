import os
import pathlib
from unittest.mock import MagicMock

import pytest

from rendercv.cli.new_command.new_command import cli_command_new
from rendercv.cli.render_command import render_outputs
from rendercv.cli.render_command.render_command import cli_command_render
from rendercv.renderer.path_resolver import resolve_rendercv_file_path


@pytest.fixture
def default_arguments():
    context = MagicMock()
    context.args = []
    return {
        "design": None,
        "locale": None,
        "settings": None,
        "typst_path": None,
        "pdf_path": None,
        "markdown_path": None,
        "html_path": None,
        "png_path": None,
        "dont_generate_markdown": False,
        "dont_generate_html": False,
        "dont_generate_typst": False,
        "dont_generate_pdf": False,
        "dont_generate_png": False,
        "ats_clean": None,
        "watch": False,
        "quiet": False,
        "yaml_field_override": None,
        "extra_data_model_override_arguments": context,
    }


@pytest.fixture
def khaitranquang_input_file(tmp_path):
    os.chdir(tmp_path)
    cli_command_new(
        full_name="John Doe",
        theme="khaitranquang",
        create_typst_templates=False,
        create_markdown_templates=False,
    )
    return tmp_path / "John_Doe_CV.yaml"


@pytest.fixture
def fake_khaitranquang_browser_renderer(monkeypatch):
    def create_browser_rendering_html(_, output_dir: pathlib.Path) -> pathlib.Path:
        html_path = output_dir / "browser.html"
        html_path.write_text("<html></html>", encoding="utf-8")
        return html_path

    def generate_browser_pdf(model, _) -> pathlib.Path | None:
        render_command = model.settings.render_command
        if render_command.dont_generate_typst or render_command.dont_generate_pdf:
            return None
        pdf_path = resolve_rendercv_file_path(model, render_command.pdf_path)
        pdf_path.write_bytes(b"%PDF-fake")
        return pdf_path

    def generate_browser_png(model, _, __) -> list[pathlib.Path] | None:
        render_command = model.settings.render_command
        if render_command.dont_generate_typst or render_command.dont_generate_png:
            return None
        png_path = resolve_rendercv_file_path(model, render_command.png_path)
        for existing_png in png_path.parent.glob(f"{png_path.stem}_*.png"):
            existing_png.unlink()
        output_path = png_path.parent / f"{png_path.stem}_1.png"
        output_path.write_bytes(b"\x89PNG\r\n\x1a\n")
        return [output_path]

    monkeypatch.setattr(
        render_outputs,
        "create_browser_rendering_html",
        create_browser_rendering_html,
    )
    monkeypatch.setattr(render_outputs, "generate_browser_pdf", generate_browser_pdf)
    monkeypatch.setattr(render_outputs, "generate_browser_png", generate_browser_png)


@pytest.mark.parametrize(
    ("flags", "expected_files", "missing_files"),
    [
        (
            {},
            [
                "John_Doe_CV.typ",
                "John_Doe_CV.pdf",
                "John_Doe_CV_1.png",
                "John_Doe_CV.md",
                "John_Doe_CV.html",
            ],
            [],
        ),
        (
            {"dont_generate_pdf": True},
            [
                "John_Doe_CV.typ",
                "John_Doe_CV_1.png",
                "John_Doe_CV.md",
                "John_Doe_CV.html",
            ],
            ["John_Doe_CV.pdf"],
        ),
        (
            {"dont_generate_png": True},
            [
                "John_Doe_CV.typ",
                "John_Doe_CV.pdf",
                "John_Doe_CV.md",
                "John_Doe_CV.html",
            ],
            ["John_Doe_CV_1.png"],
        ),
        (
            {"dont_generate_markdown": True},
            ["John_Doe_CV.typ", "John_Doe_CV.pdf", "John_Doe_CV_1.png"],
            ["John_Doe_CV.md", "John_Doe_CV.html"],
        ),
        (
            {"dont_generate_html": True},
            [
                "John_Doe_CV.typ",
                "John_Doe_CV.pdf",
                "John_Doe_CV_1.png",
                "John_Doe_CV.md",
            ],
            ["John_Doe_CV.html"],
        ),
        (
            {"dont_generate_typst": True},
            ["John_Doe_CV.md", "John_Doe_CV.html"],
            ["John_Doe_CV.typ", "John_Doe_CV.pdf", "John_Doe_CV_1.png"],
        ),
    ],
)
def test_khaitranquang_output_file_generation(
    khaitranquang_input_file,
    default_arguments,
    fake_khaitranquang_browser_renderer,
    flags,
    expected_files,
    missing_files,
):
    assert fake_khaitranquang_browser_renderer is None
    cli_command_render(
        input_file_name=khaitranquang_input_file,
        **{**default_arguments, **flags},
    )

    rendercv_output = khaitranquang_input_file.parent / "rendercv_output"
    for file in expected_files:
        assert (rendercv_output / file).exists()
    for file in missing_files:
        assert not (rendercv_output / file).exists()


def test_khaitranquang_uses_custom_browser_output_paths(
    khaitranquang_input_file,
    default_arguments,
    fake_khaitranquang_browser_renderer,
):
    assert fake_khaitranquang_browser_renderer is None
    custom_paths = {
        "pdf_path": khaitranquang_input_file.parent / "custom.pdf",
        "png_path": khaitranquang_input_file.parent / "custom.png",
    }

    cli_command_render(
        input_file_name=khaitranquang_input_file,
        **{**default_arguments, **custom_paths},
    )

    assert (khaitranquang_input_file.parent / "custom.pdf").exists()
    assert (khaitranquang_input_file.parent / "custom_1.png").exists()
