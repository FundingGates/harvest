require_relative './invoice_not_found.rb'

module Harvest
  class HarvestError < StandardError
  end

  class ParserError < HarvestError
    def message
      "unable to parse response body"
    end
  end
end
