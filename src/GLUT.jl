#require("GLU")
require("OpenGL")
require("OpenGL/src/OpenGLAux")
require("GetC")
#using GLU
using OpenGL
using OpenGLAux

module GLUT

import GetC.@get_c_fun

glut = dlopen("libglut")

@get_c_fun glut glutinit glutInit(pargc::Ptr{Int32}, argv::Ptr{Ptr{Uint8}})::Void
export glutinit
@get_c_fun glut glutinitwindowposition glutInitWindowPosition(x::Int32, y::Int32)::Void
export glutinitwindowposition
@get_c_fun glut glutinitwindowsize glutInitWindowSize(width::Int32, height::Int32)::Void
export glutinitwindowsize
@get_c_fun glut glutinitdisplaymode glutInitDisplayMode(displayMode::Uint32)::Void
export glutinitdisplaymode
@get_c_fun glut glutinitdisplaystring glutInitDisplayString(displayMode::Ptr{Uint8})::Void
export glutinitdisplaystring

@get_c_fun glut glutmainloop glutMainLoop()::Void
export glutmainloop

@get_c_fun glut glutcreatewindow glutCreateWindow(title::Ptr{Uint8})::Int32
export glutcreatewindow
@get_c_fun glut glutcreatesubwindow glutCreateSubWindow(window::Int32, x::Int32, y::Int32, width::Int32, height::Int32)::Int32
export glutcreatesubwindow
@get_c_fun glut glutdestroywindow glutDestroyWindow(window::Int32)::Void
export glutdestroywindow
@get_c_fun glut glutsetwindow glutSetWindow(window::Int32)::Void
export glutsetwindow
@get_c_fun glut glutgetwindow glutGetWindow()::Int32
export glutgetwindow
@get_c_fun glut glutsetwindowtitle glutSetWindowTitle(title::Ptr{Uint8})::Void
export glutsetwindowtitle
@get_c_fun glut glutseticontitle glutSetIconTitle(title::Ptr{Uint8})::Void
export glutseticontitle
@get_c_fun glut glutreshapewindow glutReshapeWindow(width::Int32, height::Int32)::Void
export glutreshapewindow
@get_c_fun glut glutpositionwindow glutPositionWindow(x::Int32, y::Int32)::Void
export glutpositionwindow
@get_c_fun glut glutshowwindow glutShowWindow()::Void
export glutshowwindow
@get_c_fun glut gluthidewindow glutHideWindow()::Void
export gluthidewindow
@get_c_fun glut gluticonifywindow glutIconifyWindow()::Void
export gluticonifywindow
@get_c_fun glut glutpushwindow glutPushWindow()::Void
export glutpushwindow
@get_c_fun glut glutpopwindow glutPopWindow()::Void
export glutpopwindow
@get_c_fun glut glutfullscreen glutFullScreen()::Void
export glutfullscreen

@get_c_fun glut glutpostwindowredisplay glutPostWindowRedisplay(window::Int32)::Void
export glutpostwindowredisplay
@get_c_fun glut glutpostredisplay glutPostRedisplay()::Void
export glutpostredisplay
@get_c_fun glut glutswapbuffers glutSwapBuffers()::Void
export glutswapbuffers

@get_c_fun glut gluttimerfunc glutTimerFunc(time::Uint32, callback::Ptr{None}, value::Int32)::Void
export gluttimerfunc
@get_c_fun glut glutidlefunc glutIdleFunc(callback::Ptr{None})::Void
export glutidlefunc

@get_c_fun glut glutkeyboardfunc glutKeyboardFunc(callback::Ptr{None})::Void
export glutkeyboardfunc
@get_c_fun glut glutspecialfunc glutSpecialFunc(callback::Ptr{None})::Void
export glutspecialfunc
@get_c_fun glut glutreshapefunc glutReshapeFunc(callback::Ptr{None})::Void
export glutreshapefunc
@get_c_fun glut glutvisibilityfunc glutVisibilityFunc(callback::Ptr{None})::Void
export glutvisibilityfunc
@get_c_fun glut glutdisplayfunc glutDisplayFunc(callback::Ptr{None})::Void
export glutdisplayfunc
@get_c_fun glut glutmousefunc glutMouseFunc(callback::Ptr{None})::Void
export glutmousefunc
@get_c_fun glut glutmotionfunc glutMotionFunc(callback::Ptr{None})::Void
export glutmotionfunc
@get_c_fun glut glutpassivemotionfunc glutPassiveMotionFunc(callback::Ptr{None})::Void
export glutpassivemotionfunc
@get_c_fun glut glutentryfunc glutEntryFunc(callback::Ptr{None})::Void
export glutentryfunc

