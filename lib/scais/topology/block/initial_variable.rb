module Scais
  module Topology
    module Block
      class InitialVariable
        include Chainable
        include Attributed
        
        attr_chainable :code, :value, :alias
        
        def initialize *args
          attributes = args.last.is_a?(::Hash) ? args.pop : {}
          code = args.shift
          attributes[:value] = args.pop unless args.last.nil?
          @code = code
          self.attributes = attributes
          puts self.attributes.inspect
        end
      end
    end
  end
end
