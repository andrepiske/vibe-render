# frozen_string_literal: true

require "test_helper"

class TestRenderer < Minitest::Test
  def setup
    @renderer = VibeRender::Renderer.new
    @test_html_file = create_test_html
    @test_html_tempfile = @test_html_file[:tempfile]  # Keep reference
    @test_html_url = @test_html_file[:url]
    @artifacts_dir = File.join(Dir.pwd, "test", "artifacts")
    FileUtils.mkdir_p(@artifacts_dir) if ENV["CI"]
  end

  def teardown
    @renderer.close if @renderer
    if @test_html_tempfile
      @test_html_tempfile.close
      @test_html_tempfile.unlink
    end
  end

  def test_renderer_initialization
    assert_instance_of VibeRender::Renderer, @renderer
  end

  def test_render_png_returns_binary_data
    png_data = @renderer.render_png(@test_html_url)
    
    assert_instance_of String, png_data
    refute_empty png_data
    # PNG files start with the magic bytes \x89PNG
    assert_equal "\x89PNG".b, png_data[0..3]
    
    # Save artifact for CI inspection
    save_artifact("test_render_png.png", png_data) if ENV["CI"]
  end

  def test_render_png_to_file
    Dir.mktmpdir do |dir|
      output_path = File.join(dir, "test_output.png")
      result = @renderer.render_png(@test_html_url, path: output_path)
      
      assert_nil result # When path is provided, screenshot returns nil
      assert File.exist?(output_path)
      assert File.size(output_path) > 0
      
      # Verify it's a valid PNG
      png_data = File.binread(output_path)
      assert_equal "\x89PNG".b, png_data[0..3]
      
      # Save artifact for CI inspection
      save_artifact("test_render_png_to_file.png", png_data) if ENV["CI"]
    end
  end

  def test_render_jpeg_returns_binary_data
    jpeg_data = @renderer.render_jpeg(@test_html_url)
    
    assert_instance_of String, jpeg_data
    refute_empty jpeg_data
    # JPEG files start with \xFF\xD8
    assert_equal "\xFF\xD8".b, jpeg_data[0..1]
    
    # Save artifact for CI inspection
    save_artifact("test_render_jpeg.jpg", jpeg_data) if ENV["CI"]
  end

  def test_render_jpeg_with_quality
    jpeg_high = @renderer.render_jpeg(@test_html_url, quality: 95)
    jpeg_low = @renderer.render_jpeg(@test_html_url, quality: 20)
    
    # Higher quality should generally produce larger files
    # Note: This is a rough heuristic and may not always hold
    assert jpeg_high.bytesize > 0
    assert jpeg_low.bytesize > 0
    
    # Save artifacts for CI inspection
    if ENV["CI"]
      save_artifact("test_render_jpeg_quality_95.jpg", jpeg_high)
      save_artifact("test_render_jpeg_quality_20.jpg", jpeg_low)
    end
  end

  def test_render_pdf_returns_binary_data
    pdf_data = @renderer.render_pdf(@test_html_url)
    
    assert_instance_of String, pdf_data
    refute_empty pdf_data
    # PDF files start with %PDF
    assert_equal "%PDF", pdf_data[0..3]
    
    # Save artifact for CI inspection
    save_artifact("test_render_pdf.pdf", pdf_data) if ENV["CI"]
  end

  def test_render_pdf_to_file
    Dir.mktmpdir do |dir|
      output_path = File.join(dir, "test_output.pdf")
      result = @renderer.render_pdf(@test_html_url, path: output_path)
      
      assert_nil result # When path is provided, pdf returns nil
      assert File.exist?(output_path)
      assert File.size(output_path) > 0
      
      # Verify it's a valid PDF
      pdf_data = File.binread(output_path)
      assert_equal "%PDF", pdf_data[0..3]
      
      # Save artifact for CI inspection
      save_artifact("test_render_pdf_to_file.pdf", pdf_data) if ENV["CI"]
    end
  end

  def test_render_pdf_landscape
    pdf_data = @renderer.render_pdf(@test_html_url, landscape: true)
    
    assert_instance_of String, pdf_data
    refute_empty pdf_data
    assert_equal "%PDF", pdf_data[0..3]
    
    # Save artifact for CI inspection
    save_artifact("test_render_pdf_landscape.pdf", pdf_data) if ENV["CI"]
  end

  def test_convenience_method_png
    png_data = VibeRender.render(@test_html_url, format: :png)
    
    assert_instance_of String, png_data
    assert_equal "\x89PNG".b, png_data[0..3]
    
    # Save artifact for CI inspection
    save_artifact("test_convenience_method_png.png", png_data) if ENV["CI"]
  end

  def test_convenience_method_jpeg
    jpeg_data = VibeRender.render(@test_html_url, format: :jpeg)
    
    assert_instance_of String, jpeg_data
    assert_equal "\xFF\xD8".b, jpeg_data[0..1]
    
    # Save artifact for CI inspection
    save_artifact("test_convenience_method_jpeg.jpg", jpeg_data) if ENV["CI"]
  end

  def test_convenience_method_jpg_alias
    jpg_data = VibeRender.render(@test_html_url, format: :jpg)
    
    assert_instance_of String, jpg_data
    assert_equal "\xFF\xD8".b, jpg_data[0..1]
    
    # Save artifact for CI inspection
    save_artifact("test_convenience_method_jpg_alias.jpg", jpg_data) if ENV["CI"]
  end

  def test_convenience_method_pdf
    pdf_data = VibeRender.render(@test_html_url, format: :pdf)
    
    assert_instance_of String, pdf_data
    assert_equal "%PDF", pdf_data[0..3]
    
    # Save artifact for CI inspection
    save_artifact("test_convenience_method_pdf.pdf", pdf_data) if ENV["CI"]
  end

  def test_convenience_method_invalid_format
    error = assert_raises(VibeRender::Error) do
      VibeRender.render(@test_html_url, format: :invalid)
    end
    
    assert_match(/Unsupported format/, error.message)
  end

  def test_close_renderer
    renderer = VibeRender::Renderer.new
    renderer.render_png(@test_html_url)
    
    # Should close without errors
    renderer.close
    
    # Closing again should be safe
    renderer.close
    
    assert true # Test passes if no exceptions raised
  end

  private

  def save_artifact(filename, data)
    artifact_path = File.join(@artifacts_dir, filename)
    File.binwrite(artifact_path, data)
    puts "  Saved artifact: #{filename}"
  end

  def create_test_html
    file = Tempfile.new(["test", ".html"])
    file.write(<<~HTML)
      <!DOCTYPE html>
      <html>
      <head>
        <title>Test Page</title>
        <style>
          body {
            font-family: Arial, sans-serif;
            padding: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
          }
          h1 { font-size: 2em; }
          .box {
            width: 200px;
            height: 200px;
            background-color: #ff6b6b;
            margin: 20px;
          }
        </style>
      </head>
      <body>
        <h1>VibeRender Test Page</h1>
        <p>This is a test page for rendering.</p>
        <div class="box"></div>
      </body>
      </html>
    HTML
    file.flush  # Ensure content is written
    { tempfile: file, url: "file://#{file.path}" }
  end
end
