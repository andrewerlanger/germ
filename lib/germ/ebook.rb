# frozen_string_literal: true

require "gepub"
require "nokogiri"
require "stringio"

module Germ
  class Ebook
    def self.call(xhtml, url)
      new(xhtml, url).call
    end

    def initialize(xhtml, url)
      @xhtml = xhtml
      @url = url
      @title = fetch_title
      @book = GEPUB::Book.new
    end

    def call
      @book.primary_identifier(@url, "BookID", "URL")
      @book.language = "en"
      @book.add_title(@title, title_type: GEPUB::TITLE_TYPE::MAIN)
      @book.add_creator("Germ Inc.")
      @book.add_date(Time.now.to_s)
      @book.add_item("main.xhtml").add_content(StringIO.new(@xhtml))
      @book.generate_epub(filename)
      {title: @title, filename: filename}
    end

    private

    def fetch_title
      doc = Nokogiri::HTML(@xhtml)
      doc.at_css("title").text.strip
    end

    def filename
      @title + ".epub"
    end
  end
end
