; ---------------------------------
;  AUTOR: Díaz García, Rodrigo
;  FECHA: 22 Febrero 2017
;  PRUEBAS REALIZADAS: Práctica 2 
; ---------------------------------

.ORG 100AH
lXI H, 1500H
MVI A, 5
etiq: MOV M, A
INR L
DCR A
CPI FFH
JNZ etiq
HLT
