require 'active_support/core_ext'
require_relative './error/harvest_error.rb'
require_relative './error/http_error.rb'

require 'pp'

module Harvest
  module ResponseParser
    class << self
      def parse(response_status, response_headers, response_body, options = {})
        content_type = response_headers.fetch("CONTENT_TYPE", "")
        key = options[:key]

        check_for_http_errors(response_status)

        hash = hashify(response_body, content_type)
        key ? fetch_key(hash, key) : hash
      end

      private
      def hashify(body, content_type)
        return {} if body.empty? || body.nil?
        case content_type
        when /xml/
          response = parse_from_xml(body)
        when /json/
          response = parse_from_json(body)
        when /html/
          response = parse_from_html(body)
        else
          raise ParserError, "Unknown response type '#{content_type}'.\nBody: #{body}"
        end

        check_for_empty_response(response)
      end

      def parse_from_json(body)
        JSON.parse(body)
      rescue JSON::ParserError
        raise_parser_error('JSON', body)
      end

      def parse_from_xml(body)
        Hash.from_trusted_xml(body)
      rescue REXML::ParseException
        raise_parser_error('XML', body)
      end

      def parse_from_html(body)
        hash = Hash.from_trusted_xml(body)
        raise ClientError if hash["html"]["body"] =~ /You are being/
        hash
      rescue REXML::ParseException
        raise_parser_error('HTML', body)
      end

      def raise_parser_error(type, body)
        raise ParserError, "Unable to parse #{type} response.\nBody: #{body}"
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

      def check_for_http_errors(response_status)
        error = case response_status
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
