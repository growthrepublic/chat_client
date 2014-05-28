require "faraday"

module GrowthRepublicChatClient
  module PaginatedApi
    class FaradayParser < Faraday::Response::Middleware
      def on_complete(env)
        pagination = {
          total_count: env.response_headers["x-total"].to_i,
          per_page:    (env.response_headers["x-per-page"] || env.body[:data].count).to_i,
          page:        env.response_headers["x-page"].to_i
        }

        env[:body].merge!(pagination: pagination)
      end
    end
  end
end