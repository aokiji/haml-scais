module Scais
  module Topology
    module Block
      class Input
        include Scais::Helpers::Chainable
        include Scais::Helpers::Attributed
        
        attr_chainable :code, :recursive, :alias, :block, :n
        attr_chainable_reader :modes, :from, :acelerator
        
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
        
        # from setter
        def from= output
          if output.is_a?(Output)
            @from = output
          elsif output.is_a?(String)
            str = output.split('.')
            blck = str[0]
            c = str[1] || "O0"
            @from = Output.new(Block::Base.new(blck), c)
          elsif output.is_a?(Block::Base)
            @from = output.output(0)
          end
        end
        
        def acelerator= *args
          args.flatten!
          options = args.last.is_a?(Hash) ? args.pop : {}
          code = args.shift
          @acelerator = {:code => code, :options => options}
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
