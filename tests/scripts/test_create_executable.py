import pathlib


def test_pyinstaller_collects_browser_renderer_dependencies():
    script_path = pathlib.Path(__file__).parents[2] / "scripts" / "create_executable.py"
    script = script_path.read_text(encoding="utf-8")

    assert '"playwright"' in script
    assert '"pymupdf"' in script
