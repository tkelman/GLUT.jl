# Mon 31 Dec 2012 01:39:42 PM EST
#
# NeHe Tut 16 - Implement lights and rotate a textured cube
#
# Q - quit
# L - turn lights on/off
# F - change texture filter (linear, nearest, mipmap)
# PageUp/Down - move camera closer/further away
# Up/Down - increase/decrease x-rotation speed
# Left/Right - increase/decrease y-rotation speed
# Space - change the currently rendered object (cube, cylinder, sphere, tapered cylinder, disc, animated disk)


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
global blend         = false

global quadratic     = 0

global part1         = 0
global part2         = 0
global p1            = 0
global p2            = 1

global object        = 0

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

    img3D = imread(expanduser("~/my_docs/julia/GLUT.jl/Examples/NeHe/tut16/crate.bmp"))
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
    global quadratic

    glviewport(0,0,w,h)
    LoadGLTextures()

    # enable texture mapping & blending
    glenable(GL_TEXTURE_2D)
    glblendfunc(GL_SRC_ALPHA, GL_ONE)
    glcolor(1.0, 1.0, 1.0, 0.5)

    glclearcolor(0.0, 0.0, 0.0, 0.0)
    glcleardepth(1.0)			 
    gldepthfunc(GL_LEQUAL)	 
    glenable(GL_DEPTH_TEST)
    glshademodel(GL_SMOOTH)
    glhint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST)

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

    # intialize quadric info
    quadratic = glunewquadric()

    gluquadricnormals(quadratic, GLU_SMOOTH)
    gluquadrictexture(quadratic, GL_TRUE)
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
    global z
    global part1
    global part2
    global quadratic
    global p1
    global p2
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

    if object == 0
        cube(cube_size)
    elseif object == 1
        gltranslate(0.0, 0.0, -1.5)
        glucylinder(quadratic, 1.0, 1.0, 3.0, 32, 32)
    elseif object == 2
        gludisk(quadratic, 0.5, 1.5, 32, 32)
    elseif object == 3
        glusphere(quadratic, 1.3, 32, 32)
    elseif object == 4
        gltranslate(0.0, 0.0, -1.5)
        glucylinder(quadratic, 1.0, 0.2, 3.0, 32, 32)
    elseif object == 5
        part1 +=p1
        part2 +=p2

        if part1 > 359
            p1    = 0
            part1 = 0
            p2    = 1
            part2 = 0
        end

        if part2 > 359
            p1 = 1
            p2 = 0
        end
        glupartialdisk(quadratic,0.5,1.5,32,32,part1,part2-part1)
    end

    xrot +=xspeed
    yrot +=yspeed

    glutswapbuffers()
end
   
_DrawGLScene = cfunction(DrawGLScene, Void, ())

function keyPressed(the_key::Char,x::Int32,y::Int32)
    global filter
    global light
    global blend
    global object

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
    elseif the_key == int('b')
        println("Blend was: $blend")
        blend = (blend ? false : true)
        if blend
            glenable(GL_BLEND)
            gldisable(GL_DEPTH_TEST)
        else
            gldisable(GL_BLEND)
            glenable(GL_DEPTH_TEST)
        end
        println("Blend is now: $blend")
    elseif the_key == int(' ')
        object +=1
        if object > 5
            object = 0
        end
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

window = glutcreatewindow("NeHe Tut 16")

glutdisplayfunc(_DrawGLScene)
glutfullscreen()

glutidlefunc(_DrawGLScene)
glutreshapefunc(_ReSizeGLScene)
glutkeyboardfunc(_keyPressed)
glutspecialfunc(_specialKeyPressed)

initGL(width, height)

glutmainloop()
