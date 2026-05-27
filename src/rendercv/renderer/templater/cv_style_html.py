import html
import re
from typing import Any

import pydantic

from rendercv.schema.models.cv.cv import Cv
from rendercv.schema.models.cv.section import BaseRenderCVSection
from rendercv.schema.models.rendercv_model import RenderCVModel

from .markdown_parser import markdown_to_html
from .template_helpers import get_section_by_title

paragraph_pattern = re.compile(r"\A<p>(?P<body>.*)</p>\Z", re.DOTALL)

CALENDAR_ICON = (
    '<svg viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="18" rx="2" '
    'ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" '
    'y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10">'
    "</line></svg>"
)
LOCATION_ICON = (
    '<svg viewBox="0 0 24 24"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 '
    '9 0 0 1 18 0z"></path><circle cx="12" cy="10" r="3"></circle></svg>'
)
PHONE_ICON = (
    '<svg viewBox="0 0 24 24"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 '
    "19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 "
    "0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 "
    "12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 "
    "0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 "
    '2.81.7A2 2 0 0 1 22 16.92z"></path></svg>'
)
EMAIL_ICON = (
    '<svg viewBox="0 0 24 24"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 '
    '1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"></path>'
    '<polyline points="22,6 12,13 2,6"></polyline></svg>'
)
LINKEDIN_ICON = (
    '<svg viewBox="0 0 24 24"><path d="M16 8a6 6 0 0 1 6 6v7h-4v-7a2 '
    '2 0 0 0-2-2 2 2 0 0 0-2 2v7h-4v-7a6 6 0 0 1 6-6z"></path>'
    '<rect x="2" y="9" width="4" height="12"></rect><circle cx="4" cy="4" '
    'r="2"></circle></svg>'
)
GITHUB_ICON = (
    '<svg viewBox="0 0 24 24"><path d="M9 19c-5 1.5-5-2.5-7-3m14 '
    "6v-3.87a3.37 3.37 0 0 0-.94-2.61c3.14-.35 6.44-1.54 "
    "6.44-7A5.44 5.44 0 0 0 20 4.77 5.07 5.07 0 0 0 19.91 "
    "1S18.73.65 16 2.48a13.38 13.38 0 0 0-7 0C6.27.65 5.09 "
    "1 5.09 1A5.07 5.07 0 0 0 5 4.77a5.44 5.44 0 0 0-1.5 "
    "3.78c0 5.42 3.3 6.61 6.44 7A3.37 3.37 0 0 0 9 "
    '18.13V22"></path></svg>'
)
OBJECTIVE_ICON = (
    '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" '
    'stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle '
    'cx="12" cy="12" r="10"></circle><circle cx="12" cy="12" r="6"></circle>'
    '<circle cx="12" cy="12" r="2"></circle></svg>'
)
EDUCATION_ICON = (
    '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" '
    'stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path '
    'd="M22 10v6M2 10l10-5 10 5-10 5z"></path><path d="M6 12v5c3 3 9 '
    '3 12 0v-5"></path></svg>'
)
SKILLS_ICON = (
    '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" '
    'stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polygon '
    'points="12 2 2 7 12 12 22 7 12 2"></polygon><polyline points="2 17 12 '
    '22 22 17"></polyline><polyline points="2 12 12 17 22 12"></polyline></svg>'
)
LANGUAGE_ICON = (
    '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" '
    'stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle '
    'cx="12" cy="12" r="10"></circle><line x1="2" y1="12" x2="22" y2="12">'
    '</line><path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 '
    '15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"></path></svg>'
)
REFERENCE_ICON = (
    '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" '
    'stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path '
    'd="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle '
    'cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87">'
    '</path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>'
)
SUMMARY_ICON = (
    '<svg viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 '
    '0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>'
)
HIGHLIGHT_ICON = (
    '<svg viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 '
    "17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 "
    '8.26 12 2"></polygon></svg>'
)
EXPERIENCE_ICON = (
    '<svg viewBox="0 0 24 24"><rect x="2" y="7" width="20" height="14" '
    'rx="2" ry="2"></rect><path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 '
    '0 0-2 2v16"></path></svg>'
)


