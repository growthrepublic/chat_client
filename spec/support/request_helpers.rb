module RequestHelpers
  def self.api_host
    "http://localhost:3000"
  end

  def request_paginated(scope, page: 1, per: 5)
    paginated = scope.page(page).per(per)
    request_scope(paginated)
  end

  def api_endpoint(path, version: 'v1')
    [RequestHelpers.api_host, 'api', version, path]
      .join('/')
  end

  def request_scope(scope)
    scope.fetch
  end

  def stubbed_response_body(name, version: 'v1')
    spec_dir  = File.join(__dir__, '..')
    stub_file = File.join(spec_dir, version, 'stubs', "#{name}.json")

    File.read(stub_file)
  end
end