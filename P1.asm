; ---------------------------------
;  AUTOR: Díaz García, Rodrigo
;  FECHA: 21 Febrero 2017
;  PRUEBAS REALIZADAS: Práctica 1 
; ---------------------------------
.ORG 100AH
; ------------
;  Apartado 1
; ------------
MVI A, 1H
MVI B, 2H
MVI C, 3H
MVI D, 4H
MVI E, 5H
MVI H, 6H
MVI L, 7H
; ------------
;  Apartado 2
; ------------
MOV M, A
; ------------
;  Apartado 3
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
;  Apartado 4
; ------------
SHLD 60FH
; ------------
;  Apartado 5
; ------------
XCHG
MOV M, A
; ------------
;  Apartado 6
; ------------
LHLD 60FH
MOV M, C
; ------------
;  Apartado 7
; ------------
STAX B
MVI A, 44H
STAX D
; -----
;  FIN
; -----
HLT 
