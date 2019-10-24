TITLE QuestionB.asm
;***************************************************************
; -Michael Buffone
; -October 24th, 2019
; -COSC2406A19F Assignment 4, Question B

; -This program will generate a random number between user input
;***************************************************************
INCLUDE Irvine32.inc

.data


;----------Main Code Section------------------------------------
.code
main PROC

;	****** User I/O ******
	mov edx, OFFSET prompt								; Print msg and collect the file string
	
	exit
main ENDP

;*************************************************************
printArrayInt PROC USES ecx ebx esi
;	RECEIVES: ESI = offset of the source array
;			  EBX = type of the source
;			  ECX = number of elements in the source
;*************************************************************

.code
	
	ret
printArrayInt ENDP
END main