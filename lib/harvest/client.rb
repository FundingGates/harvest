require_relative './hclient.rb'
require_relative './invoice.rb'
require_relative './customer.rb'
require_relative './person.rb'
require_relative './me.rb'
require_relative './company.rb'
require_relative './error/harvest_error.rb'
require_relative './error/http_error.rb'
require_relative './response_parser'

module Harvest
  class Client < SimpleDelegator
    def initialize(oauth_token)
      super(HClient.new(access_token: oauth_token))
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
      attributes = get_data("invoices/#{id}", key: "invoice")
      attributes.delete("csv_line_items")
      Harvest::Invoice.new(attributes)
    end

    def customers(query = {})
      customers = get_data('clients', query: query, key: "clients")
      customers.map { |c| Harvest::Customer.new(c) }
    end

    def customer(id)
      attributes = get_data("clients/#{id}", key: "client")
      Harvest::Customer.new(attributes)
    end

    def contacts
      contacts = get_data('clients', key: 'clients')
      contacts.map { |contact| Harvest::Person.new(contact) }
    end

    def contacts_for_customer(customer_id)
      contacts = get_data("clients/#{customer_id}/contacts", key: "contacts")
      contacts.map { |contact| Harvest::Person.new(contact) }
    end

    private
    def get_data(path, opts = {})
      query = opts.fetch(:query, {})
      key = opts.fetch(:key, nil)

      request = request_full(REQUEST_PATH: path,
                             REQUEST_QUERY: query)
      response_headers = request["RESPONSE_HEADERS"]
      body = request["RESPONSE_BODY"]
      ResponseParser.parse(body, response_headers: response_headers,
                                 key: key)
    end
  end
end
