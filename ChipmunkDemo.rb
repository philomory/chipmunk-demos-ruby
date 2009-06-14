#!/usr/bin/env ruby

require 'enumerator'

# Added for consistency between 1.8 and 1.9. Just ignore it.
unless [].respond_to?(:enum_cons)
  module Enumerable
    alias :enum_cons :each_cons
  end
end

require 'gosu'
require 'chipmunk_object'
require 'chipmunk_adjust'
require 'draw_primitives'

module ChipmunkDemos
  class MainWindow
  end
end