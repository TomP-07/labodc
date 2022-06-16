.equ SCREEN_WIDTH, 		640
.equ SCREEN_HEIGH, 		480
.equ BITS_PER_PIXEL,  	32

.equ BUS_HEIGHT, 60
.equ BUS_WIDTH, 130
.equ BUS_Y_UPPER_LIMIT, 390 // Upper Limit of the Bus Y Position
.equ BUS_Y_DOWN_LIMIT, 456 // Lower Limit of The Bus Y Position

.equ SPEED_MULTIPLIER, 1 // Speed Multiplier, If it runs too slow increase this, but it will not be as good as with 1.


.globl main
main:

mov x27, x0	// Save framebuffer base address to x27	

bl Reset_Sub_F_Buffer // Reset Sub Frame Buffer to all 0

movz x21, SCREEN_HEIGH - 24, lsl 00 // x21 =  Bus Y Position
mov x26, 1 // x26 = Frame Counter

// Animation Main Loop
LoopAnimacion:
    

    // Push x0 - x15 to Stack
    adr x18, .
    add x18, x18, 12
    b Stack_Push_Caller


/*
    Prepare DibujarFondoPantalla Args
*/

    ldr x0, =SUB_F_BUFFER // x0 = Framebuffer
    movz x1, 0x99db, lsl 00
    movk x1, 0x0070, lsl 16 // x1 = Color
    mov x2, x26 // x2 = Frame Counter

    bl DibujarFondoPantalla

/*
    Prepare DibujarCarretera Args
*/

    ldr x0, =SUB_F_BUFFER

    bl DibujarCarretera

/*
    Draw Car Animations:
*/
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
    
    // IF Frame Number >= 120 && <= 400 
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
    
    // IF Frame Number >= 300 && <= 600 
    cmp x26, 300
    b.LO LA_END_CAR_3_SKIP_IF
    cmp x26, 600
    b.HI LA_END_CAR_3_SKIP_IF

    sub x3, x26, 300
    mov x4, 7
    mul x3, x4, x3
    sub x0, x0, x3
    bl DibujarAuto
LA_END_CAR_3_SKIP_IF:
    
    movz x0, 800
    movz x1, SCREEN_HEIGH - 107
    movz x2, 0x00A1, lsl 16
    movk x2, 0x3422
    
    // IF Frame Number >= 350 && <= 650 
    cmp x26, 350
    b.LO LA_END_CAR_4_SKIP_IF
    cmp x26, 650
    b.HI LA_END_CAR_4_SKIP_IF

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
    movz x2, 0x00B0, lsl 16
    movk x2, 0x00AA
    
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
    
    // IF Frame Number > 610 && < 910
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

    movz x0, 800
    movz x1, SCREEN_HEIGH - 107
    movz x2, 0x0066, lsl 16
    movk x2, 0x6666
    
    // IF Frame Number > 830 && < 1000
    cmp x26, 830
    b.LS LA_END_CAR_8_SKIP_IF
    cmp x26, 1000
    b.HS LA_END_CAR_8_SKIP_IF

    sub x3, x26, 830
    mov x4, 16
    mul x3, x4, x3
    sub x0, x0, x3
    bl DibujarAuto
LA_END_CAR_8_SKIP_IF:

    movz x0, 800
    movz x1, SCREEN_HEIGH - 107
    movz x2, 0x00AA, lsl 16
    movk x2, 0x22FF
    
    // IF Frame Number > 850 && < 1150
    cmp x26, 850
    b.LS LA_END_CAR_9_SKIP_IF
    cmp x26, 1150
    b.HS LA_END_CAR_9_SKIP_IF

    sub x3, x26, 850
    mov x4, 4
    mul x3, x4, x3
    sub x0, x0, x3
    bl DibujarAuto
LA_END_CAR_9_SKIP_IF:

    movz x0, 800
    movz x1, SCREEN_HEIGH - 107
    movz x2, 0x0022, lsl 16
    movk x2, 0x2222
    
    // IF Frame Number > 950 && < 1250
    cmp x26, 950
    b.LS LA_END_CAR_10_SKIP_IF
    cmp x26, 1250
    b.HS LA_END_CAR_10_SKIP_IF

    sub x3, x26, 950
    mov x4, 5
    mul x3, x4, x3
    sub x0, x0, x3
    bl DibujarAuto
