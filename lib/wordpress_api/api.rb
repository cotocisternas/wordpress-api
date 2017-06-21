require 'httparty'
require 'wordpress_api/parser'

class WordpressApi::API
  include HTTParty
  headers 'Accept' => 'application/json', 'Content-Type' => 'text/json'
  format :json
  parser WordpressApi::Parser

  ENDPOINTS = {
      posts: 'posts'
  }.freeze

  def self.headers_for(length)
    {
        'Date' => Time.now.httpdate(),
        'User-Agent' => user_agent_string,
        "Content-Length" => length.to_s
    }
  end

  private

  def self.user_agent_string
    "(Rubygems; Ruby #{RUBY_VERSION} #{RUBY_PLATFORM})"
  end
end
