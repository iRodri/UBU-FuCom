; ---------------------------------
;  AUTHOR: Díaz García, Rodrigo
;  DATE: 30 March 2017
;  ASSIGNMENT: P5
; ---------------------------------

.DATA 1200
  dB 6H, 5H ; values to be multiplied
.ORG 1000

LXI H, 1200H ; Initialize H Pair
MOV B, M ; Initialize B to the first value
INX H ; Increase referenced memory address
MOV C, M ; Initialize C to the second value
CALL MULT ; Call function MULT
INX H ; Increase referenced memory address
MOV M, D ; Save result to memory
HLT ; End

; * * * * * * * * * * * * * * * * * * * * * * * * * *
; 	@function	MULT
; 	@abstract	Multiplies two numbers
;	@discussion	This functions gets two numbers,
;           		multiplies them, and returns
;             		the result value.
;	@param	B	Multiplicand
;	@param	C	Multiplier
;	@result D	Result of A*B
; * * * * * * * * * * * * * * * * * * * * * * * * * *

MULT: ; Start of function MULT
	MVI D, 0H ; Initialize result
	STEP: ; Start of subroutine STEP
		MOV A, C ; Load content of multiplier
		CPI 0H ; Reset Carry and check if multiplier is 0
		JZ BREAK ; if multiplier=0, goto function end
		RAR ; Rotate A and Carry to the right
		MOV C, A ; Store remaining bits of multiplier
		JNC NOT ; if carry=0, goto NOT
			MOV A, B ; Load content of multiplicand
			ADD D ; Add current result to multiplied value
			MOV D, A ; Store current result
		NOT : ; NOT marker (else)
			MOV A, B ; Load content of multiplicand
			RAL ; Rotate A and Carry to the left
			MOV B, A ; Store new content of multiplicand
		JMP STEP ; Repeat subroutine
	BREAK: ; End of function marker
RET ; End of function
