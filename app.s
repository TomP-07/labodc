.equ SCREEN_WIDTH, 		640
.equ SCREEN_HEIGH, 		480
.equ BITS_PER_PIXEL,  	32

.equ BUS_HEIGHT, 60
.equ BUS_WIDTH, 130

.equ LOOP_BURN_INSTRUCTIONS, 10000

.globl main
main:
	// X0 contiene la direccion base del framebuffer
	mov x27, x0	// Save framebuffer base address to x27	

/*	movz x10, 0xC7, lsl 16
	movk x10, 0x1585, lsl 00

	mov x2, SCREEN_HEIGH         // Y Size 
loop1:
	mov x1, SCREEN_WIDTH         // X Size
loop0:
	stur w10,[x0]	   // Set color of pixel N
	add x0,x0,4	   // Next pixel
	sub x1,x1,1	   // decrement X counter
	cbnz x1,loop0	   // If not end row jump
	sub x2,x2,1	   // Decrement Y counter
	cbnz x2,loop1	   // if not last row, jump

*/

/*// --- This whole block is used exactly as it is for Stack Function Calls. Not pretty, but simple and useful enough. --- //
adr x18, . // Read Program Counter at this instruction
add x18, x18, 12 // Use x18 as a Special Register for Stack Calls. This makes sures that the Stack Call jumps back two lines after this one.
b Stack_Push_Caller*/




																									//	||
																													// Basically, this line.

/*mov x0, SCREEN_WIDTH
lsr x0, x0, 1
lsl x0, x0, 32
mov x1, SCREEN_HEIGH
lsr x1, x1, 1
add x0, x0, x1
// x0 = 320 | 240

mov x1, 50
movz x2, 0xDD, lsl 16
movk x2, 0xD00D, lsl 00 
mov x3, x20

bl DibujarCirculo

movz x0, 320, lsl 32
movk x0, 240

movz x1, 5900, lsl 32
movk x1, 5000

movz x2, 0x99, lsl 32
movk x2, 0x5555

mov x3, x20

bl DibujarRectangulo*/

mov x0, x27
movz x1, 0x99db, lsl 00
movk x1, 0x0070, lsl 16
bl DibujarFondoPantalla

mov x0, 100
mov x1, 80
mov x2, x27
bl DibujarSol

mov x0, x27
bl DibujarCarretera

/*movz x0, 100, lsl 32
movk x0, 100

movz x1, 100, lsl 32
movk x1, 200

movz x2, 0x00FF, lsl 32
movk x2, 0xFFFF 

mov x3, x20

bl DibujarEdificio*/

mov x19, LOOP_BURN_INSTRUCTIONS
mov x20, xzr

mov x0, xzr
add x0, x0, 70
mov x1, SCREEN_HEIGH
sub x1, x1, 24

loopAnimacion: // La idea es tener aproximadamente 20 FPS
    mov x20, xzr

    add x0, x0, 1
    mov x2, x27

    adr x18, .
    add x18, x18, 12
    b Stack_Push_Caller

    bl DibujarColectivo

    adr x18, .
    add x18, x18, 12
    b Stack_Pop_Caller


killTime:
    cmp x20, x19
    b.HS loopAnimacion
    add x20, x20, 1
    b killTime


InfLoop: 
	b InfLoop


/*
    ----------------------------------
        DRAW FUNCTIONS
    ----------------------------------
*/


// x0=(X|Y), x1=(Ancho|Alto), x2 el color, x3 direccion del frame buffer  
DibujarEdificio:

 adr x18, .                      //x18 = direccion de la linea en donde esta escrita
    add x18, x18, 12                //x18 = direccion de la linea tres instrucciones abajo de adr
    b Stack_Push_Callee             //salta a la funcion que guarda del x19 al x27 mas el x30

    bl DibujarRectangulo

    // ventanas

    //ventana1
