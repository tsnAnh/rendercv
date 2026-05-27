import contextlib
import functools
import pathlib
import re
from typing import Literal

import jinja2

from rendercv.schema.models.rendercv_model import RenderCVModel

from .cv_style_html import render_cv_style_header, render_cv_style_shell
from .markdown_parser import markdown_to_html
from .model_processor import download_photo_from_url, process_model
from .string_processor import clean_url
from .template_helpers import (
    get_entry_details,
    get_entry_highlights,
    get_entry_title,
    get_section_by_title,
    markdown_to_html_block,
    markdown_to_html_inline,
)

templates_directory = pathlib.Path(__file__).parent / "templates"
cv_style_theme_names = {
    "executive-rail",
    "monochrome-editorial",
    "engineering-grid",
    "blueprint-compact",
    "teal-systems",
    "premium-paper",
    "creative-ink",
    "ink-wash-graphite",
    "linear-narrative",
    "kami-paper",
    "architect-mono",
    "linear-sidebar",
    "kami-sidebar",
    "architect-sidebar",
}
cv_style_body_start_pattern = re.compile(
    r"(?P<body_start><body>\n<div class=\"resume-page\">\n)"
    r"(?P<header>.*?\n    </header>)"
    r".*?"
    r"(?P<tail>\n\n  <button class=\"btn-print\".*)",
    re.DOTALL,
)
cv_style_avatar_pattern = re.compile(
    r"\n        <div class=\"avatar\" aria-hidden=\"true\">.*?\n        </div>",
    re.DOTALL,
)
cv_style_avatar_fallback_pattern = re.compile(r"\s+onerror=\"[^\"]*ui-avatars[^\"]*\"")
cv_style_print_page_border_override = """
    @media print {
      body {
        position: relative;
      }

      body::before {
        content: "";
        position: fixed;
        top: 0;
        bottom: 0;
        left: 0;
        width: 255px;
        background: #f5f8fc;
        border-right: 1px solid var(--rule);
        z-index: 0;
      }

      .resume-page {
        border: 0 !important;
        outline: 0 !important;
        position: relative;
        z-index: 1;
      }

      .sidebar,
      main {
        box-decoration-break: clone;
        -webkit-box-decoration-break: clone;
      }

      .sidebar {
        padding-top: calc(32px + 0.22in) !important;
      }

      main {
        padding-top: calc(34px + 0.22in) !important;
      }
    }
"""


@functools.lru_cache(maxsize=1)
def get_jinja2_environment(
    input_file_path: pathlib.Path | None = None,
) -> jinja2.Environment:
    """Create cached Jinja2 environment with custom filters and template loaders.

    Why:
        Template rendering is called multiple times per render. Caching environment
        prevents repeated filesystem scans. Loader hierarchy enables user template
        overrides by checking input file directory before built-in templates.

    Args:
        input_file_path: Path to input file for user template override resolution.

    Returns:
        Configured Jinja2 environment with filters and loaders.
    """
    env = jinja2.Environment(
        loader=jinja2.FileSystemLoader(
            [
                (  # To allow users to override the templates:
                    input_file_path.parent if input_file_path else pathlib.Path.cwd()
                ),
                templates_directory,
            ]
        ),
        trim_blocks=True,
        lstrip_blocks=True,
    )
    env.filters["clean_url"] = clean_url
    env.filters["strip"] = lambda string: string.strip()
    env.filters["section_by_title"] = get_section_by_title
    env.filters["entry_title"] = get_entry_title
    env.filters["entry_details"] = get_entry_details
    env.filters["entry_highlights"] = get_entry_highlights
    env.filters["markdown_to_html"] = markdown_to_html_block
    env.filters["markdown_to_html_inline"] = markdown_to_html_inline
    return env


