module Scais
  module Topology
    class Logate < Block::Base
      attr_chainable :low, :high, :condition
      attr_writer :initial_output
      
      validates :low, :high, :condition, :presence => true
      validates :outputs, :many => {:exact => 1}
      
      def initialize code, attributes={}
        super code, attributes.merge(:module => 'LOGATE')
      end
      
      def initial_output *args
        args.empty? ? @initial_output : (@initial_output = args) && self 
      end
      
      # add constants before validation
      def before_validate
        self.constants={ 'FORMULA' => condition}
        self.outputs<< output(0) if self.outputs.empty?
        self.inputs<< high.code('IN_HIGH')
        self.inputs<< low.code('IN_LOW')
        args= ['INITIALOUTPUT']+@initial_output
        self.initial_variables<< InitialVariable.new(*args) unless self.initial_output.nil?
        super
      end
      
      def self.constant_fint value, code, options={}
        options = {:from => -1}.merge(options)
        Fint.new(code).times([options[:from]]).coefs([value])
      end
    end
  end
end