const  FREEGLUT                        = 1
const  GLUT_API_VERSION                = 4
const  FREEGLUT_VERSION_2_0            = 1
const  GLUT_XLIB_IMPLEMENTATION        = 13

const  GLUT_KEY_F1                     = 0x0001
const  GLUT_KEY_F2                     = 0x0002
const  GLUT_KEY_F3                     = 0x0003
const  GLUT_KEY_F4                     = 0x0004
const  GLUT_KEY_F5                     = 0x0005
const  GLUT_KEY_F6                     = 0x0006
const  GLUT_KEY_F7                     = 0x0007
const  GLUT_KEY_F8                     = 0x0008
const  GLUT_KEY_F9                     = 0x0009
const  GLUT_KEY_F10                    = 0x000A
const  GLUT_KEY_F11                    = 0x000B
const  GLUT_KEY_F12                    = 0x000C
const  GLUT_KEY_LEFT                   = 0x0064
const  GLUT_KEY_UP                     = 0x0065
const  GLUT_KEY_RIGHT                  = 0x0066
const  GLUT_KEY_DOWN                   = 0x0067
const  GLUT_KEY_PAGE_UP                = 0x0068
const  GLUT_KEY_PAGE_DOWN              = 0x0069
const  GLUT_KEY_HOME                   = 0x006A
const  GLUT_KEY_END                    = 0x006B
const  GLUT_KEY_INSERT                 = 0x006C
                                        
const  GLUT_LEFT_BUTTON                = 0x0000
const  GLUT_MIDDLE_BUTTON              = 0x0001
const  GLUT_RIGHT_BUTTON               = 0x0002
const  GLUT_DOWN                       = 0x0000
const  GLUT_UP                         = 0x0001
const  GLUT_LEFT                       = 0x0000
const  GLUT_ENTERED                    = 0x0001

const  GLUT_RGB                        = 0x0000
const  GLUT_RGBA                       = 0x0000
const  GLUT_INDEX                      = 0x0001
const  GLUT_SINGLE                     = 0x0000
const  GLUT_DOUBLE                     = 0x0002
const  GLUT_ACCUM                      = 0x0004
const  GLUT_ALPHA                      = 0x0008
const  GLUT_DEPTH                      = 0x0010
const  GLUT_STENCIL                    = 0x0020
const  GLUT_MULTISAMPLE                = 0x0080
const  GLUT_STEREO                     = 0x0100
const  GLUT_LUMINANCE                  = 0x0200
                                        
const  GLUT_MENU_NOT_IN_USE            = 0x0000
const  GLUT_MENU_IN_USE                = 0x0001
const  GLUT_NOT_VISIBLE                = 0x0000
const  GLUT_VISIBLE                    = 0x0001
const  GLUT_HIDDEN                     = 0x0000
const  GLUT_FULLY_RETAINED             = 0x0001
const  GLUT_PARTIALLY_RETAINED         = 0x0002
const  GLUT_FULLY_COVERED              = 0x0003
                                        
