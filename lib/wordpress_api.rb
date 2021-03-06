require 'wordpress_api/errors'
require 'wordpress_api/configuration'

require 'wordpress_api/api'

require 'wordpress_api/types'
require 'wordpress_api/request'
require 'wordpress_api/response'


module WordpressApi
  attr_accessor :configuration

  ERROR_MESSAGES = {
      timeout: "Request has timed out."
  }.freeze

  def self.configuration
    @configuration ||= WordpressApi::Configuration.new
    yield @configuration if block_given?
    @configuration
  end

  def self.configuration=(configuration)
    raise ArgumentError, 'Expected a Wordpress::Configuration instance' unless configuration.kind_of?(Configuration)
    @configuration = configuration
  end

  def self.configure(&block)
    configuration(&block)
  end

  def self.timeout
    configuration.timeout
  end

  def self.timeout=(timeout)
    configuration.timeout = timeout
  end

  def self.read_timeout
    configuration.read_timeout
  end

  def self.read_timeout=(read_timeout)
    configuration.read_timeout = read_timeout
  end

  def self.open_timeout
    configuration.open_timeout
  end

  def self.open_timeout=(open_timeout)
    configuration.open_timeout = open_timeout
  end

  def self.endpoint
    configuration.endpoint
  end
  def self.endpoint=(endpoint)
    configuration.endpoint = endpoint
  end

  def self.username
    configuration.username
  end
  def self.username=(username)
    configuration.username = username
  end

  def self.password
    configuration.password
  end
  def self.password=(password)
    configuration.password = password
  end

  def self.version
    configuration.version
  end
  def self.version=(version)
    configuration.version = version
  end

  def self.get(opts = {})
    response = WordpressApi::API.get(
        statement(opts),
        {
            headers: WordpressApi::API.headers_for('0'),
            basic_auth: authentication
        }.merge!(net_settings)
    )
    get_response(opts, response)
  rescue Timeout::Error
    puts ERROR_MESSAGES[:timeout]
    raise TimeoutError
  end

  def self.post(opts = {})
    raise EndpointNotSupportedError unless opts[:id]

    response = WordpressApi::API.post(
        statement(opts),
        {
            headers: WordpressApi::API.headers_for('0'),
            # TODO: Confirm auth requirements for post/put methods
            basic_auth: authentication
        }.merge!(net_settings)
    )

    # TODO: Update external sources here (if applicable).
    get_singular_response(opts, response)
  rescue Timeout::Error
    puts ERROR_MESSAGES[:timeout]
    raise TimeoutError
  end

  def self.delete(opts = {})
    raise EndpointNotSupportedError unless opts[:id]
    # TODO: Add a safe delete mechanism.

    response = WordpressApi::API.delete(
        statement(opts),
        {
            headers: WordpressApi::API.headers_for('0'),
            # TODO: Confirm auth requirements for delete method
            basic_auth: authentication
        }.merge!(net_settings)
    )
    get_singular_response(opts, response)
  rescue Timeout::Error
    puts ERROR_MESSAGES[:timeout]
    raise TimeoutError
  end

  private

  def self.statement(opts = {})
    endpoint = opts[:endpoint]
    singular = opts[:id]
    [
      configuration.endpoint,
      configuration.version,
      WordpressApi::API::ENDPOINTS[endpoint],
      singular
    ].join("/")
  end

  def self.get_response(opts, response)
    key = opts[:endpoint]
    if opts[:id]
      get_singular_response(opts, response)
    else
      WordpressApi::API::RESPONSES[key].constantize.new(response)
    end
  end

  def self.get_singular_response(opts, response)
    key = opts[:endpoint].to_s.chomp('s').to_sym
    WordpressApi::API::RESPONSES[key].constantize.new(response)
  end

  def self.uri(key)
    [
        configuration.endpoint,
        configuration.version,
        WordpressApi::API::ENDPOINTS[key]
    ].join("/")
  end

  def self.net_settings
    settings = {}
    if timeout
      settings[:read_timeout] = timeout
      settings[:open_timeout] = timeout
    end
    settings[:read_timeout] = read_timeout if read_timeout
    settings[:open_timeout] = open_timeout if open_timeout
    settings
  end

  def self.authentication
    { :username => username, :password => password}
  end

  def initialize_client
    Faraday.new(url: "#{Settings.content.host}") do |faraday|
      faraday.use ::FaradayMiddleware::FollowRedirects
      faraday.request  :url_encoded
      faraday.response :logger, Rails.logger
      faraday.adapter  :net_http
    end
  end
end
