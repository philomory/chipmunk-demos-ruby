require 'chipmunk_object'

module ChipmunkDemos
  class Demo
    
    def dt
      (1.0/60.0)/steps
    end
    
    attr_accessor :steps,:space, :chipmunk_objects,:arrow_direction
    def initialize
      CP::Shape.reset_id_counter
      @space = CP::Space.new
      @chipmunk_objects = []
      @steps = 3
      @arrow_direction = CP::vzero
    end
    
    def update
      self.steps.times do
        self.space.step(self.dt)
      end
    end
    
    def options
      {:color => true}
    end

  end
end