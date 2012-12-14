One mention of caution: Please don't use this without saving important work
first.  I have had two instances in which a GLUT/SDL instance crashed my X11
session.  It appears to happen very rarely, but no harm in being safe.

This package is intended to be a fully fledged Julia (http://www.julialang.org)
interface to the GLUT implementation on your machine.

NOTE: Since Julia code doesn't exactly have arguments like a C program would
have, I made a small wrapper function called glutinit(), which can be called to
initialize  GLUT.  glutinit() wraps the original glutinit(pargc::Ptr{Int32},
argv::Ptr{Ptr{Uint8}}), so that the user doesn't have to pass dummy arguments
to make everything work.

#TODO

+ Fix performance hiccups
+ Find a way to close a GLUT instance without quitting the Julia REPL that
	created it
+ Fully FFI the whole library

#Usage notes

Many GLUT functions are working, but many of the less commonly used functions
are still not fully implemented. (You can edit the method signatures by hand,
but it is a painful process.  Jasper's FFI will soon handle this
automatically!)

PLEASE NOTE: When used in a Julia file, all of the function names are written in
lowercase. For example:

C - Julia comparisons

+ glutInit - 											  glutinit
+ glutCreateWindow - 							  glcreatewindow
+ glutMainLoop - 								 	  glmainloop

See the Examples directory for translations of the first ten NeHe tutorials
into Julia-GLUT.

At the moment, this has only been tested on a 2010 Macbook running Linux
(Fedora 17, freeglut) and a custom built PC desktop running Linux (Fedora 17,
freeglut). Have fun!

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
