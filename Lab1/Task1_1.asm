;creating labels for better management of LCD pins 
	LCD_BUS equ P1
	LCD_RS equ P3.1
	LCD_E equ P3.2

;Main routine to call other routines in one place
main:
	
	mov R0, #30
	call ms_delay ;waiting for 30 ms, to rise voltage to certain level (which would take place in real microcontroler)

	call initialization ; initialize display
	
	mov R0, #39 ; wait for more than 39 us after ending of initialization
	call us_delay
	
	mov R0, #'K' ; saving letter "K" to register R0
	call send_data ; send letter to display

	mov R0, #39 ; wait for more than 39 us 
	call us_delay
	
	jmp $ ; inifite loop - finish

;Routine for whole proces of initiatlization
initialization:

	clr LCD_RS ; instruction are sent to the module 

; function set
	mov LCD_BUS, #00111000B ; set proper values for 2 lines as simulator cannot handle 1 line, default font
	
	call send_command  ; negative edge on E to save settings

	mov A, #39 ; wait for 39 us according to algorithm
	call us_delay
	
; display on/off control 	
	mov LCD_BUS, #00001110B ; turn on display and cursor

	call send_command  ; negative edge on E to save settings

	mov A, #39 ; wait for 39 microseconsd according to algorithm
	call us_delay

; omitting display clear phase as it is not needed according to display manual

; entry mode set
	mov LCD_BUS, #00000110B ; mode set to inc. address by one and shift cursor to the right
	
	call send_command  ; negative edge on E to save settings	
	
	ret
; routine for uppering and lowering LCD_E, making it to be on negatiev edge
send_command:
	setb LCD_E
	clr LCD_E
	
	ret
; routine for sending a letter to display	
send_data:	
	mov LCD_BUS, R0 ; sending letter "K" to data bus
	setb LCD_RS ; change mode to sending data

	call send_command ; negative edge on E to perform action

	ret 
; subroutine to create multiple delay of 1us, accurate to 1us 
us_delay: 
	mov A, R0
	rr A ; divide delay by two as djnz instruction take 2 us to execute
	subb A, #5 ; correct delay as each instruction (despite djnz) takes time to execute
	mov R0, A
	djnz R0, $
	
	ret
; subroutine to create multiple delay of 1ms, about 0.3% error of accuracy
ms_delay: 
	ms_one:	 
		mov R1, #10
	ms_two:
		mov R2, #48 ; as other instruction takes time to execute, 48 instead of 50 is used 
		nop 		; and NOP instruction for some correction
	djnz R2, $ 
	djnz R1, ms_two
	djnz R0, ms_one

	ret