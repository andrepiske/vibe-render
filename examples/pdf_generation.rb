#!/usr/bin/env ruby
# frozen_string_literal: true

require "bundler/setup"
require "vibe_render"

puts "PDF Generation Examples\n\n"

# Example 1: Simple PDF
puts "Example 1: Rendering example.com as PDF..."
pdf_data = VibeRender.render("https://example.com", format: :pdf)
File.binwrite("example_simple.pdf", pdf_data)
puts "  ✓ Saved to example_simple.pdf (#{pdf_data.bytesize} bytes)"

# Example 2: Landscape PDF
puts "\nExample 2: Landscape orientation PDF..."
renderer = VibeRender::Renderer.new

renderer.render_pdf("https://example.com",
  path: "example_landscape.pdf",
  landscape: true
)
puts "  ✓ Saved to example_landscape.pdf"

# Example 3: Wait for content to load
puts "\nExample 3: PDF with wait time (useful for dynamic content)..."
renderer.render_pdf("https://example.com",
  path: "example_waited.pdf",
  wait: 2.0  # Wait 2 seconds for JavaScript to execute
)
puts "  ✓ Saved to example_waited.pdf"

renderer.close

puts "\n✓ All PDFs generated!"
puts "Files created:"
puts "  - example_simple.pdf"
puts "  - example_landscape.pdf"
puts "  - example_waited.pdf"
