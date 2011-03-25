module Scais
  module Topology
    module Block
      class Constant
        class Value
          attr_accessor :value
          
          def initialize(value)
            @value = value
          end
          
          def string?
            value.is_a?(String)
          end
          
          def double?
            !string?
          end
          
          def xml_safe
            if string? && value.match('<|>') 
              cdata(value)
            elsif double? && value.is_a?(Array) 
              value.join(',')
            else
              value.to_s
            end
          end
          
          def to_s
            xml_safe
          end
          
          def method_missing(sym, *args, &block)
            return value.call(sym, *args, &block) if call_to_value?(sym)
            super(sym, *args, &block)
          end
          
          private
          def call_to_value?(sym)
            @value.respond_to?(sym)
          end
          
          def cdata(string)
            "<![CDATA[#{string}]]>"
          end
        end
        attr_accessor :code, :value
        
        def initialize code, value
          @code = code
          @value = Value.new value
        end
      end
    end
  end
end
