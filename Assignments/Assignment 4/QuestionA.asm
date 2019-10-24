TITLE QuestionA.asm
;***************************************************************
; -Michael Buffone
; -October 24th, 2019
; -COSC2406A19F Assignment 4, Question A

; -This program will read a file and print a secret message
;***************************************************************
INCLUDE Irvine32.inc

.data

comma BYTE ", ", 0

; Prompts
prompt BYTE "Enter the file name: ", 0

; File data
fileName BYTE 20 DUP(?)
fileHandle HANDLE ?

; Arrays
letters BYTE 26 DUP(?)
index BYTE 27 DUP(?)

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

;	****** Read from the file and store into letters array ******
	mov edx, OFFSET letters								; Move the location of the letters array to edx
	mov ecx, LENGTHOF letters							; Move ecx (loop) for the length of letters array
	call ReadFromFile									; Store content of file into letters

;	****** Read from the file and store into index array ******
	mov eax, fileHandle									; Move the file handle to eax
	mov edx, OFFSET index								; Move the location of the letters array to edx
	mov ecx, LENGTHOF index								; Move ecx (loop) for the length of index array
	call ReadFromFile									; Store content of file into index

;	****** Close the file ******
	mov eax, fileHandle
	call CloseFile

;	****** Print the letter array using the indexes ******
	mov ecx, LENGTHOF letters
	dec ecx												; Decrement to prevent comma being prented

	movzx esi, BYTE PTR index[LENGTHOF index-1]			; Go to the last value in the index array
L1:
	mov al, letters[esi]								; Move the letter[index] into al and print it
	call WriteChar										
	mov edx, OFFSET comma								; Print the comma and space
	call WriteString
	movzx esi, BYTE PTR index[esi]						; Move the position of the letter that needs to be printed next into esi
	loop L1;

	mov al, letters[esi]								; Move the last value letters[esi] (the end of the array) into al and print it
	call WriteChar
	call CrlF
	call CrlF

;	*** Print the arrays ***
	mov esi, OFFSET letters
	mov ebx, TYPE letters
	mov ecx, LENGTHOF letters
	call PrintArrayChar 

	mov esi, OFFSET index
	mov ebx, TYPE index
	mov ecx, LENGTHOF index
	call PrintArrayInt 
	
	exit
main ENDP

;*************************************************************
printArrayChar PROC USES ecx ebx esi
;	RECEIVES: ESI = offset of the source array
;			  EBX = type of the source
;			  ECX = number of elements in the source
;*************************************************************

.code
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

	ret
printArrayChar ENDP

;*************************************************************
printArrayInt PROC USES ecx ebx esi
;	RECEIVES: ESI = offset of the source array
;			  EBX = type of the source
;			  ECX = number of elements in the source
;*************************************************************

.code
	mov al, '['							; print the opening bracket of the array
	call WriteChar
	dec ecx								; decrease the loop amount of ecx by one so you can print the last elements without a comma

L2:
	movzx eax, BYTE PTR [esi]			; print the next value of the array into ax
	call WriteInt						
	mov edx, OFFSET comma				; write the comma and space for the next value
	call WriteString
	add esi, ebx						; go to the next element
	loop L2								; end of the loop
	
	movzx eax, BYTE PTR [esi]			; print the last value of the array into ax
	call WriteInt
	mov al, ']'							; print the last bracket and end the print function
	call WriteChar
	call CrlF

	ret
printArrayInt ENDP
END main