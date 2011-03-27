module Scais
  module Topology
    module Block
      class InternalVariable
        include Scais::Helpers::Chainable
        include Scais::Helpers::Attributed
        
        attr_chainable :code, :initial_value, :alias
        
        def initialize code, attributes
          @code = code
          self.attributes = attributes
        end
      end
    end
  end
end
