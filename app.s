.equ SCREEN_WIDTH, 		640
.equ SCREEN_HEIGH, 		480
.equ BITS_PER_PIXEL,  	32

.equ BUS_HEIGHT, 60
.equ BUS_WIDTH, 130
.equ BUS_Y_UPPER_LIMIT, 390
.equ BUS_Y_DOWN_LIMIT, 456

.equ SPEED_MULTIPLIER, 1


.globl main
main:


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

// X0 contiene la direccion base del framebuffer
mov x27, x0	// Save framebuffer base address to x27	
bl Reset_Sub_F_Buffer
    
/*
ldr x0, =SUB_F_BUFFER
movz x1, 0x99db, lsl 00
mov x1, 80
ldr x2, =SUB_F_BUFFER
bl DibujarSol

ldr x0, =SUB_F_BUFFER
bl DibujarCarretera

mov x8, x27
bl Flush_Sub_F_Buffer
*/


/*movz x0, 100, lsl 32
movk x0, 100

movz x1, 100, lsl 32
movk x1, 200

movz x2, 0x00FF, lsl 32
movk x2, 0xFFFF 

mov x3, x20

bl DibujarEdificio*/




movz x19, 0x0000, lsl 00
//mov x20, LOOP_BURN_MULTIPLIER
mov x20, 1
mul x19, x19, x20
mov x20, xzr


// X1 Bus Start Y Position
movz x21, SCREEN_HEIGH - 24, lsl 00 // Bus Y Position

mov x26, 1 // x26 = Frame Counter


loopAnimacion:
    

    adr x18, .
    add x18, x18, 12
    b Stack_Push_Caller


    ldr x0, =SUB_F_BUFFER // Framebuffer
    movz x1, 0x99db, lsl 00 // Color
    movk x1, 0x0070, lsl 16 // Color
    mov x2, x26 // Pass Frame Number

    bl DibujarFondoPantalla

    ldr x0, =SUB_F_BUFFER
    bl DibujarCarretera


    movz x0, 800
    movz x1, SCREEN_HEIGH - 37
    movz x2, 0x00FF, lsl 16
    movk x2, 0x0000

    // IF Frame Number < 400
    cmp x26, 400
    b.HI LA_END_CAR_1_SKIP_IF
    mov x3, 4       
    mul x3, x26, x3
    sub x0, x0, x3

    bl DibujarAuto
LA_END_CAR_1_SKIP_IF:

    movz x0, 800
    movz x1, SCREEN_HEIGH - 37
    movz x2, 0x00FF, lsl 16
    movk x2, 0x0000
    
    // IF Frame Number > 120 && < 400 
    cmp x26, 120
    b.LO LA_END_CAR_2_SKIP_IF
    cmp x26, 400
    b.HI LA_END_CAR_2_SKIP_IF

    sub x3, x26, 120
    mov x4, 4
    mul x3, x4, x3
    sub x0, x0, x3
    bl DibujarAuto
LA_END_CAR_2_SKIP_IF:
    movz x0, 800
    movz x1, SCREEN_HEIGH - 107
    movz x2, 0x0000, lsl 16
    movk x2, 0xFF00
    
    // IF Frame Number > 300 && < 600 
    cmp x26, 300
    b.LS LA_END_CAR_3_SKIP_IF
    cmp x26, 600
    b.HS LA_END_CAR_3_SKIP_IF

    sub x3, x26, 300
    mov x4, 7
    mul x3, x4, x3
    sub x0, x0, x3
    bl DibujarAuto
LA_END_CAR_3_SKIP_IF:
    
    movz x0, 800
    movz x1, SCREEN_HEIGH - 107
    movz x2, 0x0000, lsl 16
    movk x2, 0xFF00
    
    // IF Frame Number > 350 && < 650 
    cmp x26, 350
    b.LS LA_END_CAR_4_SKIP_IF
    cmp x26, 650
    b.HS LA_END_CAR_4_SKIP_IF

    sub x3, x26, 350
    mov x4, 5
    mul x3, x4, x3
    sub x0, x0, x3
    bl DibujarAuto
