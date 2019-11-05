TITLE QuestionA.asm
;***************************************************************
; -Michael Buffone
; -November 4th, 2019
; -COSC2406A19F Assignment 5, Question A

; -This program will read an integer, store it into a DWORD, 
;  and compute operations based on that input
;***************************************************************
INCLUDE Irvine32.inc

.data

; Prompts
prompt BYTE "Enter the file name: ", 0
comma BYTE " ,", 0

; File data
fileName BYTE 30 DUP(?)
fileHandle HANDLE ?

; Data
fileData BYTE 20 DUP(?)

;----------Main Code Section------------------------------------
.code
main PROC

;	****** User I/O ******
	mov edx, OFFSET prompt								; Print msg and collect the file string
	call WriteString
	mov ecx, LENGTHOF fileName							; String input from the user
	mov edx, OFFSET fileName
	call ReadString										; Returns the string into edx

;	****** Open the file ******
	call OpenInputFile									; Call procedure with the fileName in edx
	mov fileHandle, eax									; OpenInputFile returns fileHandle in eax, save it

;	****** Read from the file ******
;readLoop:
	mov eax, fileHandle
	mov edx, OFFSET fileData
	mov ecx, SIZEOF fileData
	call ReadFromFile

;	cmp eax, 0											; Check if we're at the end of the file
;	je doneReading

;	mov edx, OFFSET msg
;	call WriteString
;	call WriteDec
;	call CrlF

;	jmp readLoop

;doneReading:
;	mov eax, fileHandle
;	call CloseInputFile
	
	mov esi, OFFSET fileData
	mov ebx, TYPE fileData
	mov ecx, LENGTHOF fileData
	call printArrayChar
	call CrlF

	exit
main ENDP

;*************************************************************
printArrayChar PROC
;	RECEIVES: ESI = offset of the source array
;			  EBX = type of the source
;			  ECX = number of elements in the source
;*************************************************************

.code
	PUSH ECX
	PUSH EBX
	PUSH ESI

	mov al, '['							; print the opening bracket of the array
	call WriteChar
	dec ecx								; decrease the loop amount of ecx by one so you can print the last elements without a comma

L1:
	mov ax, [esi]						; print the next value of the array into ax
	call WriteChar						
	mov edx, OFFSET comma				; write the comma and space for the next value
	call WriteString
	add esi, ebx						; go to the next element
	loop L1								; end of the loop
	
	mov ax, [esi]						; print the last value of the array into ax
	call WriteChar
	mov al, ']'							; print the last bracket and end the print function
	call WriteChar
	call CrlF

	POP ESI
	POP EBX
	POP ECX
	ret
printArrayChar ENDP

END main