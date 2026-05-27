import pathlib
import platform
import shutil
import subprocess
import sys
import tempfile
import zipfile

root_path = pathlib.Path(__file__).parent.parent

platform_names = {
    "linux": "linux",
    "darwin": "macos",
    "win32": "windows",
}

machine_names = {
    "AMD64": "x86_64",
    "x86_64": "x86_64",
    "aarch64": "ARM64",
    "arm64": "ARM64",
}

with tempfile.TemporaryDirectory() as temp_dir:
    temp_path = pathlib.Path(temp_dir)

    # Copy rendercv to temp directory
    shutil.copytree(root_path / "src" / "rendercv", temp_path / "rendercv")

    # Create entry point script
    cvfactori_file = temp_path / "cvfactori.py"
    cvfactori_file.write_text("import rendercv.cli.app as app; app.app()")

    # Run PyInstaller
    subprocess.run(
        [
            sys.executable,
            "-m",
            "PyInstaller",
            "--onefile",
            "--clean",
            "--collect-all",
            "rendercv",
            "--collect-all",
            "rendercv_fonts",
            "--collect-all",
            "playwright",
            "--collect-all",
            "pymupdf",
            "--distpath",
            "bin",
            str(cvfactori_file),
        ],
        check=True,
    )

    # Determine executable name based on platform
    platform_name = platform_names[sys.platform]
    machine_name = machine_names[platform.machine()]

    # Get original and new executable paths
    match sys.platform:
        case "win32":
            original_name = "cvfactori.exe"
            new_name = f"cvfactori-{platform_name}-{machine_name}.exe"
        case _:
            original_name = "cvfactori"
            new_name = f"cvfactori-{platform_name}-{machine_name}"

    original_path = root_path / "bin" / original_name
    executable_path = root_path / "bin" / new_name
    original_path.rename(executable_path)

# Create zip archive with preserved executable permissions
zip_path = executable_path.with_suffix(".zip")

with zipfile.ZipFile(zip_path, "w", zipfile.ZIP_DEFLATED) as zipf:
    zipinfo = zipfile.ZipInfo(executable_path.name)
    # Set Unix executable permissions (rwxr-xr-x) - 0o755 shifted to external_attr position
    zipinfo.external_attr = 0o755 << 16
    zipf.writestr(zipinfo, executable_path.read_bytes())
