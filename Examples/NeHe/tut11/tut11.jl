# Mon 31 Dec 2012 01:38:23 PM EST
#
# NeHe Tut 11 - Waving texture
#
# Q - quit


# load necessary GLUT/OpenGL routines and image routines for loading textures

require("image")
using GLUT

# initialize variables

global window

global xrot   = 0.0
global yrot   = 0.0
global zrot   = 0.0

global tex    = Array(Uint32,1) # generating 1 texture

global points = Array(Float64,(45,45,3))

for x=1:45
    for y=1:45
        points[x,y,1] = x/5-4.5
        points[x,y,2] = y/5-4.5
        points[x,y,3] = sin((((x/5)*40)/360)*2*pi)
    end
end

wiggle_count = 0

width        = 640
height       = 480

# load textures from images

function LoadGLTextures()
    global tex

    img3D = imread(expanduser("~/.julia/GLUT/Examples/NeHe/tut11/tim.bmp"))
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
    gldepthfunc(GL_LEQUAL)	 
    glenable(GL_DEPTH_TEST)
    glshademodel(GL_SMOOTH)
    glhint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST)

    # enable Polygon filling

    glpolygonmode(GL_BACK, GL_FILL)
    glpolygonmode(GL_FRONT, GL_LINE)

    # enable texture mapping
    glenable(GL_TEXTURE_2D)

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
    global tex
    global xrot
    global yrot
    global zrot
    global points
    global wiggle_count
    
    glclear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
    glloadidentity()

    gltranslate(0.0, 0.0, -12.0)

    glrotate(xrot,1.0,0.0,0.0)
    glrotate(yrot,0.0,1.0,0.0)
    glrotate(zrot,0.0,0.0,1.0)

    glbindtexture(GL_TEXTURE_2D,tex[1])

    glbegin(GL_QUADS)
        for x=1:44
            for y=1:44
                tex_x  = x/45
                tex_y  = y/45
                tex_xb = (x+1)/45
                tex_yb = (y+1)/45

                gltexcoord(tex_x, tex_y)
                glvertex(points[x,y,1],points[x,y,2],points[x,y,3])
                gltexcoord(tex_x, tex_yb)
                glvertex(points[x,y+1,1],points[x,y+1,2],points[x,y+1,3])
                gltexcoord(tex_xb, tex_yb)
                glvertex(points[x+1,y+1,1],points[x+1,y+1,2],points[x+1,y+1,3])
                gltexcoord(tex_xb, tex_y)
                glvertex(points[x+1,y,1],points[x+1,y,2],points[x+1,y,3])
            end
        end
    glend()

    if wiggle_count == 2
        for y=1:45
            hold = points[1,y,3]
            for x=1:44
                points[x,y,3] = points[x+1,y,3]
            end
            points[45,y,3] = hold
        end
        wiggle_count = 0
    end

    wiggle_count +=1

    xrot +=0.3
    yrot +=0.2
    zrot +=0.4

    glutswapbuffers()
end
   
_DrawGLScene = cfunction(DrawGLScene, Void, ())

function keyPressed(the_key::Char,x::Int32,y::Int32)
    if the_key == int('q')
        glutdestroywindow(window)
    end

    return nothing # keyPressed returns "void" in C. this is a workaround for Julia's "automatically return the value of the last expression in a function" behavior.
end

_keyPressed = cfunction(keyPressed, Void, (Char, Int32, Int32))

# run GLUT routines

glutinit()
glutinitdisplaymode(GLUT_RGBA | GLUT_DOUBLE | GLUT_ALPHA | GLUT_DEPTH)
glutinitwindowsize(width, height)
glutinitwindowposition(0, 0)

window = glutcreatewindow("NeHe Tut 11")

glutdisplayfunc(_DrawGLScene)
glutfullscreen()

glutidlefunc(_DrawGLScene)
glutreshapefunc(_ReSizeGLScene)
glutkeyboardfunc(_keyPressed)

initGL(width, height)

glutmainloop()
