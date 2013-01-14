# Tue 13 Nov 2012 04:13:36 PM EST 
#
# NeHe Tut 10 - Move around in a 3D world
#
# Q - quit
# B - turn texture alpha-blending on/off
# L - turn lights on/off
# F - change texture filter (linear, nearest, mipmap)
# PageUp/Down - look up/down
# Up/Down - move forward/backward
# Left/Right - turn left/right


# load necessary GLUT/OpenGL routines and image routines for loading textures

require("image")
using GLUT

### auxiliary functions

function SetupWorld(world_map::String)

    global numtriangles

    filein       = open(world_map)
    world_data   = readlines(filein)

    numtriangles = parse_int(chomp(split(world_data[1],' ')[2]))

    sector       = zeros(numtriangles,3,5)

    loop = 1
    vert = 1
    line = 1
    
    while line <= length(world_data)-2
        if world_data[2+line][1] != '/' && world_data[2+line][1] != '\n'
            while vert <= 3
                (x, y, z, u, v)      = split(chomp(world_data[2+line]),' ')
                x                    = parse_float(x)
                y                    = parse_float(y)
                z                    = parse_float(z)
                u                    = parse_float(u)
                v                    = parse_float(v)
                sector[loop,vert,:]  = [x,y,z,u,v]
                vert                 += 1
                line                 += 1
            end
            vert = 1
            loop += 1
        else
            line += 1
        end
    end

    return sector

end

### end of auxiliary functions

# initialize variables

global window

global numtriangles  = 0

global walkbias      = 0.0
global walkbiasangle = 0.0

global lookupdown    = 0.0

global xpos          = 0.0
global zpos          = 0.0

global yrot          = 0.0

global LightAmbient  = [0.5f0, 0.5f0, 0.5f0, 1.0f0]
global LightDiffuse  = [1.0f0, 1.0f0, 1.0f0, 1.0f0]
global LightPosition = [0.0f0, 0.0f0, 2.0f0, 1.0f0]

global filter        = 3
global light         = true
global blend         = false

global xtrans        = 0.0
global ytrans        = 0.0
global ztrans        = 0.0
global sceneroty     = 0.0

global tex           = Array(Uint32,3) # generating 3 textures

width                = 640
height               = 480

# initialize sector1 with SetupWorld

sector1 = SetupWorld(expanduser("~/.julia/GLUT/Examples/tut10/world.txt"))

# load textures from images

function LoadGLTextures()
    global tex

    img3D = imread(expanduser("~/.julia/GLUT/Examples/tut10/mud.bmp"))
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
    glviewport(0,0,w,h)
    LoadGLTextures()
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
    glenable(GL_LIGHTING)

    # enable texture mapping and alpha blending
    glenable(GL_TEXTURE_2D)
    glblendfunc(GL_SRC_ALPHA, GL_ONE)

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
    global xtrans
    global ytrans
    global ztrans
    global xpos
    global ypos
    global walkbias
    global sceneroty
    global yrot
    global lookupdown
    global tex
    global numtriangles
    global sector1

    glclear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
    glloadidentity()

    xtrans = -xpos
    ztrans = -zpos
    ytrans = -walkbias-0.25
    sceneroty = 360.0-yrot

    glrotate(lookupdown, 1.0, 0.0, 0.0)
    glrotate(sceneroty, 0.0, 1.0, 0.0)
    gltranslate(xtrans, ytrans, ztrans)

    glbindtexture(GL_TEXTURE_2D,tex[filter])

    for face = 1:numtriangles
        glbegin(GL_TRIANGLES)
            glnormal(0.0, 0.0, 1.0)
            x_m = sector1[face,1,1]
            y_m = sector1[face,1,2]
            z_m = sector1[face,1,3]
            u_m = sector1[face,1,4]
            v_m = sector1[face,1,5]
            gltexcoord(u_m,v_m) 
            glvertex(x_m,y_m,z_m)

            x_m = sector1[face,2,1]
            y_m = sector1[face,2,2]
            z_m = sector1[face,2,3]
            u_m = sector1[face,2,4]
            v_m = sector1[face,2,5]
            gltexcoord(u_m,v_m) 
            glvertex(x_m,y_m,z_m)

            x_m = sector1[face,3,1]
            y_m = sector1[face,3,2]
            z_m = sector1[face,3,3]
            u_m = sector1[face,3,4]
            v_m = sector1[face,3,5]
            gltexcoord(u_m,v_m)
            glvertex(x_m,y_m,z_m)
        glend()
    end

    glutswapbuffers()
end
   
_DrawGLScene = cfunction(DrawGLScene, Void, ())

function keyPressed(the_key::Char,x::Int32,y::Int32)
    global blend
    global light
    global filter

    if the_key == int('q')
        glutdestroywindow(window)
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
    global lookupdown
    global xpos
    global zpos
    global walkbias
    global walkbiasangle
    global yrot

    if the_key == GLUT_KEY_PAGE_UP
        lookupdown -=0.2
    elseif the_key == GLUT_KEY_PAGE_DOWN
        lookupdown +=1.0
    elseif the_key == GLUT_KEY_UP
        xpos -=sin(degrees2radians(yrot))*0.05
        zpos -=cos(degrees2radians(yrot))*0.05
        walkbias +=10
        if walkbiasangle <= 359.0
            walkbiasangle = 0.0
        else
            walkbiasangle +=10
        end
        walkbias = sin(degrees2radians(walkbiasangle))/20.0
    elseif the_key == GLUT_KEY_DOWN
        xpos +=sin(degrees2radians(yrot))*0.05
        zpos +=cos(degrees2radians(yrot))*0.05
        walkbias -=10
        if walkbiasangle <= 1.0
            walkbiasangle = 359.0
        else
            walkbiasangle -=10
        end
        walkbias = sin(degrees2radians(walkbiasangle))/20.0
    elseif the_key == GLUT_KEY_LEFT
        yrot +=1.5
    elseif the_key == GLUT_KEY_RIGHT
        yrot -=1.5
    end

    return nothing # specialKeyPressed returns "void" in C-GLUT. this is a workaround for Julia's "automatically return the value of the last expression in a function" behavior.
end

_specialKeyPressed = cfunction(specialKeyPressed, Void, (Int32, Int32, Int32))

# run GLUT routines

glutinit()
glutinitdisplaymode(GLUT_RGBA | GLUT_DOUBLE | GLUT_ALPHA | GLUT_DEPTH)
glutinitwindowsize(width, height)
glutinitwindowposition(0, 0)

window = glutcreatewindow("NeHe Tut 10")

glutdisplayfunc(_DrawGLScene)
glutfullscreen()

glutidlefunc(_DrawGLScene)
glutreshapefunc(_ReSizeGLScene)
glutkeyboardfunc(_keyPressed)
glutspecialfunc(_specialKeyPressed)

initGL(width, height)

glutmainloop()
