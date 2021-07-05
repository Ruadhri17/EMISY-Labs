;creating labels for better management of LCD pins 
	LCD_BUS equ P1
	LCD_RS equ P3.1
	LCD_E equ P3.2

;Main routine to call other routines in one place
main:
	
	mov R0, #30
	call ms_delay ;waiting for 30 ms

	call initialization ;initialize display
	
	mov R0, #39 ; wait for more than 39 us 
	call us_delay
	
	mov R0, #'K' ; saving letter to register R1 
	call send_data ; display letter 

	mov R0, #39 ; wait for more than 39 us 
	call us_delay
	
	jmp $ ; inifite loop - finish
;Routine for whole proces of initiatlization
initialization:

	clr LCD_RS ;instruction are sent to the module 

; function set
	mov LCD_BUS, #00100000B ; set to 4-bit operiation 
	call send_command
    
    mov A, #39 ; as it is 4-bit mode, set high nibble to be sent twice
	call us_delay

	call send_command ; negative edge on E

    mov A, #39 ; as it is 4-bit mode, set high nibble to be sent twice
	call us_delay

    mov LCD_BUS, #10000000B ; set to 4-bit operiation 
	call send_command ; negative edge on E

    mov A, #39 ; as it is 4-bit mode, set high nibble to be sent twice
	call us_delay
; display on/off control 	
	mov LCD_BUS, #00000000B ; turn on display and cursor
	call send_command ; negative edge on E

    mov A, #39 ; wait for 39 microseconsd according to algorithm
	call us_delay

    mov LCD_BUS, #11100000B ; turn on display and cursor
	call send_command ; negative edge on E

	mov A, #39 ; wait for 39 microseconsd according to algorithm
	call us_delay

; omitting display clear phase as it is not needed according to manual

; entry mode set
	mov LCD_BUS, #00000000B ; turn on display and cursor
	call send_command ; negative edge on E

    mov A, #39 ; wait for 39 microseconsd according to algorithm
	call us_delay

    mov LCD_BUS, #01100000B ; turn on display and cursor
	call send_command ; negative edge on E

	mov A, #39 ; wait for 39 microseconsd according to algorithm
	call us_delay

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
	
	call send_command ; negative edge on E
	
    mov A, R0
    rl A
    rl A
    rl A
    rl A
    mov LCD_BUS, A
    setb LCD_RS ; change mode to sending data
	
	call send_command ; negative edge on E
	
	ret 
; subroutine to create multiple delay of 1us 
us_delay: 
	mov A, R0
	rr A ; divide delay by two as djnz instruction take 2 us to execute
	subb A, #5 ; correct delay as each instruction (despite djnz) takes time to execute
	mov R0, A
	djnz R0, $
	
	ret
; subroutine to create multiple delay of 1ms
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
