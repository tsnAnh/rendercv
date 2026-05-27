import pathlib
import shutil

from rendercv.schema.models.rendercv_model import RenderCVModel


def copy_browser_fonts(output_dir: pathlib.Path) -> None:
    """Copy bundled browser fonts next to staged HTML."""
    fonts_dir = pathlib.Path(__file__).parent / "fonts"
    destination = output_dir / "fonts"
    shutil.copytree(fonts_dir / "Inter", destination / "Inter", dirs_exist_ok=True)
    shutil.copytree(
        fonts_dir / "MaterialSymbols",
        destination / "MaterialSymbols",
        dirs_exist_ok=True,
    )


def copy_browser_photo(rendercv_model: RenderCVModel, output_dir: pathlib.Path) -> None:
    """Copy local CV photo next to staged HTML when present."""
    photo_path = rendercv_model.cv.photo
    if isinstance(photo_path, pathlib.Path):
        destination = output_dir / photo_path.name
        if photo_path != destination:
            shutil.copy(photo_path, destination)


def build_local_font_face_css() -> str:
    """Return local @font-face declarations used by Chromium rendering."""
    return """
@font-face {
    font-family: 'Inter';
    src: url('fonts/Inter/Inter-Regular.ttf') format('truetype');
    font-weight: 300 400;
    font-style: normal;
}
@font-face {
    font-family: 'Inter';
    src: url('fonts/Inter/Inter-Medium.ttf') format('truetype');
    font-weight: 500;
    font-style: normal;
}
@font-face {
    font-family: 'Inter';
    src: url('fonts/Inter/Inter-SemiBold.ttf') format('truetype');
    font-weight: 600;
    font-style: normal;
}
@font-face {
    font-family: 'Inter';
    src: url('fonts/Inter/Inter-Bold.ttf') format('truetype');
    font-weight: 700;
    font-style: normal;
}
@font-face {
    font-family: 'Material Symbols Rounded';
    src: url('fonts/MaterialSymbols/MaterialSymbolsRounded-Filled.ttf')
        format('truetype');
    font-weight: 400;
    font-style: normal;
    font-display: block;
}
"""
