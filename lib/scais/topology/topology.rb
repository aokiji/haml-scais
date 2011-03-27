module Scais
  module Topology
    include Block
    class Topology
      include Scais::Helpers::Chainable
      include Scais::Helpers::Attributed
      
      attr_reader :code
      attr_accessor :current_block
      attr_chainable :name, :description
      
      def initialize code, options={}, &block
        @code = code
        @block = block
        @buffer = ""
        @current_block = 1
        self.attributes = options
      end
      
      # add a block to the topology.
      # automatically add index incrementing 1 by 1 if missing
      def add_block block
        if block.index
          self.current_block = block.index+1
        else
          block.index(current_block)
          self.current_block+=1
        end
        # concat to the haml buffer
        haml_concat block.to_xml
      end
      
      #defines schema location
      def schema
        if Scais.root
          'file://'+File.join(Scais.root, 'BABIECA', 'Schema', 'Topology.xsd')
        else
          nil
        end 
      end
      
      def to_xml
        topo = self
        blck = topo_block
        block = Proc.new {
          haml_concat capture_haml(topo, &block = blck)
        } if blck
        render(File.expand_path("../haml/topology.haml", __FILE__), self, {}, &block = block)
      end
      
      def to_s
        to_xml
      end
      
      private
      def topo_block
        self.chain_block || @block
      end
    end
  end
end
