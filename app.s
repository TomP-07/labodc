.equ SCREEN_WIDTH, 		640
.equ SCREEN_HEIGH, 		480
.equ BITS_PER_PIXEL,  	32

.globl main
main:
	// X0 contiene la direccion base del framebuffer
	mov x20, x0	// Save framebuffer base address to x20	

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

// --- This whole block is used exactly as it is for Stack Function Calls. Not pretty, but simple and useful enough. --- //
adr x18, . // Read Program Counter at this instruction
add x18, x18, 12 // Use x18 as a Special Register for Stack Calls. This makes sures that the Stack Call jumps back two lines after this one.
b Stack_Push_Caller




																									//	||
																													// Basically, this line.
mov x0, SCREEN_WIDTH
lsr x0, x0, 1
lsl x0, x0, 32
mov x1, SCREEN_HEIGH
lsr x1, x1, 1
add x0, x0, x1

// x0 = 320 | 240 = 0x140 | 0xF0

mov x1, 50 // x1 = 0x32
movz x2, 0xDD, lsl 16
movk x2, 0xDDDD, lsl 00 // x2 = 0x000...00DDDDDD 
mov x3, x20

bl DrawCircle

movz x0, 50, lsl 32
movk x0, 50, lsl 00

movz x1, 100

movz x2, 0x99, lsl 32
movk x2, 0x5555, lsl 00

// x2 = 0x000000995555
// Color = w2 = 0x00995555

mov x3, x20

bl DibujarCuadrado

// Definimos un color.
// Defino un altura. Digamos 100.

DibujarRectangulo

// Si el alto de la pantalla es de 480.

// La autopista va a estar a partir de los 340


adr x18, . // Read Program Counter at this instruction
add x18, x18, 12 // Use x18 as a Special Register for Stack Calls. This makes sures that the Stack Call jumps back two lines after this one.
b Stack_Pop_Caller

InfLoop: 
	b InfLoop



// Draw File //

// x0=(X|Y), x1 el ancho, x2 el color, x3 direccion del frame buffer
DibujarCuadrado:


    // 000...000 |    Ancho
    mov x4, x1
    lsl x1, x1, 32 // Ancho | 000...000
    add x1, x1, x4 // Ancho | Ancho


    mov x4, x3 // x4 = Frame buffer
    mov x3, x2 // x3 = Color
    adr x2, MapeadorCuadrado // Callback function of the iterator.
    
    adr x18, .
    add x18, x18, 12
    b Stack_Push_Callee

    bl SquareMapIterator
    
    adr x18, .
    add x18, x18, 12
    b Stack_Pop_Callee

    br lr

// x0=(X|Y), x1=r radio del circulo, x2 color del circulo, x3 direccion del frame buffer. 
DrawCircle: 
    
    mov x12, x0 // x12 = Center

	cmp x1, xzr
	b.LE DC_Exit // Checks that is r > 0

    // Setup SquareMapIterator Arguments
    
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
    adr x2, CircleMaper // Callback function of the iterator.

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
    bl SquareMapIterator

    // Restore the Return Address (and others)
    adr x18, .
    add x18, x18, 12
    b Stack_Pop_Callee

DC_Exit: // Branch to Caller.
    br lr


// x0=(X|Y), x1 el color, x2 direccion del frame buffer
MapeadorCuadrado:
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
CircleMaper:


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
SquareMapIterator:
    // Store the Callee Saved Registers.
    adr x18, .
    add x18, x18, 12
    b Stack_Push_Callee

    // Fix Width if it is out of bounds.
    lsr x10, x0, 32 // x10 = X
    lsr x11, x1, 32 // x11 = Width
    add x9, x10, x11
    cmp x9, SCREEN_WIDTH
    b.LS SMI_1
        mov x9, SCREEN_WIDTH
        sub x11, x9, x10 // New Width
SMI_1:
    // Fix Height if it is out of bounds.
    mov x9, xzr
    add w9, w0, w1
    cmp x9, SCREEN_HEIGH
    b.LS SMI_2
        mov x9, SCREEN_HEIGH
        sub w1, w9, w0 // New Height
SMI_2:
    // Move everything to Caller Saved Registers so that function call does not kill its values.
    mov x19, x10 // x19 = Initial X

    mov x20, x19
    lsl x20, x20, 32
	mov x15, xzr
	mov w15, w0
    add x20, x20, x15 // x20 = (X Counter | Y Counter) 
    
    add x21, x19, x11 // X Counter Limit
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

    // Setup function arguments for function call.
    mov x0, x20 // Argument #1 (X Counter | Y Counter)
    mov x1, x23 // Argument #2
    mov x2, x24 // Argument #3
    mov x3, x25 // Argument #4
    mov x4, x26 // Argument #5
    mov x5, x27 // Argument #6
    
    blr x22 // Branch to Function!

    movz x9, 0x0001, lsl 32
    add x20, x20, x9 // Increase X Counter by 1

    lsr x9, x20, 32 // Temporal X Counter
    lsr x10, x21, 32 // Temporal X Counter Limit
    cmp x9, x10 // Compare Y Counter against X Counter Limit.
    b.HS SMI_Y_Loop
    b SMI_X_Loop // Continue of next column (X).
SMI_Y_Loop: // Loop over the Y Axis
    add x20, x20, 1 // Increase Y Counter by 1
    cmp w20, w21 // Compare Y Counter against Y Counter Limit.
    b.HS SMI_End
	
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
    br lr

// UTILITIES //
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


	







