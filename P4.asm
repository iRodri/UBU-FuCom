; ---------------------------------
;  AUTHOR: Díaz García, Rodrigo
;  DATE: 30 March 2017
;  ASSIGNMENT: P4
; ---------------------------------

.DATA 1500H
  dB 126, 231, 25, 156, 36, 219, 147, 74, 252, 152, 92, 117, 244, 189, 236, 40, 102, 192, 42, 194; Random memory values
.ORG 1000H

LXI H, 1500H ; Initialize H Pair 
MVI B, AH ; Initialize B to (n)
CALL MAX ; Call function MAX
MOV C, E ; Stores maximum in C
MVI E, 0H ; Resets E
MVI B, AH ; Inicialize B to (n)
CALL MAX ; Call function MAX
MOV A, C ; Load stored value in C
SUB E ; Substract new maximum
MOV M, A ; Save result to memory
HLT ; End

; * * * * * * * * * * * * * * * * * * * * * * * * * *
; 	@function	MAX
; 	@abstract	Get maximum value in memory
;             in range n.
;	@discussion	This function looks through memory
;             and returns they maximum value
;             encountered in n addresses.
;	@param	B, number of iterations (n)
;	@param	HL, referenced memory address
;	@result E, maximum value in range
; * * * * * * * * * * * * * * * * * * * * * * * * * *

MAX: ; Start of function MAX
	DCR B ; Decrease B by 1
	SCAN: ; Start of subroutine SCAN
		JM BREAK ; if B<0, end subroutine
		MOV A, M ; Copy memory to A
		CMP E ; Compare stored maximum
		DCR B ; B-=1
		INX H ; HL+=1
		JC SCAN ; if A>maximum, repeat subroutine
		MOV E, A ; store value as maximum
		JMP SCAN ; Repeat subroutine
	BREAK: ; End of subroutine
RET ;  End of function
