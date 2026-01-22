# frozen_string_literal: true

require "ferrum"

module VibeRender
  # The main renderer class that uses Ferrum to control Chrome/Chromium
  class Renderer
    DEFAULT_VIEWPORT = { width: 1280, height: 720 }.freeze
    DEFAULT_TIMEOUT = 30
    
    # @param headless [Boolean] Run browser in headless mode (default: true)
    # @param browser_options [Hash] Additional options to pass to Ferrum browser
    # @param timeout [Integer] Default timeout in seconds (default: 30)
    def initialize(headless: true, browser_options: {}, timeout: DEFAULT_TIMEOUT)
      @timeout = timeout
      
      # Build base options
      base_options = {
        headless: headless,
        timeout: timeout,
        process_timeout: 30,  # Give Chrome more time to start in CI
        browser_options: ci_browser_args
      }
      
      # Use custom Chrome path in CI if provided
      base_options[:browser_path] = ENV["BROWSER_PATH"] if ENV["BROWSER_PATH"]
      
      @browser_options = base_options.merge(browser_options)
      @browser = nil
    end
    
    # Render a webpage as PNG
    # @param url [String] The URL to render
    # @param path [String, nil] Optional file path to save the screenshot
    # @param full_page [Boolean] Capture full page screenshot (default: false)
    # @param viewport [Hash] Viewport dimensions (default: 1280x720)
    # @param wait [Float] Time to wait after page load in seconds
    # @return [String] Binary PNG data (or nil if path is provided)
    def render_png(url, path: nil, full_page: false, viewport: DEFAULT_VIEWPORT, wait: nil)
      browser.goto(url)
      wait_after_load(wait)
      
      screenshot_options = { format: :png, full: full_page, encoding: :binary }
      screenshot_options[:path] = path if path
      
      result = browser.screenshot(**screenshot_options)
      decode_if_base64(result)
    end
    
    # Render a webpage as JPEG
    # @param url [String] The URL to render
    # @param path [String, nil] Optional file path to save the screenshot
    # @param quality [Integer] JPEG quality 0-100 (default: 75)
    # @param full_page [Boolean] Capture full page screenshot (default: false)
    # @param viewport [Hash] Viewport dimensions (default: 1280x720)
    # @param wait [Float] Time to wait after page load in seconds
    # @return [String] Binary JPEG data (or nil if path is provided)
    def render_jpeg(url, path: nil, quality: 75, full_page: false, viewport: DEFAULT_VIEWPORT, wait: nil)
      browser.goto(url)
      wait_after_load(wait)
      
      screenshot_options = { format: :jpeg, quality: quality, full: full_page, encoding: :binary }
      screenshot_options[:path] = path if path
      
      result = browser.screenshot(**screenshot_options)
      decode_if_base64(result)
    end
    
    # Render a webpage as PDF
    # @param url [String] The URL to render
    # @param path [String, nil] Optional file path to save the PDF
    # @param landscape [Boolean] Use landscape orientation (default: false)
    # @param paper_size [Hash] Paper dimensions (default: Letter size)
    # @param wait [Float] Time to wait after page load in seconds
    # @return [String] Binary PDF data (or nil if path is provided)
    def render_pdf(url, path: nil, landscape: false, paper_size: nil, wait: nil)
      browser.goto(url)
      wait_after_load(wait)
      
      pdf_options = { landscape: landscape, encoding: :binary }
      pdf_options[:path] = path if path
      pdf_options[:paper_size] = paper_size if paper_size
      
      result = browser.pdf(**pdf_options)
      decode_if_base64(result)
    end
    
    # Close the browser instance
    def close
      @browser&.quit
      @browser = nil
    end
    
    private
    
    def browser
      @browser ||= Ferrum::Browser.new(**@browser_options)
    end
    
    def wait_after_load(wait_time)
      sleep(wait_time) if wait_time && wait_time > 0
    end
    
    def decode_if_base64(data)
      return data if data.nil? # When path is provided, returns nil
      
      # Check if data looks like base64 (no binary characters in first few bytes)
      # PNG starts with \x89PNG, JPEG with \xFF\xD8, PDF with %PDF
      if data.is_a?(String) && data.encoding == Encoding::US_ASCII && !data.start_with?("\x89PNG", "\xFF\xD8".b, "%PDF")
        require "base64"
        Base64.decode64(data)
      else
        data
      end
    end
    
    def ci_browser_args
      # Chrome flags needed for CI environments (especially GitHub Actions)
      return {} unless ENV["CI"]
      
      {
        "no-sandbox" => nil,
        "disable-dev-shm-usage" => nil,
        "disable-gpu" => nil,
        "disable-software-rasterizer" => nil
      }
    end
  end
end
