TITLE QuestionD.asm
;***************************************************************
; -Michael Buffone
; -October 11th, 2019
; -COSC2406A19F Assignment 3, Question D

; -This program will create an array of 10 DWORD values,
;  populate the array with user defined values, and rotate the
;  array's values by 1 index to the right
;***************************************************************
INCLUDE Irvine32.inc

.data
array DWORD 4 DUP(?)

prompt BYTE "Enter a number: ", 0


;----------Main Code Section------------------------------------
.code
main PROC

	mov edi, OFFSET array						; EDI = address of the array
	mov esi, OFFSET array						; Used for printArray function
	mov ebx, TYPE array							; Move the number of bytes for the array type = 4 bytes (DWORD)
	mov ecx, LENGTHOF array						; Loop for the length of the array

;	****** User I/O Into the Array ******
L1:
	mov edx, OFFSET prompt						; Print user input statement
	call WriteString
	call ReadInt
	mov [edi], eax								; Store the inputted value into edi
	add edi, ebx								; Proceed to the next index
	loop L1


	mov ecx, LENGTHOF array						; Reset ECX back to 4 for the printArray function
	call printArray
	call CrlF


;	****** Re-index the Array ******
	mov edi, OFFSET array						; EDI = address of the array
	mov ecx, LENGTHOF array						; Reset ECX back to 4 for the index change
L2:
	add edi, ebx
	loop L2


	mov ecx, LENGTHOF array						; Reset ECX back to 4 for the printArray function
	call printArray
	call CrlF
main ENDP

;*************************************************************
printArray PROC USES ecx ebx esi
;	RECEIVES: ESI = offset of the source array
;			  EBX = type of the source
;			  ECX = number of elements in the source
;*************************************************************
.data
	comma BYTE ", ", 0

.code
	mov al, '['							; print the opening bracket of the array
	call WriteChar
	dec ecx								; decrease the loop amount of ecx by one so you can print the last elements without a comma

L1:
	mov ax, [esi]						; print the next value of the array into ax
	call WriteInt						
	mov edx, OFFSET comma				; write the comma and space for the next value
	call WriteString
	add esi, ebx						; go to the next element
	loop L1								; end of the loop
	
	mov ax, [esi]						; print the last value of the array into ax
	call WriteInt
	mov al, ']'							; print the last bracket and end the print function
	call WriteChar
	call CrlF
	ret

printArray ENDP

END main