LA_END_CAR_10_SKIP_IF:

    movz x0, 2000
    movz x1, SCREEN_HEIGH - 37
    movz x2, 0x00FF, lsl 16
    movk x2, 0x0033
    
    // IF Frame Number > 1100 && < 1600
    cmp x26, 1100
    b.LS LA_END_CAR_11_SKIP_IF
    cmp x26, 1600
    b.HS LA_END_CAR_11_SKIP_IF

    sub x3, x26, 1100
    mov x4, 9
    mul x3, x4, x3
    sub x0, x0, x3
    bl DibujarAuto
LA_END_CAR_11_SKIP_IF:

    movz x0, 2500
    movz x1, SCREEN_HEIGH - 37
    movz x2, 0x0000, lsl 16
    movk x2, 0xFFF2
    
    // IF Frame Number > 1200 && < 1600
    cmp x26, 1200
    b.LS LA_END_CAR_12_SKIP_IF
    cmp x26, 1600
    b.HS LA_END_CAR_12_SKIP_IF

    sub x3, x26, 1200
    mov x4, 12
    mul x3, x4, x3
    sub x0, x0, x3
    bl DibujarAuto
LA_END_CAR_12_SKIP_IF:

    // Pop x0-x15 from Stack
    adr x18, .
    add x18, x18, 12
    b Stack_Pop_Caller

/*
    Prepare DibujarColectivo Args
*/
    
    // This all calculates Bus X Position:

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

    // IF Frame Number > 670 && < 770
    cmp x26, 1150
    b.LS LA_END_BUS_5_SKIP_IF
    cmp x26, 1300
    b.HS LA_END_BUS_5_SKIP_IF
    sub x21, x21, SPEED_MULTIPLIER
    cmp x21, BUS_Y_UPPER_LIMIT
    b.HS LA_END_BUS_5_SKIP_IF
    mov x21, BUS_Y_UPPER_LIMIT
LA_END_BUS_5_SKIP_IF:

    mov x0, 70
    mov x1, x21
    ldr x2, =SUB_F_BUFFER


    // Push x0-x15 to Stack
    adr x18, .
    add x18, x18, 12
    b Stack_Push_Caller

    // Draw da bus
    bl DibujarColectivo

    // Pop x0-x15 from Stack
    adr x18, .
    add x18, x18, 12
    b Stack_Pop_Caller


    // Check if we are at Animation Reset time
    cmp x26, 1700
    b.LO LA_KILL_SKIP

    // Start Drawing Screen of Death ?
    mov x0, xzr
    movz x1, SCREEN_WIDTH, lsl 32
    sub x9, x26, 1700
    mov x8, 5
    mul x8, x8, x9
    add x1, x1, x8

    mov x2, xzr
    ldr x3, =SUB_F_BUFFER

    bl DibujarRectangulo

    cmp x26, 1950
    b.LO LA_KILL_SKIP

    // Reset Animation    
    mov x26, 1

LA_KILL_SKIP:

    // Flush Sub Frame Buffer, A.K.A, draw changes to Screen
    mov x8, x27
    bl Flush_Sub_F_Buffer

    // Multiply Frame Counter by the speed.
    add x26, x26, SPEED_MULTIPLIER

    // Loop the Animation!
    b LoopAnimacion

/*
    ----------------------------------
        DRAW FUNCTIONS
    ----------------------------------
*/

