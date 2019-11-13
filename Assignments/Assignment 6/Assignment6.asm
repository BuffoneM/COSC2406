TITLE Assignment6.asm
;***************************************************************
; -Michael Buffone
; -November 11th, 2019
; -COSC2406A19F Assignment 6

; -This program will read an integer, store it into a DWORD, 
;  and compute operations based on that input
;***************************************************************
INCLUDE Irvine32.inc

.data

menu BYTE "1 - Populate the array with random numbers", 0ah,
		  "2 - Multiply the array with a user provided multiplier", 0ah,
		  "3 - Divide the array with a user provided divisor", 0ah,
		  "4 - Print the array", 0ah,
		  "0 - Exit", 0

;----------Main Code Section------------------------------------
.code
main PROC
	mov edx, OFFSET menu					; Print menu
	call WriteString
	call CrlF

	exit
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