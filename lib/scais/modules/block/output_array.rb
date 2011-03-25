class OutputArray < Array
  attr_accessor :block
  
  def initialize block
    @block = block
  end
  
  def << obj
    obj = parse(obj) unless obj.is_a?(Output)
    obj.n = self.size+1
    super obj
  end
  
  private
  def parse options
    Output.new block
  end
end