const  GLUT_WINDOW_X                   = 0x0064
const  GLUT_WINDOW_Y                   = 0x0065
const  GLUT_WINDOW_WIDTH               = 0x0066
const  GLUT_WINDOW_HEIGHT              = 0x0067
const  GLUT_WINDOW_BUFFER_SIZE         = 0x0068
const  GLUT_WINDOW_STENCIL_SIZE        = 0x0069
const  GLUT_WINDOW_DEPTH_SIZE          = 0x006A
const  GLUT_WINDOW_RED_SIZE            = 0x006B
const  GLUT_WINDOW_GREEN_SIZE          = 0x006C
const  GLUT_WINDOW_BLUE_SIZE           = 0x006D
const  GLUT_WINDOW_ALPHA_SIZE          = 0x006E
const  GLUT_WINDOW_ACCUM_RED_SIZE      = 0x006F
const  GLUT_WINDOW_ACCUM_GREEN_SIZE    = 0x0070
const  GLUT_WINDOW_ACCUM_BLUE_SIZE     = 0x0071
const  GLUT_WINDOW_ACCUM_ALPHA_SIZE    = 0x0072
const  GLUT_WINDOW_DOUBLEBUFFER        = 0x0073
const  GLUT_WINDOW_RGBA                = 0x0074
const  GLUT_WINDOW_PARENT              = 0x0075
const  GLUT_WINDOW_NUM_CHILDREN        = 0x0076
const  GLUT_WINDOW_COLORMAP_SIZE       = 0x0077
const  GLUT_WINDOW_NUM_SAMPLES         = 0x0078
const  GLUT_WINDOW_STEREO              = 0x0079
const  GLUT_WINDOW_CURSOR              = 0x007A
                                        
const  GLUT_SCREEN_WIDTH               = 0x00C8
const  GLUT_SCREEN_HEIGHT              = 0x00C9
const  GLUT_SCREEN_WIDTH_MM            = 0x00CA
const  GLUT_SCREEN_HEIGHT_MM           = 0x00CB
const  GLUT_MENU_NUM_ITEMS             = 0x012C
const  GLUT_DISPLAY_MODE_POSSIBLE      = 0x0190
const  GLUT_INIT_WINDOW_X              = 0x01F4
const  GLUT_INIT_WINDOW_Y              = 0x01F5
const  GLUT_INIT_WINDOW_WIDTH          = 0x01F6
const  GLUT_INIT_WINDOW_HEIGHT         = 0x01F7
const  GLUT_INIT_DISPLAY_MODE          = 0x01F8
const  GLUT_ELAPSED_TIME               = 0x02BC
const  GLUT_WINDOW_FORMAT_ID           = 0x007B

const  GLUT_HAS_KEYBOARD               = 0x0258
const  GLUT_HAS_MOUSE                  = 0x0259
const  GLUT_HAS_SPACEBALL              = 0x025A
const  GLUT_HAS_DIAL_AND_BUTTON_BOX    = 0x025B
const  GLUT_HAS_TABLET                 = 0x025C
const  GLUT_NUM_MOUSE_BUTTONS          = 0x025D
const  GLUT_NUM_SPACEBALL_BUTTONS      = 0x025E
const  GLUT_NUM_BUTTON_BOX_BUTTONS     = 0x025F
const  GLUT_NUM_DIALS                  = 0x0260
const  GLUT_NUM_TABLET_BUTTONS         = 0x0261
const  GLUT_DEVICE_IGNORE_KEY_REPEAT   = 0x0262
const  GLUT_DEVICE_KEY_REPEAT          = 0x0263
const  GLUT_HAS_JOYSTICK               = 0x0264
const  GLUT_OWNS_JOYSTICK              = 0x0265
const  GLUT_JOYSTICK_BUTTONS           = 0x0266
const  GLUT_JOYSTICK_AXES              = 0x0267
const  GLUT_JOYSTICK_POLL_RATE         = 0x0268

const  GLUT_OVERLAY_POSSIBLE           = 0x0320
const  GLUT_LAYER_IN_USE               = 0x0321
const  GLUT_HAS_OVERLAY                = 0x0322
const  GLUT_TRANSPARENT_INDEX          = 0x0323
const  GLUT_NORMAL_DAMAGED             = 0x0324
const  GLUT_OVERLAY_DAMAGED            = 0x0325
                                        
const  GLUT_VIDEO_RESIZE_POSSIBLE      = 0x0384
const  GLUT_VIDEO_RESIZE_IN_USE        = 0x0385
const  GLUT_VIDEO_RESIZE_X_DELTA       = 0x0386
const  GLUT_VIDEO_RESIZE_Y_DELTA       = 0x0387
const  GLUT_VIDEO_RESIZE_WIDTH_DELTA   = 0x0388
const  GLUT_VIDEO_RESIZE_HEIGHT_DELTA  = 0x0389
const  GLUT_VIDEO_RESIZE_X             = 0x038A
const  GLUT_VIDEO_RESIZE_Y             = 0x038B
const  GLUT_VIDEO_RESIZE_WIDTH         = 0x038C
const  GLUT_VIDEO_RESIZE_HEIGHT        = 0x038D
                                        
