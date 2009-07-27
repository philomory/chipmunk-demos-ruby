require 'demo'

module ChipmunkDemos
  module PinballPaddle
    class PinballPaddleDemo < Demo
      OPTIONS = {
        :title => "Paddle Demo"
      }
      def initialize
        super
        @steps = 2
        @space.gravity = cpv(0,600)
        frame  = Frame.new
        paddle = PaddleAssembly.new(cpv(320,240),frame.body)
      end
    end
    class PaddleAssembly
      include CP::Object
      def initialize(p,static_body)
        paddle = Paddle.new(p,static_body)
        init_chipmunk_object(paddle)
      end
    end
    class Paddle
      include CP::Object
      MASS = 2.0
      VERTICES = [
        cpv(-10, 0),
        cpv( 10,-5),
        cpv( 10, 5)
      ]
      MOMENT = CP::moment_for_poly(MASS,VERTICES,CP::vzero)
      attr_reader :body, :shape
      def initialize(p,static_body)
        @body = CP::Body.new(MASS,MOMENT)
        @body.p = p
        
        @shape = CP::Shape::Poly.new(@body,VERTICES,CP::vzero)
      end
    end
    class Frame
      include CP::Object
      attr_reader :body
      def initialize
        @body = CP::StaticBody.new
        init_chipmunk_object(@body)
      end
  end
end