///////////////////x0///////////////
    lsl x4, x0, 32
    lsr x4, x4, 1        //x4 = mitad del ancho del edificio
    sub x4, x4, 10        //x4 = mitad del ancho del edificio - 10 (X)
    lsr x4, x4, 32

    lsr w4, w0, 2        //x4 = (X|alto dividido 4)
    sub w4, w4, 6        //x4 = (X|alto dividido 4 - 6)   x4=(X|Y)

    mov x5, x0           // x5 = (X|Y) del edificio
    mov x0, x4           // x0 = x4 (X|Y) primera ventana
///////////////////x1/////////////////////
    lsl x6, x1, 32
    lsr x6, x6, 3        //x4 = ancho del edificio dividido 8
    lsr x6, x6, 32    //x4 = mitad del ancho del edificio - 10 (X|000...000)

    lsr w6, w1, 3        //x4 = (X|alto dividido 8)
    sub w6, w6, 5        //x4 = (X|alto dividido 8 - 5)

    mov x7, x1          // x7 = (Ancho|Alto) general
    mov x1, x6          // x1 = x6

////////////////////x2//////////////////////

    movz x2, 0x0000, lsl 00        //x2 = 0x 0000...0000000


    bl DibujarRectangulo            //salta a dibujarrectangulo y guarla la direc de la instruccion sig en x30

    adr x18, .                      //x18 = direccion de la linea en donde esta escrita
    add x18, x18, 12                //x18 = direccion de la linea tres instrucciones abajo de adr
    b Stack_Pop_Callee              //salta a la funcion que restaura del x19 al x27 mas el x30

    br lr                           //vuelve a la direc gusrdada en x30 de la instruccion siguiente de donde se llamo a la funcion


// X0 = X, x1 = Y, x2 = FrameBuffer
DibujarSol:

    adr x18, .              
    add x18, x18, 12                
    b Stack_Push_Callee  

    lsl x0, x0, 32
    add x0, x0, x1

    movz x1, 45

    mov x3, x2

    movz x2, 0x00EB, lsl 16
    movk x2, 0xC334

    bl DibujarCirculo

    adr x18, .              
    add x18, x18, 12                
    b Stack_Pop_Callee  

    br lr

// X0 = X, x1=2, x2 = FrameBuffer
DibujarColectivo:
    adr x18, .              
    add x18, x18, 12                
    b Stack_Push_Callee            

    mov x19, x2 // x19 = Frame Buffer
    mov x20, x0 // x20 = X
    mov x21, x1 // x21 = Y

    mov x1, x21
    sub x1, x1, BUS_HEIGHT

    mov x0, x20
    lsl x0, x0, 32
    add x0, x0, x1

    mov x1, BUS_WIDTH
    lsl x1, x1, 32
    add x1, x1, BUS_HEIGHT

    movz x2, 0x00F7, lsl 16
    movk x2, 0xFF00, lsl 00

    mov x3, x19
    
    bl DibujarRectangulo

    
    mov x0, x20
    add x0, x0, 33
    lsl x0, x0, 32
    add x1, x21, 3
    add x0, x0, x1

    movz x1, 10 // r = 10

    mov x2, xzr
    mov x3, x19

    bl DibujarCirculo

    mov x0, x20
    add x0, x0, BUS_WIDTH
    sub x0, x0, 33
    lsl x0, x0, 32
    add x1, x21, 3
    add x0, x0, x1

    movz x1, 10 // r = 10

    mov x2, xzr
    mov x3, x19

    bl DibujarCirculo

    mov x0, x20
    add x0, x0, BUS_WIDTH
    sub x0, x0, 30

    mov x1, x21
    sub x1, x1, BUS_HEIGHT
    add x1, x1, 10

    lsl x0, x0, 32
    add x0, x0, x1

    movz x1, 20, lsl 32
    movk x1, 40

    movz x2, 0x00E0, lsl 16
    movk x2, 0xFFFF

    mov x3, x19

    bl DibujarRectangulo

    add x0, x20, 6
    mov x1, x21
    sub x1, x1, BUS_HEIGHT
    add x1, x1, 10

    lsl x0, x0, 32
    add x0, x0, x1

    movz x1, 20, lsl 32
    movk x1, 40, lsl 00

    movz x2, 0x00E0, lsl 16
    movk x2, 0xFFFF

    mov x3, x19

    bl DibujarRectangulo


    add x0, x20, BUS_WIDTH
    sub x0, x0, 5

    sub x1, x21, BUS_HEIGHT
    add x1, X1, 3
    
    lsl x0, x0, 32
    add x0, x0, x1

    movz x1, 5
    lsl x1, x1, 32
    
    mov x2, BUS_HEIGHT
    sub x2, x2, 15

    add x1, x1, x2

    movz x2, 0x00E0, lsl 16
    movk x2, 0xFFFF

    mov x3, x19

    bl DibujarRectangulo



    adr x18, .                      
    add x18, x18, 12                
    b Stack_Pop_Callee              

    br lr

