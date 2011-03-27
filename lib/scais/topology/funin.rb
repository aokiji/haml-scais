module Scais
  module Topology
    class Funin < Block::Base
      constants :formula
      
      validates :formula, :presence => true
      validates :outputs, :many => {:exact => 1}
      
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
