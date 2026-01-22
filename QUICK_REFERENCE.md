# VibeRender Quick Reference

## Installation

```bash
gem install vibe_render
# or add to Gemfile:
gem 'vibe_render'
```

## Basic Usage

### One-line Rendering

```ruby
require 'vibe_render'

# PNG
VibeRender.render('https://example.com', format: :png)

# JPEG
VibeRender.render('https://example.com', format: :jpeg)

# PDF
VibeRender.render('https://example.com', format: :pdf)
```

### Renderer Instance

```ruby
renderer = VibeRender::Renderer.new

# Render and get binary data
png_data = renderer.render_png('https://example.com')

# Render directly to file
renderer.render_png('https://example.com', path: 'output.png')

# Always close when done
renderer.close
```

## Common Options

### PNG Options
```ruby
render_png(url,
  path: 'output.png',              # Save to file
  full_page: true,                 # Capture full page
  viewport: { width: 1920, height: 1080 },
  wait: 2.0                        # Wait seconds after load
)
```

### JPEG Options
```ruby
render_jpeg(url,
  path: 'output.jpg',
  quality: 90,                     # 0-100
  full_page: true,
  viewport: { width: 1920, height: 1080 },
  wait: 1.5
)
```

### PDF Options
```ruby
render_pdf(url,
  path: 'output.pdf',
  landscape: true,                 # Orientation
  paper_size: { width: 8.5, height: 11 },
  wait: 1.0
)
```

## Browser Configuration

```ruby
VibeRender::Renderer.new(
  headless: true,                  # Headless mode
  timeout: 60,                     # Timeout in seconds
  browser_options: {
    browser_path: '/path/to/chrome',
    window_size: [1920, 1080]
  }
)
```

## File URLs

```ruby
# Render local HTML files
file_path = File.absolute_path('page.html')
VibeRender.render("file://#{file_path}", format: :png)
```

## Development Commands

```bash
# Setup
./bin/setup

# Run tests
bundle exec rake test

# Build gem
bundle exec rake build

# Install locally
bundle exec rake install

# Run examples
ruby examples/basic_screenshot.rb
```

## Error Handling

```ruby
begin
  data = VibeRender.render(url, format: :png)
rescue VibeRender::Error => e
  puts "Rendering failed: #{e.message}"
end
```

## Tips

1. **Always close renderers** when done to free resources
2. **Use `wait` option** for JavaScript-heavy pages
3. **Use `full_page: true`** to capture entire scrollable content
4. **Adjust JPEG quality** to balance file size and image quality
5. **Set custom viewport** for responsive design testing

## Requirements

- Ruby >= 3.4.8
- Chrome or Chromium browser installed
