; ---------------------------------
;  AUTOR: Díaz García, Rodrigo
;  FECHA: 29 Marzo 2017
;  PRUEBAS REALIZADAS: Práctica 6
; ---------------------------------

.ORG 1000H ; Comienzo de datos
MVI A, 08H ; Inicializa A, a mascara de interrupciones
MVI B, FFH ; Inicializa B
MVI C, FFH ; Inicializa C
LXI SP, 2000H ; Inicializa SP
SIM ; Establece la máscara
REP: ; Ciclo principal
	EI ; Habilita interrupciones
	RIM ; Lee máscara
	JMP REP ; Repite ciclo

; * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; 	@interruption	5.5 (2C/44)
; 	@abstract		Suma o resta 2 números.
;	@discussion		Interpreta la tecla pulsada en
;					el puerto 0, si es un número, lo
;					guarda, si es un operando, realiza
;					la operación.
;	@input	0H		Teclado	
;	@result E		Resultado de A+B o |A-B|
;	@result D		Signo de A-B (0 Positivo, 1 Negativo)
; * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

.ORG 2CH ; Comienzo de datos de la interrupción 5.5
IN 00H ; Obtener datos del bus de i/o
CPI 3AH ; Comprobar si es mayor de 3A
RNC ; Si lo es, finalizar interrupción
CPI 30H ; Comprobar si es menor de 30
JC CHKSGN ; Si lo es, comprobar si es un signo

SUI 30H ; Restar 30 para obtener el numero
PUSH PSW ; Guardar AF
MOV A, B
CPI FFH ; Comprobar si B está vacio
JNZ ELSE ; Si lo esta, ir a else
POP PSW ; Cargar AF guardado
MOV B, A ; Guardar numero en B
RET ; Finalizar interrupción
ELSE:
	POP PSW ; Cargar AF guardado
	MOV C, A ; Guardar numero en C
	RET ; Finalizar interrupción

CHKSGN:
	CPI 2BH ; Comprobar si es +
	JNZ CHKSGN2 ; Si no lo es, ir a siguiente comprobación
	MVI D, 0H ; Establecer signo a positivo
	MOV A, B ; A = B
	ADD C ; A = B + C 
	DAA ; Convertir A a BCD
	MOV E, A ; Guardar resultado en E
	MVI B, FFH ; Vaciar B
	MVI C, FFH ; Vaciar B
	RET ; Finalizar interrupción
	
CHKSGN2:
	CPI 2DH ; Comprobar si es -
	RNZ ; Si no lo es, finalizar interrupción
	MVI D, 0H ; Establecer signo a positivo
	MOV A, B ; A = B
	SUB C ; A = B - C 
	MVI B, FFH ; Vaciar B
	MVI C, FFH ; Vaciar B
	MOV E, A ; Guardar resultado en E
	CPI 0H ; Comprobar si es positivo
	RP ; Si lo es, finalizar interrupción
	MVI D, 1H ; Establecer signo a negativo
	XRI FFH ; A = NOT A
	ADI 1H ; Corregir desviación de XOR
	MOV E, A ; Guardar resultado en E
	RET ; Finalizar interrupción
		