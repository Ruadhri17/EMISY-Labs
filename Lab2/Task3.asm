DISPLAY_BUS equ P1 ; Label for all 7 segments of display
DECODE_CS equ P0.7 ; Label for Chip Select pin to enable decoding
DECODE_ADR equ P3 ; Specifically Pins: 3.3 and 3.4 for choosing which display will display

main:
	setb DISPLAY_BUS   ; clear display
	mov R2, #00000001B ; set value of R2 for Display 0
	jmp initialize     ; go to initialize process of timer 
	
	org 0BH  ; interrupt address 
	clr TF0  ; clear overflow flag
	
	mov ACC, R2        ; load R2 to ACC in order to know on which display we operate
	jb ACC.0, DISPLAY0 ; go to display 0 
	jb ACC.1, DISPLAY1 ; go to display 0
	jb ACC.2, DISPLAY2 ; go to display 0
	jb ACC.3, DISPLAY3 ; go to display 0
	reti

display0:
	mov R0, #00000000B ; set to fill segments in display  0
	mov R1, #10010010B ; turn on segments that are responsible for '5'
	mov R2, #00000010B ; set value of R2 to move to Display 1 label
	call display

	mov TH0, #11011000B ; load timer with value 65535 - 10000 
	mov TL0, #11101111B ; splitted into to registers TH0 and TL0
	reti


display1:
	mov R0, #00001000B ; set to fill segments in display  1
	mov R1, #11111000B ; turn on segments that are responsible for '7'
	mov R2, #00000100B ; set value of R2 to move to Display 2 label
	call display

	mov TH0, #11011000B ; load timer with value 65535 - 10000 
	mov TL0, #11101111B ; splitted into to registers TH0 and TL0
	reti

display2:
	mov R0, #00010000B ; set to fill segments in display  2
	mov R1, #11111001B ; turn on segments that are responsible for '1'
	mov R2, #00001000B ; set value of R2 to move to Display 3 label
	call display

	mov TH0, #11011000B ; load timer with value 65535 - 10000 
	mov TL0, #11101111B ; splitted into to registers TH0 and TL0
	reti


display3:
	mov R0, #00011000B ; set to fill segments in display  3
	mov R1, #11000000B ; turn on segments that are responsible for '0'
	mov R2, #00000001B ; set value of R2 to move to Display 0 label
	call display

	mov TH0, #11011000B ; load timer with value 65535 - 10000 
	mov TL0, #11101111B ; splitted into to registers TH0 and TL0
	reti

initialize:
	setb TR0             ; turn on T0 
	mov TMOD, #00000001B ; set time to work in mode 1, gate = 0 
	setb ET0             ; set overflow interrupt
	setb EA              ; enable global interrupt 
	
	mov TH0, #11011000B ; load timer with value 65535 - 10000 
 	mov TL0, #11101111B ; splitted into to registers TH0 and TL0

	jmp $ ; infinite loop

display:
	clr DECODE_CS       ; turn off decoder to choose display
	mov DECODE_ADR, R0  ; user choice display 
	mov DISPLAY_BUS, R1 ; user choice pattern 
	setb DECODE_CS      ; turn on decoder
	
	ret                 ; return to main
