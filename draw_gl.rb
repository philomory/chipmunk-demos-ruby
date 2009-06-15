require 'opengl'

module CP
  module DrawGL
    include GL
    CircleVAR = [
       0.0000,  1.0000,
       0.2588,  0.9659,
       0.5000,  0.8660,
       0.7071,  0.7071,
       0.8660,  0.5000,
       0.9659,  0.2588,
       1.0000,  0.0000,
       0.9659, -0.2588,
       0.8660, -0.5000,
       0.7071, -0.7071,
       0.5000, -0.8660,
       0.2588, -0.9659,
       0.0000, -1.0000,
      -0.2588, -0.9659,
      -0.5000, -0.8660,
      -0.7071, -0.7071,
      -0.8660, -0.5000,
      -0.9659, -0.2588,
      -1.0000, -0.0000,
      -0.9659,  0.2588,
      -0.8660,  0.5000,
      -0.7071,  0.7071,
      -0.5000,  0.8660,
      -0.2588,  0.9659,
       0.0000,  1.0000,
       0.0,     0.0 # For an extra line to see the rotation.
    ]
    
    CircleVAR_count = CircleVAR.length/2
    
    def draw_circle_shape(body,circle)
      glVertexPointer(2,GL_FLOAT,0,CircleVAR)
      
      glPushMatrix()
        center = body.p + circle.c.rotate(body.rot)
        glTranslatef(center.x,center.y,0.0)
        glRotatef(body.a*180.0/Math::PI, 0.0, 0.0, 1.0)
        glScalef(circle.r, circle.r, 1.0)
        
        #glColor_from_pointer(circle)
        glDrawArrays(GL_TRIANGLE_FAN, 0, CircleVAR_count -1)
        
        #glColor3f(LINE_COLOR)
        glDrawArrays(GL_LINE_STRIP, 0, CircleVAR_count)
      glPopMatrix()
    end

end
end