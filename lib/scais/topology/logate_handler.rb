module Scais
  module Topology
    class LogateHandler < Block::Base
      constants :formula, :action, :limit_conditions, :precision
      internal_variables :previous_output
      initial_variables :initial_output
      
      validates :outputs, :many => {:exact => 1}
      validates :constants, :many => {:exact => 2}
      
      def initialize code, attributes={}
        super code, attributes.merge(:module => 'FUNIN')
      end
      
      # add constants before validation
      def before_validate
        self.outputs<< output(0) if self.outputs.empty?
        super
      end
    end
  end
end
