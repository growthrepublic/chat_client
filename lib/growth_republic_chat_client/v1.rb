require "her"
require "faraday"
require "faraday_middleware"

require "growth_republic_chat_client/paginated_api"

module GrowthRepublicChatClient
  module V1
    def self.configure(endpoint, &block)
      @api = Her::API.new

      @api.setup :url => "#{endpoint}/api/v1" do |c|
        yield c if block_given?

        c.use GrowthRepublicChatClient::PaginatedApi::FaradayParser

        c.use FaradayMiddleware::EncodeJson
        c.use Her::Middleware::AcceptJSON
        c.use Her::Middleware::FirstLevelParseJSON

        # inject default adapter unless in test mode
        c.adapter Faraday.default_adapter unless c.builder.handlers.include?(Faraday::Adapter::Test)
      end

      # This is very important. Due to way Her currently works
      # model files need to be required after configuring the API
      require "growth_republic_chat_client/v1/models/conversation"
      require "growth_republic_chat_client/v1/models/message"
    end

    def self.api
      @api
    end
  end
end