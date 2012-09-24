require_relative './client_error'

module Harvest
  class InvoiceNotFound < Harvest::ClientError
  end
end