// x0 = Direccion Frame Buffer, x1 Color
DibujarFondoPantalla:
    mov x3, x0
    mov x2, x1
    mov x0, xzr
    movz x1, SCREEN_WIDTH, lsl 32
    movk x1, SCREEN_HEIGH, lsl 00
    
    adr x18, . 
    add x18, x18, 12
    b Stack_Push_Callee
    
    bl DibujarRectangulo

    adr x18, . 
    add x18, x18, 12
    b Stack_Pop_Callee

    br lr

// x0 = Direccion Frame Buffer
DibujarCarretera:
    adr x18, .                      //x18 = direccion de la linea en donde esta escrita
    add x18, x18, 12                //x18 = direccion de la linea tres instrucciones abajo de adr 
    b Stack_Push_Callee             //salta a la funcion que guarda del x19 al x27 mas el x30

    mov x19, x0                     //x19 = Direccion Frame Buffer
    mov x3, x0
    mov x0, SCREEN_HEIGH            //x0 = altura
    sub x0, x0, 120                  //x0 = altura - 50
    mov x20, x0                     //x20 = x0

    movz x1, SCREEN_WIDTH, lsl 32   //x1 = ancho | 000...000
    movk x1, 120                    //x1 = ancho | 000...100
    mov x21, x1                     //x21 = x1

    movz x2, 0x0055, lsl 16         //x2 = 0x 0000...00550000
    movk x2, 0x5555, lsl 00         //x2 = 0x 0000...00555555

    bl DibujarRectangulo            //salta a dibujarrectangulo y guarla la direc de la instruccion sig en x30
    
    mov x3, x19
    mov x0, x20
    add x0, x0, 50 
    mov x1, x21
    movk x1, 1
    mov x2, x22
    movk x2, 0xFB00, lsl 00
    movk x2, 0x00FF, lsl 16
    bl DibujarRectangulo

    mov x3, x19
    mov x0, x20
    add x0, x0, 58
    mov x1, x21
    movk x1, 1
    mov x2, x22
    movk x2, 0xFB00, lsl 00
    movk x2, 0x00FF, lsl 16
    bl DibujarRectangulo

/*
mov x0, xzr
    mov x1, BUS_WIDTH
    lsl x1, x1, 32
    add x1, x1, BUS_HEIGHT

    movz x2, 0x0000, lsl 00
    
    mov x3, x19

    bl DibujarRectangulo  */

    adr x18, .                      //x18 = direccion de la linea en donde esta escrita
    add x18, x18, 12                //x18 = direccion de la linea tres instrucciones abajo de adr 
    b Stack_Pop_Callee              //salta a la funcion que restaura del x19 al x27 mas el x30

    br lr                           //vuelve a la direc gusrdada en x30 de la instruccion siguiente de donde se llamo a la funcion
    

