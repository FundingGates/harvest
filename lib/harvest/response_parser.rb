require 'active_support/core_ext'
require_relative './error/harvest_error.rb'
require_relative './error/http_error.rb'

module Harvest
  module ResponseParser
    class << self
      def parse(body, options = {})
        response_headers = options.fetch(:response_headers)
        content_type = response_headers.fetch("CONTENT_TYPE", "")
        key = options[:key]

        check_for_http_errors(response_headers)

        hash = hashify(body, content_type)
        key ? fetch_key(hash, key) : hash
      end

      private
      def hashify(body, content_type)
        case content_type
        when /xml/
          response = parse_from_xml(body)
        when /json/
          response = parse_from_json(body)
        else
          raise ParserError, "unknown response type: #{content_type}"
        end

        check_for_empty_response(response)
      end

      def parse_from_json(body)
        JSON.parse(body)
        rescue JSON::ParserError
          raise ParserError, "unable to parse JSON response"
      end

      def parse_from_xml(body)
        Hash.from_xml(body)
        rescue REXML::ParseException
          raise ParserError, "unable to parse XML response"
      end

      def check_for_empty_response(hash)
        if hash.has_key?("nil_classes")
          {}
        else
          hash
        end
      end

      def fetch_key(hash, key)
        hash = hash.fetch("hash") if hash.has_key? "hash"

        unless key.nil? || hash.empty?
          hash.fetch(key)
        else
          hash
        end
      end

      def check_for_http_errors(response_headers)
        code = response_headers["STATUS"].to_i
        error = case code
        when 400; BadRequest
        when 401; Unauthorized
        when 403; Forbidden
        when 404; NotFound
        when 406; NotAcceptable
        when 420; EnhanceYourCalm
        when 500; InternalServerError
        when 502; BadGateway
        when 503; ServiceUnavailable
        end
        raise error if error
      end
    end
  end
end
