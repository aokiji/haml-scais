module Scais
  module Topology
    class Vmetodo < Block::Base
      TIME = 'VTIME'
      
      internal_variables :vtime
      
      def initialize code, attributes={}
        @equations = 0
        super code, attributes.merge(:module => 'VMETODO')
      end
      
      # add constants before validation
      def before_validate
        if @Vtime
          self.vtime :alias => 'VmetodoTime'
        end
        super
      end
      
      # override method missing to add ypn and yn methods
      def method_missing(sym, *args)
        if sym.to_s =~ /^yp\d+$/
          # calling method ypn
          n = sym.to_s[/\d+/]
          if args.empty?
            get_equation(n)
          else
            set_equation(n, *args)
          end
        elsif sym.to_s =~ /^y\d+$/
          n = sym.to_s[/\d+/]
          set_variable(n, *args)
        else
          super sym, *args
        end
      end
      
      # Override base because of different output names
      # Get output from sym or string for this block
      #   .output(ypn)
      #   .output(yn)
      def output(n)
        out = Output.new(self)
        out.code(n.to_s.upcase) unless n.nil?
        out
      end
      
      private
      # set equation n (ypn) and ypn output attributes
      def set_equation(n, eq, options)
        n = n.to_i
        @equations = n if @equations < n
        # replace Vmetodo::Time
        eq.gsub!('Vmetodo::TIME') do |match|
          @Vtime = true
          Vmetodo::TIME
        end
        
        # add constant formula to list
        eval "@yp#{n} = '#{eq}'"
        self.constants.delete_if{|x| x.code == "FORMULA#{n}"};
        self.constants<< Constant.new("FORMULA#{n}", eq);
        
        # add outputs ypn
        self.outputs<< Output.new(self, nil, options.merge({:code => "YP#{n}"}))
      end
      
      # get string for equation n (ypn)
      def get_equation(n)
        eval "@yp#{n}"
      end
      
      # sets value of variable n (yn)
      def set_variable(n, *args)
        options = args.last ? args.pop : {}
        
        # add initial value
        unless args.empty?
           self.initial_variables<< InitialVariable.new("y#{n}", :value => args[0], :alias => "y#{n}")
        end
        
        # add outputs ypn
        self.outputs<< Output.new(self, nil, options.merge({:code => "Y#{n}"}))
      end
    end
  end
end
