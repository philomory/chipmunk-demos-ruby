require 'chipmunk_object'

module ChipmunkDemos
  class Demo
    STEPS = 3
    DT = 1.0/60.0/STEPS
    
    attr_accessor :space, :chipmunk_objects
    def initialize
      # Unfortunately, this function is not available in the ruby wrapper for
      # chipmunk at the moment.
      # CP.reset_shape_id_counter
      @space = CP::Space.new
      @chipmunk_objects = []
    end
    
    def update
      STEPS.times do
        self.space.step(DT)
      end
    end
    
  end
end