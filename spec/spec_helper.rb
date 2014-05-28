$LOAD_PATH.unshift(File.join(__dir__, "..", "lib"))

require "webmock/rspec"

require "growth_republic_chat_client/paginated_api"
require "growth_republic_chat_client/v1"

Dir[File.join(__dir__, "support/**/*.rb")].each { |f| require f }

GrowthRepublicChatClient::V1.configure(RequestHelpers.api_host)

RSpec.configure do |config|
  config.raise_errors_for_deprecations!
  config.include RequestHelpers
end

WebMock.disable_net_connect!