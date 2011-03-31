module Scais
  module Topology
    class Files < Block::Base
      constants :file
      
      validates :outputs, :many => {:minimum => 1}
      validates :inputs, :many => {:exact => 0}
      
      def initialize code, attributes={}
        super code, attributes.merge(:module => 'FILES')
      end
      
      #
      # select columns for a specific output
      #   select_for "O0", :time => 1, :value => 2
      #
      def select_for output, options={}
        #parse output
        if output.is_a?(Integer)
          output = "O#{n}"
        elsif output.is_a?(Output)
          output = output.code
        else
          output = output.to_s
        end
        
        #add constant
        self.constants<< Constant.new(output, [options[:time], options[:value]])
        self
      end
    end
    
    class Integrator < Convex
      def initialize code, attributes={}
        super code, attributes.merge(:roots => [0, 1])
      end
    end
  end
end
