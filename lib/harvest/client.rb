require_relative './hclient.rb'
require_relative './invoice.rb'
require_relative './customer.rb'
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
      Harvest::Invoice.new(get("invoices/#{id}")["invoice"])
    end

    def customers
      get('clients').map { |c| Harvest::Customer.new(c["client"]) }
    end
  end
end
