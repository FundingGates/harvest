require_relative '../../lib/harvest/client.rb'

describe Harvest::Client do
  describe '#new' do
    it 'delegates to the rest-core client' do
      client=Harvest::Client.new('some_key')
      client.access_token.should == 'some_key'
    end
  end
end
