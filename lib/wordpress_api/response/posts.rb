require 'hashie/extensions/symbolize_keys'
require 'wordpress_api/types'

module WordpressApi
  module Response
    class Posts < WordpressApi::Types::Stash
      property :articles, from: Posts

      def initialize(response)
        self.articles = []
        response.parsed_response.each do |post|
          post = Hashie::Extensions::SymbolizeKeys.symbolize_keys(post)
          self.articles << Post.new(post)
        end

        super()
      end

      def Posts=(response)
        puts "Ran the Posts method"
      end

      def success?
        !self.articles.blank?
      end
    end
  end
end

