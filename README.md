This package is intended to be a fully fledged Julia (http://www.julialang.org)
interface to the GLUT implementation on your machine.

NOTE: It is recommended that you use the proprietary drivers for your graphics
card.  Open-source drivers produce poor performance and have caused X11 to
crash before.

NOTE: Since Julia code doesn't exactly have arguments like a C program would
have, I made a small wrapper function called glutinit(), which can be called to
initialize GLUT.  glutinit() wraps the original glutinit(pargc::Ptr{Int32},
argv::Ptr{Ptr{Uint8}}), so that the user doesn't have to pass dummy arguments
to make everything work.

Many GLUT functions are working, but many of the less commonly used functions
are still not fully implemented. (You can edit the method signatures by hand,
but it is a painful process.  Jasper's FFI
(https://github.com/o-jasper/julia-ffi.git) will soon handle this
automatically!)

#Usage notes

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

See the Examples directory for translations of sixteen NeHe tutorials into
Julia-GLUT.

Have fun!

#Caveats

At the moment, GLUT callbacks communicate with each other through globals,
which can make for very messy code. There must be a better way to do this.

#Credit

The VAST majority of work was done by Jasper den Ouden
(https://github.com/o-jasper).  Without his FFI, C header parser, original
examples, and responses to my questions, I would never have been able to put
this into a Julia package.  All credit goes to him.

We'd also like to thank the Khronos Group (http://www.opengl.org) for making the
original GLUT API, a simple and straight-forward way to open windows for OpenGL
contexts. Plus, thanks to Pawel W. Olstza, Andreas Umbach, Steve Baker, and John
Fay for the freeglut project (http://freeglut.sourceforge.net), a free,
open-source alternative that has found it's way onto many Linux boxes.

Thanks to NeHe Productions (http://nehe.gamedev.net) for making their excellent
tutorials, which served as a wonderful test-bed for this interface. 

Thanks to the Julia team (http://julialang.org) for making Julia, a programming
language that many have been longing for, whether they knew about it or not.
The "Octave-for-C-programmers," as one could think of it, is an incredibly fast
and powerful programming language that is a welcome breath of fresh air in the
technical and numerical programming communities.

--rennis250 & o-jasper
