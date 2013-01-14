# Tue 13 Nov 2012 04:13:36 PM EST 
#
# NeHe Tut 9 - Make some colored stars and play w/ alpha blending a bit more
#
# Q - quit
# T - turn "twinkle" on/off
# PageUp/Down - move camera closer/further away
# Up/Down - increase/decrease tilt about x-axis


# load necessary GLUT/OpenGL routines and image routines for loading textures

require("image")
using GLUT

# initialize variables

STAR_NUM = 50

type star
    r::Int64
    g::Int64
    b::Int64
    dist::Float64
    angle::Float64
end

tempr = randi(256)
tempg = randi(256)
tempb = randi(256)

stars = [star(tempr,tempg,tempb,0.0,0.0)] # Julia doesn't like it when you try to initialize an empty array of
                                        # a composite type and try to fill it afterwards, so we start with a 1-element
                                        # vector and tack on values in a loop

for loop = 1:STAR_NUM-1
    tempr = randi(256)
    tempg = randi(256)
    tempb = randi(256)
    stars = push!(stars,star(tempr,tempg,tempb,loop/STAR_NUM*5.0,0.0))
end

global window

global tilt    = 90.0
global zoom    = -15.0
global spin    = 0.0

global twinkle = false

global tex     = Array(Uint32,1) # generating 1 texture

width          = 640
height         = 480

# load textures from images

function LoadGLTextures()
    global tex

    img3D = imread(expanduser("~/.julia/GLUT/Examples/tut9/Star.bmp"))
    w     = size(img3D,2)
    h     = size(img3D,1)
    img   = glimg(img3D) # see OpenGLAux.jl for description

    glgentextures(1,tex)
    glbindtexture(GL_TEXTURE_2D,tex[1])
    gltexparameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
    gltexparameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
    glteximage2d(GL_TEXTURE_2D, 0, 3, w, h, 0, GL_RGB, GL_UNSIGNED_BYTE, img)
end

# function to init OpenGL context

function initGL(w::Integer,h::Integer)
    glviewport(0,0,w,h)
    LoadGLTextures()
    glclearcolor(0.0, 0.0, 0.0, 0.0)
    glcleardepth(1.0)			 
    glshademodel(GL_SMOOTH)

    # enable texture mapping and alpha blending
    glenable(GL_TEXTURE_2D)
    glenable(GL_BLEND)
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
    global zoom
    global stars
    global tilt
    global twinkle
    global STAR_NUM
    global tex
    global spin

    glclear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
    glloadidentity()

    glbindtexture(GL_TEXTURE_2D,tex[1])

    for loop = 1:STAR_NUM

        glloadidentity()

        gltranslate(0.0, 0.0, zoom)

        glrotate(tilt,1.0,0.0,0.0)
        glrotate(stars[loop].angle, 0.0, 1.0, 0.0)

        gltranslate(stars[loop].dist, 0.0, 0.0)

        glrotate(-stars[loop].angle, 0.0, 1.0, 0.0)
        glrotate(-tilt,1.0,0.0,0.0)

        if twinkle
            glcolor4ub(stars[STAR_NUM - loop + 1].r,stars[STAR_NUM - loop + 1].g,stars[STAR_NUM - loop + 1].b,255)

            glbegin(GL_QUADS)
                gltexcoord(0.0, 0.0)
                glvertex(-1.0, -1.0, 0.0)
                gltexcoord(1.0, 0.0)
                glvertex(1.0, -1.0, 0.0)
                gltexcoord(1.0, 1.0)
                glvertex(1.0, 1.0, 0.0)
                gltexcoord(0.0, 1.0)
                glvertex(-1.0, 1.0, 0.0)
            glend()
        end

        # main star

        glrotate(spin, 0.0, 0.0, 1.0)
        glcolor4ub(stars[loop].r, stars[loop].g, stars[loop].b, 255)

        glbegin(GL_QUADS)
            gltexcoord(0.0, 0.0)
            glvertex(-1.0, -1.0, 0.0)
            gltexcoord(1.0, 0.0)
            glvertex(1.0, -1.0, 0.0)
            gltexcoord(1.0, 1.0)
            glvertex(1.0, 1.0, 0.0)
            gltexcoord(0.0, 1.0)
            glvertex(-1.0, 1.0, 0.0)
        glend()

        spin              +=0.01
        stars[loop].angle +=loop/STAR_NUM
        stars[loop].dist  -=0.01

        if stars[loop].dist < 0.0
            stars[loop].dist  +=5.0
            stars[loop].r     = randi(256)
            stars[loop].g     = randi(256)
            stars[loop].b     = randi(256)
        end

    end

    glutswapbuffers()
end
   
_DrawGLScene = cfunction(DrawGLScene, Void, ())

function keyPressed(the_key::Char,x::Int32,y::Int32)
    global twinkle

    if the_key == int('q')
        glutdestroywindow(window)
    elseif the_key == int('t')
        println("Twinkle was: $twinkle")
        twinkle = (twinkle ? false : true)
        println("Twinkle is now: $twinkle")
    end

    return nothing # keyPressed returns "void" in C. this is a workaround for Julia's "automatically return the value of the last expression in a function" behavior.
end

_keyPressed = cfunction(keyPressed, Void, (Char, Int32, Int32))

function specialKeyPressed(the_key::Int32,x::Int32,y::Int32)
    global zoom
    global tilt

    if the_key == GLUT_KEY_PAGE_UP
        zoom -= 0.02
    elseif the_key == GLUT_KEY_PAGE_DOWN
        zoom += 0.02
    elseif the_key == GLUT_KEY_UP
        tilt -= 0.5
    elseif the_key == GLUT_KEY_DOWN
        tilt += 0.5
    end

    return nothing # specialKeyPressed returns "void" in C. this is a workaround for Julia's "automatically return the value of the last expression in a function" behavior.
end

_specialKeyPressed = cfunction(specialKeyPressed, Void, (Int32, Int32, Int32))

# run GLUT routines

glutinit()
glutinitdisplaymode(GLUT_RGBA | GLUT_DOUBLE | GLUT_ALPHA | GLUT_DEPTH)
glutinitwindowsize(width, height)
glutinitwindowposition(0, 0)

window = glutcreatewindow("NeHe Tut 9")

glutdisplayfunc(_DrawGLScene)
glutfullscreen()

glutidlefunc(_DrawGLScene)
glutreshapefunc(_ReSizeGLScene)
glutkeyboardfunc(_keyPressed)
glutspecialfunc(_specialKeyPressed)

initGL(width, height)

glutmainloop()
