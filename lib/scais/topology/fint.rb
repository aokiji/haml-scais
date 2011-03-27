module Scais
  module Topology
    class Fint < Block::Base
      constants :times => :time, :coefs => :coef
      
      validates :times, :coefs, :presence => true
      validates :inputs, :many => {:exact => 0}
      validates :outputs, :many => {:exact => 1}
      
      def initialize code, attributes={}
        super code, attributes.merge(:module => 'FINT')
      end
      
      # add constants before validation
      def before_validate
        self.outputs<< output(0) if self.outputs.empty?
        super
      end
      
      def self.constant_fint value, code, options={}
        options = {:from => -1}.merge(options)
        Fint.new(code).times([options[:from]]).coefs([value])
      end
      
      #
      # Add Constant Fint generators. Default time is from -1
      #   1.Fint code           # constant 1 fint
      #   0.Fint code, options  # constant 0 fint
      # You can specify the time from start
      #   Fint.1 code, :from => -100, options
      Integer.class_eval "def Fint *args; Fint.constant_fint self, args;end"
    end
  end
end
