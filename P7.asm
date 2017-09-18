; ---------------------------------
;  AUTOR: Díaz García, Rodrigo
;  FECHA: 12 Abril 2017
;  PRUEBAS REALIZADAS: Práctica 7
; ---------------------------------

OUTPT EQU 041DH ; Establece posición de la función OUTPT
RDKBD EQU 044EH ; Establece posición de la función RDKBD

ORG 1000H ; Comienzo de datos
MVI A, 08H ; Inicializa A, a mascara de interrupciones
MVI B, FFH ; Inicializa B
MVI C, FFH ; Inicializa C
LXI SP, 2000H ; Inicializa SP
SIM ; Establece la máscara
EI ; Habilita interrupciones
REP: ; Ciclo principal
	CALL RDKBD ; Espera y devuelve una tecla pulsada en A
	CALL CHKKP ; Comprueba que hacer con la tecla
	JMP REP ; Repite ciclo

; * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; 	@function		CHKKP
; 	@abstract		Comprueba la telca pulsada
;	@discussion		Interpreta la tecla pulsada en
;					el acumulador, si es un número, lo
;					guarda, si es un operando, realiza
;					la operación.
;	@input	A		ASCII de tecla pulsada	
;	@result M1600	Primer código introducido
;	@result M1601	Segundo código introducido
;	@result M1602	Código del primer dígito del resultado
;	@result M1603	Código del segundo dígito del resultado
;	@result M1604	Modo de operacion (0 = -, 1 = +)
;	@result M1605	Signo resultante (0 = -, 1 = +)
; * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

CHKKP:
	CPI 41H ; Comprobar si es a
	JZ KPADD ; Si lo es, realizar suma
	CPI 61H ; Comprobar si es A
	JZ KPADD ; Si lo es, realizar suma
	CPI 46H ; Comprobar si es f
	JZ KPSUB ; Si lo es, realizar resta
	CPI 66H ; Comprobar si es F
	JZ KPSUB ; Si lo es, realizar resta
	CPI 3AH ; Comprobar si es mayor de 39
	RNC ; Si lo es, finalizar función
	CPI 30H ; Comprobar si es mayor de 30
	JNC KPNUM ; Si lo es, guardar numero
	RET ; Finalizar función


; * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; 	@subroutine		KPADD
; 	@abstract		Suma dos números
;	@discussion		Suma dos números de una cifra,
;					convierte el resultado en decimal y
;					lo guarda en memoria
;	@input	B		Primer operando
;	@input	C		Segundo operando
;	@result M1602	Código del primer dígito del resultado
;	@result M1603	Código del segundo dígito del resultado
;	@result M1604	1 (Suma)
;	@result M1605	1 (Positivo)
; * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

KPADD:
	LXI H, 1602H ; Comienzo de datos resultantes
	MOV A, B ; A = B
	ADD C ; A = B + C 
	DAA ; Convertir A a BCD
	MOV E, A ; Guardar resultado en E
	ANI F0H ; Obtener primer digito
	RAR ; A=A/10
	RAR ; A=A/10
	RAR ; A=A/10
	RAR ; A=A/10
	ADI 30H ; Obtener código ASCII
	MOV M, A ; Guardar código del primer dígito
	INX H ; Siguiente posición de memoria
	MOV A, E ; Cargar resultado
	ANI FH ; Obtener segundo digito
	ADI 30H ; Obtener código ASCII
	MOV M, A ; Guardar código del segundo dígito
	INX H ; Siguiente posición de memoria
	MVI M, 1H ; Establecer modo a suma
	INX H ; Siguiente posición de memoria
	MVI M, 1H ; Establecer signo a positivo
	CALL UPDATE ; Llamar función escribir en pentalla
	MVI B, FFH ; Vaciar B
	MVI C, FFH ; Vaciar C
	RET ; Finalizar función CHKKP
	
; * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; 	@subroutine		KPSUB
; 	@abstract		Resta dos números
;	@discussion		Resta dos números de una cifra en,
;					obtiene el valor absoluto y guarda el
;					signo de la resta.
;	@input	B		Primer operando
;	@input	C		Segundo operando
;	@result M1602	30 (0)
;	@result M1603	Código del resultado absoluto (|A-B|)
;	@result M1604	0 (Resta)
;	@result M1605	Signo resultante (0 = -, 1 = +)
; * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

KPSUB:
	LXI H, 1602H ; Comienzo de datos resultantes
	MVI M, 30H ; Guardar primer código como 0
	INX H ; Siguiente posición de memoria
	MOV A, B ; A = B
	CMP C ; Comprobar que operando es mayor
	JC ABS ; Si el segundo es mayor, ve al método ABS
		SUB C ; A = B - C 
		MOV E, A ; Guardar resultado en E
		ADI 30H ; Obtener código ASCII
		MOV M, A ; Guardar código del resultado
		INX H ; Siguiente posición de memoria
		MVI M, 0H ; Establecer modo a resta
		INX H ; Siguiente posición de memoria
		MVI M, 1H ; Establecer signo a positivo
		CALL UPDATE ; Llamar función escribir en pentalla
		MVI B, FFH ; Vaciar B
		MVI C, FFH ; Vaciar C
		RET ; Finalizar función CHKKP
	
	ABS: ; Método ABS, calcula la resta y el absoluto
		MOV A, B ; A = B
		SUB C ; A = B - C 
		XRI FFH ; A = NOT A
		ADI 1H ; Corregir desviación de XOR
		MOV E, A ; Guardar resultado en E
		ADI 30H ; Obtener código ASCII
		MOV M, A ; Guardar código del resultado
		INX H ; Siguiente posición de memoria
		MVI M, 0H ; Establecer modo a resta
		INX H ; Siguiente posición de memoria
		MVI M, 0H ; Establecer signo a negativo
		CALL UPDATE ; Llamar función escribir en pentalla
		MVI B, FFH ; Vaciar B
		MVI C, FFH ; Vaciar C
		RET ; Finalizar función CHKKP

; * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; 	@subroutine		KPNUM
; 	@abstract		Almacena número
;	@discussion		Obtiene el número a partir del código
;					y lo guarda en B/M si este esta vacio
;					o en C/M.
;	@input	A		Código introducido
;	@result M1600	Primer código introducido
;	@result M1601	Segundo código introducido
; * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

KPNUM:
	PUSH PSW ; Guardar AF
	MOV A, B ; Obtener primer numero guardado
	CPI FFH ; Comprobar que este vacio
	JNZ ELSE ; Si no lo esta, ir a else
		POP PSW ; Cargar AF guardado
		STA 1600H ; Guardar como primer código
		SUI 30H ; Restar 30 para obtener el numero
		MOV B, A ; Guardar numero en B
		RET ; Finalizar interrupción

	ELSE:
		POP PSW ; Cargar AF guardado
		STA 1601H ; Guardar como segundo código
		SUI 30H ; Restar 30 para obtener el numero
		MOV C, A ; Guardar numero en C
		RET ; Finalizar función CHKKP

; * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; 	@function		UPDATE
; 	@abstract		Escribe operación en pantalla
;	@discussion		Escribe los 2 numeros introducidos,
;					el modo de operación, el signo, y
;					el resultado.
;	@input M1600	Primer código introducido
;	@input M1601	Segundo código introducido
;	@input M1602	Primer código del resultado
;	@input M1603	Segundo código del resultado
;	@input M1604	Modo de operacion (0 = -, 1 = +)
;	@input M1605	Signo resultante (0 = -, 1 = +)
; * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

UPDATE:
	LXI H, 1604H ; Obtener operación
	MVI A, 0H ; Seleccionar campo de dirección
	MOV B, M ; Escribir punto si es una resta
	LXI H, 1600H ; Escribir dos primeros números
	OUTPT ; Escribir en pantalla
	LXI H, 1605H ; Obtener signo
	MVI A, 1H; Seleccionar campo de datos
	MOV B, M ; Escribir punto si es negativo
	LXI H, 1602H ; Escribir resultado
	OUTPT ; Escribir en pantalla
	RET ; Finalizar función