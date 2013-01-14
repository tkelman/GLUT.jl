# Thu 08 Nov 2012 05:07:44 PM EST
#
# NeHe Tut 7 - Implement lights and rotate a textured cube
#
# Q - quit
# L - turn lights on/off
# F - change texture filter (linear, nearest, mipmap)
# PageUp/Down - move camera closer/further away from cube
# Left/Right - increase/decrease y-rotation speed
# Up/Down - increase/decrease x-rotation speed


# load necessary GLUT/OpenGL routines and image routines for loading textures

require("image")
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

global window

global filter        = 3
global light         = true

global xrot          = 0.0
global yrot          = 0.0
global xspeed        = 0.0
global yspeed        = 0.0

global tex           = Array(Uint32,3) # generating 3 textures

global cube_size     = 1.0

global z             = -5.0

width                = 640
height               = 480

global LightAmbient  = [0.5f0, 0.5f0, 0.5f0, 1.0f0]
global LightDiffuse  = [1.0f0, 1.0f0, 1.0f0, 1.0f0]
global LightPosition = [0.0f0, 0.0f0, 2.0f0, 1.0f0]

# load textures from images

function LoadGLTextures()
    global tex

    img3D = imread(expanduser("~/.julia/GLUT/Examples/NeHe/tut7/crate.bmp"))
    w     = size(img3D,2)
    h     = size(img3D,1)
    img   = glimg(img3D) # see OpenGLAux.jl for description

    glgentextures(3,tex)
    glbindtexture(GL_TEXTURE_2D,tex[1])
    gltexparameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST)
    gltexparameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST)
    glteximage2d(GL_TEXTURE_2D, 0, 3, w, h, 0, GL_RGB, GL_UNSIGNED_BYTE, img)

    glbindtexture(GL_TEXTURE_2D,tex[2])
    gltexparameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
    gltexparameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
    glteximage2d(GL_TEXTURE_2D, 0, 3, w, h, 0, GL_RGB, GL_UNSIGNED_BYTE, img)

    glbindtexture(GL_TEXTURE_2D,tex[3])
    gltexparameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
    gltexparameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_NEAREST)
    glteximage2d(GL_TEXTURE_2D, 0, 3, w, h, 0, GL_RGB, GL_UNSIGNED_BYTE, img)

    glubuild2dmipmaps(GL_TEXTURE_2D, 3, w, h, GL_RGB, GL_UNSIGNED_BYTE, img)
end

# function to init OpenGL context

function initGL(w::Integer,h::Integer)
    global LightAmbient 
    global LightDiffuse 
    global LightPosition

    glviewport(0,0,w,h)
    LoadGLTextures()

    # enable texture mapping
    glenable(GL_TEXTURE_2D)

    glclearcolor(0.0, 0.0, 0.0, 0.0)
    glcleardepth(1.0)			 
    gldepthfunc(GL_LESS)	 
    glenable(GL_DEPTH_TEST)
    glshademodel(GL_SMOOTH)

    glmatrixmode(GL_PROJECTION)
    glloadidentity()

    gluperspective(45.0,w/h,0.1,100.0)

    glmatrixmode(GL_MODELVIEW)
    
    # initialize lights
    gllightfv(GL_LIGHT1, GL_AMBIENT, LightAmbient)
    gllightfv(GL_LIGHT1, GL_DIFFUSE, LightDiffuse)
    gllightfv(GL_LIGHT1, GL_POSITION, LightPosition)

    glenable(GL_LIGHT1)
    glenable(GL_LIGHTING)
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
    global xrot
    global yrot
    global tex
    global cube_size
    global xspeed
    global yspeed
    global filter

    glclear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
    glloadidentity()

    gltranslate(0.0,0.0,z)

    glrotate(xrot,1.0,0.0,0.0)
    glrotate(yrot,0.0,1.0,0.0)

    glbindtexture(GL_TEXTURE_2D,tex[filter])
    cube(cube_size)

    xrot +=xspeed
    yrot +=yspeed

    glutswapbuffers()
end
   
_DrawGLScene = cfunction(DrawGLScene, Void, ())

function keyPressed(the_key::Char,x::Int32,y::Int32)
    global filter
    global light

    if the_key == int('q')
        glutdestroywindow(window)
    elseif the_key == int('l')
        println("Light was: $light")
        light = (light ? false : true)
        println("Light is now: $light")
        if light
            glenable(GL_LIGHTING)
        else
            gldisable(GL_LIGHTING)
        end
    elseif the_key == int('f')
        println("Filter was: $filter")
        filter += 1
        if filter > 3
            filter = 1
        end
        println("Filter is now: $filter")
    end

    return nothing # keyPressed returns "void" in C. this is a workaround for Julia's "automatically return the value of the last expression in a function" behavior.
end

_keyPressed = cfunction(keyPressed, Void, (Char, Int32, Int32))

function specialKeyPressed(the_key::Int32,x::Int32,y::Int32)
    global z
    global xspeed
    global yspeed

    if the_key == GLUT_KEY_PAGE_UP
        z -= 0.02
    elseif the_key == GLUT_KEY_PAGE_DOWN
        z += 0.02
    elseif the_key == GLUT_KEY_UP
        xspeed -= 0.01
    elseif the_key == GLUT_KEY_DOWN
        xspeed += 0.01
    elseif the_key == GLUT_KEY_LEFT
        yspeed -= 0.01
    elseif the_key == GLUT_KEY_RIGHT
        yspeed += 0.01
    end

    return nothing # specialKeyPressed returns "void" in C. this is a workaround for Julia's "automatically return the value of the last expression in a function" behavior.
end

_specialKeyPressed = cfunction(specialKeyPressed, Void, (Int32, Int32, Int32))

# run GLUT routines

glutinit()
glutinitdisplaymode(GLUT_RGBA | GLUT_DOUBLE | GLUT_ALPHA | GLUT_DEPTH)
glutinitwindowsize(width, height)
glutinitwindowposition(0, 0)

window = glutcreatewindow("NeHe Tut 7")

glutdisplayfunc(_DrawGLScene)
glutfullscreen()

glutidlefunc(_DrawGLScene)
glutreshapefunc(_ReSizeGLScene)
glutkeyboardfunc(_keyPressed)
glutspecialfunc(_specialKeyPressed)

initGL(width, height)

glutmainloop()