// x0=(X|Y), x1=(Ancho|Alto), x2 el color, x3 direccion del frame buffer
DibujarRectangulo:

    mov x4, x3 // x4 = Frame buffer
    mov x3, x2 // x3 = Color
    adr x2, CuadradoMap // Callback function of the iterator.
    
    adr x18, .
    add x18, x18, 12
    b Stack_Push_Callee

    bl RectangleMapIterator
    
    adr x18, .
    add x18, x18, 12
    b Stack_Pop_Callee

    br lr

// x0=(X|Y), x1=r radio del circulo, x2 color del circulo, x3 direccion del frame buffer. 
DibujarCirculo: 
    mov x12, x0 // x12 = Center

    // Setup RectangleMapIterator Arguments
    
    // This whole thing setups x0 with the starting points of the Map Box.
    mov x14, x0
    lsr x15, x0, 32
    sub x0, x15, x1
    lsl x0, x0, 32
    // --- //
    mov x15, xzr
    mov w15, w14
    sub x15, x15, x1
    add x0, x0, x15

    // Setup Width and Height of the Map Box.
    mov x15, x1
    lsl x15, x15, 1 // r * 2
    lsl x1, x15, 32
    add x1, x1, x15


    lsr x15, x15, 1 // x15 = r
    mov x14, x2 // x14 = Color
    mov x13, x3 // x13 = FrameBuffer
                // x12 = Center, already in place.

    //mov x2, CircleMaper 
    adr x2, CirculoMap // Callback function of the iterator.

    mov x3, x12 // Center
    mov x4, x15 // Radius
    mov x5, x14 // Color
    mov x6, x13 // FrameBuffer

    // Store the Return Address (and others)
    adr x18, .
    add x18, x18, 12
    b Stack_Push_Callee

    // x0=(270, 190) = (0x10E, 0xBE)
    // x1=(100, 100)
    // x2 ..
    // x3 = (320, 240) = (0x140 | 0xF0)
    // x4 = 50 = 0x32
    // x5 = 0x0000...000DDDDDD
    // Branch to Iterator
	//mov x0, xzr
    bl RectangleMapIterator

    // Restore the Return Address (and others)
    adr x18, .
    add x18, x18, 12
    b Stack_Pop_Callee

DC_Exit: // Branch to Caller.
    br lr

// x0=(X|Y), x1 el color, x2 direccion del frame buffer
CuadradoMap:
    mov x4, xzr
    mov w4, w0 // x4 = Y Position
    lsr x3, x0, 32 // x3 = X Position
    
    // Time to PAINT :D

    // So, the pixel address is: BUFFER[x][y] = BUFFER + 4 * (y * SCREEN_WIDTH + x)
    mov x5, SCREEN_WIDTH
    mul x5, x5, x4 // y * SCREEN_WIDTH
    add x5, x5, x3 // (y * SCREEN_WIDTH + x)
    lsl x5, x5, 2 // 4 * (y * SCREEN_WIDTH + x)
    add x5, x5, x2 // BUFFER + 4 * (y * SCREEN_WIDTH + x)
    stur w1, [x5] // Paint the pixel :D

    br lr

