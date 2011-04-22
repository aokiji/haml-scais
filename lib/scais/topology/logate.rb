module Scais
  module Topology
    class Logate < Block::Base
      attr_chainable :low, :high
      constants :condition => :formula
      initial_variables :initial_output
      attr_chainable :initial_state
      
      validates :low, :high, :condition, :presence => true
      validates :outputs, :many => {:exact => 1}
      
      def initialize code, attributes={}
        super code, attributes.merge(:module => 'LOGATE')
      end
      
      def low
        @low||= Input.new(self)
      end
      
      def high
        @high||= Input.new(self)
      end
      
      # add constants before validation
      def before_validate
        self.outputs<< output(0) if self.outputs.empty?
        self.inputs<< high.code('IN_HIGH') unless @high.nil?
        self.inputs<< low.code('IN_LOW') unless @low.nil?
        super
      end
      
      def self.constant_fint value, code, options={}
        options = {:from => -1}.merge(options)
        Fint.new(code).times([options[:from]]).coefs([value])
      end
    end
  end
end
