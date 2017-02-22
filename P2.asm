; ---------------------------------
;  AUTOR: Díaz García, Rodrigo
;  FECHA: 22 Febrero 2017
;  PRUEBAS REALIZADAS: P2 
;  VERSIÓN: 1.1 - Comentarios actualizados
; ---------------------------------

.DATA 0071H ; Directiva de compilador
  dB 1,2,3,4,5 ; Directiva de compilador
.ORG 100AH ; Directiva de compilador

LXI H, 71H ; Inicializar Par H
MVI B, 4 ; Inicializar Par B a (n-1)
REP: ADD M ; Marcador de repetición: Incrementar A en M
INX H ; Incrementar dirección apuntada en 1
DCR B ; Reducir B en 1
JP REP ; Si B es positiva, ir a REP
MOV M, A ; Guardar acumulador en memoria apuntada
HLT ; Fin