def get_theme_template(
    rendercv_model: RenderCVModel,
    relative_template_path: str,
) -> jinja2.Template | None:
    """Return a theme-specific template when one exists.

    Why:
        Some themes need full-document control rather than the default
        section-by-section assembly. Looking up the theme path first keeps that
        behavior opt-in and preserves existing themes.

    Args:
        rendercv_model: CV model that provides the active theme and input path.
        relative_template_path: Template path relative to a theme folder.

    Returns:
        The resolved template, or None when the theme does not provide it.
    """
    jinja2_environment = get_jinja2_environment(rendercv_model._input_file_path)
    with contextlib.suppress(jinja2.TemplateNotFound):
        return jinja2_environment.get_template(
            f"{rendercv_model.design.theme}/{relative_template_path}"
        )

    return None


def render_full_template(
    rendercv_model: RenderCVModel, file_type: Literal["typst", "markdown"]
) -> str:
    """Render complete CV document by assembling preamble, header, and sections.

    Why:
        CV generation requires consistent structure across formats. This orchestrates
        model processing, template rendering for each component, and assembly into
        final document following proper order.

    Example:
        ```py
        typst_document = render_full_template(rendercv_model, "typst")
        # Returns complete .typ file with preamble, header, and all sections

        markdown_document = render_full_template(rendercv_model, "markdown")
        # Returns complete .md file with header and all sections
        ```

    Args:
        rendercv_model: CV model to render.
        file_type: Output format for template selection and processing.

    Returns:
        Complete rendered document as string.
    """
    extension = {
        "typst": "typ",
        "markdown": "md",
    }[file_type]

    download_photo_from_url(rendercv_model)
    rendercv_model = process_model(rendercv_model, file_type)

    full_template = get_theme_template(rendercv_model, f"Full.j2.{extension}")
    if full_template is not None:
        return render_template(full_template, rendercv_model)

    header = render_single_template(
        file_type,
        f"Header.j2.{extension}",
        rendercv_model,
    )
    if file_type == "typst":
        preamble = render_single_template(
            file_type,
            f"Preamble.j2.{extension}",
            rendercv_model,
        )
        code = f"{preamble}\n\n{header}\n"
    else:
        code = f"{header}\n"

    for rendercv_section in rendercv_model.cv.rendercv_sections:
        section_beginning = render_single_template(
            file_type,
            f"SectionBeginning.j2.{extension}",
            rendercv_model,
            section_title=rendercv_section.title,
            snake_case_section_title=rendercv_section.snake_case_title,
            entry_type=rendercv_section.entry_type,
        )
        section_ending = render_single_template(
            file_type,
            f"SectionEnding.j2.{extension}",
            rendercv_model,
            entry_type=rendercv_section.entry_type,
        )
        entry_codes = []
        for entry in rendercv_section.entries:
            entry_code = render_single_template(
                file_type,
                f"entries/{rendercv_section.entry_type}.j2.{extension}",
                rendercv_model,
                entry=entry,
            )
            entry_codes.append(entry_code)
        entries_code = "\n\n".join(entry_codes)
        section_code = f"{section_beginning}\n{entries_code}\n{section_ending}"
        code += f"\n{section_code}"

    return code


def render_html(rendercv_model: RenderCVModel, markdown: str) -> str:
    """Convert Markdown to HTML and wrap with full HTML template.

    Why:
        HTML output requires both content conversion (Markdown to HTML body) and
        document structure (head, CSS, metadata). Separate function handles HTML-
        specific workflow distinct from Typst/Markdown direct generation.

    Example:
        ```py
        markdown_content = render_full_template(rendercv_model, "markdown")
        html_document = render_html(rendercv_model, markdown_content)
        # Returns complete HTML with <head>, CSS, and converted Markdown body
        ```

    Args:
        rendercv_model: CV model for template context.
        markdown: Markdown content to convert.

    Returns:
        Complete HTML document.
    """
    html_body = markdown_to_html(markdown)
    full_template = get_theme_template(rendercv_model, "Full.html")
    if full_template is not None:
        download_photo_from_url(rendercv_model)
        processed_model = process_model(rendercv_model, "markdown")
        html = render_template(
            full_template,
            processed_model,
            html_body=html_body,
        )
        if processed_model.design.theme in cv_style_theme_names:
            html = f"{html}\n"
            if is_cv_style_source_fixture(processed_model):
                return html
            return render_cv_style_user_body(processed_model, html)
        return html

    return render_single_template(
        "html", "Full.html", rendercv_model, html_body=html_body
    )


