import pathlib

import pytest

from rendercv.renderer.browser_pdf import cv_style_browser_themes
from rendercv.renderer.html import generate_html
from rendercv.renderer.markdown import generate_markdown
from rendercv.schema.models.cv.cv import Cv
from rendercv.schema.models.rendercv_model import RenderCVModel
from rendercv.schema.sample_generator import create_sample_rendercv_pydantic_model


def create_hanh_tran_cv_style_model(
    base_model: RenderCVModel, theme: str
) -> RenderCVModel:
    cv = Cv(
        name="Hanh Tran",
        headline="AI-Driven Full-Stack Developer / AI Engineer",
        location="Da Nang, Vietnam",
        email="tnnganhanh@gmail.com",
    )
    return RenderCVModel(
        cv=cv,
        design={"theme": theme},
        locale=base_model.locale,
        settings=base_model.settings,
    )


@pytest.mark.parametrize("cv_variant", ["minimal", "full"])
def test_generate_html(
    compare_file_with_reference,
    cv_variant: str,
    request: pytest.FixtureRequest,
):
    base_model = request.getfixturevalue(f"{cv_variant}_rendercv_model")

    model = RenderCVModel(
        cv=base_model.cv,
        locale=base_model.locale,
        settings=base_model.settings,
    )

    def generate_file(output_path):
        model.settings.render_command.markdown_path = output_path.with_suffix(".md")
        markdown_path = generate_markdown(model)

        model.settings.render_command.html_path = output_path
        generate_html(model, markdown_path)

    reference_filename = f"{cv_variant}.html"
    assert compare_file_with_reference(generate_file, reference_filename)


def test_generate_html_uses_theme_full_template(tmp_path, minimal_rendercv_model):
    model = RenderCVModel(
        cv=minimal_rendercv_model.cv,
        design={"theme": "khaitranquang"},
        locale=minimal_rendercv_model.locale,
        settings=minimal_rendercv_model.settings,
    )
    model.settings.render_command.markdown_path = tmp_path / "khaitranquang.md"
    markdown_path = generate_markdown(model)

    html_path = tmp_path / "khaitranquang.html"
    model.settings.render_command.html_path = html_path
    generate_html(model, markdown_path)

    html = html_path.read_text(encoding="utf-8")
    assert '<div class="sheet">' in html
    assert ".sheet::before" in html
    assert "Full-height blue stripe via pseudo-element" in html
    assert 'class="side-col"' in html
    assert 'class="side-inner"' in html
    assert 'class="main-col"' in html
    assert 'class="export-btn"' in html
    assert "Export PDF" in html
    assert "Jitter-free Smart Sticky Sidebar" in html
    assert "markdown-body" not in html


def test_generate_html_falls_back_to_default_wrapper(tmp_path, minimal_rendercv_model):
    model = RenderCVModel(
        cv=minimal_rendercv_model.cv,
        locale=minimal_rendercv_model.locale,
        settings=minimal_rendercv_model.settings,
    )
    model.settings.render_command.markdown_path = tmp_path / "classic.md"
    markdown_path = generate_markdown(model)

    html_path = tmp_path / "classic.html"
    model.settings.render_command.html_path = html_path
    generate_html(model, markdown_path)

    html = html_path.read_text(encoding="utf-8")
    assert "markdown-body" in html
    assert 'class="side-col"' not in html


def test_generate_html_khaitranquang_preserves_standard_content(
    tmp_path,
):
    model = create_sample_rendercv_pydantic_model(theme="khaitranquang")
    model.settings.render_command.markdown_path = tmp_path / "khaitranquang-full.md"
    markdown_path = generate_markdown(model)

    html_path = tmp_path / "khaitranquang-full.html"
    model.settings.render_command.html_path = html_path
    generate_html(model, markdown_path)

    html = html_path.read_text(encoding="utf-8")
    assert "Nexus AI" in html
    assert "FlashInfer" in html
    assert "Sparse Mixture-of-Experts" in html
    assert "MIT Technology Review" in html


@pytest.mark.parametrize("theme", sorted(cv_style_browser_themes))
def test_generate_html_cv_style_theme_matches_source_template(
    tmp_path,
    minimal_rendercv_model,
    theme: str,
):
    model = create_hanh_tran_cv_style_model(minimal_rendercv_model, theme)
    model.settings.render_command.markdown_path = tmp_path / f"{theme}.md"
    markdown_path = generate_markdown(model)

    html_path = tmp_path / f"{theme}.html"
    model.settings.render_command.html_path = html_path
    generate_html(model, markdown_path)

    source_html = pathlib.Path("new_templates", f"{theme}.html").read_text(
        encoding="utf-8"
    )
    assert html_path.read_text(encoding="utf-8") == source_html


@pytest.mark.parametrize("theme", sorted(cv_style_browser_themes))
def test_generate_html_cv_style_theme_renders_user_content(
    tmp_path,
    minimal_rendercv_model,
    theme: str,
):
    model = RenderCVModel(
        cv=minimal_rendercv_model.cv,
        design={"theme": theme},
        locale=minimal_rendercv_model.locale,
        settings=minimal_rendercv_model.settings,
    )
    model.settings.render_command.markdown_path = tmp_path / f"{theme}.md"
    markdown_path = generate_markdown(model)

    html_path = tmp_path / f"{theme}.html"
    model.settings.render_command.html_path = html_path
    generate_html(model, markdown_path)

    html = html_path.read_text(encoding="utf-8")
    assert "John Doe" in html
    assert "Software Engineer at Company X" in html
    assert "Hanh Tran" not in html
    assert "Northeastern University" not in html
    assert "carrotcake AI" not in html


def test_generate_html_cv_style_hanh_with_sections_renders_user_content(
    tmp_path,
    minimal_rendercv_model,
):
    theme = sorted(cv_style_browser_themes)[0]
    cv = Cv(
        name="Hanh Tran",
        headline="AI-Driven Full-Stack Developer / AI Engineer",
        location="Da Nang, Vietnam",
        email="tnnganhanh@gmail.com",
        sections=minimal_rendercv_model.cv.sections,
    )
    model = RenderCVModel(
        cv=cv,
        design={"theme": theme},
        locale=minimal_rendercv_model.locale,
        settings=minimal_rendercv_model.settings,
    )
    model.settings.render_command.markdown_path = tmp_path / f"{theme}.md"
    markdown_path = generate_markdown(model)

    html_path = tmp_path / f"{theme}.html"
    model.settings.render_command.html_path = html_path
    generate_html(model, markdown_path)

    html = html_path.read_text(encoding="utf-8")
    assert "Software Engineer at Company X" in html
    assert "Northeastern University" not in html
    assert "carrotcake AI" not in html
