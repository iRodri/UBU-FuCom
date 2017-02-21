; ---------------------------------
;  AUTOR: Díaz García, Rodrigo
;  FECHA: 21 Febrero 2017
;  PRUEBAS REALIZADAS: Práctica 2 
; ---------------------------------
.DATA 0071H
  dB 1,2,3,4,5,0
.ORG 100AH
LXI H, 71H
MVI B, 4
REP: ADD M
INX H
DCR B
JP REP
MOV M, A
HLT
