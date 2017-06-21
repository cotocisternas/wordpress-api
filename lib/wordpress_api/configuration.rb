class WordpressApi::Configuration

  attr_writer :endpoint
  attr_accessor :timeout
  attr_accessor :read_timeout
  attr_accessor :open_timeout
  attr_accessor :password
  attr_accessor :username
  attr_writer :version

  ##
  # Public: Get the API endpoint used by the configuration.  Unless explicitly
  # set, the endpoint will default to the official production endpoint
  #
  # Returns the String for the API endpoint.
  #
  def endpoint
    @endpoint ||= "#{Settings.content.host}"
  end

  ##
  # Public: Get the API version. Defaults to 1.0.
  #
  # Returns the String for the API version.
  #
  def version
    @version ||= 'v2'
  end
end