def render_cv_style_header(rendercv_model: RenderCVModel, header: str) -> str:
    """Fill the cv-style header fields that live outside RenderCV defaults."""
    metadata = get_metadata(rendercv_model.cv)
    header = replace_role_keywords(header, metadata["role_keywords"])
    contact_items = render_contact_items(rendercv_model.cv, metadata)
    return re.sub(
        r"<ul class=\"contact-list\">.*?</ul>",
        f'<ul class="contact-list">\n{contact_items}\n            </ul>',
        header,
        count=1,
        flags=re.DOTALL,
    )


def render_cv_style_shell(rendercv_model: RenderCVModel) -> str:
    """Render user CV sections with the same class structure as cv-style mockups."""
    cv = rendercv_model.cv
    return (
        '    <div class="resume-shell">\n'
        '      <aside class="sidebar" aria-label="Fixed resume sidebar">\n'
        f"{render_objective(cv)}\n"
        f"{render_education(cv)}\n"
        f"{render_skills(cv)}\n"
        f"{render_languages(cv)}\n"
        f"{render_references(cv)}\n"
        "      </aside>\n\n"
        '      <main id="mainContent">\n'
        f"{render_summary(cv)}\n"
        f"{render_highlights(cv)}\n"
        f"{render_experiences(cv)}\n"
        "      </main>\n"
        "    </div>\n"
    )


def get_metadata(cv: Cv) -> dict[str, Any]:
    objective = first_entry(cv, "Objective")
    metadata: dict[str, Any] = {
        "date_of_birth": entry_value(objective, "date_of_birth"),
        "role_keywords": split_keywords(entry_value(objective, "role_keywords")),
        "phone_href": entry_value(objective, "phone_href"),
        "phone_display": entry_value(objective, "phone_display"),
        "linkedin_url": entry_value(objective, "linkedin_url"),
        "linkedin_label": entry_value(objective, "linkedin_label"),
        "github_url": entry_value(objective, "github_url"),
        "github_label": entry_value(objective, "github_label"),
    }
    if not metadata["phone_href"] and cv.phone:
        phone_display = scalar_text(cv.phone)
        metadata["phone_display"] = phone_display
        metadata["phone_href"] = "tel:" + re.sub(r"[^\d+]", "", phone_display)

    for network in cv.social_networks or []:
        username = network.username
        if network.network == "LinkedIn" and not metadata["linkedin_url"]:
            metadata["linkedin_url"] = network.url
            metadata["linkedin_label"] = f"linkedin.com/in/{username}"
        if network.network == "GitHub" and not metadata["github_url"]:
            metadata["github_url"] = network.url
            metadata["github_label"] = f"github.com/{username}"

    return metadata


def replace_role_keywords(header: str, keywords: list[str]) -> str:
    if not keywords:
        return header
    keyword_markup = "".join(
        f"\n            <span>{inline_html(keyword)}</span>" for keyword in keywords
    )
    return re.sub(
        r"<div class=\"role-keywords\" aria-label=\"Recruiter focus areas\">.*?</div>",
        (
            '<div class="role-keywords" aria-label="Recruiter focus areas">'
            f"{keyword_markup}\n          </div>"
        ),
        header,
        count=1,
        flags=re.DOTALL,
    )


def render_contact_items(cv: Cv, metadata: dict[str, Any]) -> str:
    items: list[str] = []
    add_contact_span(items, CALENDAR_ICON, metadata["date_of_birth"])
    add_contact_span(items, LOCATION_ICON, cv.location)
    add_contact_link(
        items, PHONE_ICON, metadata["phone_display"], metadata["phone_href"], False
    )
    email = scalar_text(cv.email)
    add_contact_link(
        items, EMAIL_ICON, email, f"mailto:{email}" if email else None, False
    )
    add_contact_link(
        items, LINKEDIN_ICON, metadata["linkedin_label"], metadata["linkedin_url"], True
    )
    add_contact_link(
        items, GITHUB_ICON, metadata["github_label"], metadata["github_url"], True
    )
    return "\n".join(items)


