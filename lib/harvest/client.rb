require_relative './hclient.rb'
require_relative './invoice.rb'
require_relative './customer.rb'
require_relative './person.rb'
require_relative './company.rb'
require_relative './error/harvest_error.rb'
require 'json'

module Harvest
  class Client < Delegator
    def initialize(oauth_token)
      @client = HClient.new(access_token: oauth_token)
    end

    def __getobj__
      @client
    end

    def __setobj__(obj)
      @client = obj
    end

    def get(path, query={})
      response = JSON.parse(super(path, query))
      if response.is_a?(Hash) && response.has_key?("error")
        exception = HarvestError 
        if %w(invalid_token invalid_grant).include?(response['error'])
          exception = AuthorizationFailure
        end
        raise exception, response["error_description"]
      end
      response
    end

    def who_am_i?
      Harvest::Person.new(get('account/who_am_i')["user"])
    end

    def people
      people = get('people')
      people = [people] unless people.is_a?(Array)
      people.map { |p| Harvest::Person.new(p["user"]) }
    end

    def company
      Harvest::Company.new(get('account/who_am_i')["company"])
    end

    def invoices(query = {})
      get('invoices', query).map { |i| Harvest::Invoice.new(i["invoices"]) }
    end

    def invoice(id)
      begin
        Harvest::Invoice.new(get("invoices/#{id}")["invoice"])
      rescue JSON::ParserError
        raise Harvest::InvoiceNotFound
      end
    end

    def customers(query = {})
      get('clients', query).map { |c| Harvest::Customer.new(c["client"]) }
    end

    def customer(id)
      Harvest::Customer.new(get("clients/#{id}")["client"])
    end
  end
end
