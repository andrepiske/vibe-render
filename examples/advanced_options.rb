#!/usr/bin/env ruby
# frozen_string_literal: true

require "bundler/setup"
require "vibe_render"

puts "Advanced VibeRender Options\n\n"

# Example 1: Custom browser configuration
puts "Example 1: Custom browser configuration..."
renderer = VibeRender::Renderer.new(
  headless: true,
  timeout: 60,
  browser_options: {
    window_size: [1920, 1080]
  }
)

renderer.render_png("https://example.com", path: "advanced_custom.png")
puts "  ✓ Rendered with custom browser settings"
renderer.close

# Example 2: High quality JPEG for printing
puts "\nExample 2: High quality JPEG (quality: 95)..."
renderer = VibeRender::Renderer.new

renderer.render_jpeg("https://example.com",
  path: "advanced_highquality.jpg",
  quality: 95,
  viewport: { width: 2560, height: 1440 }
)
puts "  ✓ Saved high quality JPEG (2560x1440)"

# Example 3: Full page screenshot with wait
puts "\nExample 3: Full page screenshot with wait time..."
renderer.render_png("https://example.com",
  path: "advanced_fullpage_wait.png",
  full_page: true,
  wait: 1.5
)
puts "  ✓ Saved full page screenshot with 1.5s wait"

renderer.close

puts "\n✓ Advanced examples complete!"
puts "Files created:"
puts "  - advanced_custom.png"
puts "  - advanced_highquality.jpg"
puts "  - advanced_fullpage_wait.png"
