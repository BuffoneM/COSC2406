TITLE PartA.asm
;***************************************************************
; -Michael Buffone
; -November 22th, 2019
; -COSC2406A19F Assignment 8, Question A

; -This program will create and utilize str_substring
;***************************************************************
INCLUDE Irvine32.inc

.data

; Prompts
enterStringMsg BYTE "Enter a string: ", 0
startIndexMsg BYTE "Start index: ", 0
endIndexMsg BYTE "End index: ", 0
substringMsg BYTE "Substring: ", 0

; Data
userString BYTE 1000 DUP(?)
targetString BYTE 1000 DUP(?)

;----------Main Code Section------------------------------------
.code
main PROC

;	****** Collect user string ******
	mov edx, OFFSET enterStringMsg					; Print msg and collect string
	call WriteString
	mov ecx, LENGTHOF userString					
	mov edx, OFFSET userString
	call ReadString									; userString now holds the user input

	mov edx, OFFSET startIndexMsg					; Collect first num
	call WriteString
	call ReadInt
	mov ebx, eax

	mov edx, OFFSET endIndexMsg						; Collect second num
	call WriteString
	call ReadInt
	
	push eax
	push ebx
	push OFFSET targetString
	push OFFSET userString
	call Str_substring

	mov edx, OFFSET substringMsg					; Print Substring: 
	call WriteString
	mov al, '"'										; Print "
	call WriteChar
	mov edx, OFFSET targetString					; Print the target
	call WriteString	
	mov al, '"'										; Print "
	call WriteChar
	
	call CrlF
	exit
main ENDP

;***************************************************************
Str_substring PROC USES eax ebx ecx edi esi,
				sourceOffset : PTR BYTE,
				targetOffset : PTR BYTE,
				firstIndex	 : DWORD,
				lastIndex	 : DWORD,
				sourceLength : DWORD
;		      -if(endIndex > sourceLength) use string length
;
;	 RETURNS: -Return the substring in the target
;			  -if(endIndex <= firstIndex) return empty
;			  -if(firstIndex >= sourceLength) return empty
;***************************************************************

.code
;	*** Move values into the registers ***
	mov edi, sourceOffset					
	mov esi, targetOffset
	mov eax, firstIndex
	mov ebx, lastIndex

	cmp ebx, eax									; if(lastIndex <= firstIndex) return empty
	jle finish

	cmp eax, sourceLength							; if(firstIndex >= sourceLength) return empty
	jge finish

	add edi, firstIndex								; Add firstIndex to source to go to the proper position

	mov ecx, lastIndex								; Get the amount of chars needed to copy
	sub ecx, firstIndex
moveChars:
	mov dl, [edi]									; Move the current letter from source into target
	mov [esi], dl
	add edi, TYPE BYTE
	add esi, TYPE BYTE
	loop moveChars

finish:
	ret 12
Str_substring ENDP

END main