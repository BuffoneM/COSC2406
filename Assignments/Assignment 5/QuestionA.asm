TITLE QuestionA.asm
;***************************************************************
; -Michael Buffone
; -November 4th, 2019
; -COSC2406A19F Assignment 5, Question A

; -This program will create a file buffer and count the amount
;  of characters / numbers in that file
;***************************************************************
INCLUDE Irvine32.inc

.data

; Prompts
prompt BYTE "Enter the file name: ", 0
invalidFile BYTE ": cannot locate file...", 0

; File data
fileName BYTE 30 DUP(?)
fileHandle HANDLE ?
fileBuffer BYTE 100 DUP(?)

; Data
counter BYTE 36 DUP(0)
numBytes DWORD 0

;----------Main Code Section------------------------------------
.code
main PROC

;	****** User I/O ******
validateFile:
	mov edx, OFFSET prompt								; Print msg and collect the file string
	call WriteString
	mov ecx, LENGTHOF fileName							; String input from the user
	mov edx, OFFSET fileName
	call ReadString										; Returns the string into edx
	call CrlF
	call WriteString

;	****** Open the file ******
	call OpenInputFile									; Call procedure with the fileName in edx
	cmp eax, INVALID_HANDLE_VALUE
	je printLine										; If the file doesn't exist, print an invalid file prompt and ask for another file
	jmp continue										; If the file exists, continue by making the file handle

printLine:
	mov edx, OFFSET invalidFile
	call WriteString
	call CrlF
	jmp validateFile

continue:
	mov fileHandle, eax									; OpenInputFile returns fileHandle in eax, save it
	
	call processCharacters

;	*** Print the results ***
	mov esi, OFFSET counter
	mov edi, TYPE counter
	call printCountResult

	exit
main ENDP


;*************************************************************
processCharacters PROC
;-  Processes all of the characters within the file, stores
;-  them in a buffer, and counts each character
;	RECEIVES: EAX = File handle
;			  ECX = Size of file buffer
;			  EDX = Offset of file buffer
;	 RETURNS: Nothing
;*************************************************************
.code

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
	add esi, TYPE fileBuffer							; Go to the next element in esi

	call isChar											; if(al == char)
	jz itsAChar
	call isDigit										; if(al == digit)
	jz itsADig
	jmp continue										; if it isn't an applicable char or digit, continue

itsAChar:
;	*** Convert the letter to upper case ***
	and al, 223
	sub al, 55
	movzx edi, al
	inc counter[edi]

itsADig:
	sub al, '0'											; Subtract '0' from AL to get the proper index
	movzx edi, al
	inc counter[edi]									; Add one to the proper index

continue:												
	loop indexElements									; Jump back up to read the next element
	jmp readLoop										; Take in another set of elements

doneReading:
	mov eax, fileHandle
	call CloseFile
	call CrlF
	
	ret
processCharacters ENDP


;*************************************************************
isChar PROC USES eax
;-	Tests if AL is a character
;	RECEIVES: AL = which is a letter
;	 RETURNS: ZF = 1 if the value in the AL register is a 
;			  letter, either upper case or lower case
;*************************************************************
.code
	cmp al, 97											; if(al < 97) check to see if it's a capital letter
	jb checkCapital						
	cmp al, 122											; if(al > 122) it isn't a lower case letter
	ja notChar
	test ax, 0											; set zf = 1

checkCapital:			
	cmp al, 65											; if(al < 65) it isn't a capital letter so it can't be a char
	jb notChar
	test ax, 0											; set zf = 1
notChar:
	ret
isChar ENDP


;*************************************************************
printCountResult PROC
;-	Prints out a summary of all characters and their amount
;	RECEIVES: ESI = offset of the source array
;			  EDI = type of the source array
;	 RETURNS: Nothing
;*************************************************************
.data
countOf BYTE "count of '", 0
equals BYTE "' = ", 0
.code
	PUSH ESI
	PUSH EDI

;	*** Print numbers 0 - 9 ***
	mov ecx, 10
	mov ebx, 0
printNum:
	mov eax, ebx										; Print "count of 'num' = "
	mov edx, OFFSET countOf
	call WriteString
	call WriteDec
	mov edx, OFFSET equals
	call WriteString					

;	*** Print the numbers in the count array ***
	mov al, [esi]										; Print the corresponding number
	call WriteDec
	add esi, edi 

	call CrlF
	inc ebx
	loop printNum

;	*** Print letters a - z ***
	mov ecx, 26
	mov ebx, 97
printLetters:
	mov eax, ebx 										; Print "letter = "
	mov edx, OFFSET countOf
	call WriteString
	call WriteChar
	mov edx, OFFSET equals
	call WriteString					

;	*** Print the numbers in the count array ***
	mov al, [esi]										; Print the corresponding number
	call WriteDec
	add esi, edi 

	call CrlF
	inc ebx
	loop printLetters

	POP EDI
	POP ESI
	ret
printCountResult ENDP

END main