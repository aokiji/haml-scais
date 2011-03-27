module Scais
  module Topology
    class Acelerator
      include Scais::Helpers::Chainable
      include Scais::Helpers::Attributed
      include Renderer
      
      attr_chainable :code, :mode, :type, :max_iterations, :threshold
      
      def initialize code, attributes={}
        @code = code
        self.attributes = attributes
      end
      
      # Method that render xml for the acelerator
      def to_xml
        render File.expand_path('../haml/acelerator.haml', __FILE__), self
      end
      
      def to_s
        to_xml
      end
    end
  end
end
