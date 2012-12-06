# Tue 13 Nov 2012 04:13:36 PM EST 
#
# NeHe Tut 9 - Make some colored stars and play w/ alpha blending a bit more


# load necessary GLUT/GLU/OpenGL routines

require("OpenGL")
require("GLU")
require("GLUT")
using OpenGL
using GLU
using GLUT

# initialize variables

const STAR_NUM      = 50
const max_star_dist = 0.3
const star_size     = 0.1

type star
    r::Int  
    g::Int
    b::Int
    dist::Float64
    angle::Float64
end

tempr = convert(Int,round(rand()*256))
tempg = convert(Int,round(rand()*256))
tempb = convert(Int,round(rand()*256))

stars = [star(tempr,tempg,tempb,0*1.0/STAR_NUM*max_star_dist,0.0)] # Julia doesn't like it when you try to initialize an empty array of
                                                         # a composite type and try to fill it afterwards, so we start with a single-element
                                                         # vector and tack on values in a loop

for loop = 1:STAR_NUM-1
    tempr = convert(Int,round(rand()*256))
    tempg = convert(Int,round(rand()*256))
    tempb = convert(Int,round(rand()*256))
    stars = [stars star(tempr,tempg,tempb,loop*1.0/STAR_NUM*max_star_dist,0.0)]
end # I haven't found a better way to make an array of composite types

tilt    = 90.0
zoom    = 0.8
spin    = 0.0

twinkle = false

# load textures from images

tex1 = SDLIMGLoad("Star.bmp")

# function to init OpenGL context

function initGL()
  glclearcolor(0.0, 0.0, 0.0, 0.0)
  glcleardepth(1.0)			 
  gldepthfunc(GL_LESS)	 
  glenable(GL_DEPTH_TEST)
  glshademodel(GL_SMOOTH)

  # enable texture mapping and alpha blending
  glblendfunc(GL_SRC_ALPHA, GL_ONE)
  glenable({GL_TEXTURE_2D, GL_BLEND})

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

    glbindtexture(GL_TEXTURE_2D,tex1)

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
                glvertex(-star_size, -star_size, 0.0)
                gltexcoord(1.0, 0.0)
                glvertex(star_size, -star_size, 0.0)
                gltexcoord(1.0, 1.0)
                glvertex(star_size, star_size, 0.0)
            glend()

        end

        # main star

        glrotate(spin, 0.0, 0.0, 1.0)
        glcolor4ub(stars[loop].r, stars[loop].g, stars[loop].b, 255)

        glbegin(GL_QUADS)
            gltexcoord(0.0, 0.0)
            glvertex(-star_size, -star_size, 0.0)
            gltexcoord(1.0, 0.0)
            glvertex(star_size, -star_size, 0.0)
            gltexcoord(1.0, 1.0)
            glvertex(star_size, star_size, 0.0)
            gltexcoord(0.0, 1.0)
            glvertex(-star_size, star_size, 0.0)
        glend()

        spin              += 0.01
        stars[loop].angle += loop * 1.0/STAR_NUM * 1.0
        stars[loop].dist  -= 0.01

        if stars[loop].dist < 0.0
            stars[loop].dist  += max_star_dist
            stars[loop].r     = convert(Int,round(rand()*256))
            stars[loop].g     = convert(Int,round(rand()*256))
            stars[loop].b     = convert(Int,round(rand()*256))
        end

    end

    glutswapbuffers()
end
   
_DrawGLScene = cfunction(DrawGLScene, Void, ())

# run GLUT routines

glutinit([1], ["a"])
glutinitdisplaymode(GLUT_RGBA | GLUT_DOUBLE | GLUT_ALPHA | GLUT_DEPTH)
glutinitwindowsize(640, 480)
glutinitwindowposition(0, 0)

window = glutcreatewindow("NeHe Tut 9")

glutdisplayfunc(_DrawGLScene)
glutfullscreen()

glutidlefunc(_DrawGLScene)
glutreshapefunc(_ReSizeGLScene)

initGL()

glutmainloop()

    # check key presses
    while true
        poll = poll_event()
        @case poll begin
            int('q') : return
            SDL_EVENTS_DONE   : break
        end

        println("Twinkle was: $twinkle")
        twinkle = @case poll begin
            int('t') : (twinkle ? false : true)
            default : twinkle
        end
        println("Twinkle is now: $twinkle")

        zoom += @case poll begin
            SDLK_PAGEUP : -0.02
            SDLK_PAGEDOWN : 0.02
            default : 0.0
        end

        tilt += @case poll begin
            SDLK_UP : -0.5
            SDLK_DOWN : 0.5
            default : 0.0
        end
    end
