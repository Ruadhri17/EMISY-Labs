; Save to RAM
	mov 30H, #'3'
	mov 31H, #'0'
	mov 32H, #'0'
	mov 33H, #'1'
 	mov 34H, #'7'
	mov 35H, #'5'
	mov 36H, #0
	mov 37H, #'K'
	mov 38H, #'R'
	mov 39H, #'Z'
	mov 3AH, #'Y'
	mov 3BH, #'S'
	mov 3CH, #'Z'
	mov 3DH, #'T'
	mov 3EH, #'O'
	mov 3FH, #'F'
	mov 40H, #0

; creating labels for better management of LCD pins 
	LCD_BUS equ P1
	LCD_RS equ P3.1
	LCD_E equ P3.2

; main routine to call other routines in one place
main:
	
	mov R0, #30
	call ms_delay ;waiting for 30 ms

	call initialization ;initialize display
	
	mov R0, #39 ; wait for more than 39 us 
	call us_delay
	
	mov R0, #10000100B ; move cursor to 5th position
	call move_cursor
	
	mov R0, #39 ; wait for more than 39 us 
	call us_delay

	mov R1, #30H
	call send_data ; display index number

	mov R0, #39 ; wait for more than 39 us 
	call us_delay
	
	mov R0, #11000001B ; move cursor to 5th position
	call move_cursor

	mov R0, #39 ; wait for more than 39 us 
	call us_delay

	mov R1, #37H
	call send_data ; display index number
	

	mov R0, #39 ; wait for more than 39 us 
	call us_delay

	jmp $ ; inifite loop - finish

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
; routine for moving cursor to given position on display
move_cursor:
	clr LCD_RS
	mov LCD_BUS, R0
	
	call send_command ; negative edge on E to perform action
	
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