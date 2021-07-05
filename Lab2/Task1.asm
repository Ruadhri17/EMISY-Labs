DISPLAY_BUS equ P1   ; Label for all 7 segments of display
DECODE_CS equ P0.7   ; Label for Chip Select pin to enable decoding
DECODE_ADR equ P3    ; Specifically Pins: 3.3 and 3.4 for choosing which display will display
main:
	setb DISPLAY_BUS     ; clear display
	mov R0, #00001000B   ; fill segments in display #1
	mov R1, #10010000B   ; write '9' to the display
	call display         ; execute
	jmp $                ; infinite loop
display:
	clr DECODE_CS        ; turn off decoder to choose display
	mov DECODE_ADR, R0   ; user choice display 
	mov DISPLAY_BUS, R1  ; user choice pattern 
	setb DECODE_CS       ; turn on decoder
	ret                  ; return to main
