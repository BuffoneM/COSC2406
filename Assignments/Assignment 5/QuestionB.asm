TITLE QuestionB.asm
;***************************************************************
; -Michael Buffone
; -November 4th, 2019
; -COSC2406A19F Assignment 5, Question B

; -This program will test if a value is a power of two by using
;  only shift or rotate operations to determine each bit
;***************************************************************
INCLUDE Irvine32.inc

.data

prompt BYTE "Enter a number: ", 0
binPrompt BYTE " -> binary : ", 0

userNum DWORD 0

;----------Main Code Section------------------------------------
.code
main PROC
	
;	****** User I/O ******
	mov edx, OFFSET prompt								; Write prompt and read user num
	call WriteString
	call ReadInt
	mov userNum, eax
	
	mov edx, OFFSET binPrompt							; Write user num in binary with prompt
	mov eax, userNum
	call WriteInt
	call WriteString
	call WriteBin


	call CrlF
	exit
main ENDP

END main