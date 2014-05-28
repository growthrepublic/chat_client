# ChatClient

[![Code Climate](https://codeclimate.com/github/growthrepublic/chat_client.png)](https://codeclimate.com/github/growthrepublic/chat_client)

This gem wraps API of Growth Republic's [chat application](https://github.com/growthrepublic/chat). It has been created to make it easier to consume the API across multiple applications. It is very thin and provides two models under first API version. It supports pagination using Kaminari. It has been used from the API written in `Grape`. Check the examples below.

## Installation

Add this line to your application's Gemfile:

    gem 'growth_republic_chat_client'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install growth_republic_chat_client

## Usage

### Configure location of the Chat API
If you have a Rails application, create `config/initialisers/chat_api.rb` to set the location of the chat API:

```
require 'growth_republic_chat_client/v1'
GrowthRepublicChatClient::V1.configure("<chat_application_url>")
# i.e. "http://127.0.0.1:3001"
```

If you need more advanced configuration of the underlying `Her::API` you can pass a block:

```
require 'growth_republic_chat_client/v1'
GrowthRepublicChatClient::V1.configure("<chat_application_url>") do |api|
  api.use Faraday::Adapter::NetHttp
end
```

For more details check out [Her documentation](https://github.com/remiprev/her#usage).

### Conversations

```
# List user's conversations
user_id = 1
GrowthRepublicChatClient::V1::Conversation.for_user(user_id).page(1).per(5)

# Start a conversation with people
people_ids = [1, 2]
GrowthRepublicChatClient::V1::Conversation.start(people_ids)

# Invite people to a conversation
conversation_id = "53731fbb31373210bc8c0300"
invitee_ids = [3, 4]
GrowthRepublicChatClient::V1::Conversation.invite_people(conversation_id, invitee_ids)

# Invite people having a conversation model
invitee_ids = [3, 4]
conversation.invite(invitee_ids)
```

### Messages

```
# List conversation's messages
conversation_id = "53731fbb31373210bc8c0300"
GrowthRepublicChatClient::V1::Message.for_conversation(conversation_id).page(1).per(5)
```

### Pagination with Grape

If you are using Grape to build the API exposing Chat API, then pagination can be achieved easily with `grape-kaminari` gem. Add it to your Gemfile:

    gem 'grape-kaminari'

And then execute:

    $ bundle

Sample endpoint that passes pagination headers to the end-user might look as follows:

```
module API
  module V1
    class Conversations < Grape::API
      include Grape::Kaminari

      # ... omitted for brevity

      resource :conversations do
        desc "Returns paginated list of user conversations."
        paginate per_page: 10
        get do
          @conversations = GrowthRepublicChatClient::V1::Models::Conversation.for_user(@user.id)
          paginate(@conversations)
        end
      end
    end
  end
end
```

Beware that you do not have to explicitly use `page` and `per` scopes. They are called internally by `paginate` helper with values passed in params.

## Contributing

1. Fork it ( https://github.com/growthrepublic/chat_client/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