def add_contact_span(items: list[str], icon: str, value: Any) -> None:
    if not value:
        return
    items.append(
        "              <li>\n"
        '                <span class="contact-item">\n'
        f'                  <span class="icon" aria-hidden="true">{icon}</span>\n'
        f"                  <span>{inline_html(value)}</span>\n"
        "                </span>\n"
        "              </li>"
    )


def add_contact_link(
    items: list[str], icon: str, label: Any, url: Any, external: bool
) -> None:
    if not label or not url:
        return
    rel = ' target="_blank" rel="noreferrer"' if external else ""
    items.append(
        "              <li>\n"
        f'                <a class="contact-item" href="{escape_attr(url)}"{rel}>\n'
        f'                  <span class="icon" aria-hidden="true">{icon}</span>\n'
        f"                  <span>{inline_html(label)}</span>\n"
        "                </a>\n"
        "              </li>"
    )


def render_objective(cv: Cv) -> str:
    entry = first_entry(cv, "Objective")
    summary = entry_value(entry, "summary") or entry_value(entry, "details") or entry
    return (
        '\n        <section class="sidebar-section sidebar-objective" '
        'aria-label="Objective">\n'
        f"          {sidebar_title(OBJECTIVE_ICON, 'Objective')}\n"
        f"          <p>{inline_html(summary)}</p>\n"
        "        </section>\n"
    )


def render_education(cv: Cv) -> str:
    entries = section_entries(cv, "Education")
    items = [render_education_item(entry) for entry in entries]
    return (
        '\n        <section class="sidebar-section sidebar-education" '
        'aria-label="Education timeline">\n'
        f"          {sidebar_title(EDUCATION_ICON, 'Education')}\n"
        f"{''.join(items)}"
        "        </section>\n"
    )


def render_education_item(entry: Any) -> str:
    title = join_nonempty(
        [entry_value(entry, "degree"), entry_value(entry, "area")], ", "
    )
    institution = entry_value(entry, "institution") or entry_value(entry, "name")
    location = entry_value(entry, "location")
    summary = entry_value(entry, "summary")
    details = join_nonempty([institution, location], " · ")
    note = first_nonempty(summary, first_highlight(entry), entry_value(entry, "note"))
    return (
        '          <article class="education-item">\n'
        f'            <span class="education-date">{inline_html(display_date(entry))}</span>\n'
        f"            <h2>{inline_html(title or institution)}</h2>\n"
        f"            <p>{inline_html(details)}</p>\n"
        f"            <p>{inline_html(note)}</p>\n"
        "          </article>\n"
    )


def render_skills(cv: Cv) -> str:
    blocks = "".join(
        render_skill_block(entry) for entry in section_entries(cv, "Skills")
    )
    return (
        '\n        <section class="sidebar-section sidebar-skills" aria-label="Skills">\n'
        f"          {sidebar_title(SKILLS_ICON, 'Skills')}\n"
        f"{blocks}"
        "        </section>\n"
    )


def render_skill_block(entry: Any) -> str:
    label = entry_value(entry, "label") or entry_value(entry, "name")
    tags = split_tags(entry_value(entry, "details"))
    tag_markup = "".join(f'<span class="tag">{inline_html(tag)}</span>' for tag in tags)
    return (
        '          <div class="sidebar-skill-block">\n'
        f"            <h3>{inline_html(label)}</h3>\n"
        f'            <div class="tag-row">{tag_markup}</div>\n'
        "          </div>\n"
    )


def render_languages(cv: Cv) -> str:
    entries = section_entries(cv, "Languages")
    rows = []
    notes = []
    for entry in entries:
        rows.append(
            f'<div class="spoken-row"><strong>{inline_html(entry_value(entry, "label"))}'
            f"</strong><span>{inline_html(entry_value(entry, 'details'))}</span></div>"
        )
        if entry_value(entry, "note"):
            notes.append(entry_value(entry, "note"))
    note = notes[0] if notes else ""
    return (
        '\n        <section class="sidebar-section" aria-label="Languages">\n'
        f"          {sidebar_title(LANGUAGE_ICON, 'Languages')}\n"
        f"          {' '.join(rows)}\n"
        f'          <p class="language-note">{inline_html(note)}</p>\n'
        "        </section>\n"
    )


