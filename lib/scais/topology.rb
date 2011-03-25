class Topology
  include Chainable
  include Attributed
  
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
    # concat to the haml buffer2
    self.haml_concat block.to_xml
  end
  
  #defines schema location
  def schema
    if Scais.root
      File.join(Scais.root, 'BABIECA', 'Schema', 'Topology.xsd')
    else
      nil
    end 
  end
  
  def to_xml
    topo = self
    blck = topo_block
    render(File.expand_path("../modules/haml/topology.haml", __FILE__), self, {}, &block = Proc.new {blck.call(topo) if blck})
  end
  
  private
  def topo_block
    self.chain_block || @block
  end
end
