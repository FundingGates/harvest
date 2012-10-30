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

  it 'converts a hash to methods' do
    foo =  Harvest::Foo.new(foo: "bar", bar: "baz", car: "fast")
    foo.foo.should == "bar"
    foo.bar.should == "baz"
    foo.car.should == "fast"
  end

  it 'with less arguments' do
    foo = Harvest::Foo.new(car: "faster")
    foo.car.should == "faster"
  end
end
