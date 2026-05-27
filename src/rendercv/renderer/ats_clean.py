import re
from typing import Any

from rendercv.schema.models.rendercv_model import RenderCVModel

reference_title_pattern = re.compile(r"[^a-z0-9]+")
svg_pattern = re.compile(r"<svg\b[^>]*>.*?</svg>", re.IGNORECASE | re.DOTALL)
img_pattern = re.compile(r"<img\b[^>]*>", re.IGNORECASE)
icon_span_pattern = re.compile(
    r"<span\b(?=[^>]*class=[\"'][^\"']*(?:\bmsi\b|\b[a-z-]*icon\b))[^>]*>.*?</span>",
    re.IGNORECASE | re.DOTALL,
)
favicon_svg_link_pattern = re.compile(
    r"\s*<link\b[^>]*rel=[\"'](?:icon|shortcut icon)[\"'][^>]*svg[^>]*>\n?",
    re.IGNORECASE,
)
button_pattern = re.compile(
    r"\s*<button\b(?=[^>]*class=[\"'][^\"']*(?:btn-print|export-btn))[^>]*>.*?</button>\n?",
    re.IGNORECASE | re.DOTALL,
)
references_section_pattern = re.compile(
    r"\n?\s*<section\b(?=[^>]*aria-label=[\"']References[\"'])[^>]*>.*?</section>",
    re.IGNORECASE | re.DOTALL,
)
avatar_container_patterns = (
    re.compile(
        r"\n?\s*<div\b[^>]*class=[\"'][^\"']*avatar-wrapper[^\"']*[\"'][^>]*>.*?</div>",
        re.IGNORECASE | re.DOTALL,
    ),
    re.compile(
        r"\n?\s*<div\b[^>]*class=[\"'][^\"']*avatar[^\"']*[\"'][^>]*>.*?</div>",
        re.IGNORECASE | re.DOTALL,
    ),
)


def prepare_ats_clean_model(rendercv_model: RenderCVModel) -> RenderCVModel:
    """Return a render-only copy with ATS-clean content suppressions applied.

    Why:
        ATS mode should not reject YAML or mutate the user's validated model. A deep
        copy lets every renderer consume the same cleaned content while preserving
        the original model and default rendering behavior.
    """
    if not rendercv_model.settings.render_command.ats_clean:
        return rendercv_model

    clean_model = rendercv_model.model_copy(deep=True)
    clean_model.cv.photo = None
    clean_model.cv.sections = remove_references_section(clean_model.cv.sections)
    clean_model.cv.__dict__.pop("rendercv_sections", None)

    if clean_model.cv.sections is not None:
        for title, entries in clean_model.cv.sections.items():
            if normalize_section_title(title) in ("objective", "headerdetails"):
                suppress_date_of_birth(entries)

    clean_model.design.header.connections.show_icons = False
    clean_model.design.links.show_external_link_icon = False
    return clean_model


def remove_references_section(sections: dict[str, Any] | None) -> dict[str, Any] | None:
    """Remove sections whose normalized title indicates references."""
    if sections is None:
        return None

    return {
        title: entries
        for title, entries in sections.items()
        if "reference" not in normalize_section_title(title)
    }


def normalize_section_title(title: str) -> str:
    """Normalize a section title for ATS-clean section filtering."""
    return reference_title_pattern.sub("", title.lower())


def suppress_date_of_birth(entries: Any) -> None:
    """Remove structured DOB fields from built-in HTML theme metadata entries."""
    if not isinstance(entries, list):
        return

    for entry in entries:
        if isinstance(entry, dict):
            entry.pop("date_of_birth", None)
        elif hasattr(entry, "date_of_birth"):
            delattr(entry, "date_of_birth")


def sanitize_ats_clean_html(rendercv_model: RenderCVModel, html: str) -> str:
    """Remove markup that ATS-clean HTML should not expose."""
    if not rendercv_model.settings.render_command.ats_clean:
        return html

    html = favicon_svg_link_pattern.sub("", html)
    html = button_pattern.sub("", html)
    html = references_section_pattern.sub("", html)
    for pattern in avatar_container_patterns:
        html = pattern.sub("", html)
    html = img_pattern.sub("", html)
    html = icon_span_pattern.sub("", html)
    html = svg_pattern.sub("", html)
    html = html.replace("section-icon", "ats-clean-removed-icon")
    html = html.replace("side-icon", "ats-clean-removed-icon")
    html = html.replace("contact-icon", "ats-clean-removed-icon")
    html = html.replace(".btn-print", ".ats-clean-removed-control")
    return html.replace(".export-btn", ".ats-clean-removed-control")
