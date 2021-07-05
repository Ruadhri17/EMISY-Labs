DISPLAY_BUS equ P1 ; Label for all 7 segments of display
DECODE_CS equ P0.7 ; Label for Chip Select pin to enable decoding
DECODE_ADR equ P3  ; Specifically Pins: 3.3 and 3.4 for choosing which display will display
main:
	setb DISPLAY_BUS ; clear display
	
	jmp initialize             ; go to initialization process of timer 
	org 00BH                   ; interrupt address
	clr TF0                    ; clear overflow flag 

	clr DECODE_CS              ; turn off decoder to choose display
	mov DECODE_ADR, #00011000B ; use 3rd display
	xrl DISPLAY_BUS, #10000000B; xor display bus to make decimal point blinking 
	setb DECODE_CS             ; turn on decoder
	
	mov TH0, #11011000B        ;restore timer
 	mov TL0, #11101111B
	reti

initialize:
	setb TR0                   ; turn on T0 
	mov TMOD, #00000001B       ; set time to work in mode 1, gate = 0 
	setb ET0                   ; set overflow interrupt of timer T0
	setb EA                    ; enable global interrupt 
	
	mov TH0, #11011000B        ; load timer with value 65535 - 10000 
 	mov TL0, #11101111B        ; splitted into to registers TH0 and TL0
	jmp $                      ; infinite loop till interrupt
