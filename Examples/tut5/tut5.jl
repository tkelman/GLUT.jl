# Tue 23 Oct 2012 07:10:59 PM EDT
#
# NeHe Tut 5 - Rotate colored (rainbow) pyramid and colored (rainbow) cube


# load necessary GLUT/GLU/OpenGL routines

require("OpenGL")
require("GLU")
require("GLUT")
using OpenGL
using GLU
using GLUT

# initialize variables

rpyr      = 0.0
rquad     = 0.0

pyr_size  = 0.2
cube_size = 0.2

# function to init OpenGL context

function initGL()
  glclearcolor(0.0, 0.0, 0.0, 0.0)
  glcleardepth(1.0)			 
  gldepthfunc(GL_LESS)	 
  glenable(GL_DEPTH_TEST)
  glshademodel(GL_SMOOTH)

  glmatrixmode(GL_PROJECTION)
  glloadidentity()

  #gluperspective(45.0,w/h,0.1,100.0)

  glmatrixmode(GL_MODELVIEW)
end

# prepare Julia equivalents of C callbacks that are typically used in GLUT code

function ReSizeGLScene{T}(w::Int32,h::Int32)
    if h == 0
        h = 1
    end

    glviewport(0,0,w,h)

    glmatrixmode(GL_PROJECTION)
    glloadidentity()

    #gluperspective(45.0,w/h,0.1,100.0)

    glmatrixmode(GL_MODELVIEW)
end

_ReSizeGLScene = cfunction(ReSizeGLScene, Void, (Int32, Int32))

function DrawGLScene()
    glclear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
    glloadidentity()

    gltranslate(-0.3,0.0,-0.6)
    glrotate(rpyr,0.0,1.0,0.0)

    glbegin(GL_POLYGON)
        # front face
        glcolor(1.0,0,0)
        glvertex(0.0,pyr_size,0.0)
        glcolor(0,1.0,0)
        glvertex(-pyr_size,-pyr_size,pyr_size)
        glcolor(0,0,1.0)
        glvertex(pyr_size,-pyr_size,pyr_size)

        # right face
        glcolor(1.0,0,0)
        glvertex(0.0,pyr_size,0.0)
        glcolor(0,0,1.0)
        glvertex(pyr_size,-pyr_size,pyr_size)
        glcolor(0,1.0,0)
        glvertex(pyr_size,-pyr_size,-pyr_size)

        # back face
        glcolor(1.0,0,0)
        glvertex(0.0,pyr_size,0.0)
        glcolor(0,1.0,0)
        glvertex(pyr_size,-pyr_size,-pyr_size)
        glcolor(0,0,1.0)
        glvertex(-pyr_size,-pyr_size,-pyr_size)

        # left face
        glcolor(1.0,0,0)
        glvertex(0.0,pyr_size,0.0)
        glcolor(0,0,1.0)
        glvertex(-pyr_size,-pyr_size,-pyr_size)
        glcolor(0,1.0,0)
        glvertex(-pyr_size,-pyr_size,pyr_size)
    glend()

    glloadidentity()

    gltranslate(0.3,0.0,-0.65)
    glrotate(rquad,1.0,1.0,1.0)

    glcolor(0.5,0.5,1.0)
    glbegin(GL_QUADS)
        # top of cube
        glcolor(0.0,1.0,0.0)		 
        glvertex( cube_size, cube_size,-cube_size) 
        glvertex(-cube_size, cube_size,-cube_size) 
        glvertex(-cube_size, cube_size, cube_size) 
        glvertex( cube_size, cube_size, cube_size) 

        # bottom of cube
        glcolor(1.0,0.5,0.0)		 
        glvertex( cube_size,-cube_size, cube_size) 
        glvertex(-cube_size,-cube_size, cube_size) 
        glvertex(-cube_size,-cube_size,-cube_size) 
        glvertex( cube_size,-cube_size,-cube_size) 

        # front of cube
        glcolor(1.0,0.0,0.0)		 
        glvertex( cube_size, cube_size, cube_size) 
        glvertex(-cube_size, cube_size, cube_size) 
        glvertex(-cube_size,-cube_size, cube_size) 
        glvertex( cube_size,-cube_size, cube_size) 

        # back of cube.
        glcolor(1.0,1.0,0.0)		 
        glvertex( cube_size,-cube_size,-cube_size) 
        glvertex(-cube_size,-cube_size,-cube_size) 
        glvertex(-cube_size, cube_size,-cube_size) 
        glvertex( cube_size, cube_size,-cube_size) 

        # left of cube
        glcolor(0.0,0.0,1.0)		 
        glvertex(-cube_size, cube_size, cube_size) 
        glvertex(-cube_size, cube_size,-cube_size) 
        glvertex(-cube_size,-cube_size,-cube_size) 
        glvertex(-cube_size,-cube_size, cube_size) 

        # Right of cube
        glcolor(1.0,0.0,1.0)		 
        glvertex( cube_size, cube_size,-cube_size) 
        glvertex( cube_size, cube_size, cube_size) 
        glvertex( cube_size,-cube_size, cube_size) 
        glvertex( cube_size,-cube_size,-cube_size) 
    glend()

    rpyr  +=0.2
    rquad -=0.2					

    glutswapbuffers()
end
   
_DrawGLScene = cfunction(DrawGLScene, Void, ())

# run GLUT routines

glutinit([1], ["a"])
glutinitdisplaymode(GLUT_RGBA | GLUT_DOUBLE | GLUT_ALPHA | GLUT_DEPTH)
glutinitwindowsize(640, 480)
glutinitwindowposition(0, 0)

window = glutcreatewindow("NeHe Tut 5")

glutdisplayfunc(_DrawGLScene)
glutfullscreen()

glutidlefunc(_DrawGLScene)
glutreshapefunc(_ReSizeGLScene)

initGL()

glutmainloop()
