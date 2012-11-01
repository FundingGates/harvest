require 'active_support/core_ext'
require_relative './error/harvest_error.rb'

module Harvest
  class ResponseParser
    def self.parse(body, options = {})
      key = options[:key]

      hash = hashify(body)
      if key
        fetch_key(hash, key)
      else
        hash
      end
    end

    private
    def self.hashify(body)
      begin
        response = Hash.from_xml(body)
      rescue REXML::ParseException
        begin
          response = JSON.parse(body)
        rescue JSON::ParserError
          raise ParserError
        end
      end
      if response.is_a? Hash
        check_for_empty_response(response)
      else
        raise ParserError
      end
    end

    def self.check_for_empty_response(hash)
      if hash.has_key?("nil_classes")
        {}
      else
        hash
      end
    end

    def self.fetch_key(hash, key)
      response = check_response_for_errors(hash)
      if response.has_key? "hash"
        response = response.fetch("hash")
      end
      if !key.nil?
        response.fetch(key)
      else
        response
      end
    end

    def self.check_response_for_errors(response)
      if response.has_key?("error")
        exception = HarvestError
        if %w(invalid_token invalid_grant).include?(response['error'])
          exception = AuthorizationFailure
        end
        raise exception, response["error_description"]
      end
      response
    end
  end
end
