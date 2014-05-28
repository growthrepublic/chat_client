# Requires:
# - `page` (Integer)
# - `per_page` (Integer)
# - `endpoint` (String) url for endpoint to be stubbed
# - `response_body` (String) response body to be returned by the `endpoint`
# - `collection` (Her::Model) scope provided by Her or the model class
shared_examples_for "collection pagination" do
  let(:total_pages) { 2 }
  let(:total_count) { total_pages * per_page }
  let(:response_headers) do
    {
      "Content-Type" => "application/json",
      "X-Page"       => page,
      "X-Total"      => total_count,
      "X-Total-Pages"=> total_pages,
      "X-Next-Page"  => page + 1,
      "X-Per-Page"   => per_page
    }
  end

  it "paginates collection" do
    stub_request(:get, endpoint)
      .to_return(
        status:  200,
        body:    response_body,
        headers: response_headers)


    results = request_paginated(collection,
      page: page,
      per:  per_page)

    expect(results.total_count).to eq total_count
    expect(results.current_page).to eq page
    expect(results.total_pages).to eq total_pages

    parsed_all_models = results.all? { |r| r.kind_of?(Her::Model) }
    expect(parsed_all_models).to be true
  end
end