require 'demo'

module ChipmunkDemos
  module Bounce
    class BounceDemo < Demo
      def initialize
        super
        @space.iterations = 10
        @walls = Walls.new
        @paddle = Paddle.new(CP::vzero)
        @boxes = Array.new(10) {Box.new(CP::Vec2.new(rand(640) - 320,rand(480) - 240))}
        @space.add_objects(@walls,@paddle,*@boxes)
        @chipmunk_objects.push(@walls,@paddle,*@boxes)
      end
    end
    
    class Box
      include CP::Object
      SIZE     = 10.0
      MASS     =  1.0
      VERTICES = [
        CP::Vec2.new(-SIZE,-SIZE),
        CP::Vec2.new(-SIZE, SIZE),
        CP::Vec2.new( SIZE, SIZE),
        CP::Vec2.new( SIZE,-SIZE)
      ]
      MOMENT   = CP::moment_for_poly(MASS,VERTICES,CP::vzero)
      RADIUS   = CP::Vec2.new(SIZE,SIZE).length
      ELASTICITY = 1.0
      FRICTION   = 0.0
      
      attr_reader :shape, :body
      def initialize(p)
        @body = CP::Body.new(MASS,MOMENT)
        @body.p = p
        @body.v = CP::Vec2.new(2*rand()-1,2*rand()-1) * 200
        
        @shape = CP::Shape::Poly.new(@body,VERTICES,CP::vzero)
        @shape.e = ELASTICITY
        @shape.u = FRICTION
        
        init_chipmunk_object(@body,@shape)
      end
    end
    class Paddle
      include CP::Object
      MASS   =   100.0
      MOMENT = 10000.0
      RADIUS =     5.0
      
      attr_reader :anchor, :body, :shape, :joint
      def initialize(p)
        @body   = CP::Body.new(MASS,MOMENT)
        a = p + CP::Vec2.new(-75,0)
        b = p + CP::Vec2.new( 75,0)
        @shape  = CP::Shape::Segment.new(body,a,b,RADIUS)
        
        @anchor = CP::StaticBody.new
        @anchor.p = p
        @joint = CP::Constraint::PivotJoint.new(@body,@anchor,CP.vzero,CP.vzero)
        
        init_chipmunk_object(@body,@shape,@anchor,@joint)
      end
    end
    
    class Walls
      include CP::Object
      ELASTICITY = FRICTION = 1.0
      VERTICES = [
        CP::Vec2.new(-320, 240),
        CP::Vec2.new(-320,-240),
        CP::Vec2.new( 320,-240),
        CP::Vec2.new( 320, 240)
      ]
      
      attr_accessor :body, :shapes
      def initialize
        @body = CP::StaticBody.new
        @shapes = VERTICES.enum_cons(2).to_a.push([VERTICES[-1],VERTICES[0]]).map do |a,b|
          seg = CP::Shape::Segment.new(@body,a,b,0.0)
          seg.e = ELASTICITY
          seg.u = FRICTION
          seg
        end
        init_chipmunk_object(@body,*@shapes)
      end # def initialize
    end # class Walls
  end # module Bounce
end # module ChipmunkDemos