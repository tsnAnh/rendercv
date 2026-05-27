import pytest

from rendercv.renderer.html import generate_html
from rendercv.renderer.markdown import generate_markdown
from rendercv.schema.models.rendercv_model import RenderCVModel
from rendercv.schema.sample_generator import create_sample_rendercv_pydantic_model


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
