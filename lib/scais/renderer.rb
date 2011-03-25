module Renderer
  # render xml from haml file
  def render file, scope = Object.new, locals = {}, &block
    Haml::Engine.new(File.read(file), default_haml_options).render(scope, locals, &block)
  end
  
  # render xml inline
  def render_inline text, scope = Object.new, locals = {}, &block
    Haml::Engine.new(text, default_haml_options).render(scope, locals, &block)
  end
  
  private
  def default_haml_options
    {:attr_wrapper => '"'}
  end
end
