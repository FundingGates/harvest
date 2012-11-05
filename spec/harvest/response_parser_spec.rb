require_relative '../../lib/harvest/response_parser.rb'
include Harvest

describe Harvest::ResponseParser do
  context "with XML" do
    let(:headers) { { :response_headers => { "CONTENT_TYPE" => "text/xml" } } }

    it 'parses an empty response' do
      empty_response = %(
                         <?xml version="1.0" encoding="UTF-8"?>
                         <nil-classes type="array"/>
                        )
      ResponseParser.parse(empty_response, headers).should == {}
    end

    it 'retrieves a key' do
      body = %(
                 <?xml version="1.0" encoding="UTF-8"?>
                 <root>
                   <foo>bar</foo>
                   <test>baz</test>
                 </root>
               )
      ResponseParser.parse(body, headers.merge(key: 'root')).should == { "foo" => "bar", "test" => "baz" }
    end
  end

  context "with JSON" do
    let(:headers) { { :response_headers => { "CONTENT_TYPE" => "text/json" } } }

    it 'parses an empty response' do
      body = %( {} )
      ResponseParser.parse(body, headers).should == {}
    end

    it 'parses a basic document' do
      body = %(
               {
                 "foo": "bar",
                 "test": "baz"
               }
              )
      ResponseParser.parse(body, headers).should == { "foo" => "bar", "test" => "baz" }
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
      ResponseParser.parse(body, headers.merge(key: "root")).should == { "foo" => "bar", "test" => "baz" }
    end
  end
end
