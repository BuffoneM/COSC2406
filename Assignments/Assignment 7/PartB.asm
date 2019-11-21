TITLE PartA.asm
;***************************************************************
; -Michael Buffone
; -November 21th, 2019
; -COSC2406A19F Assignment 7, Part B

; -This program will read an edge length and utilize FPU
;***************************************************************
INCLUDE Irvine32.inc

.data

;Variables
userNum			REAL4 ?

; Prompts
floatMsg BYTE "Enter a float value: ", 0
realNumMsg BYTE "Real number in binary: ", 0

;----------Main Code Section------------------------------------
.code
main PROC

	mov edx, OFFSET floatMsg					; Print msg and collect float
	call WriteString
	call ReadFloat
	FSTP userNum								; Store the input into userNum var
	
	call showFPUstack
	call CrlF
	push userNum									; Push the variable on the stack
	call flpValToBin

	exit
main ENDP


;***************************************************************
flpValToBin PROC
;	RECEIVES: userNum on stack
;	[EBP + 8] = userNum
;	 RETURNS: 
;***************************************************************
.code
	push ebp										; Create the procedure anchor
	mov ebp, esp
	
	mov eax, [EBP + 8]								; Move the user num into eax
	call WriteBin
	call CrlF

	shl eax, 1										; Move the sign bit into the carry bit
	ja positiveSign
	jb negativeSign

positiveSign:										; Sign bit is 0
	mov al, '+'
	call WriteChar
	jmp continue
negativeSign:										; Sign bit is 1
	mov al, '-'
	call WriteChar

continue:											; Print (sign)1. rest of int
	mov al, '1'
	call WriteChar
	mov al, '.'
	call WriteChar

	mov ebx, eax
	shr ebx, 24										; Move the number 24 bits left to isolate the term
	sub ebx, 127									; EAX - 127 to get the exponent

	mov ecx, 18
printBinary:
	shl eax, 1
	ja print1
	jb print0
print1:
	mov al, '1'
	call WriteChar
	jmp printBinContinue
print0:
	mov al, '0'
	call WriteChar
printBinContinue:
	loop printBinary
	

	pop ebp
	ret
flpValToBin ENDP

END main