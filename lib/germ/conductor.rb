# frozen_string_literal: true

require "faraday"

module Germ
  class Conductor
    def self.call(url)
      new(url).call
    end

    def initialize(url)
      @url = url
    end

    def call
      puts "🌐 fetching article content..."
      content = fetch_content

      puts "📝 building prompt..."
      user_prompt = build_prompt(content)

      puts "⚡ generating xhtml response..."
      xhtml = generate_xhtml(user_prompt)

      puts "📚 generating ebook..."
      result = Ebook.call(xhtml, @url)
      title = result[:title]
      filename = result[:filename]

      puts "📧 sending to kindle..."
      Kindle.call(title, filename)

      puts "🚮 deleting file..."
      File.delete(filename)

      puts "😎 done!"
    end

    private

    def fetch_content
      url = @url.start_with?("http") ? @url : "https://r.jina.ai/#{@url}"
      Faraday.get(url).body
    end

    def build_prompt(content)
      encoding = "UTF-8"
      user_prompt = File.read(File.expand_path("../../user_prompt.md", __dir__), encoding:)

      content = content.force_encoding(encoding)
      user_prompt = user_prompt.gsub("{{ CONTENT }}", content)

      example = File.read(File.expand_path("../../example.html", __dir__), encoding:)
      user_prompt.gsub("{{ EXAMPLE }}", example)
    end

    def generate_xhtml(user_prompt)
      response = Gemini.call(user_prompt)
      response.split("```xhtml", 2).last.split("```", 2).first
    end
  end
end
