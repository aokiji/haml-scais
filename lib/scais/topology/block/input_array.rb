module Scais
  module Topology
    module Block
      class InputArray < Array
        attr_accessor :block
        
        def initialize block
          @block = block
        end
        
        def << obj
          obj = parse(obj) unless obj.is_a?(Input)
          obj.n = self.size
          obj.code("I#{obj.n}") if obj.code.nil? # default code if none given
          super obj
        end
        
        # Generate new input for the block
        # used to generate inputs in block call from Block class.
        def input
          b = block.input
          push b
          b
        end
        
        private
        def parse options
          Input.new block
        end
      end
    end
  end
end
