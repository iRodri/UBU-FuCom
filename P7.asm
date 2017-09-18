; ---------------------------------
;  AUTHOR: Díaz García, Rodrigo
;  DATE: 12 April 2017
;  ASSIGNMENT: P7
; ---------------------------------

OUTPT EQU 041DH ; Function Output
RDKBD EQU 044EH ; Function Read Keyboard

ORG 1000H
MVI A, 08H ; Initialize A as interrupt mask
MVI B, FFH ; Initialize B
MVI C, FFH ; Initialize C
LXI SP, 2000H ; Initialize SP
SIM ; Set iterrupt mask
EI ; Enable interrupt
REP: ; Main loop
	CALL RDKBD ; Wait until keypress
	CALL CHKKP ; Check key
	JMP REP ; Repeat

; * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; 	@function	CHKKP
; 	@abstract	Checks the pressed key
;	@discussion	Checks pressed key in port 0,
;			stores numbers or executes
;			mathematical operation.
;	@input	A	Pressed key's ASCII
;	@result M1600	First number's ASCII
;	@result M1601	Second number's ASCII
;	@result M1602	First result number's ASCII
;	@result M1603	Second result number's ASCII
;	@result M1604	Operation mode (0 = -, 1 = +)
;	@result M1605	Result sign (0 = -, 1 = +)
; * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

CHKKP:
	CPI 41H ; is key = 'a'?
	JZ KPADD ; if true, addition
	CPI 61H ; is key = 'A'?
	JZ KPADD ; if true, addition
	CPI 46H ; is key = 'f'?
	JZ KPSUB ; if true, subtraction
	CPI 66H ; is key = 'F'?
	JZ KPSUB ; if true, subtraction
	CPI 3AH ; is key > 39?
	RNC ; if true, return
	CPI 30H ; is key > 30?
	JNC KPNUM ; if true, store number
	RET ; Return


; * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; 	@subroutine	KPADD
; 	@abstract	Adds two numbers
;	@discussion	Adds two single digit numbers,
;			stores result in memory.
;	@input	B	First operand
;	@input	C	Second operand
;	@result M1602	First result number's ASCII
;	@result M1603	Second result number's ASCII
;	@result M1604	1 (Addition)
;	@result M1605	1 (Positive)
; * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

KPADD:
	LXI H, 1602H
	MOV A, B ; A = B
	ADD C ; A = B + C 
	DAA ; Convert A to BCD
	MOV E, A ; Store result in E
	ANI F0H ; Get first digit
	RAR ; A=A/10
	RAR ; A=A/10
	RAR ; A=A/10
	RAR ; A=A/10
	ADI 30H ; Obtain ASCII
	MOV M, A ; Store first result number's ASCII
	INX H ; Next memory position
	MOV A, E ; Load result
	ANI FH ; Get second digit
	ADI 30H ; Obtain ASCII
	MOV M, A ; Store second result number's ASCII
	INX H
	MVI M, 1H ; mode = addition
	INX H
	MVI M, 1H ; sign = positive
	CALL UPDATE ; Update screen
	MVI B, FFH ; Empty B
	MVI C, FFH ; Empty C
	RET ; Return
	
; * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; 	@subroutine	KPSUB
; 	@abstract	Subtracts two numbers
;	@discussion	Subtracts two single digit numbers,
;			obtains absolute value, and stores
;			result and sign in memory.
;	@input	B	First operand
;	@input	C	Second operand
;	@result M1602	30 (0)
;	@result M1603	Absolute result's ASCII (|A-B|)
;	@result M1604	0 (Subtraction)
;	@result M1605	Result sign (0 = -, 1 = +)
; * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

KPSUB:
	LXI H, 1602H
	MVI M, 30H ; |Result| will always be < 10
	INX H
	MOV A, B ; A = B
	CMP C ; is C > B?
	JC ABS ; if true go to ABS
		SUB C ; A = B - C 
		MOV E, A ; Store result in E
		ADI 30H ; Obtain ASCII
		MOV M, A ; Store result's ASCII
		INX H
		MVI M, 0H ; mode = subtraction
		INX H
		MVI M, 1H ; sign = positive
		CALL UPDATE ; Update screen
		MVI B, FFH ; Empty B
		MVI C, FFH ; Empty C
		RET ; Return
	
	ABS:
		MOV A, B ; A = B
		SUB C ; A = B - C 
		XRI FFH ; A = NOT A
		ADI 1H ; Fix XOR deviation
		MOV E, A ; Store result in E
		ADI 30H ; Obtain ASCII
		MOV M, A ; Store result's ASCII
		INX H
		MVI M, 0H ; mode = subtraction
		INX H
		MVI M, 0H ; sign = negative
		CALL UPDATE ; Update screen
		MVI B, FFH ; Empty B
		MVI C, FFH ; Empty C
		RET ; Return

; * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; 	@subroutine	KPNUM
; 	@abstract	Stores number
;	@discussion	Decides where to store number,
;			B/1600 for the first one and
;			C/1601 for the second one.
;	@input	A	Number's ASCII
;	@result M1600	First number's ASCII
;	@result B	First number
;	@result M1601	Second number's ASCII
;	@result C	Second number
; * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

KPNUM:
	PUSH PSW ; Store state
	MOV A, B ; obtain first stored number
	CPI FFH ; is it empty?
	JNZ ELSE ; if false, go to else
		POP PSW ; Load state
		STA 1600H ; Store as first number
		SUI 30H ; Obtain number
		MOV B, A ; Store number in B
		RET ; Return

	ELSE:
		POP PSW ; Load state
		STA 1601H ; Store as second number
		SUI 30H ; Obtain number
		MOV C, A ; Store number in C
		RET ; Return

; * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; 	@function	UPDATE
; 	@abstract	Shows operation in screen
;	@discussion	Escribe los 2 numeros introducidos,
;			el modo de operación, el signo, y
;			el resultado.
;	@discussion	Writes the 2 operands, the mode,
;			the sign, and the result.
;	@input M1600	First operand's ASCII
;	@input M1601	Second operand's ASCII
;	@input M1602	First result digit's ASCII
;	@input M1603	Second result digit's ASCII
;	@input M1604	Operation mode (0 = -, 1 = +)
;	@input M1605	Result sign (0 = -, 1 = +)
; * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

UPDATE:
	LXI H, 1604H ; Get mode
	MVI A, 0H ; Select first screen half
	MOV B, M ; Write dash if mode is subtraction
	LXI H, 1600H ; Write both operands
	OUTPT ; Write screen
	LXI H, 1605H ; Get sign
	MVI A, 1H; Select second screen half
	MOV B, M ; Write dot if sign is negative
	LXI H, 1602H ; Write result
	OUTPT ; Write screen
	RET ; Return
