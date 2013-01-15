This package is intended to be a fully fledged
[Julia](http://www.julialang.org) interface to the GLUT implementation on your
machine.

NOTE: Since Julia code doesn't exactly have arguments like a C program would
have, I made a small wrapper function called glutinit(), which can be called to
initialize GLUT.  glutinit() wraps the original glutinit(pargc::Ptr{Int32},
argv::Ptr{Ptr{Uint8}}), so that the user doesn't have to pass dummy arguments
to make everything work.

Many of the commonly used GLUT functions are working, but most of the less
commonly used functions are still not fully implemented. (You can edit the
method signatures by hand, but it is a painful process.  [Jasper's
FFI](https://github.com/o-jasper/julia-ffi.git) will soon handle this
automatically!)

#Installation

```julia
Pkg.add("GLUT")
```

You will also need to install the [GLUT
libraries](http://freeglut.sourceforge.net) for your system.

On Ubuntu, install the following:

	freeglut3-dev

On Fedora, install the following:

	freeglut

The internet and the freeGLUT website seem to have instructions for Windows and
Mac OS X, which (as always) have a more detailed (and frustrating) install
process.

NOTE: If you are on Linux, it is recommended that you use the proprietary
drivers for your graphics card.  Open-source drivers produce poor performance
and have caused X11 to crash before.  Mac and Windows users should be fine.
However, I don't believe this package has been tested on either of those
operating systems.

#Usage notes

Press 'q' in any of the NeHe examples to quit.

PLEASE NOTE: When used in a Julia file, all of the function names are written in
lowercase. For example:

In C-GLUT code, one would write,

```c
glutInit
glutCreateWindow
glutMainLoop
```

In Julia-GLUT code, one would write:

```julia
glutinit
glutcreatewindow
glutmainloop
```

See the Examples/NeHe directory for translations of sixteen NeHe tutorials into
Julia-GLUT. Controls are listed in the opening comments of each example.

Mouse and joystick versions of tutorial 7 can be found in the Examples/NeHe
directory.  The joystick version is currently untested.

(At the moment, NeHe tutorial 17 will run, but produces a glicthy output.  I've
yet to figure that out.  It may be a while before I return to it, since fonts
in 3D applications aren't terribly interesting to me.)

To try a NeHe example (e.g. tutorial 2), do

```julia
require("GLUT/Examples/NeHe/tut2/tut2.jl")
```

###Some usage quirks:

- You must use glutdestroywindow() to quit a Julia-GLUT instance (press 'q' in
any of the NeHe examples to quit), just like you would in C-GLUT code.  Trying
to 'break' out of the GLUT main loop does not work.  glutdestroywindow() will
close your current Julia REPL session.

#Loading and using images as textures

NOTE: Examples with images will not work unless you have ImageMagick installed on
your system, since imread depends on it.

1. Load the image using imread from Julia's image.jl file. (You will need to
	 require("image") before imread will be available in the Main namespace.)
2. Pass the image array into glimg (automatically exported when
	 require("OpenGL") is evaluated). OpenGL expects upside-down, 1D image arrays
	 in an RGB format and glimg performs the necessary conversion on the 3D image
	 arrays produced by imread.
3. Initialize an empty array of Uint32's to contain texture identifiers.  For
	 example, an Array(Uint32,3) should be created if you want to make three
	 different textures.
4. Continue with the typical OpenGL image/texture process.
5. See Examples 6 or greater in the Examples/NeHe directory for the relevant
	 code.

#Caveats

At the moment, GLUT callbacks communicate with each other through globals,
which can make for very messy code, so I suggest that you use the SDL.jl
package, if you can. There must be a better way to have callbacks communicate
with each other.

#Credit

The VAST majority of work was done by [Jasper den
Ouden](https://github.com/o-jasper).  Without his FFI, C header parser,
original examples, and responses to my questions, I would never have been able
to put this into a Julia package.  All credit goes to him.

Thanks to [NeHe Productions](http://nehe.gamedev.net) for making their
excellent tutorials, which served as a wonderful test-bed for this interface. 

We'd also like to thank the [Khronos Group](http://www.opengl.org) for making
the original GLUT API, a simple and straight-forward way to open windows for
OpenGL contexts. Plus, thanks to Pawel W. Olstza, Andreas Umbach, Steve Baker,
and John Fay for the [freeglut project](http://freeglut.sourceforge.net), a
free, open-source alternative that has found it's way onto many Linux boxes.

Thanks to the [Julia team](http://julialang.org) for making Julia, a
programming language that many have been longing for, whether they knew about
it or not. The "Octave-for-C-programmers," as one could think of it, is an
incredibly fast and powerful programming language that is a welcome breath of
fresh air in the technical and numerical programming communities.

Have fun!
--rennis250 & o-jasper
