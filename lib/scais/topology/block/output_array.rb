module Scais
  module Topology
    module Block
      class OutputArray < Array
        attr_accessor :block
        
        def initialize block
          @block = block
        end
        
        def << obj
          obj = parse(obj) unless obj.is_a?(Output)
          obj.n = self.size
          obj.code("O#{obj.n}") if obj.code.nil? # default code if none given
          super obj
        end
        
        # Generate new input for the block
        # used to generate inputs in block call from Block class.
        def output
          b = block.output
          self<< b
          b
        end
        
        private
        def parse options
          Output.new block
        end
      end
    end
  end
end
