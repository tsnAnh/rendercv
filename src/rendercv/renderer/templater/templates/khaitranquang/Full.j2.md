{% set header_section = cv | section_by_title("Header Details") %}
{% set header_entry = header_section.entries[0] if header_section and header_section.entries else none %}
{% set education = (cv | section_by_title("Sidebar Education")) or (cv | section_by_title("Education")) %}
{% set skills = (cv | section_by_title("Sidebar Technical Skills")) or (cv | section_by_title("Skills")) %}
{% set english = cv | section_by_title("Sidebar English Proficiency") %}
{% set objective = cv | section_by_title("Sidebar Career Objective") %}
{% set summary = (cv | section_by_title("Summary")) or (cv | section_by_title("Welcome to RenderCV")) %}
{% set ai = cv | section_by_title("AI Strategy & Innovation") %}
{% set experience = cv | section_by_title("Experience") %}
{% set rendered_section_titles = [
    "Header Details",
    "Sidebar Education",
    "Sidebar Technical Skills",
    "Sidebar English Proficiency",
    "Sidebar Career Objective",
    "Education",
    "Skills",
    "Summary",
    "Welcome to RenderCV",
    "AI Strategy & Innovation",
    "Experience",
] %}
{% if cv.name %}
# {{ cv.name }}
{% endif %}
{% if cv.headline %}
## {{ cv.headline }}
{% endif %}
{% if header_entry and header_entry.tagline is defined %}
{{ header_entry.tagline }}
{% endif %}

{% if header_entry and header_entry.date_of_birth is defined %}
- Date of Birth: {{ header_entry.date_of_birth }}
{% endif %}
{% if cv.phone %}
- Phone: {{ cv.phone|replace("tel:", "")|replace("-", " ") }}
{% endif %}
{% if cv.email %}
- Email: [{{ cv.email }}](mailto:{{ cv.email }})
{% endif %}
{% if header_entry and header_entry.experience is defined %}
- Experience: {{ header_entry.experience }}
{% endif %}
{% if cv.location %}
- Location: {{ cv.location }}
{% endif %}

{% if education %}
## {{ education.title|replace("Sidebar ", "") }}

{% for entry in education.entries %}
### {{ entry.name if entry.name is defined else entry.institution }}
{% if entry.summary %}
{{ entry.summary }}
{% endif %}
{% if entry.date_string is defined and entry.date_string %}
{{ entry.date_string }}
{% endif %}
{% if entry.badge is defined %}
{{ entry.badge }}
{% endif %}
{% if entry.url is defined %}
[Verify]({{ entry.url }})
{% endif %}

{% endfor %}
{% endif %}
{% if skills %}
## {{ skills.title|replace("Sidebar ", "") }}

{% for entry in skills.entries %}
- **{{ entry.label }}:** {{ entry.details }}
{% endfor %}

{% endif %}
{% if english %}
## {{ english.title|replace("Sidebar ", "") }}

{% for entry in english.entries %}
- **{{ entry.label }}:** {{ entry.details }}{% if entry.percent is defined %} ({{ entry.percent }}%){% endif %}
{% endfor %}

{% endif %}
{% if objective %}
## {{ objective.title|replace("Sidebar ", "") }}

{% for entry in objective.entries %}
- {{ entry }}
{% endfor %}

{% endif %}
{% if summary %}
## {{ summary.title }}

{% if summary.entries and summary.entries[0] is string %}
{% for entry in summary.entries %}
{{ entry }}

{% endfor %}
{% elif summary.entries and summary.entries[0].summary is defined %}
{{ summary.entries[0].summary }}

{% for entry in summary.entries[1:] %}
- **{{ entry.name }}:** {{ entry.summary }}
{% endfor %}
{% endif %}

{% endif %}
{% if ai %}
## {{ ai.title }}

{% for entry in ai.entries %}
{% if entry.summary %}
{{ entry.summary }}
{% endif %}
{% if entry.highlights %}
{% for item in entry.highlights %}
- {{ item }}
{% endfor %}
{% endif %}
{% endfor %}

{% endif %}
{% if experience %}
## {{ experience.title }}

{% for entry in experience.entries %}
### {{ entry|entry_title }}{% if entry.date_string is defined and entry.date_string %} · {{ entry.date_string }}{% endif %}

{% if entry.location or entry.position is defined or entry.team_size is defined %}
{{ entry.location if entry.location else "" }}{% if entry.position is defined %} · {{ entry.position }}{% endif %}{% if entry.team_size is defined %} · {{ entry.team_size }}{% endif %}
{% endif %}

{% if entry.summary %}
**Project:** {{ entry.summary }}
{% endif %}

{% if entry.single_column is defined and entry.highlights %}
{% for item in entry.highlights %}
- {{ item }}
{% endfor %}
{% elif entry.project_management is not defined and entry.technical is not defined and entry.highlights %}
{% for item in entry.highlights %}
- {{ item }}
{% endfor %}
{% else %}
{% if entry.project_management is defined %}
**{{ entry.project_management_title if entry.project_management_title is defined else "Project Management" }}**

{% for item in entry.project_management %}
- {{ item }}
{% endfor %}
{% endif %}
{% if entry.technical is defined %}
**Technical**

{% for item in entry.technical %}
- {{ item }}
{% endfor %}
{% endif %}
{% endif %}
{% if entry.stack is defined %}
**Stack:** {{ entry.stack }}
{% endif %}

{% endfor %}
{% endif %}
{% for section in cv.rendercv_sections %}
{% if section.title not in rendered_section_titles %}
## {{ section.title }}

{% for entry in section.entries %}
{% set entry_title = entry|entry_title %}
{% set details = entry|entry_details %}
{% set highlights = entry|entry_highlights %}
{% if entry is string %}
{{ entry }}

{% else %}
{% if entry_title %}
### {{ entry_title }}{% if entry.date_string is defined and entry.date_string %} · {{ entry.date_string }}{% endif %}

{% endif %}
{% if details %}
{{ details|join(" · ") }}

{% endif %}
{% if entry.summary is defined and entry.summary %}
{{ entry.summary }}

{% endif %}
{% for item in highlights %}
- {{ item }}
{% endfor %}

{% endif %}
{% endfor %}
{% endif %}
{% endfor %}
