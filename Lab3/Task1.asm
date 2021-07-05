; Save to RAM
	mov 30H, #'K'
	mov 31H, #'R'
	mov 32H, #'Z'
	mov 33H, #'Y'
	mov 34H, #'S'
	mov 35H, #'Z'
	mov 36H, #'T'
	mov 37H, #'O'
	mov 38H, #'F'
	mov 39H, #0

; creating labels for better management of LCD pins 
	LCD_BUS equ P1
	LCD_RS equ P3.1
	LCD_E equ P3.2
	SWITCH equ P2.7

; main routine to call other routines in one place
main:
	mov R0, #30
	call ms_delay ;waiting for 30 ms

	call initialization ;initialize display

display_off:

	jb SWITCH, $

display_on:
	mov R1, #30H
	call send_data ; display index number

	mov R0, #39 ; wait for more than 39 us 
	call us_delay

	jnb SWITCH, $
	call clear_display ; inifite loop - finish
	jmp display_off
; routine for whole proces of initiatlization
initialization:

	clr LCD_RS ;instruction are sent to the module 

; function set
	mov LCD_BUS, #00111000B ; set proper values for 1 line, default font

	call send_command ; negative edge on E to perform action
	
	mov A, #39 ; wait for 39 us according to algorithm
	call us_delay
	
; display on/off control 	
	mov LCD_BUS, #00001110B ; turn on display and cursor

	call send_command ; negative edge on E to perform action

	mov A, #39 ; wait for 39 microseconsd according to algorithm
	call us_delay

; omitting display clear phase as it is not needed according to manual

; entry mode set
	mov LCD_BUS, #00000110B ; mode set to inc. address by one and shift cursor to the right
	
	call send_command ; negative edge on E to perform action
	
	mov R0, #39 ; wait for more than 39 us 
	call us_delay
	
	ret
; routine for uppering and lowering LCD_E, making it to be on negatiev edge
send_command:
	setb LCD_E
	clr LCD_E
	
	ret
; routine for sending a letters to display	
send_data:	
	setb LCD_RS ; change mode to sending data
loop:
	mov A, @R1
	jz finish
	mov LCD_BUS, A
	
	call send_command ; negative edge on E to perform action
	
	mov R0, #39 ; wait for more than 39 us 
	call us_delay

	inc R1
	jmp loop
finish:
	ret
; routine for clearing display
clear_display:
	clr LCD_RS ;instruction are sent to the module 
	mov LCD_BUS, #00000001B
	
	call send_command
	mov R0, #2 ; wait approx. 2 ms for clearing display
	call ms_delay
	
	ret
; routine to create multiple delay of 1us
us_delay:  
	mov A, R0
	rr A ; divide delay by two as djnz instruction take 2 us to execute
	subb A, #5 ; correct delay as each instruction (despite djnz) takes time to execute
	mov R0, A
	djnz R0, $
	
	ret

; routine to create multiple delay of 1ms
ms_delay: 
	ms_one:	 
		mov R1, #10
	ms_two:
		mov R2, #48 ; as other instruction takes time to execute, 48 instead of 50 is used 
		nop ; and NOP instruction for some correction, overall 0.03% of error for ms_delay is applied
	djnz R2, $ 
	djnz R1, ms_two
	djnz R0, ms_one

	ret
