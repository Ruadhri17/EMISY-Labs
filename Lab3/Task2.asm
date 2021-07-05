LED_BANK equ P1 ; label for LEDs
KEYBOARD equ P0 ; label for keyboard 

main:

mov KEYBOARD, #11110000B ; set row to '0' 
jmp init ; initialize interrupt INT1

org 013H ; interrupt address 

xrl LED_BANK, #10100101B ; switch on/off 0 2nd 5th and 7th LED 
reti ; back to infinite loop

init: 
setb EA ; enable global interrupt
setb EX1 ; enable INT1 interrupt 
setb IT1 ; make INT1 work with falling edge

jmp $ ; infinite loop until interrupt occurs 