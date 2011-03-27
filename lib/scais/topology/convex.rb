module Scais
  module Topology
    class Convex < Block::Base
      internal_variables :previous_input, :previous_output
      initial_variables :initial_output => :previous_output
      constants :vforz, :roots => 'root-coef'
      
      validates :vforz, :roots, :presence => true
      validates :outputs, :many => {:exact => 1}
      validates :inputs, :many => {:exact => 1}
      
      def initialize code, attributes={}
        super code, attributes.merge(:module => 'CONVEX')
      end
      
      # add constants before validation
      def before_validate
        self.outputs<< output(0) if self.outputs.empty?
        super
      end
    end
    
    class Integrator < Convex
      def initialize code, attributes={}
        super code, attributes.merge(:roots => [0, 1])
      end
    end
  end
end