// Draws the Bus!
// X0 = X, x1=Y, x2 = FrameBuffer
DibujarColectivo:

    // Push the Callee Saved Registers. (Save LR)
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
    
    bl DibujarRectangulo // Dibuja el cuerpo principal

    mov x0, x20
    add x0, x0, 33
    lsl x0, x0, 32
    add x1, x21, 3
    add x0, x0, x1

    movz x1, 10 

    mov x2, xzr
    mov x3, x19

    bl DibujarCirculo // Dibuja la rueda de la izquierda

    mov x0, x20
    add x0, x0, BUS_WIDTH
    sub x0, x0, 33
    lsl x0, x0, 32
    add x1, x21, 3
    add x0, x0, x1

    movz x1, 10 

    mov x2, xzr
    mov x3, x19

    bl DibujarCirculo // Dibuja la rueda de la derecha

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

    bl DibujarRectangulo // Dibuja una puerta

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

    bl DibujarRectangulo // Dibuja la otra puerta


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

    bl DibujarRectangulo // Dibuja la ventana

    lsl x22, x20, 32
    add x22, x22, x21
    
    // Draws the o of odc
    
    mov x0, 40
    lsl x0, x0, 32
    add x0, x22, x0
    sub x0, x0, 21
    
    mov x1, 9

    movz x2, 0x0000, lsl 16
    movk x2, 0x0000
    
    ldr x3, =SUB_F_BUFFER

    bl DibujarCirculo // Dibuja la o de "odc", cool

    mov x0, 40
    lsl x0, x0, 32
    add x0, x22, x0
    sub x0, x0, 21
    
    mov x1, 4

    movz x2, 0x00F7, lsl 16
    movk x2, 0xFF00, lsl 00
    
    ldr x3, =SUB_F_BUFFER

    bl DibujarCirculo

    // Draws the d of odc

    mov x0, 60
    lsl x0, x0, 32
    add x0, x22, x0
    sub x0, x0, 20
    
    mov x1, 9

    movz x2, 0x0000, lsl 16
    movk x2, 0x0000
    
    ldr x3, =SUB_F_BUFFER

    bl DibujarCirculo // Dibuja la panza de la d de "odc"

    mov x0, 60
    lsl x0, x0, 32
    add x0, x22, x0
    sub x0, x0, 20 
    
    mov x1, 4

    movz x2, 0x00F7, lsl 16
    movk x2, 0xFF00, lsl 00
    
    ldr x3, =SUB_F_BUFFER

    bl DibujarCirculo

    mov x0, 64
    lsl x0, x0, 32
    add x0, x22, x0
    sub x0, x0, 42
    
    movz x1, 5, lsl 32
    movk x1, 27, lsl 00

    movz x2, 0x0000, lsl 16
    movk x2, 0x0000, lsl 00
    
    ldr x3, =SUB_F_BUFFER

    bl DibujarRectangulo // Dibuja el palito de la d de "odc"

    // Draws the c of odc

    mov x0, 80
    lsl x0, x0, 32
    add x0, x22, x0
    sub x0, x0, 22
    
    mov x1, 9

    movz x2, 0x0000, lsl 16
    movk x2, 0x0000
    
    ldr x3, =SUB_F_BUFFER

    bl DibujarCirculo

    mov x0, 85
    lsl x0, x0, 32
    add x0, x22, x0
    sub x0, x0, 22 
    
    mov x1, 6

    movz x2, 0x00F7, lsl 16
    movk x2, 0xFF00, lsl 00
    
    ldr x3, =SUB_F_BUFFER

    bl DibujarCirculo // Dibuja la c de "odc"

    // Pop the Callee Saved Registers. (Restore LR)
    adr x18, .                      
    add x18, x18, 12                
    b Stack_Pop_Callee              

    // Branch to caller
    br lr

// Draws a Car!
// x0 Posicion X, x1 Posicion Y, x2 Color
DibujarAuto:
    
    // Push the Callee Saved Registers. (Save LR)
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
    bl DibujarRectangulo // Dibuja el cuerpo principal

    mov x0, x19
    add x0, x0, 20
    lsl x0, x0, 32
    add x0, x0, x20
    sub x0, x0, 17

    movz x1, 50, lsl 32
    movk x1, 17

    mov x2, x21
    ldr x3, =SUB_F_BUFFER

    bl DibujarRectangulo // Dibuja la parte superior

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

    bl DibujarRectangulo // Dibuja la primera ventana

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

    bl DibujarRectangulo // Dibuja la segunda ventana

    mov x0, x19
    add x0, x0, 20
    lsl x0, x0, 32
    add x0, x0, x20
    add x0, x0, 21

    movz x1, 10

    mov x2, xzr
    ldr x3, =SUB_F_BUFFER

    bl DibujarCirculo // Dibuja la primera rueda!

    mov x0, x19
    add x0, x0, 70
    lsl x0, x0, 32
    add x0, x0, x20
    add x0, x0, 21

    movz x1, 10

    mov x2, xzr
    ldr x3, =SUB_F_BUFFER

    bl DibujarCirculo // Dibuja la segunda rueda!
    
    // Pop the Callee Saved Registers. (Restore LR)
    adr x18, . 
    add x18, x18, 12
    b Stack_Pop_Callee
    
    // Branch back to caller!
    br lr

