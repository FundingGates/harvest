require 'rest-core'

HClient = RestCore::Builder.client do
  use RestCore::DefaultSite, 'https://api.harvestapp.com/'
  use RestCore::DefaultHeaders, {'Accept' => 'application/json'}
  use RestCore::Oauth2Query   , nil
  use RestCore::CommonLogger, method(:puts)
  use RestCore::Cache       , nil, 3600
  run RestCore::RestClient # the simplest and easier HTTP client
end
