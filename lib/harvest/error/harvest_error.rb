require_relative './invoice_not_found.rb'

module Harvest
  class HarvestError < StandardError
  end

  class AuthorizationFailure < HarvestError
  end

  class ParserError < HarvestError
    def message
      "unable to parse response body"
    end
  end
end
