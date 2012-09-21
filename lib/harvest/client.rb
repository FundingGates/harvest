require_relative './hclient.rb'
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
      get('invoices').map { |i| i["invoices"] }
    end
  end
end
