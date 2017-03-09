; ---------------------------------
;  AUTOR: Díaz García, Rodrigo
;  FECHA: 8 Marzo 2017
;  PRUEBAS REALIZADAS: Práctica 3
; ---------------------------------

.DATA 1500H ; Directiva de compilador
  dB 1,2,3,4,5,6,7,8,9,10 ; Directiva de compilador
.ORG 1000H ; Directiva de compilador

LXI H, 1500H ; Inicializa Par H
MVI B, 9H ; Inicializa B a (n-1)
REP: ADD M ; Marcador de repetición: A+=M
INX H ; Incrementa marcador de memoria en 1
DCR B ; Reduce B en 1
JP REP ; Si B es positivo ir a REP
MOV M, A ; Guardar resultado en memoria 
HLT ; Detener
