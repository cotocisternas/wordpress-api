require 'hashie/extensions/symbolize_keys'

class WordpressApi::Response::Post < WordpressApi::Types::Stash
  property :id, required: true
  property :date
  property :date_gmt
  property :guid
  property :link
  property :modified
  property :modified_gmt
  property :slug
  property :status
  property :type
  property :password
  property :title
  property :content
  property :author
  property :excerpt
  property :featured_media
  property :comment_status
  property :ping_status
  property :format
  property :meta
  property :sticky
  property :template
  property :categories
  property :tags
  property :liveblog_likes

  def initialize(response)
    super(Hashie::Extensions::SymbolizeKeys.symbolize_keys(response))
  end

  def success?
    !id.blank?
  end
end
