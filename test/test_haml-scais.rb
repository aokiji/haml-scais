require File.expand_path('../helper',__FILE__)

class TestHamlScais < Test::Unit::TestCase
  def test_block
    block = Block.new :code => 'H1'
    modes = ['A', 'B']
    block.modes = modes    
    assert block.modes.to_s == modes.join(','),  'Modes Array.to_s should have been extended'
    output = Output.new(block)
    output.save = true
    assert output.save_value == 1, 'Save value should be now 1'
    block.outputs << output
    block.outputs << {:save => true}
    block.constants = {'FORMULA' => 'A < B'}
    puts block.index(11).to_xml
  end
  
  def test_output
    puts Fint.new('BF1').output(0).inspect
  end
  
  def test_constants
    block = Block.new :code => 'Test'
    array = [0, 1, 2]
    block.constants = {'FORMULA' => 'A < B', 'ARRAY' => array, 'STRING' => 'HOLA'}
    
    #assert block.constants[0].value.to_s == '<![CDATA[A < B]]>', 'String "A < B" not parsed with cdata'
    puts block.constants[0].value.to_s
    assert block.constants[1].value.to_s == array.join(','), 'Array not joined'
    assert block.constants[2].value.to_s == 'HOLA', '"HOLA" String modified!'
  end
  
  def test_fint
    puts Fint.new('BF1', :index => 1).times((1..10).to_a).coefs((1..10).to_a).to_xml
    puts Fint.new('BF1', :index => 2, :times => ((1..10).to_a), :coefs => ((1..10).to_a)).to_xml
  end

  def test_topology
    topo= Topology.new('Topo1').name('Topology').description('Description') do |topo|
      topo.add_block Fint.new('BF1').times((1..10).to_a).coefs(((1..10).to_a))
      topo.add_block Fint.new('BF1', :index => 3, :times => ((1..10).to_a), :coefs => ((1..10).to_a))
      fint = 1.Fint('BF1')
      fint.outputs<< fint.output(0).alias('JA').save(true)
      topo.add_block fint
    end
    puts topo.to_xml
  end
  
  def test_logate
    puts logate 'BL', :low => 'BF1.O0', :high => 'BF2.O0', :condition => 'TIME > 100', :initial_output => 0
  end
end