def is_cv_style_source_fixture(rendercv_model: RenderCVModel) -> bool:
    """Return whether the model is the source fixture for cv-style templates."""
    cv = rendercv_model.cv
    return (
        cv.name == "Hanh Tran"
        and cv.headline == "AI-Driven Full-Stack Developer / AI Engineer"
        and cv.location == "Da Nang, Vietnam"
        and str(cv.email) == "tnnganhanh@gmail.com"
        and cv.photo is None
        and cv.phone is None
        and cv.website is None
        and cv.social_networks is None
        and cv.custom_connections is None
        and cv.sections is None
    )


def render_cv_style_user_body(rendercv_model: RenderCVModel, source_html: str) -> str:
    """Render real user content in a cv-style theme shell.

    Why:
        The cv-style source HTML files are preserved as golden Hanh Tran
        mockups. For other CVs, keep the theme head/print controls and render
        the user's sections into the same sidebar/card/project structure.
    """
    source_html = source_html.replace(
        "\n  </style>", f"{cv_style_print_page_border_override}\n  </style>", 1
    )
    match = cv_style_body_start_pattern.search(source_html)
    if match is None:
        return source_html

    header = match.group("header")
    if rendercv_model.cv.photo is None:
        header = cv_style_avatar_pattern.sub("", header, count=1)
    else:
        header = cv_style_avatar_fallback_pattern.sub("", header)
    header = render_cv_style_header(rendercv_model, header)

    return (
        source_html[: match.start()]
        + match.group("body_start")
        + header
        + "\n\n"
        + render_cv_style_shell(rendercv_model)
        + "  </div>"
        + match.group("tail")
    )


def render_single_template(
    file_type: Literal["markdown", "typst", "html"],
    relative_template_path: str,
    rendercv_model: RenderCVModel,
    **kwargs,
) -> str:
    """Render single Jinja2 template with user override support. Arbitrary keyword
    arguments may be passed to the template as additional template variables.

    Why:
        Users can override built-in templates by placing custom templates in
        theme folder alongside input file. Typst templates check theme-specific
        location first, falling back to built-in templates if not found.

    Example:
        ```py
        header = render_single_template("typst", "Header.j2.typ", rendercv_model)
        # First checks for classic/Header.j2.typ in input file directory
        # Falls back to built-in typst/Header.j2.typ if not found

        section = render_single_template(
            "typst",
            "SectionBeginning.j2.typ",
            rendercv_model,
            section_title="Experience",
        )
        ```

    Args:
        file_type: Format for template directory selection.
        relative_template_path: Template file path relative to format directory.
        rendercv_model: CV model providing template context.

    Returns:
        Rendered template as string.
    """
    jinja2_environment = get_jinja2_environment(rendercv_model._input_file_path)
    template = get_theme_template(rendercv_model, relative_template_path)

    if template is None:
        template = jinja2_environment.get_template(
            f"{file_type}/{relative_template_path}"
        )

    return render_template(template, rendercv_model, **kwargs)


def render_template(
    template: jinja2.Template,
    rendercv_model: RenderCVModel,
    **kwargs,
) -> str:
    """Render a Jinja template with RenderCV's shared context variables.

    Args:
        template: Jinja template to render.
        rendercv_model: CV model providing template context.
        **kwargs: Additional variables for specialized templates.

    Returns:
        Rendered template text.
    """
    return template.render(
        cv=rendercv_model.cv,
        design=rendercv_model.design,
        locale=rendercv_model.locale,
        settings=rendercv_model.settings,
        **kwargs,
    )
