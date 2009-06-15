#!/usr/bin/env ruby

require 'enumerator'

# Added for consistency between 1.8 and 1.9. Just ignore it.
unless [].respond_to?(:enum_cons)
  module Enumerable
    alias :enum_cons :each_cons
  end
end
unless 'a'.respond_to?(:ord)
  class String
    def ord
      self[0]
    end
  end
end

require 'gosu'
require 'chipmunk_object'
require 'chipmunk_adjust'
require 'draw_primitives'

require 'PyramidStack'
require 'Plink'
require 'Bounce'
require 'Tumble'
require 'PyramidTopple'

module ChipmunkDemos
  DEMOS = [
    PyramidStack::PyramidStackDemo,
    Plink::PlinkDemo,
    Tumble::TumbleDemo,
    PyramidTopple::PyramidToppleDemo,
    Bounce::BounceDemo
  ]
  
  class MainWindow < Gosu::Window
    include CP::DrawPrimitives
    def initialize
      super(640,480,false)
      @demo = DEMOS[0].new
    end
    
    def update
      @demo.update
    end
    
    def draw
      self.clip_to(0,0,self.width,self.height) do 
        self.draw_rect(0,0,self.width,self.height,Gosu::white)
        @demo.chipmunk_objects.each {|obj| obj.draw(self)}
      end
    end
    
    def button_down(id)
      if id == Gosu::KbEscape
        close
      elsif (demo = DEMOS[(self.button_id_to_char(id).ord - 'a'.ord)] rescue nil)
        @demo = demo.new
      end
    end
    
    def centerx
      0
    end
    
    def centery
      0
    end
  end
end

ChipmunkDemos::MainWindow.new.show