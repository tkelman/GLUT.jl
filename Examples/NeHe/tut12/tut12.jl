# Mon 31 Dec 2012 01:39:13 PM EST
#
# NeHe Tut 12 - Rotate a textured cube
#
# Q - quit
# Up/Down - increase/decrease rotation of each cube about it's own x-axis
# Left/Right - increase/decrease rotation of each cube about it's own y-axis


# load necessary GLUT/OpenGL routines and image routines for loading textures

require("image")
using GLUT

# initialize variables

global window

global xrot = 0
global yrot = 0

global box  = 0
global top  = 0

boxcol      = [1.0 0.0 0.0;
               1.0 0.5 0.0;
               1.0 1.0 0.0;
               0.0 1.0 0.0;
               0.0 1.0 1.0]

topcol      = [0.5 0.0  0.0;
               0.5 0.25 0.0;
               0.5 0.5  0.0;
               0.0 0.5  0.0;
               0.0 0.5  0.5]

global tex  = Array(Uint32,1) # generating 1 texture

width       = 640
height      = 480

# load textures from images

function LoadGLTextures()
    global tex

    img3D = imread(expanduser("/home/rje/my_docs/julia/GLUT.jl/Examples/NeHe/tut12/cube.bmp"))
    w     = size(img3D,2)
    h     = size(img3D,1)
    img   = glimg(img3D) # see OpenGLAux.jl for description

    glgentextures(1,tex)
    glbindtexture(GL_TEXTURE_2D,tex[1])
    gltexparameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR_MIPMAP_NEAREST)
    gltexparameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
    glteximage2d(GL_TEXTURE_2D, 0, 3, w, h, 0, GL_RGB, GL_UNSIGNED_BYTE, img)
    glubuild2dmipmaps(GL_TEXTURE_2D, 3, w, h, GL_RGB, GL_UNSIGNED_BYTE, img)
end

# function to init OpenGL context

function initGL(w::Integer,h::Integer)
    global box
    global top

    glviewport(0,0,w,h)
    LoadGLTextures()
    glclearcolor(0.0, 0.0, 0.0, 0.5)
    glcleardepth(1.0)			 
    gldepthfunc(GL_LEQUAL)
    glenable(GL_DEPTH_TEST)
    glshademodel(GL_SMOOTH)
    glhint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST)

    # enable texture mapping
    glenable(GL_TEXTURE_2D)

    #enable simple lighting
    glenable(GL_LIGHT0)         
    glenable(GL_LIGHTING)
    glenable(GL_COLOR_MATERIAL)

    glmatrixmode(GL_PROJECTION)
    glloadidentity()

    gluperspective(45.0,w/h,0.1,100.0)

    glmatrixmode(GL_MODELVIEW)

    # build the display lists

    box = glgenlists(2)

    glnewlist(box, GL_COMPILE)
        glbegin(GL_QUADS)
            # Bottom Face
            gltexcoord(0.0, 1.0)
            glvertex(-1.0, -1.0, -1.0)
            gltexcoord(1.0, 1.0)
            glvertex(1.0, -1.0, -1.0)
            gltexcoord(1.0, 0.0)
            glvertex(1.0, -1.0,  1.0)
            gltexcoord(0.0, 0.0)
            glvertex(-1.0, -1.0,  1.0)

            # Front Face
            gltexcoord(1.0, 0.0)
            glvertex(-1.0, -1.0,  1.0)
            gltexcoord(0.0, 0.0)
            glvertex(1.0, -1.0,  1.0)
            gltexcoord(0.0, 1.0)
            glvertex(1.0,  1.0,  1.0)
            gltexcoord(1.0, 1.0)
            glvertex(-1.0,  1.0,  1.0)

            # Back Face
            gltexcoord(0.0, 0.0)
            glvertex(-1.0, -1.0, -1.0)
            gltexcoord(0.0, 1.0)
            glvertex(-1.0,  1.0, -1.0)
            gltexcoord(1.0, 1.0)
            glvertex(1.0,  1.0, -1.0)
            gltexcoord(1.0, 0.0)
            glvertex(1.0, -1.0, -1.0)

            # Right Face
            gltexcoord(0.0, 0.0)
            glvertex(1.0, -1.0, -1.0)
            gltexcoord(0.0, 1.0)
            glvertex(1.0,  1.0, -1.0)
            gltexcoord(1.0, 1.0)
            glvertex(1.0,  1.0,  1.0)
            gltexcoord(1.0, 0.0)
            glvertex(1.0, -1.0,  1.0)

            # Left Face
            gltexcoord(1.0, 0.0)
            glvertex(-1.0, -1.0, -1.0)
            gltexcoord(0.0, 0.0)
            glvertex(-1.0, -1.0,  1.0)
            gltexcoord(0.0, 1.0)
            glvertex(-1.0,  1.0,  1.0)
            gltexcoord(1.0, 1.0)
            glvertex(-1.0,  1.0, -1.0)
        glend()
    glendlist()

    top = uint32(box+1)

    glnewlist(top, GL_COMPILE)
        glbegin(GL_QUADS)
            # Top Face
            gltexcoord(1.0, 1.0)
            glvertex(-1.0, 1.0, -1.0)
            gltexcoord(1.0, 0.0)
            glvertex(-1.0, 1.0,  1.0)
            gltexcoord(0.0, 0.0)
            glvertex(1.0, 1.0,  1.0)
            gltexcoord(0.0, 1.0)
            glvertex(1.0, 1.0, -1.0)
        glend()
    glendlist()
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
    global box
    global top

    glclear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)

    glbindtexture(GL_TEXTURE_2D, tex[1])

    for yloop = 1:5
	      for xloop = 1:yloop
            glloadidentity()

            gltranslate(1.4+2.8xloop-1.4yloop, ((6.0-yloop)*2.4)-7.0, -20.0)

            glrotate(45.0-(2.0yloop)+xrot, 1.0, 0.0, 0.0)
            glrotate(45.0+yrot, 0.0, 1.0, 0.0)

            glcolor(boxcol[yloop,:])
            glcalllist(box)         
            
            glcolor(topcol[yloop,:])
            glcalllist(top)        
        end
    end

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

function specialKeyPressed(the_key::Int32,x::Int32,y::Int32)
    global xrot
    global yrot

    if the_key == GLUT_KEY_UP
        xrot -=0.2
    elseif the_key == GLUT_KEY_DOWN
        xrot +=0.2
    elseif the_key == GLUT_KEY_LEFT
        yrot -=0.2
    elseif the_key == GLUT_KEY_RIGHT
        yrot +=0.2
    end

    return nothing # specialKeyPressed returns "void" in C-GLUT. this is a workaround for Julia's "automatically return the value of the last expression in a function" behavior.
end

_specialKeyPressed = cfunction(specialKeyPressed, Void, (Int32, Int32, Int32))

# run GLUT routines

glutinit()
glutinitdisplaymode(GLUT_RGBA | GLUT_DOUBLE | GLUT_ALPHA | GLUT_DEPTH)
glutinitwindowsize(width, height)
glutinitwindowposition(0, 0)

window = glutcreatewindow("NeHe Tut 12")

glutdisplayfunc(_DrawGLScene)
glutfullscreen()

glutidlefunc(_DrawGLScene)
glutreshapefunc(_ReSizeGLScene)
glutkeyboardfunc(_keyPressed)
glutspecialfunc(_specialKeyPressed)

initGL(width, height)

glutmainloop()
