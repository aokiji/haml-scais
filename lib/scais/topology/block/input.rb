module Scais
  module Topology
    module Block
      class Input
        include Scais::Helpers::Chainable
        include Scais::Helpers::Attributed
        
        attr_chainable :code, :recursive, :alias, :from, :acelerator, :block, :n
        attr_chainable_reader :modes
        
        def initialize(block, n=0, attributes={})
          @block = block
          @n = 0
          @recursive = false
          self.attributes=attributes
        end
        
        # check if recursive
        def recursive?
          recursive == true
        end
        
        # 1 if recursive true 0 otherwise
        def recursive_value
          recursive? ? 1 : 0
        end
        
        # set modes for block. accepts Array and String.
        # if Array provided if extends instance to_s method to print separated by ',' elements
        def modes= m
          m.instance_eval "def to_s; self.join(','); end" if m.is_a?(Array) #override to_s
          @modes = m
        end
        
        # check if modes given
        def modes?
          !@modes.nil? && !@modes.empty?
        end
        
        # check if alias given
        def alias?
          !@alias.nil? && !@alias.empty?
        end
      end
    end
  end
end
