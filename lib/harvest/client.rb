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
      xml = super(path, query)
      begin
        response = Hash.from_xml(xml)
      rescue REXML::ParseException
        response = JSON.parse(xml)
        if response.has_key?("error")
          exception = HarvestError 
          if %w(invalid_token invalid_grant).include?(response['error'])
            exception = AuthorizationFailure
          end
          raise exception, response["error_description"]
        end
      end
      response
    end

    def who_am_i?
      me = get('account/who_am_i')["hash"]["user"]
      Harvest::Me.new(me)
    end

    def people
      people = get('people')["users"]
      people = [people] unless people.is_a?(Array)
      people.map { |p| Harvest::Person.new(p) }
    end

    def company
      company = get('account/who_am_i')["hash"]["company"]
      Harvest::Company.new(company)
    end

    def invoices(query = {})
      invoices = get('invoices', query)["invoices"]
      invoices.map { |i| Harvest::Invoice.new(i) }
    end

    def invoice(id)
      begin
        attributes = get("invoices/#{id}")["invoice"]
        attributes.delete("csv_line_items")
        Harvest::Invoice.new(attributes)
      rescue NoMethodError
        raise Harvest::InvoiceNotFound
      end
    end

    def customers(query = {})
      customers = get('clients', query)["clients"]
      customers.map { |c| Harvest::Customer.new(c) }
    end

    def customer(id)
      attributes = get("clients/#{id}")["client"]
      Harvest::Customer.new(attributes)
    end
  end
end
