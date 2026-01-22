#!/usr/bin/env ruby
# frozen_string_literal: true

require "bundler/setup"
require "vibe_render"

# Example 1: Simple PNG screenshot using convenience method
puts "Example 1: Rendering example.com as PNG..."
png_data = VibeRender.render("https://example.com", format: :png)
File.binwrite("example_simple.png", png_data)
puts "  ✓ Saved to example_simple.png (#{png_data.bytesize} bytes)"

# Example 2: JPEG screenshot with custom quality
puts "\nExample 2: Rendering example.com as JPEG with quality 90..."
jpeg_data = VibeRender.render("https://example.com", format: :jpeg, quality: 90)
File.binwrite("example_quality.jpg", jpeg_data)
puts "  ✓ Saved to example_quality.jpg (#{jpeg_data.bytesize} bytes)"

# Example 3: Using renderer instance for multiple renders
puts "\nExample 3: Multiple screenshots with renderer instance..."
renderer = VibeRender::Renderer.new

# Full page screenshot
renderer.render_png("https://example.com", 
  path: "example_fullpage.png",
  full_page: true
)
puts "  ✓ Saved full page screenshot to example_fullpage.png"

# Custom viewport size
renderer.render_png("https://example.com",
  path: "example_1920x1080.png",
  viewport: { width: 1920, height: 1080 }
)
puts "  ✓ Saved 1920x1080 screenshot to example_1920x1080.png"

renderer.close

puts "\n✓ All screenshots complete!"
puts "Files created:"
puts "  - example_simple.png"
puts "  - example_quality.jpg"
puts "  - example_fullpage.png"
puts "  - example_1920x1080.png"