LA_END_CAR_4_SKIP_IF:

    movz x0, 800
    movz x1, SCREEN_HEIGH - 37
    movz x2, 0x0000, lsl 16
    movk x2, 0x00FF
    
    // IF Frame Number > 550 && < 650 
    cmp x26, 550
    b.LS LA_END_CAR_5_SKIP_IF
    cmp x26, 650
    b.HS LA_END_CAR_5_SKIP_IF

    sub x3, x26, 550
    mov x4, 12
    mul x3, x4, x3
    sub x0, x0, x3
    bl DibujarAuto
LA_END_CAR_5_SKIP_IF:

        movz x0, 800
    movz x1, SCREEN_HEIGH - 37
    movz x2, 0x0000, lsl 16
    movk x2, 0x00FF
    
    // IF Frame Number > 600 && < 700 
    cmp x26, 600
    b.LS LA_END_CAR_6_SKIP_IF
    cmp x26, 700
    b.HS LA_END_CAR_6_SKIP_IF

    sub x3, x26, 600
    mov x4, 16
    mul x3, x4, x3
    sub x0, x0, x3
    bl DibujarAuto
LA_END_CAR_6_SKIP_IF:

    movz x0, 800
    movz x1, SCREEN_HEIGH - 107
    movz x2, 0x00AA, lsl 16
    movk x2, 0xAAAA
    
    // IF Frame Number > 610 && < 900
    cmp x26, 610
    b.LS LA_END_CAR_7_SKIP_IF
    cmp x26, 910
    b.HS LA_END_CAR_7_SKIP_IF

    sub x3, x26, 610
    mov x4, 4
    mul x3, x4, x3
    sub x0, x0, x3
    bl DibujarAuto
LA_END_CAR_7_SKIP_IF:

    adr x18, .
    add x18, x18, 12
    b Stack_Pop_Caller




    // Prepare DibujarColectivo Args,
    
    // IF Frame Number > 80 && < 200
    cmp x26, 80
    b.LS LA_END_BUS_1_SKIP_IF
    cmp x26, 200
    b.HS LA_END_BUS_1_SKIP_IF
    sub x21, x21, SPEED_MULTIPLIER
    cmp x21, BUS_Y_UPPER_LIMIT
    b.HS LA_END_BUS_1_SKIP_IF
    mov x21, BUS_Y_UPPER_LIMIT
LA_END_BUS_1_SKIP_IF:

    // IF Frame Number > 300 && < 400
    cmp x26, 300
    b.LS LA_END_BUS_2_SKIP_IF
    cmp x26, 400
    b.HS LA_END_BUS_2_SKIP_IF
    add x21, x21, SPEED_MULTIPLIER
    cmp x21, BUS_Y_DOWN_LIMIT
    b.LO LA_END_BUS_2_SKIP_IF
    mov x21, BUS_Y_DOWN_LIMIT
LA_END_BUS_2_SKIP_IF:



// IF Frame Number > 545 && < 650
    cmp x26, 545
    b.LS LA_END_BUS_3_SKIP_IF
    cmp x26, 650
    b.HS LA_END_BUS_3_SKIP_IF
    sub x21, x21, SPEED_MULTIPLIER
    cmp x21, BUS_Y_UPPER_LIMIT
    b.HS LA_END_BUS_3_SKIP_IF
    mov x21, BUS_Y_UPPER_LIMIT
LA_END_BUS_3_SKIP_IF:

    // IF Frame Number > 670 && < 770
    cmp x26, 670
    b.LS LA_END_BUS_4_SKIP_IF
    cmp x26, 770
    b.HS LA_END_BUS_4_SKIP_IF
    add x21, x21, SPEED_MULTIPLIER
    cmp x21, BUS_Y_DOWN_LIMIT
    b.LO LA_END_BUS_4_SKIP_IF
    mov x21, BUS_Y_DOWN_LIMIT
