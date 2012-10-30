require_relative '../../lib/harvest/harvest_data.rb'

module Harvest
  class Foo < HarvestData
  end
end

describe Harvest::HarvestData do
  context 'when already initialized' do
    subject(:foo) { Harvest::Foo.new(foo: "bar", gregg: "roth") }

    it 'doesnt warn against initialized constant' do
      foo
      Struct.should_not_receive(:new)
      foo
    end
  end
end
