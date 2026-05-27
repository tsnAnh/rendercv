import json
import pathlib
from typing import Any

import pytest

from rendercv.schema.cv_style_json_schema import CV_STYLE_SECTION_REFS
from rendercv.schema.json_schema_generator import (
    generate_json_schema,
    generate_json_schema_file,
)

type JsonSchema = dict[str, Any]


def test_generate_json_schema() -> None:
    schema = generate_json_schema()
    assert isinstance(schema, dict)


def test_generate_json_schema_file(tmp_path: pathlib.Path) -> None:
    schema_file_path = tmp_path / "schema.json"
    generate_json_schema_file(schema_file_path)

    assert schema_file_path.exists()

    schema_text = schema_file_path.read_text(encoding="utf-8")
    schema = json.loads(schema_text)

    assert isinstance(schema, dict)


def test_cv_sections_include_named_cv_style_section_properties() -> None:
    schema = generate_json_schema()
    sections_object_schema = get_cv_sections_object_schema(schema)

    assert sections_object_schema["additionalProperties"] == {
        "$ref": "#/$defs/Section"
    }
    for section_name, definition_name in CV_STYLE_SECTION_REFS.items():
        assert sections_object_schema["properties"][section_name] == {
            "$ref": f"#/$defs/{definition_name}"
        }


@pytest.mark.parametrize(
    ("section_name", "entry_definition_name"),
    [
        ("Objective", "CVStyleObjectiveEntry"),
        ("Education", "CVStyleEducationEntry"),
        ("Skills", "CVStyleSkillsEntry"),
        ("Languages", "CVStyleLanguagesEntry"),
        ("References", "CVStyleReferencesEntry"),
        ("Summary", "CVStyleSummaryEntry"),
        ("Highlights", "CVStyleHighlightsEntry"),
        ("Experiences", "CVStyleExperienceEntry"),
        ("Experience", "CVStyleExperienceEntry"),
    ],
)
def test_named_cv_style_sections_reference_cv_style_entries(
    section_name: str,
    entry_definition_name: str,
) -> None:
    schema = generate_json_schema()
    section_definition_name = CV_STYLE_SECTION_REFS[section_name]
    section_schema = schema["$defs"][section_definition_name]
    specific_section_schema = section_schema["anyOf"][0]

    assert section_schema["anyOf"][1] == {"$ref": "#/$defs/Section"}
    assert section_item_references_entry(
        specific_section_schema["items"],
        entry_definition_name,
    )


@pytest.mark.parametrize(
    ("entry_definition_name", "field_names"),
    [
        ("CVStyleObjectiveEntry", ("role_keywords", "phone_href")),
        ("CVStyleSkillsEntry", ("strong", "percent")),
        ("CVStyleLanguagesEntry", ("percent",)),
        ("CVStyleReferencesEntry", ("phone_href",)),
        ("CVStyleExperienceEntry", ("team_size", "single_column")),
    ],
)
def test_cv_style_entry_fields_are_in_correct_definitions(
    entry_definition_name: str,
    field_names: tuple[str, ...],
) -> None:
    schema = generate_json_schema()
    properties = schema["$defs"][entry_definition_name]["properties"]

    for field_name in field_names:
        assert field_name in properties


def test_cv_style_entry_fields_are_not_required() -> None:
    schema = generate_json_schema()
    entry_definition_names = {
        definition_name.replace("Section", "Entry")
        for definition_name in CV_STYLE_SECTION_REFS.values()
    }

    for entry_definition_name in entry_definition_names:
        assert "required" not in schema["$defs"][entry_definition_name]


def get_cv_sections_object_schema(schema: JsonSchema) -> JsonSchema:
    sections_schema = schema["$defs"]["Cv"]["properties"]["sections"]
    for section_option in sections_schema["anyOf"]:
        if section_option.get("type") == "object":
            return section_option
    raise AssertionError("cv.sections object schema not found")


def section_item_references_entry(
    item_schema: JsonSchema,
    entry_definition_name: str,
) -> bool:
    entry_reference = {"$ref": f"#/$defs/{entry_definition_name}"}
    if item_schema == entry_reference:
        return True
    return entry_reference in item_schema.get("anyOf", [])
