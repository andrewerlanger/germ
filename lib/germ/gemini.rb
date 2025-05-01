# frozen_string_literal: true

module Germ
  class Gemini
    BASE_URL = "https://generativelanguage.googleapis.com/v1beta/models"
    MODEL = "gemini-2.5-pro-preview-03-25"
    TIMEOUT = 60 * 6

    def self.call(user_prompt)
      new(user_prompt).call
    end

    def initialize(user_prompt)
      @user_prompt = user_prompt
    end

    def call
      response = Faraday.post(url) do |req|
        req.headers["Content-Type"] = "application/json"
        req.body = {contents: contents}.to_json
        req.options.timeout = TIMEOUT
      end

      json = JSON.parse(response.body)
      json.dig("candidates", 0, "content", "parts", 0, "text")
    end

    private

    def url
      key = ENV.fetch("GEMINI_API_KEY")
      "#{BASE_URL}/#{MODEL}:generateContent?key=#{key}"
    end

    def contents
      [{parts: [{text: @user_prompt}]}]
    end
  end
end
