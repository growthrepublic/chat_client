require "spec_helper"

describe GrowthRepublicChatClient::V1::Models::Conversation, ".for_user" do
  let(:user_id)  { 1 }
  let(:endpoint) { api_endpoint("conversations", version: 'v1') }

  it "scopes by query attribute :user_id" do
    stub_request(:get, "#{endpoint}?user_id=#{user_id}")
      .to_return(status: 200, body: "[]")

    response = request_scope(described_class.for_user(user_id))
    expect(response).to eq []
  end
end

describe GrowthRepublicChatClient::V1::Models::Conversation, ".start" do
  let(:people_ids)    { [1, 236] }
  let(:endpoint)      { api_endpoint("conversations", version: 'v1') }
  let(:response_body) { stubbed_response_body("created_conversation", version: 'v1') }

  it "starts a conversation with given people" do
    stub_request(:post, endpoint)
      .with(body: { people_ids: people_ids }.to_json)
      .to_return(status: 201, body: response_body)

    conversation = described_class.start(people_ids)
    expect(conversation.subscribers).to eq people_ids
  end
end

describe GrowthRepublicChatClient::V1::Models::Conversation, ".invite_people" do
  let(:people_ids)          { [1, 236] }
  let(:invitee_ids)         { [3] }
  let(:create_conversation) { described_class.start(people_ids) }
  let(:conversation_id)     { create_conversation.id.to_s }

  let(:create_endpoint) { api_endpoint("conversations", version: 'v1') }
  let(:invite_endpoint) { api_endpoint("conversations/#{conversation_id}/invite", version: 'v1') }

  before(:each) do
    body = stubbed_response_body("created_conversation", version: 'v1')
    stub_request(:post, create_endpoint)
      .with(body: { people_ids: people_ids }.to_json)
      .to_return(status: 201, body: body)

    create_conversation
  end

  it "invites people to a conversation" do
    body = stubbed_response_body("invited_people", version: 'v1')
    stub_request(:post, invite_endpoint)
      .with(body: { people_ids: invitee_ids }.to_json)
      .to_return(status: 200, body: body)

    conversation = described_class.invite_people(conversation_id, invitee_ids)
    expect(conversation.subscribers).to eq people_ids | invitee_ids
  end
end

describe GrowthRepublicChatClient::V1::Models::Conversation, "pagination" do
  include_examples "collection pagination" do
    let(:user_id)       { 1 }
    let(:page)          { 1 }
    let(:per_page)      { 2 }
    let(:collection)    { described_class.for_user(user_id) }
    let(:response_body) { stubbed_response_body("user_conversations", version: 'v1') }
    let(:endpoint) do
      params = {
        user_id: user_id,
        page: page,
        per_page: per_page
      }
      api_endpoint("conversations?#{params.to_query}", version: 'v1')
    end
  end
end