const  GLUT_NORMAL                     = 0x0000
const  GLUT_OVERLAY                    = 0x0001
                                        
const  GLUT_ACTIVE_SHIFT               = 0x0001
const  GLUT_ACTIVE_CTRL                = 0x0002
const  GLUT_ACTIVE_ALT                 = 0x0004
                                        
const  GLUT_CURSOR_RIGHT_ARROW         = 0x0000
const  GLUT_CURSOR_LEFT_ARROW          = 0x0001
const  GLUT_CURSOR_INFO                = 0x0002
const  GLUT_CURSOR_DESTROY             = 0x0003
const  GLUT_CURSOR_HELP                = 0x0004
const  GLUT_CURSOR_CYCLE               = 0x0005
const  GLUT_CURSOR_SPRAY               = 0x0006
const  GLUT_CURSOR_WAIT                = 0x0007
const  GLUT_CURSOR_TEXT                = 0x0008
const  GLUT_CURSOR_CROSSHAIR           = 0x0009
const  GLUT_CURSOR_UP_DOWN             = 0x000A
const  GLUT_CURSOR_LEFT_RIGHT          = 0x000B
const  GLUT_CURSOR_TOP_SIDE            = 0x000C
const  GLUT_CURSOR_BOTTOM_SIDE         = 0x000D
const  GLUT_CURSOR_LEFT_SIDE           = 0x000E
const  GLUT_CURSOR_RIGHT_SIDE          = 0x000F
const  GLUT_CURSOR_TOP_LEFT_CORNER     = 0x0010
const  GLUT_CURSOR_TOP_RIGHT_CORNER    = 0x0011
const  GLUT_CURSOR_BOTTOM_RIGHT_CORNER = 0x0012
const  GLUT_CURSOR_BOTTOM_LEFT_CORNER  = 0x0013
const  GLUT_CURSOR_INHERIT             = 0x0064
const  GLUT_CURSOR_NONE                = 0x0065
const  GLUT_CURSOR_FULL_CROSSHAIR      = 0x0066
                                        
const  GLUT_RED                        = 0x0000
const  GLUT_GREEN                      = 0x0001
const  GLUT_BLUE                       = 0x0002
                                        
const  GLUT_KEY_REPEAT_OFF             = 0x0000
const  GLUT_KEY_REPEAT_ON              = 0x0001
const  GLUT_KEY_REPEAT_DEFAULT         = 0x0002

const  GLUT_JOYSTICK_BUTTON_A          = 0x0001
const  GLUT_JOYSTICK_BUTTON_B          = 0x0002
const  GLUT_JOYSTICK_BUTTON_C          = 0x0004
const  GLUT_JOYSTICK_BUTTON_D          = 0x0008

const  GLUT_GAME_MODE_ACTIVE           = 0x0000
const  GLUT_GAME_MODE_POSSIBLE         = 0x0001
const  GLUT_GAME_MODE_WIDTH            = 0x0002
const  GLUT_GAME_MODE_HEIGHT           = 0x0003
const  GLUT_GAME_MODE_PIXEL_DEPTH      = 0x0004
const  GLUT_GAME_MODE_REFRESH_RATE     = 0x0005
const  GLUT_GAME_MODE_DISPLAY_CHANGED  = 0x0006

export  FREEGLUT             
export  GLUT_API_VERSION               
export  FREEGLUT_VERSION_2_0            
export  GLUT_XLIB_IMPLEMENTATION       
                                        
export  GLUT_KEY_F1                      
export  GLUT_KEY_F2                      
export  GLUT_KEY_F3                      
export  GLUT_KEY_F4                      
export  GLUT_KEY_F5                      
export  GLUT_KEY_F6                      
export  GLUT_KEY_F7                      
export  GLUT_KEY_F8                      
export  GLUT_KEY_F9                      
export  GLUT_KEY_F10                     
export  GLUT_KEY_F11                     
export  GLUT_KEY_F12                     
export  GLUT_KEY_LEFT                    
export  GLUT_KEY_UP                      
export  GLUT_KEY_RIGHT                   
export  GLUT_KEY_DOWN                    
export  GLUT_KEY_PAGE_UP                 
export  GLUT_KEY_PAGE_DOWN               
export  GLUT_KEY_HOME                    
export  GLUT_KEY_END                     
export  GLUT_KEY_INSERT                  
                                        
