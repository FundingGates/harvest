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

    def get(path, query={})
      body = super(path, query)
      hash = parse_body(body)
      check_response_for_errors(hash)
    end

    def who_am_i?
      me = get('account/who_am_i').fetch("user")
      Harvest::Me.new(me)
    end

    def people
      people = get('people').fetch("users")
      people = [people] unless people.is_a?(Array)
      people.map { |p| Harvest::Person.new(p) }
    end

    def company
      company = get('account/who_am_i').fetch("company")
      Harvest::Company.new(company)
    end

    def invoices(query = {})
      invoices = get('invoices', query).fetch("invoices")
      invoices.map { |i| Harvest::Invoice.new(i) }
    end

    def invoice(id)
      begin
        attributes = get("invoices/#{id}").fetch("invoice")
        attributes.delete("csv_line_items")
        Harvest::Invoice.new(attributes)
      rescue KeyError
        raise Harvest::InvoiceNotFound
      end
    end

    def customers(query = {})
      customers = get('clients', query).fetch("clients")
      customers.map { |c| Harvest::Customer.new(c) }
    end

    def customer(id)
      attributes = get("clients/#{id}").fetch("client")
      Harvest::Customer.new(attributes)
    end

    private
    def check_response_for_errors(response)
      if response.has_key?("error")
        exception = HarvestError
        if %w(invalid_token invalid_grant).include?(response['error'])
          exception = AuthorizationFailure
        end
        raise exception, response["error_description"]
      end
      if response.has_key? "hash"
        response = response.fetch("hash")
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
  end
end
