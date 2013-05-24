require_relative './logger'

module Harvest
  module Logging
    def debug(msg)
      Harvest.logger.debug("[#{self.class}] #{msg}")
    end
  end
end
