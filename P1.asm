; ---------------------------------
;  AUTHOR: Díaz García, Rodrigo
;  DATE: 22 February 2017
;  ASSIGNMENT: P1
;  REVISION: 1.2 - Corrected date
; ---------------------------------
.ORG 100AH
; ------------
;  Section 1
; ------------
MVI A, 1H
MVI B, 2H
MVI C, 3H
MVI D, 4H
MVI E, 5H
MVI H, 6H
MVI L, 7H
; ------------
;  Section 2
; ------------
MOV M, A
; ------------
;  Section 3
; ------------
INX H
MOV M, B
INX H
MOV M, C
INX H
MOV M, D
INX H
MOV M, E
; ------------
;  Section 4
; ------------
SHLD 60FH
; ------------
;  Section 5
; ------------
XCHG
MOV M, A
; ------------
;  Section 6
; ------------
LHLD 60FH
MOV M, C
; ------------
;  Section 7
; ------------
STAX B
MVI A, 44H
STAX D
; -----
;  END
; -----
HLT 
