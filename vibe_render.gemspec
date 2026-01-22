# frozen_string_literal: true

require_relative "lib/vibe_render/version"

Gem::Specification.new do |spec|
  spec.name = "vibe_render"
  spec.version = VibeRender::VERSION
  spec.authors = ["Your Name"]
  spec.email = ["your.email@example.com"]

  spec.summary = "Render webpages as images (PNG, JPEG) or PDF files using Chrome/Chromium"
  spec.description = "VibeRender provides a simple code API to render webpages as screenshots (PNG, JPEG) or PDF files using Chrome/Chromium via Ferrum"
  spec.homepage = "https://github.com/yourusername/vibe-render"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.4.8"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/yourusername/vibe-render"
  spec.metadata["changelog_uri"] = "https://github.com/yourusername/vibe-render/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir.glob(%w[
    lib/**/*.rb
    LICENSE.txt
    README.md
    CHANGELOG.md
  ])
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Runtime dependencies
  spec.add_dependency "ferrum", "~> 0.17"

  # Development dependencies
  spec.add_development_dependency "minitest", "~> 6.0"
  spec.add_development_dependency "rake", "~> 13.0"
end
