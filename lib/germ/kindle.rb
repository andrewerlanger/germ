# frozen_string_literal: true

require "net/smtp"

module Germ
  class Kindle
    def self.call(title, filename)
      new(title, filename).call
    end

    def initialize(title, filename)
      @title = title
      @filename = filename
      @from = ENV.fetch("APP_EMAIL")
      @to = ENV.fetch("KINDLE_EMAIL")
      @password = ENV.fetch("APP_EMAIL_PASSWORD")
    end

    def call
      smtp = Net::SMTP.new("smtp.gmail.com", 587)
      smtp.enable_starttls
      prefix, domain = @from.split("@")

      args = [domain, prefix, @password, :login]
      smtp.start(*args) { smtp.send_message(message, @from, @to) }
    end

    private

    def message
      <<~MESSAGE
        From: #{@from}
        To: #{@to}
        Subject: #{@title}
        MIME-Version: 1.0
        Content-Type: multipart/mixed; boundary=BOUNDARY

        --BOUNDARY
        Content-Type: application/epub+zip
        Content-Transfer-Encoding: base64
        Content-Disposition: attachment; filename="#{@filename}"

        #{[File.read(@filename)].pack("m")}
        --BOUNDARY--
      MESSAGE
    end
  end
end
