import re
from typing import Any

import pydantic
from markupsafe import Markup

from rendercv.schema.models.cv.cv import Cv
from rendercv.schema.models.cv.section import BaseRenderCVSection

from .markdown_parser import markdown_to_html

paragraph_pattern = re.compile(r"\A<p>(?P<body>.*)</p>\Z", re.DOTALL)


def get_section_by_title(cv: Cv, title: str) -> BaseRenderCVSection | None:
    """Return the first rendered CV section with a matching title.

    Why:
        Full-document templates need to place sections in custom regions such as
        sidebars. Looking up by title keeps the CV schema unchanged while letting
        themes opt into richer layouts.

    Args:
        cv: The processed CV model.
        title: Section title to find.

    Returns:
        Matching section, or None when it is absent.
    """
    normalized_title = title.casefold()
    for section in cv.rendercv_sections:
        if section.title.casefold() == normalized_title:
            return section

    return None


def get_entry_attribute(entry: Any, attribute: str) -> Any:
    """Return an entry attribute only when it is present and meaningful."""
    if isinstance(entry, str):
        return None

    value = getattr(entry, attribute, None)
    return value if value not in (None, "", []) else None


def stringify_entry_value(value: Any) -> str:
    """Convert supported entry values into template-friendly text."""
    if value is None:
        return ""

    if isinstance(value, list):
        return ", ".join(stringify_entry_value(item) for item in value)

    if isinstance(value, pydantic.HttpUrl):
        return str(value)

    return str(value)


def get_entry_title(entry: Any) -> str:
    """Return a concise title for any RenderCV entry type.

    Why:
        Full-document themes still need to render arbitrary sections and all
        standard entry types. A single title helper prevents templates from
        assuming one specialized entry shape.

    Args:
        entry: Entry model or text entry.

    Returns:
        Best available title text, or an empty string.
    """
    for attribute in (
        "name",
        "company",
        "institution",
        "title",
        "label",
        "bullet",
        "number",
        "reversed_number",
    ):
        value = get_entry_attribute(entry, attribute)
        if value is not None:
            return stringify_entry_value(value)

    return ""


def get_entry_details(entry: Any) -> list[str]:
    """Return secondary details for any RenderCV entry type."""
    if isinstance(entry, str):
        return [entry]

    details: list[str] = []
    for attribute in (
        "details",
        "degree_and_area",
        "degree",
        "area",
        "position",
        "authors",
        "journal",
        "location",
    ):
        value = get_entry_attribute(entry, attribute)
        if value is not None:
            text = stringify_entry_value(value)
            if text not in details:
                details.append(text)

    return details


def get_entry_highlights(entry: Any) -> list[str]:
    """Return bullet-like content for entries that expose it."""
    highlights = get_entry_attribute(entry, "highlights")
    if isinstance(highlights, list):
        return [stringify_entry_value(item) for item in highlights]

    return []


def markdown_to_html_block(value: Any) -> Markup:
    """Convert Markdown to HTML for template insertion.

    Why:
        Theme-specific HTML templates render directly from CV fields instead of
        receiving one pre-built Markdown body. This filter gives templates the
        same Markdown behavior as the default HTML renderer.

    Args:
        value: Value to render as Markdown.

    Returns:
        HTML marked safe for Jinja insertion.
    """
    return Markup(markdown_to_html(str(value)))


def markdown_to_html_inline(value: Any) -> Markup:
    """Convert Markdown to inline HTML by removing a wrapping paragraph.

    Why:
        Names, labels, chips, and card text need inline markup. The Markdown
        package wraps plain text with ``<p>``; stripping only that outer wrapper
        preserves links and emphasis without changing block content.

    Args:
        value: Value to render as inline Markdown.

    Returns:
        Inline HTML marked safe for Jinja insertion.
    """
    html = str(markdown_to_html_block(value)).strip()
    match = paragraph_pattern.fullmatch(html)
    if match:
        return Markup(match.group("body"))

    return Markup(html)
