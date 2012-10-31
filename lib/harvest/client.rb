require_relative './hclient.rb'
require_relative './invoice.rb'
require_relative './customer.rb'
require_relative './person.rb'
require_relative './me.rb'
require_relative './company.rb'
require_relative './error/harvest_error.rb'
require 'active_support/core_ext'

module Harvest
  class Client < SimpleDelegator
    def initialize(oauth_token)
      super(HClient.new(access_token: oauth_token))
    end

    def get_data(path, opts = {})
      query = opts.fetch(:query, {})
      key = opts.fetch(:key, nil)

      hash = get(path, query)
      fetch_key(hash, key)
    end

    def who_am_i?
      me = get_data('account/who_am_i', key: "user")
      Harvest::Me.new(me)
    end

    def people
      people = get_data('people', key: "users")
      people = [people] unless people.is_a?(Array)
      people.map { |p| Harvest::Person.new(p) }
    end

    def company
      company = get_data('account/who_am_i', key: "company")
      Harvest::Company.new(company)
    end

    def invoices(query = {})
      invoices = get_data('invoices', query: query, key: "invoices")
      invoices.map { |i| Harvest::Invoice.new(i) }
    end

    def invoice(id)
      begin
        attributes = get_data("invoices/#{id}", key: "invoice")
        attributes.delete("csv_line_items")
        Harvest::Invoice.new(attributes)
      rescue KeyError
        raise Harvest::InvoiceNotFound
      end
    end

    def customers(query = {})
      customers = get_data('clients', query: query, key: "clients")
      customers.map { |c| Harvest::Customer.new(c) }
    end

    def customer(id)
      attributes = get_data("clients/#{id}", key: "client")
      Harvest::Customer.new(attributes)
    end

    private
    def get(path, query={})
      body = super(path, query)
      parse_body(body)
    end

    def check_response_for_errors(response)
      if response.has_key?("error")
        exception = HarvestError
        if %w(invalid_token invalid_grant).include?(response['error'])
          exception = AuthorizationFailure
        end
        raise exception, response["error_description"]
      end
      response
    end

    # TODO untangle this mess
    def parse_body(body)
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
        response
      else
        raise ParserError
      end
    end

    def fetch_key(hash, key)
      response = check_response_for_errors(hash)
      if response.has_key? "hash"
        response = response.fetch("hash")
      end
      if response.has_key?("nil_classes")
        return {}
      elsif !key.nil?
        response.fetch(key)
      else
        response
      end
    end

  end
end
