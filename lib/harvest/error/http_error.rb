module Harvest
  class HTTPError < StandardError; end

  class BadRequest < HTTPError; end
  class Unauthorized < HTTPError; end
  class Forbidden < HTTPError; end
  class NotFound < HTTPError; end
  class NotAcceptable < HTTPError; end
  class EnhanceYourCalm < HTTPError; end
  class InternalServerError < HTTPError; end
  class BadGateway < HTTPError; end
  class ServiceUnavailable < HTTPError; end
end
