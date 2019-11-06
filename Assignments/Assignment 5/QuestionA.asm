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
fileBuffer BYTE 100 DUP(?)

; Data
fileData BYTE 36 DUP(0)
numBytes DWORD 0

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
readLoop:
	mov eax, fileHandle
	mov edx, OFFSET fileBuffer
	mov ecx, SIZEOF fileBuffer
	call ReadFromFile									; Returns the amount of bytes read in the buffer

	cmp eax, 0											; Check if we're at the end of the file
	je doneReading

	mov numBytes, eax

	mov ecx, numBytes
	mov esi, OFFSET fileBuffer
;	*** Count every element in the file buffer ***
indexElements:						
	mov al, [esi]										; Print every element in the file
	call WriteChar
	add esi, TYPE fileBuffer							; Go to the next element in esi

	call isChar											; if(al == char)
	jz itsAChar
	call isDigit										; if(al == digit)
	jz itsADig
	jmp exitCheck

itsAChar:

itsADig:
	sub al, '0'											; Subtract 48 from AL to get the proper index
	movzx edi, al
	inc fileData[edi]									; Add one to the proper index

	loop indexElements
	jmp readLoop

doneReading:
	mov eax, fileHandle
	call CloseFile

exitCheck:

	call CrlF
	mov esi, OFFSET fileData
	mov ebx, TYPE fileData
	mov ecx, LENGTHOF fileData
	call printArrayInt

	call CrlF
	exit
main ENDP


;*************************************************************
isChar PROC USES eax
;	RECEIVES: AL which is a letter
;	 RETURNS: ZF = 1 if the value in the AL register is a 
;			  letter, either upper case or lower case
;*************************************************************
.code
	cmp al, 97							; if(al < 97) check to see if it's a capital letter
	jb checkCapital						
	cmp al, 122							; if(al > 122) it isn't a lower case letter
	ja notChar
	test ax, 0							; set zf = 1

checkCapital:			
	cmp al, 65							; if(al < 65) it isn't a capital letter so it can't be a char
	jb notChar
	test ax, 0							; set zf = 1
notChar:
	ret
isChar ENDP


;*************************************************************
printArrayInt PROC
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
	mov eax, 0
L1:
	mov al, [esi]						; print the next value of the array into ax
	call WriteDec						
	mov edx, OFFSET comma				; write the comma and space for the next value
	call WriteString
	add esi, ebx						; go to the next element
	loop L1								; end of the loop
	
	mov al, [esi]						; print the last value of the array into ax
	call WriteDec
	mov al, ']'							; print the last bracket and end the print function
	call WriteChar
	call CrlF

	POP ESI
	POP EBX
	POP ECX
	ret
printArrayInt ENDP

END main