TITLE QuestionC.asm
;***************************************************************
; -Michael Buffone
; -October 11th, 2019
; -COSC2406A19F Assignment 3, Question C

; -This program will prompt the user to enter five numbers,
;  store them, and compute a formula
;***************************************************************
INCLUDE Irvine32.inc

.data
pVar DWORD 0	
qVar SDWORD 0 ; signed
rVar DWORD 0
sVar DWORD 0 ; signed
tVar DWORD 0

pPrompt BYTE "Enter an unsigned value for 'P': ", 0
qPrompt BYTE "Enter a signed value for 'Q': ", 0
rPrompt BYTE "Enter an unsigned value for 'R': ", 0
sPrompt BYTE "Enter an signed value for 'S': ", 0
tPrompt BYTE "Enter an unsigned value for 'T': ", 0

equation BYTE "4T + (P - 3Q) - (S + 2R) = ", 0


;----------Main Code Section------------------------------------
.code
main PROC

;	****** User I/O for Variables ******
	mov edx, OFFSET pPrompt						; Print msg and collect pVar
	call WriteString
	call ReadInt
	mov pVar, eax
	call Crlf

	mov edx, OFFSET qPrompt						; Print msg and collect qVar
	call WriteString
	call ReadInt
	mov qVar, eax
	call Crlf
	
	mov edx, OFFSET rPrompt						; Print msg and collect rVar
	call WriteString
	call ReadInt
	mov rVar, eax
	call Crlf
	
	mov edx, OFFSET sPrompt						; Print msg and collect sVar
	call WriteString
	call ReadInt
	mov sVar, eax
	call Crlf

	mov edx, OFFSET tPrompt						; Print msg and collect tVar
	call WriteString
	call ReadInt
	mov tVar, eax
	call Crlf

;	****** Formula Computation ******
;	4T + (P-3Q) - (S + 2R)
;	This can be solved using the associative properties using EAX only
	mov eax, 0

;	4T
	add eax, tVar								; Add T to EAX four times
	add eax, tVar
	add eax, tVar
	add eax, tVar

;	P-3Q	
	add eax, pVar								; Add P to EAX once times

	sub eax, qVar								; Subtract Q to EAX three times
	sub eax, qVar
	sub eax, qVar

;	-S-2R
	sub eax, sVar								; Sub S from EAX once

	sub eax, rVar								; Sub R from EAX twice
	sub eax, rVar

	mov edx, OFFSET equation					; Print the equation and solution
	call WriteString
	call WriteInt
	call CrlF

	exit
main ENDP

END main