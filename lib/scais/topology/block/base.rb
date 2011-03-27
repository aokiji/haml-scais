module Scais
  module Topology
    module Block
      class Base
        include Scais::Helpers::Chainable
        include Validations
        include Scais::Helpers::Builder
        include Scais::Helpers::Attributed
        include Renderer
        
        attr_accessor :module, :code, :outputs, :inputs, :initial_variables, :internal_variables
        attr_reader :constants
        attr_chainable_reader :modes
        attr_chainable :index, :name, :active, :module, :debug
        
        validates :code, :name, :index, :active, :debug , :presence => true
        
        DEBUG_LEVELS = [:fatal, :warning, :info, :debug]
        
        def initialize code, attributes={}
          @constants = Array.new
          @initial_variables = Array.new
          attributes = {:code => code, :outputs => OutputArray.new(self),
            :inputs => InputArray.new(self),
            :internal_variables => Array.new
          }.merge(attributes)
          self.attributes = attributes
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
        
        def debug_level
          DEBUG_LEVELS.index(debug)
        end
        
        # check if active
        def active?
          active == true
        end
        
        def active_value
          active? ? 1 : 0
        end
        
        # constant is set by hash
        def constants= hash
          @constants = Array.new
          hash.each do |code, value|
            @constants<< Constant.new(code, value)
          end
        end
        
        # Method that render xml for the block, but first it
        # runs defined validations and before_validate method
        def to_xml
          before_validate
          validate
          render File.expand_path('../../haml/block.haml', __FILE__), self
        end
        
        def identify
          s="#{self.class.name}"
          s << ":'#{code}'" unless code.nil?
        end
        
        def to_s
          to_xml
        end
        
        # Get output n for this block
        def output(n=nil)
          out = Output.new(self, n)
          out.code(n.is_a?(Integer) ? "O#{n}" : n) unless n.nil?
          out
        end
        
        # Get input n for this block
        def input(n=nil)
          inp = Input.new(self, n)
          inp.code(n.is_a?(Integer) ? "I#{n}" : n) unless n.nil?
          inp
        end
        
        private
        # set defaults values when values not given
        def before_validate
          self.active = true if self.active.nil?
          self.name = code if self.name.nil?
          self.debug = 0 if self.debug.nil?
        end
      end
    end
  end
end