def render_references(cv: Cv) -> str:
    entries = section_entries(cv, "References")
    references = "".join(render_reference(entry) for entry in entries)
    return (
        '\n        <section class="sidebar-section" aria-label="References">\n'
        f"          {sidebar_title(REFERENCE_ICON, 'References')}\n"
        f"{references}"
        "        </section>\n"
    )


def render_reference(entry: Any) -> str:
    title = join_nonempty(
        [entry_value(entry, "title"), entry_value(entry, "role")], " · "
    )
    phone_href = entry_value(entry, "phone_href")
    phone_display = entry_value(entry, "phone_display")
    contact = ""
    if phone_href and phone_display:
        contact = (
            f'            <a href="{escape_attr(phone_href)}">\n'
            f"              {PHONE_ICON}\n"
            f"              {inline_html(phone_display)}\n"
            "            </a>\n"
        )
    return (
        '          <div class="sidebar-reference">\n'
        f"            <strong>{inline_html(entry_value(entry, 'name'))}</strong>\n"
        f"            <span>{inline_html(title)}</span>\n"
        f"{contact}"
        "          </div>\n"
    )


def render_summary(cv: Cv) -> str:
    paragraphs = []
    for entry in section_entries(cv, "Summary"):
        text = entry_value(entry, "summary") or entry_value(entry, "details") or entry
        if text:
            paragraphs.append(f"            <p>{inline_html(text)}</p>")
    return section_card(
        "summary",
        SUMMARY_ICON,
        "Summary",
        f'<div class="copy-block">\n{chr(10).join(paragraphs)}\n          </div>',
    )


def render_highlights(cv: Cv) -> str:
    entries = section_entries(cv, "Highlights")
    entry = entries[0] if entries else None
    title = entry_value(entry, "title") or entry_value(entry, "name") or "Highlights"
    summary = entry_value(entry, "summary")
    bullets = render_bullet_list(entry_value(entry, "highlights") or [])
    body = (
        '          <article class="highlight-note">\n'
        f"            <h3>{inline_html(title)}</h3>\n"
        f"            <p>{inline_html(summary)}</p>\n"
        f"{bullets}"
        "          </article>"
    )
    return section_card("highlights", HIGHLIGHT_ICON, "Highlights", body)


def render_experiences(cv: Cv) -> str:
    projects = "".join(
        render_project(entry)
        for entry in section_entries_any(cv, ["Experiences", "Experience"])
    )
    body = f'          <div class="project-list">\n{projects}          </div>'
    return section_card("experience", EXPERIENCE_ICON, "Experiences", body)


def render_project(entry: Any) -> str:
    if isinstance(entry, str):
        return (
            '            <article class="project">\n'
            '              <div class="project-header">\n'
            "                <div>\n"
            f'                  <div class="project-kicker">{inline_html(entry)}</div>\n'
            f'                  <h3 class="project-title">{inline_html(entry)}</h3>\n'
            "                </div>\n"
            "              </div>\n"
            '              <div class="project-body">\n'
            f"                <p>{inline_html(entry)}</p>\n"
            "              </div>\n"
            "            </article>\n\n"
        )

    kicker = entry_value(entry, "kicker") or entry_value(entry, "name")
    title = entry_value(entry, "title") or entry_value(entry, "position") or kicker
    summary = entry_value(entry, "summary")
    return (
        '            <article class="project">\n'
        '              <div class="project-header">\n'
        "                <div>\n"
        f'                  <div class="project-kicker">{inline_html(kicker)}</div>\n'
        f'                  <h3 class="project-title">{inline_html(title)}</h3>\n'
        "                </div>\n"
        '                <div class="project-time-container">\n'
        f'                  <div class="project-time">{inline_html(display_date(entry))}</div>\n'
        f'                  <div class="project-duration">{inline_html(entry_value(entry, "duration"))}</div>\n'
        "                </div>\n"
        "              </div>\n"
        '              <div class="project-meta">\n'
        f"{meta_line('Role', entry_value(entry, 'role') or entry_value(entry, 'position'))}"
        f"{meta_line('Team size', entry_value(entry, 'team_size') or 'Not specified')}"
        f"{meta_line('Stack', entry_value(entry, 'stack'))}"
        "              </div>\n"
        '              <div class="project-body">\n'
        f"                <p>{inline_html(summary)}</p>\n"
        f"{render_bullet_list(entry_value(entry, 'highlights') or [])}"
        "              </div>\n"
        "            </article>\n\n"
    )