LA_END_BUS_4_SKIP_IF:



    mov x0, 70
    mov x1, x21
    ldr x2, =SUB_F_BUFFER

    adr x18, .
    add x18, x18, 12
    b Stack_Push_Caller

    bl DibujarColectivo

    adr x18, .
    add x18, x18, 12
    b Stack_Pop_Caller




    mov x8, x27
    bl Flush_Sub_F_Buffer
    
    mov x20, xzr // Reset burn time counter
    mov x9, SPEED_MULTIPLIER
    add x26, x26, x9
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
/*DibujarEdificio:

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

*/


// X0 = X, x1=Y, x2 = FrameBuffer
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

// x0 Posicion X, x1 Posicion Y, x2 Color
DibujarAuto:
    adr x18, . 
    add x18, x18, 12
    b Stack_Push_Callee

    mov x19, x0
    mov x20, x1
    mov x21, x2

    mov x0, x19
    lsl x0, x0, 32
    add x0, x0, x20
    
    movz x1, 90, lsl 32
    movk x1, 22
    
    mov x2, x21
    ldr x3, =SUB_F_BUFFER
    bl DibujarRectangulo

    mov x0, x19
    add x0, x0, 20
    lsl x0, x0, 32
    add x0, x0, x20
    sub x0, x0, 17

    movz x1, 50, lsl 32
    movk x1, 17

    mov x2, x21
    ldr x3, =SUB_F_BUFFER

    bl DibujarRectangulo

    mov x0, x19
    add x0, x0, 25
    lsl x0, x0, 32
    add x0, x0, x20
    sub x0, x0, 13

    movz x1, 17, lsl 32
    movk x1, 12

    movz x2, 0x00FF, lsl 16
    movk x2, 0xFFFF

    ldr x3, =SUB_F_BUFFER

    bl DibujarRectangulo

    mov x0, x19
    add x0, x0, 48
    lsl x0, x0, 32
    add x0, x0, x20
    sub x0, x0, 13

    movz x1, 17, lsl 32
    movk x1, 12

    movz x2, 0x00FF, lsl 16
    movk x2, 0xFFFF

    ldr x3, =SUB_F_BUFFER

    bl DibujarRectangulo

    mov x0, x19
    add x0, x0, 20
    lsl x0, x0, 32
    add x0, x0, x20
    add x0, x0, 21

    movz x1, 10 // r = 10

    mov x2, xzr
    ldr x3, =SUB_F_BUFFER

    bl DibujarCirculo

    mov x0, x19
    add x0, x0, 70
    lsl x0, x0, 32
    add x0, x0, x20
    add x0, x0, 21

    movz x1, 10 // r = 10

    mov x2, xzr
    ldr x3, =SUB_F_BUFFER

    bl DibujarCirculo






    adr x18, . 
    add x18, x18, 12
    b Stack_Pop_Callee
    
    br lr

// x0 = Direccion Frame Buffer, x1 Color, x2 Frame Number
DibujarFondoPantalla:
    mov x3, x0
    mov x19, x2 // x19 = Frame Number
    mov x2, x1
    mov x0, xzr
    movz x1, SCREEN_WIDTH, lsl 32
    movk x1, SCREEN_HEIGH, lsl 00
    
    adr x18, . 
    add x18, x18, 12
    b Stack_Push_Callee
    
    bl DibujarRectangulo

    mov x0, 100
    mov x1, 80
    ldr x2, =SUB_F_BUFFER
    bl DibujarSol

    mov x0, 700
    mov x1, 150

    // If Frame Number is < 1600
    cmp x19, 1600
    b.HI DFP_Cloud_IF_1
    mov x8, 1
    mul x9, x8, x19
    sub x0, x0, x9
