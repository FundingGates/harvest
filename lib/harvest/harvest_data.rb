require 'delegate'

module Harvest
  class HarvestData < SimpleDelegator
    # Wrapper around ruby's Struct class that enables you to use a hash in the constructor, thereby
    # removing the need to know the attributes up-front.
    #
    # @param [Hash] attributes a hash of attributes that you wish to be made into methods
    def initialize(attributes)
      keys = attributes.keys
      values = attributes.values
      super(struct_class(keys).new(*values))
    end

    private
    def struct_class(keys)
      begin
        Struct.const_get(class_name)
      rescue NameError
        Struct.new(class_name, *keys)
      end
    end

    def class_name
      last_word = /(\w*)\z/
      self.class.to_s.match(last_word)[0]
    end
  end
end
