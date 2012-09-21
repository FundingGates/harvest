require_relative '../../lib/harvest/invoice.rb'

describe Harvest::Invoice do
  describe '#new' do
    it 'accepts a hash of attributes and creates methods for each key' do
      invoice = Harvest::Invoice.new({
        "name"   => "bob",
        "amount" => "100"
      })
      invoice.name.should == "bob"
      invoice.amount.should == "100"
    end
  end
end
