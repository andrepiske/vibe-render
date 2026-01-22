# Test Artifacts in CI

## Overview

The test suite now saves rendered images and PDFs as artifacts when running in CI (GitHub Actions). This allows you to manually inspect the visual output of the rendering tests.

## How It Works

### Test Changes

When the `CI` environment variable is set, the test suite:

1. Creates a `test/artifacts/` directory
2. Saves each rendered file (PNG, JPEG, PDF) to this directory
3. Names files descriptively based on the test name

### CI Environment Configuration

The renderer automatically detects CI environments and applies necessary Chrome configurations:

- **Chrome flags**: Adds `--no-sandbox`, `--disable-dev-shm-usage`, `--disable-gpu`, and `--disable-software-rasterizer` for GitHub Actions compatibility
- **Process timeout**: Increased to 30 seconds to allow Chrome to start properly in CI
- **Browser path**: Uses the Chrome binary installed by `browser-actions/setup-chrome`

These configurations only apply when the `CI` environment variable is set, so local development is unaffected.

### Saved Artifacts

The following test outputs are saved as artifacts:

- `test_render_png.png` - Basic PNG rendering
- `test_render_png_to_file.png` - PNG rendering to file
- `test_render_jpeg.jpg` - Basic JPEG rendering
- `test_render_jpeg_quality_95.jpg` - High quality JPEG
- `test_render_jpeg_quality_20.jpg` - Low quality JPEG
- `test_render_pdf.pdf` - Basic PDF rendering
- `test_render_pdf_to_file.pdf` - PDF rendering to file
- `test_render_pdf_landscape.pdf` - Landscape PDF
- `test_convenience_method_png.png` - PNG via convenience method
- `test_convenience_method_jpeg.jpg` - JPEG via convenience method
- `test_convenience_method_jpg_alias.jpg` - JPG via convenience method
- `test_convenience_method_pdf.pdf` - PDF via convenience method

## Accessing Artifacts in GitHub Actions

After a test run completes (whether successful or failed):

1. Go to the GitHub Actions workflow run page
2. Scroll down to the "Artifacts" section at the bottom
3. Download the `test-rendered-files` artifact
4. Extract the ZIP file to view all rendered files

The artifacts are retained for **30 days** and will be available even if tests fail (due to the `if: always()` condition).

## Local Testing

To generate artifacts locally (for testing purposes):

```bash
CI=true bundle exec rake test
```

This will create the `test/artifacts/` directory with all rendered files, which you can inspect locally.

Note: The `test/artifacts/` directory is ignored by git (added to `.gitignore`).

## Configuration

- **Artifact name**: `test-rendered-files`
- **Retention period**: 30 days
- **Upload condition**: Always (even on test failures)
- **Files saved**: Only when `CI` environment variable is set
