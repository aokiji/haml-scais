require 'haml'
require 'scais/helpers'
require 'scais/scais'
require 'scais/topology'

self.send :include, Renderer
self.send :include, Scais::Topology
