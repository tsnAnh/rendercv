import pytest

from rendercv.renderer.markdown import generate_markdown
from rendercv.schema.models.rendercv_model import RenderCVModel
from rendercv.schema.sample_generator import create_sample_rendercv_pydantic_model


@pytest.mark.parametrize("cv_variant", ["minimal", "full"])
def test_generate_markdown(
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
        model.settings.render_command.markdown_path = output_path
        generate_markdown(model)

    reference_filename = f"{cv_variant}.md"
    assert compare_file_with_reference(generate_file, reference_filename)


def test_generate_markdown_uses_theme_full_template(tmp_path, minimal_rendercv_model):
    model = RenderCVModel(
        cv=minimal_rendercv_model.cv,
        design={"theme": "khaitranquang"},
        locale=minimal_rendercv_model.locale,
        settings=minimal_rendercv_model.settings,
    )
    output_path = tmp_path / "khaitranquang.md"
    model.settings.render_command.markdown_path = output_path

    generate_markdown(model)

    markdown = output_path.read_text(encoding="utf-8")
    assert markdown.startswith("# John Doe")
    assert "John Doe's CV" not in markdown


def test_generate_markdown_khaitranquang_preserves_standard_content(
    tmp_path,
):
    model = create_sample_rendercv_pydantic_model(theme="khaitranquang")
    output_path = tmp_path / "khaitranquang-full.md"
    model.settings.render_command.markdown_path = output_path

    generate_markdown(model)

    markdown = output_path.read_text(encoding="utf-8")
    assert "Nexus AI" in markdown
    assert "FlashInfer" in markdown
    assert "Sparse Mixture-of-Experts" in markdown
    assert "MIT Technology Review" in markdown
