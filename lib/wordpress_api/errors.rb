module WordpressApi
  Error = Class.new(StandardError)
  TimeoutError = Class.new(Error)
  NotImplementedError = Class.new(Error)
  EndpointNotSupportedError = Class.new(Error)
  class ApiError < Class.new(Error) do
      def initialize(response = nil)
        @message = response
        super
      end

      def message
        @message
      end
    end
  end

end

