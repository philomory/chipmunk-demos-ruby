require 'demo'

module ChipmunkDemos
  module TheoJansen
    OFFSET = 30.0
    SEG_RADIUS = 3.0
    ROBOT_GROUP = 1
    class TheoJansenDemo < Demo
      def initialize
        super
        @space.gravity = cpv(0,-500)
        @space.iterations = 20
        @boundary = Boundary.new
        @bot = Bot.new
        
        @space.add_objects(@boundary,@bot)
        @chipmunk_objects.push(@boundary,@bot)
      end
      def update
        coef = (2.0 + self.arrow_direction.y)/3.0
        rate = (self.arrow_direction.x*10.0*coef)
        @bot.motor.rate = -rate
        @bot.motor.max_force = ((rate == 0) ? 0.0 : 100000.0)
        super
      end
    end
    class Bot
      include CP::Object
      NUM_LEGS = 2 # this is pairs of legs, not total legs
      SIDE = 30.0 #? why is this called side?
      def initialize
        @chassis = Chassis.new
        @crank = Crankshaft.new(@chassis)

        @legs = []
        for i in (0...NUM_LEGS) do
          for j in (0..1) do
            s = (j == 0 ? 1 : -1)
            angle = (2*i+j)/NUM_LEGS*Math::PI
            v = CP::Vec2.for_angle(angle) * Crankshaft::RADIUS
            @legs << LegAssembly.new(SIDE,OFFSET,@chassis,@crank,v)
          end
        end
        
        init_chipmunk_object(@chassis,@crank,*@legs)
      end
    end
    class Chassis
      include CP::Object
      MASS = 2.0
      A = cpv(-OFFSET,0.0)
      B = cpv( OFFSET,0.0)
      MOMENT = CP::moment_for_segment(MASS,A,B)
      attr_reader :body,:shape
      def initialize
        @body = CP::Body.new(MASS,MOMENT)
        @shape = CP::Shape::Segment.new(@body,a,b,SEG_RADIUS)
        @shape.group = ROBOT_GROUP
        init_chipmunk_object(@body,@shape)
      end
    end
    class Crankshaft
      include CP::Object
      MASS     =  1.0
      RADIUS   = 13.0
      MOMENT   = CP::moment_for_circle(MASS,RADIUS,0.0,CP::vzero)

      attr_reader :body, :shape, :joint, :motor
      def initialize(chassis)
        @body = CP::Body.new(MASS,MOMENT)
        @shape = CP::Shape::Circle.new(@body,RADIUS,CP::vzero)
        @shape.group = WALK_BOT_GROUP
        @joint = CP::Constraint::PivotJoint.new(chassis.body,@body,CP::vzero,CP::vzero)
        @motor = CP::Constraint::SimpleMotor.new(chassis.body,@body,6.0)
        
        init_chipmunk_object(@body,@shape,@joint,@motor)
      end  
    end
    class LegAssembly
      include CP::Object
      MASS = 1.0
      def initialize(side,offset,chassis,crank,anchor)
        @upper_leg = UpperLeg.new(side,offset,chassis,crank,anchor)
        @lower_leg = LowerLeg.new(side,offset,chassis)
        @gear = CP::Constraint::Gear.new(@upper_leg.body,@lower_leg.body,cpv(offset,0.0),CP::vzero)
        init_chipmunk_object(@upper_leg,@lower_leg,@gear)
      end
    end
    class UpperLeg
      include CP::Object
      MASS = 1.0
      attr_reader :body
      def initialize(side,offset,chassis,crank,anchor)
        a,b = CP::vzero,cpv(0.0,side)
        @body = CP::Body.new(MASS,CP::moment_for_segment(MASS,a,b))
        @body.p = cpv(offset,0.0)
        @shape = CP::Shape::Segment.new(@body,a,b,SEG_RADIUS)
        @pivot = CP::Constraint::PivotJoint.new(chassis.body,@body,@body.p,CP::vzero)
        @pin   = CP::Constraint::PinJoint.new(crank.body,@body,anchor,B)
        @pin.dist = Math.sqrt(side*side + offset*offset)
        init_chipmunk_object(@body,@shape,@pivot,@pin)
      end
    end
    class LowerLeg
      include CP::Object
      MASS = 1.0
      attr_reader :body
      def initialize(side,offset,chassis)
        a,b = CP::vzero,cpv(0.0,-side)
        @body = CP::Body.new(MASS,CP::moment_for_segment(MASS,a,b))
        @body.p = cpv(offset,-side)
        @leg_shape = CP::Shape::Segment.new(@body,A,B,SEG_RADIUS)
        @leg_shape.group = ROBOT_GROUP
        @foot_shape = CP::Shape::Circle.new(@body,SEG_RADIUS*2,B)
        @foot_shape.e = 0.0; @foot_shape.u = 1.0
        @joint = CP::Constraint::PinJoint.new(chassis.body,@body,cpv(offset,0.0),CP::vzero)
        @pin   = CP::Constraint::PinJoint.new(crank.body,@body,anchor,A)
        @pin.dist = Math.sqrt(side*side + offset*offset)
        init_chipmunk_object(@body,@leg_shape,@foot_shape,@joint,@pin)
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
          shape.u = FRICTION
          shape
        end
        init_chipmunk_object(@body,*@shapes)
      end
    end