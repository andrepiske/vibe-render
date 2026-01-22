#!/usr/bin/env ruby
# frozen_string_literal: true

require "bundler/setup"
require "vibe_render"
require "tmpfile"

puts "Local HTML Rendering Example\n\n"

# Create a temporary HTML file
html_content = <<~HTML
  <!DOCTYPE html>
  <html>
  <head>
    <meta charset="utf-8">
    <title>Local HTML Example</title>
    <style>
      body {
        font-family: 'Arial', sans-serif;
        max-width: 800px;
        margin: 50px auto;
        padding: 20px;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
      }
      h1 {
        font-size: 3em;
        margin-bottom: 0.5em;
        text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
      }
      .card {
        background: rgba(255, 255, 255, 0.1);
        border-radius: 10px;
        padding: 20px;
        margin: 20px 0;
        backdrop-filter: blur(10px);
      }
      .feature {
        margin: 15px 0;
        padding: 10px;
        background: rgba(255, 255, 255, 0.05);
        border-left: 4px solid #ff6b6b;
      }
    </style>
  </head>
  <body>
    <h1>🎨 VibeRender Demo</h1>
    
    <div class="card">
      <h2>Local HTML Rendering</h2>
      <p>This page was created from a string and rendered locally!</p>
    </div>

    <div class="card">
      <h3>Features:</h3>
      <div class="feature">✓ Render local HTML files</div>
      <div class="feature">✓ Full CSS support</div>
      <div class="feature">✓ Modern web standards</div>
      <div class="feature">✓ Beautiful gradients and effects</div>
    </div>

    <div class="card">
      <p><strong>Powered by VibeRender + Ferrum + Chrome</strong></p>
    </div>
  </body>
  </html>
HTML

# Write HTML to temporary file
File.write("local_example.html", html_content)
file_url = "file://#{File.absolute_path('local_example.html')}"

puts "Created temporary HTML file: local_example.html"
puts "Rendering: #{file_url}\n\n"

# Render as PNG
puts "Rendering as PNG..."
VibeRender.render(file_url, 
  format: :png, 
  path: "local_example.png",
  viewport: { width: 1024, height: 768 }
)
puts "  ✓ Saved to local_example.png"

# Render as PDF
puts "\nRendering as PDF..."
VibeRender.render(file_url, 
  format: :pdf, 
  path: "local_example.pdf"
)
puts "  ✓ Saved to local_example.pdf"

puts "\n✓ Local HTML rendering complete!"
puts "Files created:"
puts "  - local_example.html (source)"
puts "  - local_example.png"
puts "  - local_example.pdf"