DFP_Cloud_IF_1:
    bl DibujarNube

    adr x18, . 
    add x18, x18, 12
    b Stack_Pop_Callee

    br lr


// x0= X Center, x1 = Y Center
DibujarNube:    
    adr x18, . 
    add x18, x18, 12
    b Stack_Push_Callee

// x0=(X|Y), x1=r radio del circulo, x2 color del circulo, x3 direccion del frame buffer. 

    mov x19, x0 // x19 = X|Y Position
    lsl x19, x19, 32
    add x19, x19, x1
    
    mov x21, 30 // x21 = Radio

    movz x22, 0x00FF, lsl 16 // x22 = Color
    movk x22, 0xFFFF

    mov x0, x19
    mov x1, x21
    mov x2, x22
    ldr x3, =SUB_F_BUFFER
    bl DibujarCirculo


    movz x4, 20
    lsl x4, x4, 32
    add x0, x19, x4
    sub x0, x0, 20
    mov x1, x21
    mov x2, x22
    ldr x3, =SUB_F_BUFFER
    bl DibujarCirculo 

    movz x4, 45
    lsl x4, x4, 32
    add x0, x19, x4
    sub x0, x0, 25
    mov x1, x21
    mov x2, x22
    ldr x3, =SUB_F_BUFFER
    bl DibujarCirculo 
    
    movz x4, 70
    lsl x4, x4, 32
    add x0, x19, x4
    sub x0, x0, 15
    mov x1, x21
    mov x2, x22
    ldr x3, =SUB_F_BUFFER
    bl DibujarCirculo 

    movz x4, 20
    lsl x4, x4, 32
    add x0, x19, x4
    add x0, x0, 10
    mov x1, x21
    mov x2, x22
    ldr x3, =SUB_F_BUFFER
    bl DibujarCirculo 

    movz x4, 50
    lsl x4, x4, 32
    add x0, x19, x4
    add x0, x0, 3
    mov x1, x21
    mov x2, x22
    ldr x3, =SUB_F_BUFFER
    bl DibujarCirculo 

    adr x18, . 
    add x18, x18, 12
    b Stack_Pop_Callee

    br lr

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
        START UTILITY FUNCTIONS
    ----------------------------------
*/
// x8 = Framebuffer
Flush_Sub_F_Buffer:
    movz x0, 0xC000, lsl 00
    movk x0, 0x0012, lsl 16
    lsr x0, x0, 2 // X0 Limit
    mov x1, xzr // x1 Counter

    mov x5, xzr

    mov x6, xzr
    ldr x6, =SUB_F_BUFFER
FSFB_LOOP:
    mov x3, x1
    lsl x3, x3, 2
    add x4, x3, x6
    
    //ldur w5, [x4] // Load to w5 Sub FrameBuffer Data
    ldp w11, w12, [x4]

    add x4, x3, x8
    //stur w5, [x4] // Store w5 Data to FrameBuffer
    stp w11, w12, [x4]
    add x1, x1, 1

    cmp x1, x0
    b.HS FSFB_END
    b FSFB_LOOP
FSFB_END:
    br lr

Reset_Sub_F_Buffer:
    mov x9, xzr
    ldr x9, =SUB_F_BUFFER

    movz x0, 0xC000, lsl 00
    movk x0, 0x0012, lsl 16
    lsr x0, x0, 2 // X0 Limit
    mov x1, xzr // x1 Counter
    movz x2, 0xAAAA, lsl 00 // x2 Color

RSFB_LOOP:
    mov x3, x1
    lsl x3, x3, 2
    add x3, x3, x9
    stur w2, [x3]
    add x1, x1, 1

    cmp x1, x0
    b.HS RSFB_END
    b RSFB_LOOP
RSFB_END:
    br lr



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
.data
SUB_F_BUFFER: .skip 0x12C000 // 640 * 480 * 4




