# VibeRender - Project Structure

## Overview
VibeRender is a Ruby gem that provides a code API for rendering webpages as images (PNG, JPEG) or PDF files using Chrome/Chromium via the Ferrum gem.

## Project Structure

```
vibe-render/
├── .github/
│   └── workflows/
│       └── ci.yml              # GitHub Actions CI workflow
├── bin/
│   └── setup                   # Setup script for development
├── examples/
│   ├── README.md               # Examples documentation
│   ├── basic_screenshot.rb     # Basic PNG/JPEG examples
│   ├── pdf_generation.rb       # PDF generation examples
│   ├── advanced_options.rb     # Advanced usage examples
│   └── local_html.rb           # Local HTML rendering examples
├── lib/
│   ├── vibe_render.rb          # Main gem entry point
│   └── vibe_render/
│       ├── version.rb          # Gem version
│       └── renderer.rb         # Core renderer implementation
├── test/
│   ├── test_helper.rb          # Test configuration
│   ├── vibe_render_test.rb     # Basic gem tests
│   └── renderer_test.rb        # Renderer functionality tests
├── .gitattributes              # Git attributes configuration
├── .gitignore                  # Git ignore patterns
├── .ruby-version               # Ruby version for rbenv
├── .tool-versions              # Ruby version for mise/asdf
├── CHANGELOG.md                # Project changelog
├── Gemfile                     # Gem dependencies
├── LICENSE.txt                 # MIT License
├── Rakefile                    # Rake tasks (test, build)
├── README.md                   # Main documentation
└── vibe_render.gemspec         # Gem specification
```

## Key Features

### 1. Core Rendering API
- `VibeRender.render(url, format:, **options)` - Convenience method
- `VibeRender::Renderer` - Reusable renderer class
- Support for PNG, JPEG, and PDF formats
- Configurable viewport, quality, paper size, and more

### 2. Testing
- Uses Minitest (as requested, not RSpec)
- Comprehensive test coverage
- Tests for PNG, JPEG, and PDF rendering
- Format validation and error handling tests

### 3. CI/CD
- GitHub Actions workflow configured
- Runs on Ruby 3.4.8
- Installs Chrome/Chromium for testing
- Automated test execution

### 4. Documentation
- Comprehensive README with examples
- API reference
- Example scripts for common use cases
- Setup instructions

## Getting Started

1. Install dependencies:
   ```bash
   ./bin/setup
   # or manually:
   bundle install
   ```

2. Run tests:
   ```bash
   bundle exec rake test
   ```

3. Try examples:
   ```bash
   ruby examples/basic_screenshot.rb
   ```

4. Build the gem:
   ```bash
   bundle exec rake build
   ```

## Dependencies

### Runtime
- `ferrum` (~> 0.15) - Chrome/Chromium automation

### Development
- `minitest` (~> 5.0) - Testing framework
- `rake` (~> 13.0) - Build automation

## Ruby Version
- Required: Ruby >= 3.4.8
- Configured in `.tool-versions` for mise
- Configured in `.ruby-version` for rbenv

## API Summary

### Convenience Method
```ruby
VibeRender.render(url, format: :png)
```

### Renderer Class
```ruby
renderer = VibeRender::Renderer.new
renderer.render_png(url, **options)
renderer.render_jpeg(url, **options)
renderer.render_pdf(url, **options)
renderer.close
```

## Testing Strategy

Tests cover:
- Version validation
- PNG rendering and format verification
- JPEG rendering with quality options
- PDF generation and format verification
- File output functionality
- Convenience method variations
- Error handling

## CI Pipeline

The GitHub Actions workflow:
1. Checks out the code
2. Sets up Ruby 3.4.8
3. Installs Chrome/Chromium
4. Installs gem dependencies
5. Runs the full test suite
6. Provides verbose output on failure

## License
MIT License - See LICENSE.txt