// x0=(X|Y), x1=(Center X | Center Y), x2=r, x3 = Color, x4 = FrameBuffer
CirculoMap:


    lsr x5, x1, 32 // x5 = X Center
    mov x6, xzr
    mov w6, w1 // x6 = Y Center

    mov x1, xzr
    mov w1, w0 // x1 = Y Position
    lsr x0, x0, 32 // x0 = X Position

    mul x2, x2, x2 // x2 = r^2

    // Se debe cumplir que: (x - Xc)^2 + (y - Yc)^2 <= r^2
    sub w7, w0, w5 // (x - Xc)
    smull x7, w7, w7 // (x - xC)^2

    sub w8, w1, w6 // (y - Yc)
    smull x8, w8, w8 // (y - Yc)^2

    add x9, x7, x8 // (x - Xc)^2 + (y - Yc)^2
    
    cmp x9, x2 // FLAGS == (x - Xc)^2 + (y - Yc)^2 <= r^2

    b.GT CM_1

    // So, the pixel address is: BUFFER[x][y] = BUFFER + 4 * (y * SCREEN_WIDTH + x)
    mov x5, SCREEN_WIDTH
    mul x5, x5, x1 // y * SCREEN_WIDTH
    add x5, x5, x0 // (y * SCREEN_WIDTH + x)
    lsl x5, x5, 2 // 4 * (y * SCREEN_WIDTH + x)
    add x5, x5, x4 // BUFFER + 4 * (y * SCREEN_WIDTH + x)
    stur w3, [x5] // Paint the pixel :D
CM_1:
    br lr

// x0=(X|Y), x1=(Width|Height), x2=Function(x0 = (X(I) | Y(I)), x1 = x3, x2 = x4, x3 = x5, x4 = x6, x5 = x7).  PRE: {0 <= X < SCREEN_WIDTH, 0 <= Y < SCREEN_HEIGH, Width > 0, Height > 0}
RectangleMapIterator:
    lsr x10, x0, 32 // x10 = X
    cmp x10, SCREEN_WIDTH
    b.GT SMI_Return // If X is greater than Screen Width, return
    mov x9, xzr
    add w9, w9, w0 // x9 = Y
    cmp x9, SCREEN_HEIGH 
    b.GT SMI_Return // If Y is greater than Screen Height, return
    lsr x8, x1, 32 
    add x11, x10, x8
    cmp x11, xzr
    b.LT SMI_Return // If X + Width < 0, return
    mov x8, xzr
    add w8, w8, w1
    add x11, x8, x9
    cmp x11, xzr
    b.LT SMI_Return // If Y + Height < 0, return
    
    // Store the Callee Saved Registers.
    adr x18, .
    add x18, x18, 12
    b Stack_Push_Callee

    // Move everything to Caller Saved Registers so that function call does not kill its values.
    mov x19, x10 // x19 = Initial X

    mov x20, x19
    lsl x20, x20, 32
	mov x15, xzr
	mov w15, w0
    add x20, x20, x15 // x20 = (X Counter | Y Counter) 
    
    lsr x15, x1, 32
    add x21, x19, x15 // X Counter Limit
    lsl x21, x21, 32
	mov x15, xzr
	add w15, w1, w20
    add x21, x21, x15 // (X Counter Limit | Y Counter Limit)

    // Setup Arguments for Function Call:
    mov x22, x2 // Function Address
    mov x23, x3 // Argument #2
    mov x24, x4 // Argument #3
    mov x25, x5 // Argument #4
    mov x26, x6 // Argument #5
    mov x27, x7 // Argument #6


SMI_X_Loop: // Loop over the X axis.

    lsr x0, x20, 32 // x0 = X
    mov x1, xzr
    mov w1, w20 // x1 = Y
    cmp x0, xzr
    b.LT SMI_After_Function // If X < 0, Ignore function call
    cmp x1, xzr
    b.LT SMI_After_Function // If Y < 0, Ignore function call
    cmp x0, SCREEN_WIDTH 
    b.GE SMI_After_Function // If X >= SCREEN_WIDTH, Ignore function call
    cmp x1, SCREEN_HEIGH
    b.GE SMI_After_Function // If Y >= SCREEN_HEIGHT, Ignore function call


    // Setup function arguments for function call.
    mov x0, x20 // Argument #1 (X Counter | Y Counter)
    mov x1, x23 // Argument #2
    mov x2, x24 // Argument #3
    mov x3, x25 // Argument #4
    mov x4, x26 // Argument #5
    mov x5, x27 // Argument #6
    
    blr x22 // Branch to Function!
