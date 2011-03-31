module Scais
  module Topology
    class LogateHandler < Block::Base
      constants :action, :limit_conditions, :precision, :condition => :formula
      internal_variables :previous_output
      initial_variables :initial_output
      
      validates :precision, :presence => true
      validates :outputs, :many => {:exact => 1}
      validates :constants, :many => {:exact => 2}
      
      def initialize code, attributes={}
        super code, attributes.merge(:module => 'LOGATEHANDLER')
      end
      
      # add constants before validation
      def before_validate
        self.previous_output :alias => 'PREVOUT' unless self.previous_output
        self.outputs<< output(0) if self.outputs.empty?
        super
      end
    end
  end
end
