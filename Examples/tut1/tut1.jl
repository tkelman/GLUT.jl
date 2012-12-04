# Tue 23 Oct 2012 07:10:59 PM EDT
#
# NeHe Tut 1 - Open a window


# load necessary GLUT routines

load("gl_glut.jl")

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

    glutswapbuffers()
end
   
_DrawGLScene = cfunction(DrawGLScene, Void, ())

# run GLUT routines

glutinit([1], ["a"])
glutinitdisplaymode(GLUT_RGBA | GLUT_DOUBLE | GLUT_ALPHA | GLUT_DEPTH)
glutinitwindowsize(640, 480)
glutinitwindowposition(0, 0)

window = glutcreatewindow("NeHe Tut 1")

glutdisplayfunc(_DrawGLScene)
glutfullscreen()

glutidlefunc(_DrawGLScene)
glutreshapefunc(_ReSizeGLScene)

initGL()

glutmainloop()