export  GLUT_LEFT_BUTTON                 
export  GLUT_MIDDLE_BUTTON               
export  GLUT_RIGHT_BUTTON                
export  GLUT_DOWN                        
export  GLUT_UP                          
export  GLUT_LEFT                        
export  GLUT_ENTERED                     
                                        
export  GLUT_RGB                         
export  GLUT_RGBA                        
export  GLUT_INDEX                       
export  GLUT_SINGLE                      
export  GLUT_DOUBLE                      
export  GLUT_ACCUM                       
export  GLUT_ALPHA                       
export  GLUT_DEPTH                       
export  GLUT_STENCIL                     
export  GLUT_MULTISAMPLE                 
export  GLUT_STEREO                      
export  GLUT_LUMINANCE                   
                                        
export  GLUT_MENU_NOT_IN_USE             
export  GLUT_MENU_IN_USE                 
export  GLUT_NOT_VISIBLE                 
export  GLUT_VISIBLE                     
export  GLUT_HIDDEN                      
export  GLUT_FULLY_RETAINED              
export  GLUT_PARTIALLY_RETAINED          
export  GLUT_FULLY_COVERED               
                                        
export  GLUT_WINDOW_X                    
export  GLUT_WINDOW_Y                    
export  GLUT_WINDOW_WIDTH                
export  GLUT_WINDOW_HEIGHT               
export  GLUT_WINDOW_BUFFER_SIZE          
export  GLUT_WINDOW_STENCIL_SIZE         
export  GLUT_WINDOW_DEPTH_SIZE           
export  GLUT_WINDOW_RED_SIZE             
export  GLUT_WINDOW_GREEN_SIZE           
export  GLUT_WINDOW_BLUE_SIZE            
export  GLUT_WINDOW_ALPHA_SIZE           
export  GLUT_WINDOW_ACCUM_RED_SIZE       
export  GLUT_WINDOW_ACCUM_GREEN_SIZE     
export  GLUT_WINDOW_ACCUM_BLUE_SIZE      
export  GLUT_WINDOW_ACCUM_ALPHA_SIZE     
export  GLUT_WINDOW_DOUBLEBUFFER         
export  GLUT_WINDOW_RGBA                 
export  GLUT_WINDOW_PARENT               
export  GLUT_WINDOW_NUM_CHILDREN         
export  GLUT_WINDOW_COLORMAP_SIZE        
export  GLUT_WINDOW_NUM_SAMPLES          
export  GLUT_WINDOW_STEREO               
export  GLUT_WINDOW_CURSOR               
                                        
export  GLUT_SCREEN_WIDTH                
export  GLUT_SCREEN_HEIGHT               
export  GLUT_SCREEN_WIDTH_MM             
export  GLUT_SCREEN_HEIGHT_MM            
export  GLUT_MENU_NUM_ITEMS              
export  GLUT_DISPLAY_MODE_POSSIBLE       
export  GLUT_INIT_WINDOW_X               
export  GLUT_INIT_WINDOW_Y               
export  GLUT_INIT_WINDOW_WIDTH           
export  GLUT_INIT_WINDOW_HEIGHT          
export  GLUT_INIT_DISPLAY_MODE           
export  GLUT_ELAPSED_TIME                
export  GLUT_WINDOW_FORMAT_ID            
                                        
