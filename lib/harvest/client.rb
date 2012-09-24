require_relative './hclient.rb'
require_relative './invoice.rb'
require_relative './customer.rb'
require_relative './error/invoice_not_found.rb'
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

    def get(args)
      JSON.parse(super(args))
    end

    def invoices
      get('invoices').map { |i| Harvest::Invoice.new(i["invoices"]) }
    end

    def invoice(id)
      begin
        Harvest::Invoice.new(get("invoices/#{id}")["invoice"])
      rescue JSON::ParserError
        raise Harvest::InvoiceNotFound
      end
    end

    def customers
      get('clients').map { |c| Harvest::Customer.new(c["client"]) }
    end

    def customer(id)
      Harvest::Customer.new(get("clients/#{id}")["client"])
    end
  end
end
