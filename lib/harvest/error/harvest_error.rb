require_relative './invoice_not_found.rb'

module Harvest
  class HarvestError < StandardError
  end

  class ParserError < HarvestError
  end
end
