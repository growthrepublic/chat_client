module GrowthRepublicChatClient
  module V1
    module Models
      class Message
        include Her::Model
        include GrowthRepublicChatClient::PaginatedApi::HerCollection

        uses_api GrowthRepublicChatClient::V1.api

        attributes :user_id, :type, :body, :created_at

        collection_path "conversations/:conversation_id/messages"
        scope :for_conversation, ->(id) { where(conversation_id: id) }
      end
    end
  end
end