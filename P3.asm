
; ---------------------------------
;  AUTHOR: Díaz García, Rodrigo
;  DATE: 30 March 2017
;  ASSIGNMENT: P3
; ---------------------------------

.DATA 1500H
  dB 1,2,3,4,5,6,7,8,9,10
.ORG 1000H

LXI H, 1500H ; Initialize H Pair 
MVI B, 9H ; Initialize B to (n-1)
REP: ADD M ; Loop Marker: Increase A by M
INX H ; Increase memory address by 1
DCR B ; Decrease B by 1
JP REP ; If B is positive go to REP
MOV M, A ; Save result to memory
HLT ; End