// Draws Screen Background (Sun, Clouds and Sky)
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
    
    bl DibujarRectangulo // Dibuja el cielo

    mov x0, 100
    mov x1, 80
    ldr x2, =SUB_F_BUFFER
    bl DibujarSol // Dibuja el solsito

    mov x0, 700
    sub x0, x0, x19
    mov x1, 150
    mov x2, 0
    bl DibujarNube // Dibuja una nube tipo 0, desplazada en pantalla para que aparezca en el tiempo correcto.

    mov x0, 900
    sub x0, x0, x19
    mov x1, 50
    mov x2, 1
    bl DibujarNube // Dibuja una nube tipo 1, desplazada en pantalla para que aparezca en el tiempo correcto.

    mov x0, 1200
    sub x0, x0, x19
    mov x1, 120
    mov x2, 2 // Dibuja una nube tipo 2, desplazada en pantalla para que aparezca en el tiempo correcto.
    bl DibujarNube

    mov x0, 1500
    sub x0, x0, x19
    mov x1, 100
    mov x2, 0   
    bl DibujarNube // Dibuja una nube tipo 0, desplazada en pantalla para que aparezca en el tiempo correcto.

    mov x0, 1700
    sub x0, x0, x19
    mov x1, 180
    mov x2, 1
    bl DibujarNube // Dibuja una nube tipo 1, desplazada en pantalla para que aparezca en el tiempo correcto.

    mov x0, 2050
    sub x0, x0, x19
    mov x1, 100
    mov x2, 2
    bl DibujarNube // Dibuja una nube tipo 2, desplazada en pantalla para que aparezca en el tiempo correcto.


    adr x18, . 
    add x18, x18, 12
    b Stack_Pop_Callee

    br lr

// Draws a Cloud!
// x0= X Center, x1 = Y Center, x2 = Tipo (0,1,2)
DibujarNube:    
    adr x18, . 
    add x18, x18, 12
    b Stack_Push_Callee

    mov x19, x0 // x19 = X|Y Position
    lsl x19, x19, 32
    add x19, x19, x1
    
    mov x21, 30 // x21 = Radio

    movz x22, 0x00FF, lsl 16 // x22 = Color
    movk x22, 0xFFFF

/*
    En resumen, cada llamada a DibujarCirculo dibuja un circulo blanco, luego desplazando las posiciones del centro de estos circulos
    formamos figuras que parecen nubes, aun que no son mas que circulos superpuestos. Hay 3 nubes diferentes, de tipo 0, 1 y 2
*/

    // Tipo 0
    cmp x2, 0
    b.NE DB_Skip_0 // Si no es Tipo 0 salta a Tipo 1

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

DB_Skip_0: // Tipo 1
    cmp x2, 1 
    b.NE DB_Skip_1 // Si no es Tipo 1 salta a Tipo 2

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
    
DB_Skip_1: // Tipo 2
    mov x0, x19
    mov x1, x21
    mov x2, x22
    ldr x3, =SUB_F_BUFFER
    bl DibujarCirculo

    movz x4, 30 
    lsl x4, x4, 32
    add x0, x19, x4
    sub x0, x0, 20
    mov x1, x21
    mov x2, x22
    ldr x3, =SUB_F_BUFFER
    bl DibujarCirculo 

    movz x4, 55
    lsl x4, x4, 32
    add x0, x19, x4
    sub x0, x0, 28
    mov x1, x21
    mov x2, x22
    ldr x3, =SUB_F_BUFFER
    bl DibujarCirculo

    movz x4, 85
    lsl x4, x4, 32
    add x0, x19, x4
    sub x0, x0, 18
    mov x1, x21
    mov x2, x22
    ldr x3, =SUB_F_BUFFER
    bl DibujarCirculo

    movz x4, 105
    lsl x4, x4, 32
    add x0, x19, x4
    sub x0, x0, 0
    mov x1, x21
    mov x2, x22
    ldr x3, =SUB_F_BUFFER
    bl DibujarCirculo

    movz x4, 125
    lsl x4, x4, 32
    add x0, x19, x4
    add x0, x0, 10
    mov x1, x21
    mov x2, x22
    ldr x3, =SUB_F_BUFFER
    bl DibujarCirculo

    movz x4, 105
    lsl x4, x4, 32
    add x0, x19, x4
    add x0, x0, 20
    mov x1, x21
    mov x2, x22
    ldr x3, =SUB_F_BUFFER
    bl DibujarCirculo

    movz x4, 65
    lsl x4, x4, 32
    add x0, x19, x4
    add x0, x0, 20
    mov x1, x21
    mov x2, x22
    ldr x3, =SUB_F_BUFFER
    bl DibujarCirculo

    movz x4, 20
    lsl x4, x4, 32
    add x0, x19, x4
    add x0, x0, 20
    mov x1, x21
    mov x2, x22
    ldr x3, =SUB_F_BUFFER
    bl DibujarCirculo

     movz x4, 65
    lsl x4, x4, 32
    add x0, x19, x4
    add x0, x0, 35
    mov x1, x21
    mov x2, x22
    ldr x3, =SUB_F_BUFFER
    bl DibujarCirculo

    adr x18, . 
    add x18, x18, 12
    b Stack_Pop_Callee

    br lr

