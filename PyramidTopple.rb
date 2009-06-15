require 'demo'

module ChipmunkDemos
  module PyramidTopple
    class PyramidToppleDemo < Demo
      def initialize
        super
        @space.iterations = 20
        @space.resize_active_hash(40.0,2999)
        @space.resize_static_hash(40.0,999)
        @space.gravity = CP::Vec2.new(0, -300)
      
        @floor = Floor.new
        @dominoes = []
        height = 9
        for i in (0..height) do
          offset = CP::Vec2.new(-i*60/2.0, (height - i)*52)
          for j in (0...i) do
            @dominoes << Domino.new(CP::Vec2.new(j*60,-220) + offset)
            @dominoes << Domino.new(CP::Vec2.new(j*60,-197) + offset,Math::PI/2.0)
            @dominoes << Domino.new(CP::Vec2.new(j*60 + 30,-191) + offset,Math::PI/2.0)
          end
          @dominoes << Domino.new(CP::Vec2.new(-17,-174) + offset)
          @dominoes << Domino.new(CP::Vec2.new((i - 1)*60 + 17, -174) + offset)
        end
      
        @space.add_objects(@floor,*@dominoes)
        @chipmunk_objects.push(@floor,*@dominoes)
      end
    end # class PyramidToppleDemo
    
    class Domino
      include CP::Object
      VERTICES = [
        CP::Vec2.new(-3,-20),
        CP::Vec2.new(-3, 20),
        CP::Vec2.new( 3, 20),
        CP::Vec2.new( 3,-20)
      ]
      MASS       = 1.0
      MOMENT     = CP::moment_for_poly(MASS,VERTICES,CP::vzero)
      ELASTICITY = 0.0
      FRICTION   = 0.6
      
      attr_reader :body, :shape
      def initialize(p,angle=nil)
        @body = CP::Body.new(MASS,MOMENT)
        @body.p = p
        @body.angle = angle if angle
        @shape = CP::Shape::Poly.new(@body,VERTICES,CP::vzero)
        @shape.e = ELASTICITY
        @shape.u = FRICTION
        
        init_chipmunk_object(@body,@shape)
      end
    end
    
    class Floor
      include CP::Object
      ELASTICITY = FRICTION = 1.0
      
      attr_reader :body, :shape
      def initialize
        @body = CP::StaticBody.new
        a = CP::Vec2.new(-600,-240)
        b = CP::Vec2.new( 600,-240)
        @shape = CP::Shape::Segment.new(@body,a,b,0.0)
        @shape.e = ELASTICITY
        @shape.u = FRICTION
        init_chipmunk_object(@body,@shape)
      end
    end
  end # module PyramidTopple
end # module ChipmunkDemos