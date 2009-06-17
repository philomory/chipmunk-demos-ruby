require 'demo'

module ChipmunkDemos
  module WalkBot
    WALK_BOT_GROUP = 1
    class WalkBotDemo < Demo
      def initialize
        @steps = 3
        @space.gravity = cpv(0.0,-600.0)
        @space.iterations = 50
        @boundary = Boundary.new
        @bot = Bot.new(cpv(200,-150))
        
        @space.add_objects(@boundary,@bot)
        @chipmunk_objects.push(@boundary,@bot)
      end
    end
    class Bot
      include CP::Object
      attr_reader :chassis
      def initialize(p)
        @chassis = Chassis.new(p)
    end
    class Chassis
      include CP::Object
      WIDTH  = 60.0
      HEIGHT = 20.0
      VERTS  = [
        cpv(-WIDTH,-HEIGHT),
        cpv(-WIDTH, HEIGHT),
        cpv( WIDTH, HEIGHT),
        cpv( WIDTH,-HEIGHT)
      ]
      MASS   =  5.0
      MOMENT = CP::moment_for_poly(MASS,VERTS,CP::vzero)
      ELASTICITY = 0.0
      FRICTIOn   = 1.0
      attr_reader :body,:shape
      def initialize(p)
        @body  = CP::BODY.new(MASS,MOMENT)
        @body.p = p
        @shape = CP::Shape::Poly.new(@body,VERTS,CP::vzero)
        @shape.e = ELASTICITY
        @shape.u = FRICTION
        @shape.group = WALK_BOT_GROUP
        
        init_chipmunk_object(@body,@shape)
      end
    end
    class Leg
      include CP::Object
    end
    class Motor
      include CP::Object
    end
    class Crankshaft
      include CP::Object
      MASS     =  1.0
      RADIUS   = 20.0
      MOMENT   = CP::moment_for_circle(MASS,RADIUS,CP::vzero)
      SPEED    = (2.0*Math::PI)/3.0
      ELASTICITY = 0.0
      FRICTION = 1.0
      X_OFFSET = WIDTH - RADIUS
      Y_OFFSET = RADIUS + 30.0
      attr_reader :body, :shape
      def initialize(chassis,x_factor)
        @body = CP::Body.new(MASS,MOMENT)
        @body.p = chassis.p + cpv(x_factor * X_OFFSET,Y_OFFSET)
        @shape = CP::Shape::Circle.new(@body,RADIUS,CP::vzero)
        @shape.e = ELASTICITY
        @shape.u = FRICTION
        @shape.group = WALK_BOT_GROUP
        
        init_chipmunk_object()
      end  
    end
    class Boundary
      include CP::Object
      VERTS = [
        cpv(-320, 240),
        cpv(-320,-240),
        cpv( 320,-240),
        cpv( 320, 240)
      ]
      ELASTICITY=FRICTION=1.0
      attr_reader :shapes, :body
      def initialize
        @body = CP::StaticBody.new
        @shapes = VERTS.enum_cons(2).map do |a,b|
          shape = CP::Shape::Segment.new(@body,a,b,0.0)
          shape.e = ELASTICITY
          shape.f = FRICTION
        end
        init_chipmunk_object(@body,*@shapes)
      end
    end
  end
end
    