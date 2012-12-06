# Thu 08 Nov 2012 05:07:44 PM EST
#
# NeHe Tut 7 - Implement lights and rotate a textured cube


# load necessary GLUT/GLU/OpenGL routines

require("GLUT")
using GLUT

### auxiliary functions

function cube(size)  # the cube function now includes surface normal specification for proper lighting
  glbegin(GL_QUADS)
    # Front Face
    glnormal(0.0,0.0,1.0)
    gltexcoord(0.0, 0.0)
    glvertex(-size, -size, size)
    gltexcoord(1.0, 0.0)
    glvertex(size, -size, size)
    gltexcoord(1.0, 1.0)
    glvertex(size, size, size)
    gltexcoord(0.0, 1.0)
    glvertex(-size, size, size)

    # Back Face
    glnormal(0.0,0.0,-1.0)
    gltexcoord(1.0, 0.0)
    glvertex(-size, -size, -size)
    gltexcoord(1.0, 1.0)
    glvertex(-size, size, -size)
    gltexcoord(0.0, 1.0)
    glvertex(size, size, -size)
    gltexcoord(0.0, 0.0)
    glvertex(size, -size, -size)

    # Top Face
    glnormal(0.0,1.0,0.0)
    gltexcoord(0.0, 1.0)
    glvertex(-size, size, -size)
    gltexcoord(0.0, 0.0)
    glvertex(-size, size, size)
    gltexcoord(1.0, 0.0)
    glvertex(size, size, size)
    gltexcoord(1.0, 1.0)
    glvertex(size, size, -size)

    # Bottom Face
    glnormal(0.0,-1.0,0.0)
    gltexcoord(1.0, 1.0)
    glvertex(-size, -size, -size)
    gltexcoord(0.0, 1.0)
    glvertex(size, -size, -size)
    gltexcoord(0.0, 0.0)
    glvertex(size, -size, size)
    gltexcoord(1.0, 0.0)
    glvertex(-size, -size, size)

    # Right Face
    glnormal(1.0,0.0,0.0)
    gltexcoord(1.0, 0.0)
    glvertex(size, -size, -size)
    gltexcoord(1.0, 1.0)
    glvertex(size, size, -size)
    gltexcoord(0.0, 1.0)
    glvertex(size, size, size)
    gltexcoord(0.0, 0.0)
    glvertex(size, -size, size)

    # Left Face
    glnormal(-1.0,0.0,0.0)
    gltexcoord(0.0, 0.0)
    glvertex(-size, -size, -size)
    gltexcoord(1.0, 0.0)
    glvertex(-size, -size, size)
    gltexcoord(1.0, 1.0)
    glvertex(-size, size, size)
    gltexcoord(0.0, 1.0)
    glvertex(-size, size, -size)
  glend()
end

### end of auxiliary functions

# initialize variables

filter        = 0
light         = false

xrot          = 0.0
yrot          = 0.0
xspeed        = 0.0
yspeed        = 0.0

z             = 0.8

cube_size     = 0.2

LightAmbient  = [0.5, 0.5, 0.5, 1.0]
LightDiffuse  = [1.0, 1.0, 1.0, 1.0]
LightPosition = [0.0, 0.0, 2.0, 1.0]

# load images as textures

tex1 = SDLIMGLoad("crate.bmp",1) # nearest filtering
tex2 = SDLIMGLoad("crate.bmp",2) # linear filtering
tex3 = SDLIMGLoad("crate.bmp",3) # mipmap filtering

# function to init OpenGL context

function initGL()
  glclearcolor(0.0, 0.0, 0.0, 0.0)
  glcleardepth(1.0)			 
  gldepthfunc(GL_LESS)	 
  glenable(GL_DEPTH_TEST)
  glshademodel(GL_SMOOTH)

  # initialize lights
  gllightfv(GL_LIGHT1, GL_AMBIENT, LightAmbient)
  gllightfv(GL_LIGHT1, GL_DIFFUSE, LightDiffuse)
  gllightfv(GL_LIGHT1, GL_POSITION, LightPosition)

  glenable(GL_LIGHT1)

  # enable texture mapping
  glenable(GL_TEXTURE_2D)

  glmatrixmode(GL_PROJECTION)
  glloadidentity()

  #gluperspective(45.0,w/h,0.1,100.0)

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

    #gluperspective(45.0,w/h,0.1,100.0)

    glmatrixmode(GL_MODELVIEW)
end

_ReSizeGLScene = cfunction(ReSizeGLScene, Void, (Int32, Int32))

function DrawGLScene()
    glclear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
    glloadidentity()

    gltranslate(0.0,0.0,z)

    glrotate(xrot,1.0,0.0,0.0)
    glrotate(yrot,0.0,1.0,0.0)

    if filter == 0
        glbindtexture(GL_TEXTURE_2D,tex1)
    elseif filter == 1
        glbindtexture(GL_TEXTURE_2D,tex2)
    elseif filter == 2
        glbindtexture(GL_TEXTURE_2D,tex3)
    end
    cube(cube_size)

    xrot +=xspeed
    yrot +=yspeed

    glutswapbuffers()
end
   
_DrawGLScene = cfunction(DrawGLScene, Void, ())

# run GLUT routines

glutinit([1], ["a"])
glutinitdisplaymode(GLUT_RGBA | GLUT_DOUBLE | GLUT_ALPHA | GLUT_DEPTH)
glutinitwindowsize(640, 480)
glutinitwindowposition(0, 0)

window = glutcreatewindow("NeHe Tut 7")

glutdisplayfunc(_DrawGLScene)
glutfullscreen()

glutidlefunc(_DrawGLScene)
glutreshapefunc(_ReSizeGLScene)

initGL()

glutmainloop()
