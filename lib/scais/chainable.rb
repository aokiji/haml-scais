# Module that adds method for automatic defining those attributes
# that when set can be chained
#    Example : Block.new('1').name('Block').index(10)
#
module Chainable
  module InstanceMethods
    attr_reader :chain_block
  end
  
  module ClassMethods
    # automatic define chainable reader methods
    def attr_chainable_reader *methods
      methods.each do |m|
        self.class_eval "def #{m.to_s} vals=nil, &block;@chain_block=block;vals.nil? ? @#{m.to_s} : (@#{m.to_s}=vals) && self; end"
      end
    end
    
    # automatic define chainable reader methods and a setter
    def attr_chainable *methods
      methods.each do |m|
        self.class_eval "def #{m.to_s} vals=nil, &block;@chain_block=block;vals.nil? ? @#{m.to_s} : (@#{m.to_s}=vals) && self; end"
        self.class_eval "def #{m.to_s}= value; @#{m.to_s}=value; end"
      end
    end
  end
  
  def self.included( base )
    base.send :include, InstanceMethods
    base.send :extend, ClassMethods 
  end
end
