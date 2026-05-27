import copy
from typing import Any

type JsonSchema = dict[str, Any]

STRING_OR_NULL_SCHEMA: JsonSchema = {"anyOf": [{"type": "string"}, {"type": "null"}]}
BOOLEAN_OR_NULL_SCHEMA: JsonSchema = {"anyOf": [{"type": "boolean"}, {"type": "null"}]}
STRING_LIST_OR_NULL_SCHEMA: JsonSchema = {
    "anyOf": [
        {"type": "string"},
        {"items": {"type": "string"}, "type": "array"},
        {"type": "null"},
    ]
}
NUMBER_STRING_OR_NULL_SCHEMA: JsonSchema = {
    "anyOf": [{"type": "number"}, {"type": "string"}, {"type": "null"}]
}

CV_STYLE_EXTRA_FIELDS: dict[str, tuple[str, ...]] = {
    "Objective": (
        "date_of_birth",
        "role_keywords",
        "phone_href",
        "phone_display",
        "linkedin_url",
        "linkedin_label",
        "github_url",
        "github_label",
        "title",
        "kicker",
        "note",
        "wide",
    ),
    "Education": ("badge", "note"),
    "Skills": ("strong", "percent", "badge", "note"),
    "Languages": ("percent", "badge", "note"),
    "References": (
        "title",
        "kicker",
        "role",
        "phone_href",
        "phone_display",
        "email",
        "url",
        "note",
    ),
    "Summary": ("title", "kicker", "role_keywords", "note", "wide"),
    "Highlights": ("title", "kicker", "note", "wide"),
    "Experience": (
        "title",
        "kicker",
        "duration",
        "role",
        "position",
        "team_size",
        "stack",
        "note",
        "single_column",
    ),
}
CV_STYLE_ENTRY_BASES: dict[str, str] = {
    "Objective": "NormalEntry",
    "Education": "EducationEntry",
    "Skills": "OneLineEntry",
    "Languages": "OneLineEntry",
    "References": "NormalEntry",
    "Summary": "NormalEntry",
    "Highlights": "NormalEntry",
    "Experience": "ExperienceEntry",
}
CV_STYLE_SECTION_REFS: dict[str, str] = {
    "Objective": "CVStyleObjectiveSection",
    "Education": "CVStyleEducationSection",
    "Skills": "CVStyleSkillsSection",
    "Languages": "CVStyleLanguagesSection",
    "References": "CVStyleReferencesSection",
    "Summary": "CVStyleSummarySection",
    "Highlights": "CVStyleHighlightsSection",
    "Experiences": "CVStyleExperienceSection",
    "Experience": "CVStyleExperienceSection",
}


def add_cv_style_section_schemas(json_schema: JsonSchema) -> None:
    """Add editor-only section schemas for CV-style HTML theme fields.

    Why:
        Runtime validation intentionally allows arbitrary section names and
        extra entry keys. These definitions only make common CV-style section
        names autocomplete fields used by the HTML renderers.
    """
    definitions = json_schema["$defs"]
    for section_name, base_definition_name in CV_STYLE_ENTRY_BASES.items():
        entry_definition_name = f"CVStyle{section_name}Entry"
        section_definition_name = (
            "CVStyleExperienceSection"
            if section_name == "Experience"
            else f"CVStyle{section_name}Section"
        )
        definitions[entry_definition_name] = create_cv_style_entry_schema(
            definitions[base_definition_name],
            entry_definition_name,
            CV_STYLE_EXTRA_FIELDS[section_name],
        )
        definitions[section_definition_name] = create_cv_style_section_schema(
            entry_definition_name,
            section_definition_name,
            allow_text_entries=section_name == "Highlights",
        )

    sections_object_schema = get_cv_sections_object_schema(json_schema)
    section_properties = sections_object_schema.setdefault("properties", {})
    for section_name, section_definition_name in CV_STYLE_SECTION_REFS.items():
        section_properties[section_name] = {
            "$ref": f"#/$defs/{section_definition_name}"
        }


def create_cv_style_entry_schema(
    base_schema: JsonSchema,
    title: str,
    extra_fields: tuple[str, ...],
) -> JsonSchema:
    properties = copy.deepcopy(base_schema.get("properties", {}))
    for field_name in extra_fields:
        properties[field_name] = create_cv_style_field_schema(field_name)
    return {
        "additionalProperties": True,
        "description": None,
        "properties": properties,
        "title": title,
        "type": "object",
    }


def create_cv_style_field_schema(field_name: str) -> JsonSchema:
    if field_name in ("wide", "single_column"):
        field_schema = copy.deepcopy(BOOLEAN_OR_NULL_SCHEMA)
    elif field_name == "percent":
        field_schema = copy.deepcopy(NUMBER_STRING_OR_NULL_SCHEMA)
    elif field_name in ("role_keywords", "strong"):
        field_schema = copy.deepcopy(STRING_LIST_OR_NULL_SCHEMA)
    else:
        field_schema = copy.deepcopy(STRING_OR_NULL_SCHEMA)
    field_schema["title"] = field_name.replace("_", " ").title()
    return field_schema


def create_cv_style_section_schema(
    entry_definition_name: str,
    title: str,
    allow_text_entries: bool,
) -> JsonSchema:
    item_schema: JsonSchema = {"$ref": f"#/$defs/{entry_definition_name}"}
    if allow_text_entries:
        item_schema = {"anyOf": [{"type": "string"}, item_schema]}
    return {
        "anyOf": [
            {"items": item_schema, "type": "array"},
            {"$ref": "#/$defs/Section"},
        ],
        "title": title,
    }


def get_cv_sections_object_schema(json_schema: JsonSchema) -> JsonSchema:
    sections_schema = json_schema["$defs"]["Cv"]["properties"]["sections"]
    for section_option in sections_schema.get("anyOf", []):
        if section_option.get("type") == "object":
            return section_option
    raise KeyError("cv.sections object schema not found")
