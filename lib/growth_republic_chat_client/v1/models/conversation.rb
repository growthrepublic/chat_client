module GrowthRepublicChatClient
  module V1
    module Models
      class Conversation
        include Her::Model
        include GrowthRepublicChatClient::PaginatedApi::HerCollection

        uses_api GrowthRepublicChatClient::V1.api

        attributes :id, :subscribers

        scope :for_user, ->(id) { where(user_id: id) }

        def self.start(people)
          create(people_ids: people)
        end

        def self.invite_people(id, people)
          new(id: id).invite(people)
        end

        def invite(people)
          path = [request_path, 'invite'].join('/')
          self.class.post(path, people_ids: people)
        end
      end
    end
  end
end