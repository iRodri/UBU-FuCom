; ---------------------------------
;  AUTOR: Díaz García, Rodrigo
;  FECHA: 29 Marzo 2017
;  PRUEBAS REALIZADAS: Práctica 5
;  VERSIÓN: 1.1 - Comentarios actualizados
; ---------------------------------

.DATA 1200H ; Comienzo de datos
  dB 6H, 5H ; Valores en memoria a ser multiplicados
.ORG 1000H ; Comienzo de programa

LXI H, 1200H ; Inicializa Par H
MOV B, M ; Inicializa B al primer valor
INX H ; Incrementa memoria apuntada
MOV C, M ; Inicializa C al segundo valor
CALL MULT ; Llama a la función MULT
INX H ; Incrementa memoria apuntada
MOV M, D ; Guarda el resultado en memoria
HLT ; Fin

; * * * * * * * * * * * * * * * * * * * * * * * * * *
; 	@function	MULT
; 	@abstract	Multiplicar dos numeros
;	@discussion	Esta función obtiene 2 números, los
;			multiplica y devuelve el resultado.
;	@param	B	Primer multiplicando
;	@param	C	Segundo multiplicando
;	@result D	Resultado de A*B
; * * * * * * * * * * * * * * * * * * * * * * * * * *

MULT: ; Comienzo de función MULT
	MVI D, 0H ; Limpiar el contenedor del resultado
	STEP: ; Comienzo de subrutina STEP
		MOV A, C ; Cargar el contenido de segundo multiplicando
		CPI 0H ; Comprobar si es 0 y resetea carry
		JZ BREAK ; Si C=0, terminar función
		RAR ; Rotar acumulador y carry hacia la derecha
		MOV C, A ; Guardar bits restantes en C
		JNC NOT ; Si bit en carry es 0, saltar hasta NOT
			MOV A, B ; Cargar acumulador con primer multiplicando
			ADD D ; Sumar resultado temporal con multiplicando
			MOV D, A ; Guardar nuevo resultado temporal
		NOT : ; Marcador NOT
			MOV A, B ; Cargar primer multiplicando en A
			RAL ; Rotar A hacia la izquierda
			MOV B, A ; Guardar A como primer multiplicando
		JMP STEP ; Repetir subrutina
	BREAK: ; Marcador de fin de función
RET ; Fin de función, devolver ejecución al programa
