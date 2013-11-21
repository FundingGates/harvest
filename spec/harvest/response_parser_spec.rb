require_relative '../../lib/harvest/response_parser.rb'
include Harvest

describe Harvest::ResponseParser do
  it 'handles a 400 by raising a BadRequest' do
    expect { ResponseParser.parse(400, {}, "") }.to raise_error(Harvest::BadRequest)
  end

  it 'handles a 401 by raising an Unauthorized' do
    expect { ResponseParser.parse(401, {}, "") }.to raise_error(Harvest::Unauthorized)
  end

  it 'handles a 403 by raising a Forbidden' do
    expect { ResponseParser.parse(403, {}, "") }.to raise_error(Harvest::Forbidden)
  end

  it 'handles a 404 by raising a NotFound' do
    expect { ResponseParser.parse(404, {}, "") }.to raise_error(Harvest::NotFound)
  end

  it 'handles a 406 by raising a NotAcceptable' do
    expect { ResponseParser.parse(406, {}, "") }.to raise_error(Harvest::NotAcceptable)
  end

  it 'handles a 420 by raising an EnhanceYourCalm' do
    expect { ResponseParser.parse(420, {}, "") }.to raise_error(Harvest::EnhanceYourCalm)
  end

  it 'handles a 500 by raising an InternalServerError' do
    expect { ResponseParser.parse(500, {}, "") }.to raise_error(Harvest::InternalServerError)
  end

  it 'handles a 502 by raising a BadGateway' do
    expect { ResponseParser.parse(502, {}, "") }.to raise_error(Harvest::BadGateway)
  end

  it 'handles a 503 by raising an ServiceUnavailable' do
    expect { ResponseParser.parse(503, {}, "") }.to raise_error(Harvest::ServiceUnavailable)
  end

  context "with XML" do
    let(:headers) do
      { "CONTENT_TYPE" => "text/xml" }
    end

    it 'parses an empty response' do
      empty_response = %(
                         <?xml version="1.0" encoding="UTF-8"?>
                         <nil-classes type="array"/>
                        )
      ResponseParser.parse(200, headers, empty_response).should == {}
    end

    it 'retrieves a key' do
      body = %(
                 <?xml version="1.0" encoding="UTF-8"?>
                 <root>
                   <foo>bar</foo>
                   <test>baz</test>
                 </root>
               )
      ResponseParser.parse(200, headers, body, key: 'root').should == { "foo" => "bar", "test" => "baz" }
    end

    it 'parses a blank response' do
      ResponseParser.parse(200, headers, "").should == {}
    end
  end

  context "with HTML" do
    let(:headers) do
      { "CONTENT_TYPE" => "text/html" }
    end

    it 'parses a redirect' do
      body = %(
        <html><body>You are being <a href=\"https://api.harvestapp.com/company/inactive\">redirected</a>.</body></html>
      )
      -> { ResponseParser.parse(200, headers, body) }.should raise_exception(Harvest::ClientError)
    end
  end

  context "with JSON" do
    let(:headers) do
      { "CONTENT_TYPE" => "text/json" }
    end

    it 'parses an empty response' do
      body = %( {} )
      ResponseParser.parse(200, headers, body).should == {}
    end

    it 'parses a basic document' do
      body = %(
               {
                 "foo": "bar",
                 "test": "baz"
               }
              )
      ResponseParser.parse(200, headers, body).should == { "foo" => "bar", "test" => "baz" }
    end

    it 'fetches a key' do
      body = %(
               {
                 "root": {
                   "foo": "bar",
                   "test": "baz"
                 }
               }
              )
      ResponseParser.parse(200, headers, body, key: 'root').should == { "foo" => "bar", "test" => "baz" }
    end
  end
end
