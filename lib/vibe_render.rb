# frozen_string_literal: true

require_relative "vibe_render/version"
require_relative "vibe_render/renderer"

module VibeRender
  class Error < StandardError; end
  
  # Convenience method to create a renderer and render in one call
  # @param url [String] The URL to render
  # @param format [Symbol] The output format (:png, :jpeg, or :pdf)
  # @param options [Hash] Additional options for rendering
  # @return [String] Binary data of the rendered output
  def self.render(url, format: :png, **options)
    renderer = Renderer.new(**options)
    begin
      case format
      when :png
        renderer.render_png(url, **options)
      when :jpeg, :jpg
        renderer.render_jpeg(url, **options)
      when :pdf
        renderer.render_pdf(url, **options)
      else
        raise Error, "Unsupported format: #{format}. Use :png, :jpeg, or :pdf"
      end
    ensure
      renderer.close
    end
  end
end
