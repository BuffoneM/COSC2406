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
prompt BYTE "Enter an integer: ", 0
sourceText BYTE "Source:", 0
targetText BYTE "Target:", 0
binText BYTE "Binary: ", 0
hexText BYTE "Hexadecimal: ", 0
sinText BYTE "Signed int: ", 0

source DWORD 0
target DWORD 0

;----------Main Code Section------------------------------------
.code
main PROC
	
	mov edx, OFFSET prompt						; Ask the question, store the input in source and target
	call WriteString
	call ReadInt
	mov source, eax
	mov target, eax
	call CrlF

	; *****Print Source*****
	mov edx, OFFSET sourceText					
	call WriteString
	call CrlF
	mov eax, source								; Move into eax for all of the printing of DWORD **source**
	
	mov edx, OFFSET binText						; binary print
	call WriteString
	call WriteBin
	call CrlF
		
	mov edx, OFFSET hexText						; hex print
	call WriteString
	call WriteHex
	call CrlF
	
	mov edx, OFFSET sinText						; signed int print
	call WriteString
	call WriteInt
	call CrlF
	call CrlF


	; *****Print target*****
	mov edx, OFFSET targetText					
	call WriteString
	call CrlF
	mov eax, target								; Move into eax for all of the printing of DWORD **target**
	
	mov edx, OFFSET binText						; binary print
	call WriteString
	call WriteBin
	call CrlF
		
	mov edx, OFFSET hexText						; hex print
	call WriteString
	call WriteHex
	call CrlF
	
	mov edx, OFFSET sinText						; signed int print
	call WriteString
	call WriteInt
	call CrlF
	
	exit
main ENDP

END main