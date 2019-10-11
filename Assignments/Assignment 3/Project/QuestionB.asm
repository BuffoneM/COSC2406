TITLE QuestionA.asm
;***************************************************************
; -Michael Buffone
; -October 11th, 2019
; -COSC2406A19F Assignment 3, Question B

; -This program will create NUM, two arrays where their size
;  is based on NUM, and compute operations
;***************************************************************
INCLUDE Irvine32.inc

.data

num DWORD 10,
array1 WORD 

;----------Main Code Section------------------------------------
.code
main PROC
	
	mov eax, num
	call WriteInt
	
	
	exit
main ENDP

END main