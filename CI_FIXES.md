# CI Test Fixes

This document explains the issues encountered when running tests in GitHub Actions CI and how they were resolved.

## Issues Encountered

### 1. Chrome Process Timeout
**Error:** `Browser did not produce websocket url within 10 seconds`

**Cause:** Chrome wasn't starting properly in the GitHub Actions containerized environment.

**Solution:**
- Increased `process_timeout` to 30 seconds
- Added required Chrome flags for CI environments:
  - `--no-sandbox`: Required for running Chrome in containers without sandbox
  - `--disable-dev-shm-usage`: Prevents shared memory issues in limited environments
  - `--disable-gpu`: Disables GPU hardware acceleration
  - `--disable-software-rasterizer`: Improves headless performance
- Set explicit Chrome binary path via `BROWSER_PATH` environment variable

### 2. Base64 Encoding Issue
**Error:** Binary data assertions failed (e.g., expected `"\x89PNG"` but got `"iVBO"`)

**Cause:** Ferrum in CI was returning base64-encoded data instead of binary data, despite the `encoding: :binary` option.

**Solution:**
- Added `decode_if_base64()` helper method that:
  - Detects if data is base64-encoded (US-ASCII encoding without binary magic bytes)
  - Automatically decodes base64 data back to binary
  - Preserves nil return value when saving to file
  - Works transparently in both local and CI environments

### 3. Tempfile Access Issue
**Error:** `Request to file:///tmp/test20260122-2175-zdd0rb.html failed (net::ERR_FILE_NOT_FOUND)`

**Cause:** Tempfile was being closed and deleted before Chrome could access it in CI.

**Solution:**
- Changed test setup to keep tempfile reference alive
- Return hash with both tempfile object and URL: `{ tempfile: file, url: "file://..." }`
- Added `file.flush` to ensure content is written to disk
- Clean up tempfile in teardown using `close` and `unlink`

### 4. assert_nothing_raised Deprecation
**Error:** `NoMethodError: undefined method 'assert_nothing_raised'`

**Cause:** `assert_nothing_raised` was removed from Minitest.

**Solution:**
- Removed `assert_nothing_raised` blocks
- Let exceptions naturally bubble up (test fails if exception occurs)
- Added simple `assert true` at end to mark test as passed

### 5. Return Value Inconsistency
**Error:** `Expected 300490 to be nil`

**Cause:** When `path:` option is provided, method should return `nil` but was returning file size.

**Solution:**
- Ensured `decode_if_base64()` preserves nil return value
- Added explicit check: `return data if data.nil?`

## Files Modified

### lib/vibe_render/renderer.rb
- Added `process_timeout: 30` to browser options
- Added `encoding: :binary` to all render methods
- Added `decode_if_base64()` helper method
- Added `ci_browser_args()` method for CI-specific Chrome flags
- Added support for `BROWSER_PATH` environment variable

### test/renderer_test.rb
- Changed `create_test_html` to return hash with tempfile and URL
- Modified setup to keep tempfile reference
- Updated all test methods to use `@test_html_url` instead of `@test_html_file`
- Changed teardown to properly close and unlink tempfile
- Replaced `assert_nothing_raised` with direct method calls
- Added `file.flush` to ensure content is written

### .github/workflows/ci.yml
- Added step to set `BROWSER_PATH` environment variable
- Ensured `CI` environment variable is set for test runs
- Added artifact upload step for rendered test files

## Testing the Fixes Locally

To test the CI configuration locally:

```bash
# Set CI environment variables
export CI=true
export BROWSER_PATH=/path/to/chrome  # Optional, usually auto-detected

# Run tests
bundle exec rake test
```

This will:
- Apply CI-specific Chrome flags
- Generate test artifacts in `test/artifacts/`
- Use the same configuration as GitHub Actions

## Results

After these fixes:
- ✅ Chrome starts successfully in CI
- ✅ All binary data assertions pass
- ✅ Tempfiles are accessible to Chrome
- ✅ Tests work in both local and CI environments
- ✅ Rendered artifacts are saved and uploadable
- ✅ Return values are consistent

All tests should now pass in GitHub Actions, and rendered files will be available as downloadable artifacts.
