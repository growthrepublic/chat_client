require "spec_helper"

describe GrowthRepublicChatClient::V1::Models::Message, ".for_conversation" do
  let(:conversation_id) { "53731fbb31373210bc8c0300" }
  let(:endpoint_without_redundant_query) do
    api_endpoint("conversations/#{conversation_id}/messages", version: 'v1')
  end
  let(:endpoint) do
    params = { conversation_id: conversation_id }
    "#{endpoint_without_redundant_query}?#{params.to_query}"
  end

  it "scopes conversation" do
    stub_request(:get, endpoint)
      .to_return(status: 200, body: "[]")

    scope = described_class.for_conversation(conversation_id)
    response = request_scope(scope)
    expect(response).to eq []
  end
end

describe GrowthRepublicChatClient::V1::Models::Message, "pagination" do
  include_examples "collection pagination" do
    let(:conversation_id) { "53731fbb31373210bc8c0300" }
    let(:page)            { 1 }
    let(:per_page)        { 2 }
    let(:collection)      { described_class.for_conversation(conversation_id) }
    let(:response_body)   { stubbed_response_body("conversation_messages", version: 'v1') }
    let(:endpoint) do
      params = {
        conversation_id: conversation_id,
        page: page,
        per_page: per_page
      }

      path = "conversations/#{conversation_id}/messages"
      api_endpoint("#{path}?#{params.to_query}", version: 'v1')
    end
  end
end