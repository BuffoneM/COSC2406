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
	mov ebx, 0									; move 0 to ebx for the counter
	mov edx, OFFSET target

L1:
	mov al, BYTE PTR [eax + ebx]				; move the current byte of eax + ebx into al
	mov [edx+ebx], al							; move al into target
	inc ebx
	loop L1
	mov target, edx								; move the built dword back into target

	call CrlF

	; *****Print Source*****
	mov edx, OFFSET sourceText					
	call WriteString
	call CrlF
	mov eax, source								; Move into eax for all of the printing of DWORD **source**
	
	mov edx, OFFSET binText						; binary print
	call WriteString
	call WriteBin								; access data from EAX
	call CrlF
		
	mov edx, OFFSET hexText						; hex print
	call WriteString
	call WriteHex								; access data from EAX
	call CrlF
	
	mov edx, OFFSET sinText						; signed int print
	call WriteString
	call WriteInt								; access data from EAX
	call CrlF
	call CrlF


	; *****Print target*****
	mov edx, OFFSET targetText					
	call WriteString
	call CrlF
	mov eax, target								; Move into eax for all of the printing of DWORD **target**
	
	mov edx, OFFSET binText						; binary print
	call WriteString
	call WriteBin								; access data from EAX
	call CrlF
		
	mov edx, OFFSET hexText						; hex print
	call WriteString
	call WriteHex								; access data from EAX
	call CrlF
	
	mov edx, OFFSET sinText						; signed int print
	call WriteString
	call WriteInt								; access data from EAX
	call CrlF
	
	exit
main ENDP

END main