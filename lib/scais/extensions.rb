module Scais
  module Extensions
    def render file, locals = {}
      Haml::Engine.new(File.read(file), default_haml_options).render(Object.new, locals)
    end
    private
    def default_haml_options
      {:attr_wrapper => '"'}
    end
  end
end