def section_card(section_id: str, icon: str, title: str, body: str) -> str:
    return (
        f'\n        <section class="section-card" id="{section_id}">\n'
        '          <h2 class="section-title">\n'
        f'            <span class="section-icon" aria-hidden="true">{icon}</span>\n'
        f"            {title}\n"
        "          </h2>\n"
        f"{body}\n"
        "        </section>\n"
    )


def sidebar_title(icon: str, title: str) -> str:
    return f'<h2 class="sidebar-title">\n            {icon}\n            {title}\n          </h2>'


def meta_line(label: str, value: Any) -> str:
    if not value:
        return ""
    return (
        f'                <div class="meta-line"><span>{escape_text(label)}</span>'
        f"<span>{inline_html(value)}</span></div>\n"
    )


def render_bullet_list(items: list[Any]) -> str:
    if not items:
        return ""
    list_items = "\n".join(
        f"                  <li>{inline_html(item)}</li>" for item in items
    )
    return f'                <ul class="bullet-list">\n{list_items}\n                </ul>\n'


def first_entry(cv: Cv, title: str) -> Any:
    entries = section_entries(cv, title)
    return entries[0] if entries else None


def section_entries(cv: Cv, title: str) -> list[Any]:
    section = get_section_by_title(cv, title)
    if not isinstance(section, BaseRenderCVSection):
        return []
    return section.entries


def section_entries_any(cv: Cv, titles: list[str]) -> list[Any]:
    for title in titles:
        entries = section_entries(cv, title)
        if entries:
            return entries
    return []


def entry_value(entry: Any, field: str) -> Any:
    if entry is None or isinstance(entry, str):
        return None
    value = getattr(entry, field, None)
    if value in (None, "", []):
        return None
    return value


def first_highlight(entry: Any) -> Any:
    highlights = entry_value(entry, "highlights")
    if isinstance(highlights, list) and highlights:
        return highlights[0]
    return None


def display_date(entry: Any) -> str:
    for field in ("date", "DATE"):
        value = entry_value(entry, field)
        if value:
            return first_display_line(value)
    start_date = entry_value(entry, "start_date")
    end_date = entry_value(entry, "end_date")
    if start_date and end_date:
        return f"{start_date} - {end_date}"
    return ""


def first_display_line(value: Any) -> str:
    for line in re.split(r"\n+", str(value)):
        stripped = line.strip()
        if stripped:
            return stripped
    return ""


def split_keywords(value: Any) -> list[str]:
    if isinstance(value, list):
        return [str(item).strip() for item in value if str(item).strip()]
    if not value:
        return []
    return [item.strip() for item in str(value).split(",") if item.strip()]


def split_tags(value: Any) -> list[str]:
    if isinstance(value, list):
        return [str(item).strip() for item in value if str(item).strip()]
    if not value:
        return []
    return [item.strip() for item in str(value).split(",") if item.strip()]


def join_nonempty(values: list[Any], separator: str) -> str:
    return separator.join(str(value) for value in values if value)


def first_nonempty(*values: Any) -> Any:
    for value in values:
        if value:
            return value
    return ""


def scalar_text(value: Any) -> str:
    if isinstance(value, list):
        return str(value[0]) if value else ""
    if isinstance(value, pydantic.HttpUrl):
        return str(value)
    return str(value) if value else ""


def inline_html(value: Any) -> str:
    if value is None:
        return ""
    rendered = markdown_to_html(str(value)).strip()
    match = paragraph_pattern.fullmatch(rendered)
    return match.group("body") if match else rendered


def escape_text(value: Any) -> str:
    return html.escape(str(value), quote=False)


def escape_attr(value: Any) -> str:
    return html.escape(str(value), quote=True)
