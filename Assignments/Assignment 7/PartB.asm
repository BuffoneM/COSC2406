TITLE PartB.asm
;***************************************************************
; -Michael Buffone
; -November 21th, 2019
; -COSC2406A19F Assignment 7, Part B

; -This program will do a float to binary conversion
;***************************************************************
INCLUDE Irvine32.inc

.data

;Variables
userNum			REAL4 ?

; Prompts
floatMsg BYTE "Enter a float value: ", 0
realNumMsg BYTE "Real number in binary: ", 0
eMsg BYTE " x 2^", 0

;----------Main Code Section------------------------------------
.code
main PROC

	mov edx, OFFSET floatMsg						; Print msg and collect float
	call WriteString
	call ReadFloat
	FSTP userNum									; Store the input into userNum var
	
	mov edx, OFFSET realNumMsg
	call WriteString
	push userNum									; Push the variable on the stack
	call flpValToBin
	call CrlF
	call showFPUstack

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
	sub ebx, 127									; EAX - 127 to get the exponent, EBX holds the exponent

	mov eax, [EBP + 8]								; Reset EAX to be the usernum
	shl eax, 9										; Move the the number 9 bits to the left
	mov ecx, 23										; Loop for 23 bits
printBinary:
	shl eax, 1										; Move the bit into the carry flag
	jc print1										; If carry is 1, print 1
	jnc print0										; If carry is 0, print 0
print1:
	mov al, '1'										; Print 1
	call WriteChar
	jmp printBinContinue
print0:
	mov al, '0'										; Print 0
	call WriteChar
printBinContinue:
	loop printBinary								; Jump back up to the top

	mov edx, OFFSET eMsg							; Write " x 2 ^ "
	call WriteString
	mov eax, ebx
	call WriteDec									; Write the exponent
	
	pop ebp
	ret
flpValToBin ENDP

END main