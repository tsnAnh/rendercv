import pytest

from rendercv.renderer.typst import generate_typst
from rendercv.schema.models.cv.entries.normal import NormalEntry
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


def test_generate_typst_ats_clean_suppresses_images_icons_and_references(
    tmp_path,
    full_rendercv_model,
):
    cv = full_rendercv_model.cv.model_copy(deep=True)
    cv.sections = {
        **(cv.sections or {}),
        "Professional References": [NormalEntry(name="Referee")],
    }
    model = RenderCVModel(
        cv=cv,
        locale=full_rendercv_model.locale,
        settings=full_rendercv_model.settings,
    )
    model.design.header.connections.show_icons = True
    model.design.links.show_external_link_icon = True
    model.settings.render_command.ats_clean = True
    model.settings.render_command.typst_path = tmp_path / "ats-clean.typ"

    generate_typst(model)

    typst = model.settings.render_command.typst_path.read_text(encoding="utf-8")
    assert "image(" not in typst
    assert "connection-with-icon" not in typst
    assert "links-show-external-link-icon: false" in typst
    assert "links-show-external-link-icon: true" not in typst
    assert "References" not in typst
    assert "Referee" not in typst
