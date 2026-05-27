import contextlib
import pathlib
from typing import Literal, Unpack

import jinja2

from rendercv.exception import RenderCVUserError, RenderCVUserValidationError
from rendercv.schema.rendercv_model_builder import (
    BuildRendercvModelArguments,
    build_rendercv_dictionary_and_model,
    read_yaml_with_validation_errors,
)

from .progress_panel import ProgressPanel
from .render_outputs import render_outputs
from .run_timing import timed_step


def collect_input_file_paths(
    input_file_path: pathlib.Path,
    design: pathlib.Path | None = None,
    locale: pathlib.Path | None = None,
    settings: pathlib.Path | None = None,
) -> dict[Literal["input", "design", "locale", "settings"], pathlib.Path]:
    """Collect all input file paths involved in a render.

    Why:
        A render may involve multiple files: the main YAML, plus overlay
        files for design/locale/settings provided via CLI flags or referenced
        in settings.render_command. Watch mode needs this complete list to
        monitor all of them for changes, and the render pipeline needs the
        resolved paths to read overlay file contents.

    Args:
        input_file_path: Path to the main YAML input file.
        design: CLI-provided design file path.
        locale: CLI-provided locale file path.
        settings: CLI-provided settings file path.

    Returns:
        Mapping from role ("input", "design", "locale", "settings") to path.
    """
    files: dict[Literal["input", "design", "locale", "settings"], pathlib.Path] = {
        "input": input_file_path
    }

    if design:
        files["design"] = design
    if locale:
        files["locale"] = locale
    if settings:
        files["settings"] = settings

    # Also include design/locale files referenced in the YAML itself
    # (CLI flags take precedence, so skip if already provided).
    # If YAML is invalid, watch mode should still start by watching the main file.
    with contextlib.suppress(RenderCVUserValidationError):
        main_dict = read_yaml_with_validation_errors(
            input_file_path.read_text(encoding="utf-8"),
            "main_yaml_file",
        )
        rc = main_dict.get("settings", {}).get("render_command", {})
        if "design" not in files and rc.get("design"):
            files["design"] = (input_file_path.parent / rc["design"]).resolve()
        if "locale" not in files and rc.get("locale"):
            files["locale"] = (input_file_path.parent / rc["locale"]).resolve()

    return files


def run_rendercv(
    input_file_path: pathlib.Path,
    progress: ProgressPanel,
    **kwargs: Unpack[BuildRendercvModelArguments],
) -> None:
    """Execute complete CV generation pipeline with progress tracking and error handling.

    Args:
        input_file_path: Path to the main YAML input file.
        progress: Progress panel for output display.
        kwargs: Optional YAML overlay strings, output paths, and generation flags.
    """
    try:
        main_yaml = input_file_path.read_text(encoding="utf-8")

        _, rendercv_model = timed_step(
            "Validated the input file",
            progress,
            build_rendercv_dictionary_and_model,
            main_yaml,
            input_file_path=input_file_path,
            **kwargs,
        )
        render_outputs(rendercv_model, progress)
        progress.finish_progress()
    except RenderCVUserError as e:
        progress.print_user_error(e)
    except jinja2.exceptions.TemplateSyntaxError as e:
        progress.print_user_error(
            RenderCVUserError(
                message=(
                    f"There is a problem with the template ({e.filename}) at line"
                    f" {e.lineno}!\n\n{e}"
                )
            )
        )
    except OSError as e:
        progress.print_user_error(RenderCVUserError(message=f"OS Error: {e}"))
    except RenderCVUserValidationError as e:
        progress.print_validation_errors(e.validation_errors)
