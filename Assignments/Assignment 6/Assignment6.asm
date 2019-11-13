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
;	*** Variables ***
array SWORD 10 dup(0)

;	*** Prompts ***
invalidOption BYTE "Invalid option entered...", 0

procedureComplete BYTE "Successfully executed...", 0ah,
						"-------------------------------------------", 0

menu BYTE "1 - Populate the array with random numbers", 0ah,
		  "2 - Multiply the array with a user provided multiplier", 0ah,
		  "3 - Divide the array with a user provided divisor", 0ah,
		  "4 - Print the array", 0ah,
		  "0 - Exit", 0

;----------Main Code Section------------------------------------
.code
main PROC
	call Randomize

;	****** User Menu ******
	mov eax, 0
promptUser:
	mov edx, OFFSET menu					; Print menu
	call WriteString
	call CrlF
	call ReadInt

	cmp eax, 1								; if(option1)
	je option1
	cmp eax, 2								; if(option2)								
	je option2
	cmp eax, 3								; if(option3)
	je option3
	cmp eax, 4								; if(option4)
	je option4
	cmp eax, 0								; if(option0)
	je option0
	mov edx, OFFSET invalidOption			; Invalid option made, ask the user again
	call WriteString
	call CrlF
	call CrlF
	jmp promptUser	
	
;	****** Procedure Options ******
;	*** Populate the array ***
option1:
	push OFFSET array						; Push offset of the SWORD array
	push LENGTHOF array						; Push the amount of elements in the SWORD array
	call populateRandomArray

	mov edx, OFFSET procedureComplete		; Print message and go to menu
	call WriteString
	call CrlF
	jmp promptUser

;	*** Multiply the array ***
option2:

	mov edx, OFFSET procedureComplete		; Print message and go to menu
	call WriteString
	call CrlF
	jmp promptUser

;	*** Divide the array ***
option3:

	mov edx, OFFSET procedureComplete		; Print message and go to menu
	call WriteString
	call CrlF
	jmp promptUser

;	*** Print the array ***
option4:
	
	mov esi, OFFSET array					
	mov ebx, TYPE array
	mov ecx, LENGTHOF array
	call PrintArrayInt
	call CrlF

	mov edx, OFFSET procedureComplete		; Print message and go to menu
	call WriteString
	call CrlF
	jmp promptUser

;	*** Exit the program ***
option0:
	exit
main ENDP


;***************************************************************
populateRandomArray PROC
;	RECEIVES: Stack Var1: Offset of the SWORD array
;			  Stack Var2: Number of elements in the array
;	 RETURNS: Nothing
;	 [EBP + 8] = length of the array
;    [EBP + 12] = offset of the array
;***************************************************************
.code
	ENTER 4, 0								; Create the proc. anchor
	mov esi, [EBP + 12]						; ESI contains the offset of the array

;	*** Generate the random number and store it in the array ***
	mov ecx, [EBP + 8]						; Loop for the length of the array
praLoop1:
	mov eax, 2500							; EAX = high number
	mov ebx, -1500							; EBX = low number
	sub eax, ebx
	inc eax
	call RandomRange
	add eax, ebx							; EAX now has the random number
	call WriteInt
	call CrlF

	mov [esi], eax							; Put eax into the array
	add esi, TYPE WORD						; Go to the next element
	loop praLoop1

	LEAVE									; Remove the proc. anchor
	ret
populateRandomArray ENDP


;*************************************************************
printArrayInt PROC USES ecx ebx esi
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

L2:
	movsx eax, SWORD PTR [esi]			; print the next value of the array into ax
	call WriteInt						
	mov edx, OFFSET comma				; write the comma and space for the next value
	call WriteString
	add esi, ebx						; go to the next element
	loop L2								; end of the loop
	
	movsx eax, SWORD PTR [esi]			; print the last value of the array into ax
	call WriteInt
	mov al, ']'							; print the last bracket and end the print function
	call WriteChar
	call CrlF

	ret
printArrayInt ENDP
END main