// Draws a Sun! (It has a nice gradient effect at the borders :D)
// X0 = X, x1 = Y, x2 = FrameBuffer
DibujarSol:

    adr x18, .              
    add x18, x18, 12                
    b Stack_Push_Callee  

    mov x19, x0 // x19 X Position
    mov x20, x1 // x20 Y Position
    mov x21, x2 // x21 Frame Buffer

/*
    Los 3 dibujos del sol son para lograr un efecto de degrades en los bordes. :)
*/

    lsl x0, x0, 32
    add x0, x0, x1

    movz x1, 45

    mov x3, x2
    movz x2, 0x00D7, lsl 16
    movk x2, 0xDE00

    bl DibujarCirculo // Dibuja el sol con un color oscuro

    lsl x0, x19, 32
    add x0, x0, x20

    movz x1, 43
    
    movz x2, 0x00E8, lsl 16
    movk x2, 0xF002
    mov x3, x21

    bl DibujarCirculo // Redibuja la mayoria del sol con un color intermedio

    lsl x0, x19, 32
    add x0, x0, x20

    movz x1, 40
    
    movz x2, 0x00F7, lsl 16
    movk x2, 0xFF00
    mov x3, x21

    bl DibujarCirculo // Redibuja la mayoria del sol con un color mas claro

    adr x18, .              
    add x18, x18, 12                
    b Stack_Pop_Callee  

    br lr

// Draws the Road, kind of simple
// x0 = Direccion Frame Buffer
DibujarCarretera:
    adr x18, .                      
    add x18, x18, 12                
    b Stack_Push_Callee             

    mov x19, x0                     //x19 = FrameBuffer
    mov x3, x0
    mov x0, SCREEN_HEIGH            
    sub x0, x0, 120                 
    mov x20, x0                     

    movz x1, SCREEN_WIDTH, lsl 32   
    movk x1, 120                    
    mov x21, x1                     

    movz x2, 0x0055, lsl 16         
    movk x2, 0x5555, lsl 00         

    bl DibujarRectangulo // Dibuja el asfalto
    
    mov x3, x19
    mov x0, x20
    add x0, x0, 50 
    mov x1, x21
    movk x1, 1
    mov x2, x22
    movk x2, 0xFB00, lsl 00
    movk x2, 0x00FF, lsl 16
    bl DibujarRectangulo // Dibuja una de las lineas de la carretera

    mov x3, x19
    mov x0, x20
    add x0, x0, 58
    mov x1, x21
    movk x1, 1
    mov x2, x22
    movk x2, 0xFB00, lsl 00
    movk x2, 0x00FF, lsl 16
    bl DibujarRectangulo // Dibuja la otra linea de la carretera

    adr x18, .                      
    add x18, x18, 12                 
    b Stack_Pop_Callee              

    br lr                         
    
// Draws a Rectangle!
// x0=(X|Y), x1=(Ancho|Alto), x2 el color, x3 direccion del frame buffer
DibujarRectangulo:

    mov x4, x3 // x4 = Frame buffer
    mov x3, x2 // x3 = Color
    adr x2, TheCrazyPixelPainter // Callback function of the iterator.
    
    adr x18, .
    add x18, x18, 12
    b Stack_Push_Callee

    // This is awesome btw
    // Basicamente hace todo el trabajo, la funcion DibujarRectangulo es meramente auxiliar
    bl RectangleMapIterator
    
    adr x18, .
    add x18, x18, 12
    b Stack_Pop_Callee

    br lr

