module Scais
  module Topology
    module Block
      class InitialVariable
        include Scais::Helpers::Chainable
        include Scais::Helpers::Attributed
        
        attr_chainable :code, :value, :alias
        
        # InternalVariable.new code, attributes
        def initialize *args
          attributes = args.last.is_a?(::Hash) ? args.pop : {}
          code = args.shift
          attributes[:value] = args.pop unless args.last.nil?
          @code = code
          self.attributes = attributes
        end
      end
    end
  end
end