export  GLUT_HAS_KEYBOARD                
export  GLUT_HAS_MOUSE                   
export  GLUT_HAS_SPACEBALL               
export  GLUT_HAS_DIAL_AND_BUTTON_BOX     
export  GLUT_HAS_TABLET                  
export  GLUT_NUM_MOUSE_BUTTONS           
export  GLUT_NUM_SPACEBALL_BUTTONS       
export  GLUT_NUM_BUTTON_BOX_BUTTONS      
export  GLUT_NUM_DIALS                   
export  GLUT_NUM_TABLET_BUTTONS          
export  GLUT_DEVICE_IGNORE_KEY_REPEAT    
export  GLUT_DEVICE_KEY_REPEAT           
export  GLUT_HAS_JOYSTICK                
export  GLUT_OWNS_JOYSTICK               
export  GLUT_JOYSTICK_BUTTONS            
export  GLUT_JOYSTICK_AXES               
export  GLUT_JOYSTICK_POLL_RATE          
                                        
export  GLUT_OVERLAY_POSSIBLE            
export  GLUT_LAYER_IN_USE                
export  GLUT_HAS_OVERLAY                 
export  GLUT_TRANSPARENT_INDEX           
export  GLUT_NORMAL_DAMAGED              
export  GLUT_OVERLAY_DAMAGED             
                                        
export  GLUT_VIDEO_RESIZE_POSSIBLE       
export  GLUT_VIDEO_RESIZE_IN_USE         
export  GLUT_VIDEO_RESIZE_X_DELTA        
export  GLUT_VIDEO_RESIZE_Y_DELTA        
export  GLUT_VIDEO_RESIZE_WIDTH_DELTA    
export  GLUT_VIDEO_RESIZE_HEIGHT_DELTA   
export  GLUT_VIDEO_RESIZE_X              
export  GLUT_VIDEO_RESIZE_Y              
export  GLUT_VIDEO_RESIZE_WIDTH          
export  GLUT_VIDEO_RESIZE_HEIGHT         
                                        
export  GLUT_NORMAL                      
export  GLUT_OVERLAY                     
                                        
export  GLUT_ACTIVE_SHIFT                
export  GLUT_ACTIVE_CTRL                 
export  GLUT_ACTIVE_ALT                  
                                        
export  GLUT_CURSOR_RIGHT_ARROW          
export  GLUT_CURSOR_LEFT_ARROW           
export  GLUT_CURSOR_INFO                 
export  GLUT_CURSOR_DESTROY              
export  GLUT_CURSOR_HELP                 
export  GLUT_CURSOR_CYCLE                
export  GLUT_CURSOR_SPRAY                
export  GLUT_CURSOR_WAIT                 
export  GLUT_CURSOR_TEXT                 
export  GLUT_CURSOR_CROSSHAIR            
export  GLUT_CURSOR_UP_DOWN              
export  GLUT_CURSOR_LEFT_RIGHT           
export  GLUT_CURSOR_TOP_SIDE             
export  GLUT_CURSOR_BOTTOM_SIDE          
export  GLUT_CURSOR_LEFT_SIDE            
export  GLUT_CURSOR_RIGHT_SIDE           
export  GLUT_CURSOR_TOP_LEFT_CORNER      
export  GLUT_CURSOR_TOP_RIGHT_CORNER     
export  GLUT_CURSOR_BOTTOM_RIGHT_CORNER  
export  GLUT_CURSOR_BOTTOM_LEFT_CORNER   
export  GLUT_CURSOR_INHERIT              
export  GLUT_CURSOR_NONE                 
export  GLUT_CURSOR_FULL_CROSSHAIR       
                                        
export  GLUT_RED                         
export  GLUT_GREEN                       
export  GLUT_BLUE                        
                                        
export  GLUT_KEY_REPEAT_OFF              
export  GLUT_KEY_REPEAT_ON               
export  GLUT_KEY_REPEAT_DEFAULT          
                                        
export  GLUT_JOYSTICK_BUTTON_A           
export  GLUT_JOYSTICK_BUTTON_B           
export  GLUT_JOYSTICK_BUTTON_C           
export  GLUT_JOYSTICK_BUTTON_D           
                                        
export  GLUT_GAME_MODE_ACTIVE            
export  GLUT_GAME_MODE_POSSIBLE          
export  GLUT_GAME_MODE_WIDTH             
export  GLUT_GAME_MODE_HEIGHT            
export  GLUT_GAME_MODE_PIXEL_DEPTH       
export  GLUT_GAME_MODE_REFRESH_RATE      
export  GLUT_GAME_MODE_DISPLAY_CHANGED   

end
