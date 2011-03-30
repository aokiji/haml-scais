require File.expand_path('../helper',__FILE__)

class TestHamlScais < Test::Unit::TestCase
  def test_block
    block = Block::Base.new :code => 'H1'
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
    block = Block::Base.new :code => 'Test'
    array = [0, 1, 2]
    block.constants = {'FORMULA' => 'A < B', 'ARRAY' => array, 'STRING' => 'HOLA'}
    
    #assert block.constants[0].value.to_s == '<![CDATA[A < B]]>', 'String "A < B" not parsed with cdata'
    puts block.constants[0].value.to_s
    assert block.constants[1].value.to_s == array.join(','), 'Array not joined'
    assert block.constants[2].value.to_s == 'HOLA', '"HOLA" String modified!'
  end
  
  def test_fint
    fint = Fint.new('B1').name('FINT TRIGGER').debug(:info).index(1).modes('ALL')
    fint.outputs<< fint.output.save(true).alias('TRIGGER')
    fint.times([-100,0.1,0.1,100])
    fint.coefs([0,0,1,1])
    puts fint.to_xml
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
  
  def test_funin
    funin = Funin.new('B8', :name =>'FUNIN EXP-2', :active => true).debug(:fatal).index(8).modes('B')
    funin.outputs<< funin.output.save(true).alias('ANALYT2')
    funin.inputs<< funin.input.alias('I0').from(Block::Base.new('B1').output(0)).modes('B')
    funin.formula = "I0+sqrt(2/5)*exp((TAU-TIME)/2)*sin(0.5*(sqrt(5)*(TIME-TAU)*PI)"
    puts funin.to_xml
  end
  
  def test_logate
    logate = Logate.new('B16').name('MULTIPLEXOR').active(true).debug(:info).index(16).modes('ALL')
    logate.outputs<< logate.output.alias('MULTIPLEXACION').save(true)
    logate.inputs<< logate.input(0).alias('I0').from(Block::Base.new('B1').output('TRIGGER')).modes('ALL')
    logate.high = logate.input.from(Block::Base.new('B14').output(0)).modes('ALL').alias('IN_HIGH')
    logate.low = logate.input.from(Block::Base.new('B15').output(0)).modes('ALL').alias('IN_LOW')
    logate.condition = "I0>0"
    logate.initial_output(0, :alias => 'INITSTATE')
    puts logate.to_xml
  end
  
  def test_logate_handler
    lh = LogateHandler.new('B5').name('LogateModeChange').debug(:info).active(true).index(5).modes('ALL')
    lh.outputs<< lh.output.alias('LOGAT1')
    lh.inputs<< lh.input.from(Block::Base.new('B4').output(0)).alias('I0').modes('ALL')
    lh.previous_output :alias => 'PREVOUT'
    lh.initial_output(0, :alias => 'INITOUT')
    lh.precision = 0.005
    lh.formula = "(TIME<2.3) and (I0>1)"
    puts lh.to_xml
  end
  
  def test_convex
    c = Convex.new('B9', :name => 'CONVEX LAG-2MODE').active(true).debug(:info).index(9).modes('B')
    c.outputs<< c.output.save(true).alias('NUM-B')
    c.inputs<< c.input.from(Block::Base.new('B7').output(0)).modes('B')
    c.roots = [-0.5, 0.5]
    c.vforz = 0
    puts c.to_xml 
  end
  
  def test_vmetodo
    topo = Topology.new("OsciladorVanPol", :description => "Diferential Ecuation Resolution", :name => "OsciladorVanPol") do |topo|
      b1 = Vmetodo.new('B1').name('VMETODO').active(true).debug(:info).modes('ALL')
      b1.yp1 'y2', :alias => 'yp1', :save => true
      b1.yp2 '-y1 + cos(1.41 * Vmetodo::TIME)', :alias => 'yp2', :save => true
      b1.y1 0.01, :alias => :y1, :save => true
      b1.y2 0.00001, :alias => :y2, :save => true
      puts "HOLA"
      topo.add_block b1
    end
    puts topo.to_xml
  end
  
  def test_acelerator
    fint = Fint.new('BF1').times((1..10).to_a).coefs(((1..10).to_a))
    fint.inputs do
      input.from('BI1').recursive(true).acelerator('Acc1', :threshold => 100)
    end
    puts fint
    a = Acelerator.new('Acc1', :mode => 'PASSIVE').threshold(1).max_iterations(10)
    puts a.to_xml
  end
  
  def test_integrator
    c = Integrator.new('B9', :name => 'CONVEX LAG-2MODE').active(true).debug(:info).index(9).modes('B')
    c.outputs<< c.output.save(true).alias('NUM-B')
    c.inputs<< c.input.from(Block::Base.new('B7').output(0)).modes('B')
    c.vforz = 0
    c.previous_input :alias => 'PREVIN'
    c.previous_output :alias => 'PREVOUT'
    c.initial_output :alias => 'PREVOUT'
    puts c.to_xml
  end
  
  def test_new_syntax
    topo= Topology.new('Topo1').name('Topology').description('Description') do |topo|
      topo.add_block do
        Fint.new('BF1').times((1..10).to_a).coefs(((1..10).to_a))
      end
      topo.add_block do
        Fint.new('BF1', :index => 3, :times => ((1..10).to_a), :coefs => ((1..10).to_a))
      end
      fint = topo.add_block do
        fint = 1.Fint('BF1')
        fint.outputs<< fint.output(0).alias('JA').save(true)
        fint
      end
      topo.add_block do
        funin = Funin.new('B8', :name =>'FUNIN EXP-2', :active => true).debug(:fatal).index(8).modes('B')
        funin.outputs do 
          output.save(true).alias('ANALYT2')
        end
        funin.formula "I0+sqrt(2/5)*exp((TAU-TIME)/2)*sin(0.5*(sqrt(5)*(TIME-TAU)*PI)"
        funin.inputs do 
          input.alias('I0').from(fint).modes('B')
        end
      end
    end
    puts topo.to_xml
  end
end
