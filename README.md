# VibeRender

[![CI](https://github.com/yourusername/vibe-render/workflows/CI/badge.svg)](https://github.com/yourusername/vibe-render/actions)
[![Gem Version](https://badge.fury.io/rb/vibe_render.svg)](https://badge.fury.io/rb/vibe_render)

VibeRender is a Ruby gem that provides a simple code API for rendering webpages as images (PNG, JPEG) or PDF files using Chrome/Chromium via the Ferrum gem. No HTTP requests or web servers required—just clean, straightforward code.

## Features

- 🖼️ **Screenshot Rendering**: Capture webpages as PNG or JPEG images
- 📄 **PDF Generation**: Convert webpages to PDF documents
- 🎨 **Customizable Options**: Control viewport size, quality, paper size, and more
- 🚀 **Simple API**: Clean, intuitive Ruby interface
- 🔧 **Flexible**: Works with any URL or local HTML file
- ⚡ **Powered by Ferrum**: Uses Chrome/Chromium for accurate rendering

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'vibe_render'
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install vibe_render
```

### Requirements

- Ruby >= 3.4.8
- Chrome or Chromium browser installed on your system

## Usage

### Quick Start

The simplest way to render a webpage:

```ruby
require 'vibe_render'

# Render as PNG (returns binary data)
png_data = VibeRender.render('https://example.com', format: :png)
File.binwrite('output.png', png_data)

# Render as JPEG
jpeg_data = VibeRender.render('https://example.com', format: :jpeg)
File.binwrite('output.jpg', jpeg_data)

# Render as PDF
pdf_data = VibeRender.render('https://example.com', format: :pdf)
File.binwrite('output.pdf', pdf_data)
```

### Using the Renderer Class

For more control and reusability:

```ruby
require 'vibe_render'

# Create a renderer instance
renderer = VibeRender::Renderer.new

# Render PNG screenshot
png_data = renderer.render_png('https://example.com')
File.binwrite('screenshot.png', png_data)

# Save directly to file
renderer.render_png('https://example.com', path: 'screenshot.png')

# Render JPEG with custom quality
renderer.render_jpeg('https://example.com', path: 'screenshot.jpg', quality: 90)

# Render PDF
renderer.render_pdf('https://example.com', path: 'document.pdf')

# Always close the renderer when done
renderer.close
```

### Advanced Options

#### PNG Screenshots

```ruby
renderer.render_png('https://example.com',
  path: 'output.png',           # Optional: save directly to file
  full_page: true,               # Capture entire page (default: false)
  viewport: { width: 1920, height: 1080 },  # Custom viewport
  wait: 2.0                      # Wait 2 seconds after page load
)
```

#### JPEG Screenshots

```ruby
renderer.render_jpeg('https://example.com',
  path: 'output.jpg',
  quality: 85,                   # JPEG quality 0-100 (default: 75)
  full_page: true,
  viewport: { width: 1920, height: 1080 },
  wait: 1.5
)
```

#### PDF Documents

```ruby
renderer.render_pdf('https://example.com',
  path: 'output.pdf',
  landscape: true,               # Landscape orientation (default: false)
  paper_size: { width: 8.5, height: 11 },  # Custom paper size in inches
  wait: 1.0
)
```

### Browser Options

You can customize the browser instance:

```ruby
renderer = VibeRender::Renderer.new(
  headless: true,                # Run in headless mode (default: true)
  timeout: 60,                   # Timeout in seconds (default: 30)
  browser_options: {
    browser_path: '/path/to/chrome',  # Custom browser path
    window_size: [1920, 1080]        # Browser window size
  }
)
```

### Working with Local Files

You can render local HTML files using the `file://` protocol:

```ruby
html_content = <<~HTML
  <!DOCTYPE html>
  <html>
    <head><title>Test</title></head>
    <body><h1>Hello, World!</h1></body>
  </html>
HTML

File.write('test.html', html_content)
VibeRender.render("file://#{File.absolute_path('test.html')}", format: :png)
```

## API Reference

### `VibeRender.render(url, format:, **options)`

Convenience method to render a webpage in one call.

**Parameters:**
- `url` (String): The URL or file path to render
- `format` (Symbol): Output format - `:png`, `:jpeg`, `:jpg`, or `:pdf`
- `**options` (Hash): Additional rendering options (passed to renderer methods)

**Returns:** Binary string data of the rendered output

### `VibeRender::Renderer.new(**options)`

Creates a new renderer instance.

**Parameters:**
- `headless` (Boolean): Run browser in headless mode (default: `true`)
- `timeout` (Integer): Default timeout in seconds (default: `30`)
- `browser_options` (Hash): Additional Ferrum browser options

### `renderer.render_png(url, **options)`

Renders a webpage as PNG.

**Parameters:**
- `url` (String): The URL to render
- `path` (String, nil): Optional file path to save the screenshot
- `full_page` (Boolean): Capture full page screenshot (default: `false`)
- `viewport` (Hash): Viewport dimensions (default: `{width: 1280, height: 720}`)
- `wait` (Float): Time to wait after page load in seconds

**Returns:** Binary PNG data (or `nil` if `path` is provided)

### `renderer.render_jpeg(url, **options)`

Renders a webpage as JPEG.

**Parameters:**
- `url` (String): The URL to render
- `path` (String, nil): Optional file path to save the screenshot
- `quality` (Integer): JPEG quality 0-100 (default: `75`)
- `full_page` (Boolean): Capture full page screenshot (default: `false`)
- `viewport` (Hash): Viewport dimensions (default: `{width: 1280, height: 720}`)
- `wait` (Float): Time to wait after page load in seconds

**Returns:** Binary JPEG data (or `nil` if `path` is provided)

### `renderer.render_pdf(url, **options)`

Renders a webpage as PDF.

**Parameters:**
- `url` (String): The URL to render
- `path` (String, nil): Optional file path to save the PDF
- `landscape` (Boolean): Use landscape orientation (default: `false`)
- `paper_size` (Hash): Paper dimensions (e.g., `{width: 8.5, height: 11}`)
- `wait` (Float): Time to wait after page load in seconds

**Returns:** Binary PDF data (or `nil` if `path` is provided)

### `renderer.close`

Closes the browser instance. Always call this when you're done with the renderer.

## Development

After checking out the repo, run:

```bash
bundle install
```

To run the tests:

```bash
bundle exec rake test
```

To build and install the gem locally:

```bash
bundle exec rake install
```

## Testing

VibeRender uses Minitest for testing. The test suite includes:

- Unit tests for the API
- Integration tests with actual browser rendering
- Format validation tests

Run tests with:

```bash
bundle exec rake test
```

Run with verbose output:

```bash
bundle exec rake test TESTOPTS="-v"
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yourusername/vibe-render.

1. Fork it
2. Create your feature branch (`git checkout -b feature/my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin feature/my-new-feature`)
5. Create a new Pull Request

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Credits

VibeRender is built on top of:
- [Ferrum](https://github.com/rubycdp/ferrum) - High-level API to control Chrome in Ruby
- Chrome/Chromium - For rendering webpages

## Support

If you encounter any issues or have questions:
- Open an issue on [GitHub](https://github.com/yourusername/vibe-render/issues)
- Check the [documentation](https://github.com/yourusername/vibe-render)
