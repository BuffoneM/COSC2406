TITLE QuestionA.asm
;***************************************************************
; -Michael Buffone
; -October 11th, 2019
; -COSC2406A19F Assignment 3, Question A

; -This program will read an integer, store it into a DWORD, 
;  and compute operations based on that input
;***************************************************************
INCLUDE Irvine32.inc

.data

;----------Main Code Section------------------------------------
.code
main PROC
	mov edx, OFFSET pPrompt						; Print msg and collect pVar
main ENDP

;***************************************************************
; printArray PROC
;	RECEIVES: ESI = offset of the source array
;			  EBX = type of the source
;			  ECX = number of elements in the source
;***************************************************************
;.data

;.code

;printArray ENP
END main