; ---------------------------------
;  AUTOR: Díaz García, Rodrigo
;  FECHA: 9 Marzo 2017
;  PRUEBAS REALIZADAS: Práctica 4
; ---------------------------------

.DATA 1500H ; Comienzo de datos
  dB 126, 231, 25, 156, 36, 219, 147, 74, 252, 152, 92, 117, 244, 189, 236, 40, 102, 192, 42, 194; Valores en memoria aleatorios
.ORG 1000H ; Comienzo de programa

LXI H, 1500H ; Inicializa Par H
MVI B, AH ; Inicializa B a (n)
CALL MAX ; Llamada a procedimiento MAX
MOV C, E ; Guarda el máximo en C
MVI E, 0H ; Resetea E
MVI B, AH ; Re-Inicializa B a (n)
CALL MAX ; Llamada a procedimiento MAX
MOV A, C ; Carga el valor guardado en C
SUB E ; Resta el nuevo máximo
MOV M, A ; Guarda el resultado en memoria
HLT ; Fin

; * * * * * * * * * * * * * * * * * * * * *
; Procedimiento Calcular Máximo [MAX]
;	Entrada: B, Dirección Memoria en HL
;	Salida: E
; * * * * * * * * * * * * * * * * * * * * *

MAX: ; Comienzo de procedimiento MAX
	DCR B ; Decrementa B en 1
	SCAN: ; Comienzo de subrutina SCAN
		JM BREAK ; Si B<0, terminar subrutina
		MOV A, M ; Copiar valor de memoria en A
		CMP E ; Comparar con el máximo temporal
		DCR B ; B-=1
		INX H ; HL+=1
		JC SCAN ; Si A es menor que el máximo temporal, repite subrutina
		MOV E, A ; Guarda A como nuevo máximo temporal
		JMP SCAN ; Repite subrutina
	BREAK: ; Fin de subrutina
RET ; Fin de procedimiento
