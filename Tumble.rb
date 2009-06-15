require 'demo'

module ChipmunkDemos
  module Tumble
    class TumbleDemo < Demo
      def initialize
        super
        @steps = 3
        @space.resize_active_hash(30.0, 999)
        @space.resize_static_hash(200.0, 99)
        @space.gravity = CP::Vec2.new(0,-600)
        
        @tumbler = Tumbler.new
        @bricks = []
        for i in (0...3) do
          for j in (0...7) do
            @bricks << Brick.new(CP::Vec2.new(i*60 - 150, j*30 - 150))
          end
        end
        
        @space.add_objects(@tumbler,*@bricks)
        @chipmunk_objects.push(@tumbler,*@bricks)
      end
      
      def update
        @steps.times do
          @space.step(self.dt)
          @tumbler.update(self)
        end
      end
      
    end # class TumbleDemo
    class Brick
      include CP::Object
      VERTICES = [
        CP::Vec2.new(-30,-15),
        CP::Vec2.new(-30, 15),
        CP::Vec2.new( 30, 15),
        CP::Vec2.new( 30,-15)
      ]
      MASS    = 1.0
      MOMENT  = CP::moment_for_poly(MASS,VERTICES,CP::vzero)
      ELASTICITY = 0.0
      FRICTION   = 0.7
      
      attr_reader :body, :shape
      def initialize(p)
        @body = CP::Body.new(MASS,MOMENT)
        @body.p = p
        @shape = CP::Shape::Poly.new(@body,VERTICES,CP::vzero)
        @shape.e = ELASTICITY
        @shape.u = FRICTION
        
        init_chipmunk_object(@body,@shape)
      end
    end # class Brick
    
    class Tumbler
      include CP::Object
      VERTICES = [
        CP::Vec2.new(-200,-200),
        CP::Vec2.new(-200, 200),
        CP::Vec2.new( 200, 200),
        CP::Vec2.new( 200,-200)
      ]
      ELASTICITY = FRICTION = 1.0
      SPIN = 0.4
      
      attr_reader :body, :shapes
      def initialize
        @body = CP::StaticBody.new
        
        # Give the box a little spin.
        # Because staticBody is never added to the space, we will need to
        # update it ourselves (see update method).
        # NOTE: Normally you would want to add the segments as normal and not static shapes.
        # I'm just doing it to demonstrate the Space#rehash_static method.
        @body.w = SPIN
        
        @shapes = VERTICES.enum_cons(2).to_a.push([VERTICES[-1],VERTICES[0]]).map do |a,b|
          seg = CP::Shape::Segment.new(@body,a,b,0.0)
          seg.e = ELASTICITY
          seg.u = FRICTION
          seg
        end
        
        init_chipmunk_object(@body,*@shapes)
      end
      
      def update(demo)
        # Manually update the position of the static shape so that the box rotates.
        @body.update_position(demo.dt)
        
        # Because the box is added as a static shape and we moved it 
        # we need to manually rehash the static spatial hash.
        demo.space.rehash_static
        
      end
    end # class Tumbler
    
  end # module Tumble
end # module ChipmunkDemos