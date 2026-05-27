import pytest

from rendercv.renderer.typst import generate_typst
from rendercv.schema.models.design.built_in_design import available_themes
from rendercv.schema.models.rendercv_model import RenderCVModel
from rendercv.schema.sample_generator import create_sample_rendercv_pydantic_model


@pytest.mark.parametrize("theme", available_themes)
@pytest.mark.parametrize("cv_variant", ["minimal", "full"])
def test_generate_typst(
    compare_file_with_reference,
    theme: str,
    cv_variant: str,
    request: pytest.FixtureRequest,
):
    base_model = request.getfixturevalue(f"{cv_variant}_rendercv_model")

    model = RenderCVModel(
        cv=base_model.cv,
        design={"theme": theme},
        locale=base_model.locale,
        settings=base_model.settings,
    )

    def generate_file(output_path):
        model.settings.render_command.typst_path = output_path
        generate_typst(model)

    reference_filename = f"{theme}_{cv_variant}.typ"
    assert compare_file_with_reference(generate_file, reference_filename)


def test_generate_typst_uses_theme_full_template(tmp_path, minimal_rendercv_model):
    model = RenderCVModel(
        cv=minimal_rendercv_model.cv,
        design={"theme": "khaitranquang"},
        locale=minimal_rendercv_model.locale,
        settings=minimal_rendercv_model.settings,
    )
    output_path = tmp_path / "khaitranquang.typ"
    model.settings.render_command.typst_path = output_path

    generate_typst(model)

    typst = output_path.read_text(encoding="utf-8")
    assert "#let sidebar-w" in typst
    assert "#show: rendercv.with" not in typst


def test_generate_typst_khaitranquang_preserves_standard_content(
    tmp_path,
):
    model = create_sample_rendercv_pydantic_model(theme="khaitranquang")
    output_path = tmp_path / "khaitranquang-full.typ"
    model.settings.render_command.typst_path = output_path

    generate_typst(model)

    typst = output_path.read_text(encoding="utf-8")
    assert "Nexus AI" in typst
    assert "FlashInfer" in typst
    assert "Sparse Mixture-of-Experts" in typst
    assert "MIT Technology Review" in typst
