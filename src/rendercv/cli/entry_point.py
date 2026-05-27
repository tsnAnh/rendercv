"""Entry point for the CVFactori CLI.

Why:
    Users might install CVFactori with `pip install cvfactori` instead of
    `pip install cvfactori[full]`. This module catches that case and shows a helpful
    error message instead of a confusing `ImportError`.
"""

import sys


def entry_point() -> None:
    """Entry point for the CVFactori CLI."""
    try:
        from .app import app as cli_app  # NOQA: PLC0415
    except ImportError:
        error_message = """
It looks like you installed CVFactori with:

    pip install cvfactori

But CVFactori needs to be installed with:

    pip install "cvfactori[full]"

Please reinstall with the correct command above.
"""
        sys.stderr.write(error_message)
        raise SystemExit(1) from None

    cli_app()
