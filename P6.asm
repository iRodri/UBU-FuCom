; ---------------------------------
;  AUTOR: Díaz García, Rodrigo
;  FECHA: 29 Marzo 2017
;  PRUEBAS REALIZADAS: Práctica 6
; ---------------------------------

.ORG 1000H
MVI A, 08H ; Initialize A as interrupt mask
MVI B, FFH ; Initialize B
MVI C, FFH ; Initialize C
LXI SP, 2000H ; Initialize SP
SIM ; Set iterrupt mask
REP: ; Main loop
	EI ; Enable interrupt
	RIM ; Read interrupt mask
	JMP REP ; Repeat

; * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; 	@interruption	5.5 (2C/44)
; 	@abstract	Adds or subtracts 2 numbers.
;	@discussion	Checks pressed key in port 0,
;			stores numbers or executes
;			mathematical operation.
;	@input	0H	Keyboard port 0
;	@result E	Result of A+B or |A-B|
;	@result D	Sign of A-B (0 positive, 1 negative)
; * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

.ORG 2CH ; Interrupt 5.5
IN 00H ; Get key
CPI 3AH ; Is key > 3A?
RNC ; if true, return
CPI 30H ; Is key < 30
JC CHKSGN ; if true, check if operation

SUI 30H ; Obtain number
PUSH PSW ; Store state
MOV A, B
CPI FFH ; Is B empty?
JNZ ELSE ; if true, go to else
POP PSW ; Load state
MOV B, A ; Store number in B
RET ; Return
ELSE:
	POP PSW ; Load state
	MOV C, A ; Store number in C
	RET ; Return

CHKSGN:
	CPI 2BH ; is key == '+'?
	JNZ CHKSGN2 ; if false, check other sign
	MVI D, 0H ; sign = positive
	MOV A, B ; A = B
	ADD C ; A = B + C 
	DAA ; Convert A to BCD
	MOV E, A ; Store result in E
	MVI B, FFH ; Empty B
	MVI C, FFH ; Empty B
	RET ; Return
	
CHKSGN2:
	CPI 2DH ; is key == '-'?
	RNZ ; if false, return
	MVI D, 0H ; sign = positive
	MOV A, B ; A = B
	SUB C ; A = B - C 
	MVI B, FFH ; Empty B
	MVI C, FFH ; Empty B
	MOV E, A ; Store result in E
	CPI 0H ; is result positive?
	RP ; if true, return
	MVI D, 1H ; sign = negative
	XRI FFH ; A = NOT A
	ADI 1H ; Fix XOR deviation
	MOV E, A ; Store result in E
	RET ; Return
		
