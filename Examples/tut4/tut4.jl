# Tue 23 Oct 2012 07:10:59 PM EDT
#
# NeHe Tut 4 - Rotate colored (rainbow) triangle and colored (cyan) square


# load necessary GLUT/GLU/OpenGL routines

require("GLUT")
using GLUT

# initialize variables

global window

global rtri  = 0.0
global rquad = 0.0

width        = 640
height       = 480

# function to init OpenGL context

function initGL(w::Integer,h::Integer)
    glviewport(0,0,w,h)
    glclearcolor(0.0, 0.0, 0.0, 0.0)
    glcleardepth(1.0)			 
    gldepthfunc(GL_LESS)	 
    glenable(GL_DEPTH_TEST)
    glshademodel(GL_SMOOTH)

    glmatrixmode(GL_PROJECTION)
    glloadidentity()

    gluperspective(45.0,w/h,0.1,100.0)

    glmatrixmode(GL_MODELVIEW)
end

# prepare Julia equivalents of C callbacks that are typically used in GLUT code

function ReSizeGLScene(w::Int32,h::Int32)
    if h == 0
        h = 1
    end

    glviewport(0,0,w,h)

    glmatrixmode(GL_PROJECTION)
    glloadidentity()

    gluperspective(45.0,w/h,0.1,100.0)

    glmatrixmode(GL_MODELVIEW)
end

_ReSizeGLScene = cfunction(ReSizeGLScene, Void, (Int32, Int32))

function DrawGLScene()
    global rtri
    global rquad

    glclear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
    glloadidentity()

    gltranslate(-1.5,0.0,-6.0)
    glrotate(rtri,0.0,1.0,0.0)

    glbegin(GL_POLYGON)
      glcolor(1.0,0,0)
      glvertex(0.0,1.0,0.0)
      glcolor(0,1.0,0)
      glvertex(1.0,-1.0,0.0)
      glcolor(0,0,1.0)
      glvertex(-1.0,-1.0,0.0)
    glend()

    glloadidentity()

    gltranslate(1.5,0.0,-6.0)
    glrotate(rquad,1.0,0.0,0.0)

    gltranslate(0.8,0,0)

    glcolor(0.5,0.5,1.0)
    glbegin(GL_QUADS)
        glvertex(-1.0,1.0,0.0)
        glvertex(1.0,1.0,0.0)
        glvertex(1.0,-1.0,0.0)
        glvertex(-1.0,-1.0,0.0)
    glend()

    rtri  += 0.2
    rquad -= 0.2

    glutswapbuffers()
end
   
_DrawGLScene = cfunction(DrawGLScene, Void, ())

function keyPressed(key::Char,x::Int32,y::Int32)
    if key == int('q')
        glutdestroywindow(window)
    end
end

_keyPressed = cfunction(keyPressed, Void, (Char, Int32, Int32))

# run GLUT routines

glutinit()
glutinitdisplaymode(GLUT_RGBA | GLUT_DOUBLE | GLUT_ALPHA | GLUT_DEPTH)
glutinitwindowsize(width, height)
glutinitwindowposition(0, 0)

window = glutcreatewindow("NeHe Tut 4")

glutdisplayfunc(_DrawGLScene)
glutfullscreen()

glutidlefunc(_DrawGLScene)
glutreshapefunc(_ReSizeGLScene)
glutkeyboardfunc(_keyPressed)

initGL(width, height)

glutmainloop()