// Draws a Circle!
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

    // This is awesome btw (x2)
    bl RectangleMapIterator

    // Restore the Return Address (and others)
    adr x18, .
    add x18, x18, 12
    b Stack_Pop_Callee

DC_Exit: // Branch to Caller.
    br lr

// Just a Pixel Painter with a Fancy Name
// Basicamente pinta cada pixel que se le pasa con el color que se le pasa, super easy.
// x0=(X|Y), x1 el color, x2 direccion del frame buffer
TheCrazyPixelPainter:
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

// Paints a pixel based on where it is inside a circle of radius R. Awesome
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

/*  
    This function is awesome,
    For every pixel inside a box starting from X|Y Position, with a width and height set the function
    stored at x2 will be called and arguments in register x3 to x7 will be passed to that function
    
    Isn't it cool ? :D
    Like, one function, draw almost everything ;)
*/
// x0=(X|Y), x1=(Width|Height), x2=Function(x0 = (X(I) | Y(I)), x1 = x3, x2 = x4, x3 = x5, x4 = x6, x5 = x7).  PRE: {0 <= X < SCREEN_WIDTH, 0 <= Y < SCREEN_HEIGH, Width > 0, Height > 0}
RectangleMapIterator:
    lsr x10, x0, 32 // x10 = X
    cmp w10, SCREEN_WIDTH
    b.GT SMI_Return // If X is greater than Screen Width, return
    mov x9, xzr
    add w9, w9, w0 // x9 = Y
    cmp w9, SCREEN_HEIGH 
    b.GT SMI_Return // If Y is greater than Screen Height, return
    lsr x8, x1, 32 
    add w11, w10, w8
    cmp w11, 0
    b.LT SMI_Return // If X + Width < 0, return
    mov x8, xzr
    add w8, w8, w1
    add w11, w8, w9
    cmp w11, 0
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
    cmp w0, 0
    b.LT SMI_After_Function // If X < 0, Ignore function call
    cmp w1, 0
    b.LT SMI_After_Function // If Y < 0, Ignore function call
    cmp w0, SCREEN_WIDTH 
    b.GE SMI_After_Function // If X >= SCREEN_WIDTH, Ignore function call
    cmp w1, SCREEN_HEIGH
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
    cmp w9, w10 // Compare X Counter against X Counter Limit.
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

// Flush Sub FrameBuffer, basically apply changes to the Screen.
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

    ldp w11, w12, [x4]

    add x4, x3, x8
    stp w11, w12, [x4] 
    add x1, x1, 1

    cmp x1, x0
    b.HS FSFB_END
    b FSFB_LOOP
FSFB_END:
    br lr

// Reset Sub FrameBuffer, basically set everything to ZERO (A.K.A black)
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

// Push (Save) Registers X0-X15 to the Stack. Allowing a Subroutine / Function to be called.
Stack_Push_Caller: 
	stp   x0, x1, [sp, #-16]!
	stp   x2, x3, [sp, #-16]!
	stp   x4, x5, [sp, #-16]!
	stp   x6, x7, [sp, #-16]!
	stp   x8, x9, [sp, #-16]!
	stp   x10, x11, [sp, #-16]!
	stp   x12, x13, [sp, #-16]!
	stp   x14, x15, [sp, #-16]!
	br x18 // Used as a Specific Register for Stack-Related Calls. Not ideal.

// Pop (Restore) Register X0-X15 from the Stack. Restoring the values before a Subroutine / Function was called.
Stack_Pop_Caller: 
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

// Push (Save) Registers X19-X27 and LR Register to the Stack. Allowing the Subroutine / Function to use those Registers.
Stack_Push_Callee: 
	stp   x19, x20, [sp, #-16]!
	stp   x21, x22, [sp, #-16]!
	stp   x23, x24, [sp, #-16]!
	stp   x25, x26, [sp, #-16]!
	stp   x27, lr, [sp, #-16]!
	br x18 // Used as a Specific Register for Stack-Related Calls. Not ideal.

// Pop (Restore) Registers X19-X27 and LR Register from the Stack. Allowing the Subroutine / Function to use those Registers.
Stack_Pop_Callee: 
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

// Our awesome Sub Frame Buffer!
.data
SUB_F_BUFFER: .skip 0x12C000 // 640 * 480 * 4
