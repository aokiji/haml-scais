require 'scais/extensions'
module Scais
  module Modules
    include Scais::Extensions
    attr_accessor :nblocks
    
    #
    # LOGATE BLOCK GENERATOR
    #
    #   logate CODE, :low => INPUT, :high => INPUT, :condition => COND, :initial_output => {:alias, :value}
    def logate code, options={}
      raise Exception.new('missing low value') if options[:low].nil?
      raise Exception.new('missing high value') if options[:high].nil?
      raise Exception.new('too many outputs') if options[:outputs] and options[:outputs].keys.size > 1
      raise Exception.new('missing condition') if options[:condition].nil?
      raise Exception.new('missing initial output') if options[:initial_output].nil?
      options[:inputs] = {} unless options[:inputs]
      options[:inputs].merge! 'IN_LOW' => options[:low], 'IN_HIGH' => options[:high]
      options = default_block_options(:outputs => {'O0' => false}, :name => code).merge(options).merge(:module_type => 'FUNIN', :initial_variables =>{'INITIALOUTPUT' => options[:initial_output]}, :constants => {'FORMULA' => options[:condition]})
      block code, options
    end
    #
    # FUNIN BLOCK GENERATOR
    #
    #   funin CODE, :formula => FORM
    def funin code, options={}
      raise Exception.new('missing formula') if options[:formula].nil?
      raise Exception.new('too many outputs') if options[:outputs].keys.size > 1
      options.merge! :constants => {'FORMULA' => options[:formula]}
      options = default_block_options(:outputs => {'O0' => false}, :name => code).merge(options).merge(:module_type => 'FUNIN')
      block code, options
    end
    #
    # FINT BLOCK GENERATOR
    #
    #   fint CODE, :time => ARRAY, :coef => ARRAY
    def fint code, options={}
      raise Exception.new('expecting no inputs') if options[:inputs] and options[:inputs].keys.size > 0
      raise Exception.new('missing time') if options[:time].nil?
      raise Exception.new('missing coef') if options[:coef].nil?
      options.merge! :constants => {'TIME' => options[:time], 'COEF' => options[:coef]}
      options = default_block_options(:outputs => {'O0' => false}, :name => code).merge(options).merge(:module_type => 'FINT')
      block code, options
    end
    
    #
    # GENERIC BLOCK GENERATOR
    #
    def block code, options={}
      options = default_block_options.merge options
      options[:code] = code
      nblocks = options[:index].to_i if options[:index]
      self.nblocks+=1
      render File.expand_path('../modules/block.haml', __FILE__), :options => options
    end
    
    def accelerator code, threshold, options={}
      render File.expand_path('../modules/accelerator.haml', __FILE__), :code => code, :threshold => threshold, :options => options
    end
    
    def nblocks
      @nblocks||= 1
    end
    
    private 
    def default_block_options options={}
      { :active => 1 , :debugging_level => 0 , :index => nblocks, :modes => 'ALL',
        :outputs => {}, :inputs => {}, :constants => [], :initial_variables => {}}.merge options
    end
  end
end
