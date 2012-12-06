# Tue 13 Nov 2012 04:13:36 PM EST 
#
# NeHe Tut 10 - Move around in a 3D world


# load necessary GLUT/GLU/OpenGL routines

require("GLUT")
using GLUT

# initialize global variables

global numtriangles = 0

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
                sector[loop,vert,:]  = [x,y,z,u,v].*0.25
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

walkbias      = 0.0
walkbiasangle = 0.0

lookupdown    = 0.0

xpos          = 0.0
zpos          = 0.0

yrot          = 0.0

LightAmbient  = [0.5, 0.5, 0.5, 1.0]
LightDiffuse  = [1.0, 1.0, 1.0, 1.0]
LightPosition = [0.0, 0.0, 2.0, 1.0]

filter        = 1
light         = true
blend         = true

x_m           = 0.0
y_m           = 0.0
z_m           = 0.0
u_m           = 0.0
v_m           = 0.0
xtrans        = 0.0
ytrans        = 0.0
ztrans        = 0.0
sceneroty     = 0.0

# initialize sector1 with SetupWorld

sector1 = SetupWorld("world.txt")

# load textures from images

tex1 = SDLIMGLoad("mud.bmp",1)
tex2 = SDLIMGLoad("mud.bmp",2)
tex3 = SDLIMGLoad("mud.bmp",3)

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

  # enable texture mapping and alpha blending
  glenable({GL_TEXTURE_2D, GL_BLEND})
  glblendfunc(GL_SRC_ALPHA, GL_ONE)

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

    xtrans = -xpos
    ztrans = -zpos
    ytrans = -walkbias-0.25
    sceneroty = 360.0 - yrot

    glrotate(lookupdown, 1.0, 0.0, 0.0)
    glrotate(sceneroty, 0.0, 1.0, 0.0)
    gltranslate(xtrans, ytrans, ztrans)

    if filter == 0
        glbindtexture(GL_TEXTURE_2D,tex1)
    elseif filter == 1
        glbindtexture(GL_TEXTURE_2D,tex2)
    elseif filter == 2
        glbindtexture(GL_TEXTURE_2D,tex3)
    end

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

# run GLUT routines

glutinit([1], ["a"])
glutinitdisplaymode(GLUT_RGBA | GLUT_DOUBLE | GLUT_ALPHA | GLUT_DEPTH)
glutinitwindowsize(640, 480)
glutinitwindowposition(0, 0)

window = glutcreatewindow("NeHe Tut 10")

glutdisplayfunc(_DrawGLScene)
glutfullscreen()

glutidlefunc(_DrawGLScene)
glutreshapefunc(_ReSizeGLScene)

initGL()

glutmainloop()