SMI_After_Function:
    movz x9, 0x0001, lsl 32
    add x20, x20, x9 // Increase X Counter by 1

    lsr x9, x20, 32 // Temporal X Counter
    lsr x10, x21, 32 // Temporal X Counter Limit
    cmp x9, x10 // Compare X Counter against X Counter Limit.
    b.GE SMI_Y_Loop
    b SMI_X_Loop // Continue of next column (X).
SMI_Y_Loop: // Loop over the Y Axis
    add x20, x20, 1 // Increase Y Counter by 1
    cmp w20, w21 // Compare Y Counter against Y Counter Limit.
    b.GE SMI_End
	
	mov x9, xzr
	mov w9, w20
    lsl x20, x19, 32
	add x20, x20, x9 // Reset X Counter
    b SMI_X_Loop // Continue loop of next row (Y).

SMI_End:// End of the Loop

    // Restore the LR Register.
    adr x18, .
    add x18, x18, 12
    b Stack_Pop_Callee
    
    // Branch to Caller.
SMI_Return:
    br lr


/*
    ----------------------------------
        END DRAW FUNCTIONS
    ----------------------------------
*/





/*  
    ----------------------------------
        START UTILITY STACK FUNCTIONS
    ----------------------------------
*/

Stack_Push_Caller: // Push (Save) Registers X0-X15 to the Stack. Allowing a Subroutine / Function to be called.
	stp   x0, x1, [sp, #-16]!
	stp   x2, x3, [sp, #-16]!
	stp   x4, x5, [sp, #-16]!
	stp   x6, x7, [sp, #-16]!
	stp   x8, x9, [sp, #-16]!
	stp   x10, x11, [sp, #-16]!
	stp   x12, x13, [sp, #-16]!
	stp   x14, x15, [sp, #-16]!
	br x18 // Used as a Specific Register for Stack-Related Calls. Not ideal.

Stack_Pop_Caller: // Pop (Restore) Register X0-X15 from the Stack. Restoring the values before a Subroutine / Function was called.
	ldp   x14, x15, [sp, 0]
	ldp   x12, x13, [sp, #16]!
	ldp   x10, x11, [sp, #16]!
	ldp   x8, x9, [sp, #16]!
	ldp   x6, x7, [sp, #16]!
	ldp   x4, x5, [sp, #16]!
	ldp   x2, x3, [sp, #16]!
	ldp   x0, x1, [sp, #16]!
	add sp, sp, 16 
	br x18 // Used as a Specific Register for Stack-Related Calls. Not ideal.

Stack_Push_Callee: // Push (Save) Registers X19-X27 and LR Register to the Stack. Allowing the Subroutine / Function to use those Registers.
	stp   x19, x20, [sp, #-16]!
	stp   x21, x22, [sp, #-16]!
	stp   x23, x24, [sp, #-16]!
	stp   x25, x26, [sp, #-16]!
	stp   x27, lr, [sp, #-16]!
	br x18 // Used as a Specific Register for Stack-Related Calls. Not ideal.

Stack_Pop_Callee: // Pop (Restore) Registers X19-X27 and LR Register from the Stack. Allowing the Subroutine / Function to use those Registers.
	ldp   x27, lr, [sp, 0]
	ldp   x25, x26, [sp, #16]!
	ldp   x23, x24, [sp, #16]!
	ldp   x21, x22, [sp, #16]!
	ldp   x19, x20, [sp, #16]!
	add sp, sp, 16
	br x18 // Used as a Specific Register for Stack-Related Calls. Not ideal.

/*
    ----------------------------------
        END UTILITY STACK FUNCTIONS
    ----------------------------------
*/


    /*
    // Example of use of square root
    mov x0, 4
    ucvtf d0, x0
    fmov x0, d0
    mov x1, 50

    // x0=N argumento en punto flotante
    
    SquareRoot:
        fmov d0, x0
        fsqrt d0, d0
        fmov x8, d0
        br lr
    */


	







