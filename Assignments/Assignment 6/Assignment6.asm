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

multiplyPrompt BYTE "Enter a number to multiply: ", 0
dividePrompt BYTE "Enter a number to divide: ", 0


menu BYTE "1 - Populate the array with random numbers", 0ah,
		  "2 - Multiply the array with a user provided multiplier", 0ah,
		  "3 - Divide the array with a user provided divisor", 0ah,
		  "4 - Print the array", 0ah,
		  "0 - Exit", 0

;	*** Function Prototype(s) ***
;*************************************************************
printArrayInt PROTO, 
	arrayLength		: DWORD,
	arrayType		: DWORD,
	arrayOffset		: PTR DWORD
;*************************************************************

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
	call CrlF

	mov edx, OFFSET procedureComplete		; Print message and go to menu
	call WriteString
	call CrlF
	jmp promptUser

;	*** Multiply the array ***
option2:
	mov edx, OFFSET multiplyPrompt			; Print prompt and collect user num
	call WriteString
	call ReadInt
	
	push OFFSET array						; Push offset of the SWORD array
	push LENGTHOF array						; Push the amount of elements in the SWORD array
	push eax								; Push the multiplier
	call multiplyArray
	call CrlF

	mov edx, OFFSET procedureComplete		; Print message and go to menu
	call WriteString
	call CrlF
	jmp promptUser

;	*** Divide the array ***
option3:
	mov edx, OFFSET dividePrompt			; Print prompt and collect user num
	call WriteString
	call ReadInt

	mov esi, OFFSET array					; ESI = array address
	mov ecx, LENGTHOF array					; Loop for the length of the array
opt3Loop1:
	movsx ebx, WORD PTR [esi]				; Move the value into ebx
	push ebx								; Push current array element
	push eax								; Push the divisor
	call divideArray						; Returns the divided number

	mov [esi], ax							; Store the divided number in the array
	add esi, TYPE array						; Go to the next element
	pop eax
	pop ebx
	loop opt3Loop1
	call CrlF

	mov edx, OFFSET procedureComplete		; Print message and go to menu
	call WriteString
	call CrlF
	jmp promptUser

;	*** Print the array ***
option4:			
	invoke PrintArrayInt, LENGTHOF array, TYPE array, OFFSET array
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
;	 [EBP + 8]  = length of the array
;    [EBP + 12] = offset of the array
;***************************************************************
.code
	ENTER 8, 0								; Create the proc. anchor
	PUSHAD
	PUSHFD

	mov esi, [EBP + 12]						; ESI contains the offset of the array
	mov DWORD PTR[EBP-4], 2500				; Create local variables
	mov DWORD PTR[EBP-8], -1500

;	*** Generate the random number and store it in the array ***
	mov ecx, [EBP + 8]						; Loop for the length of the array
praLoop1:
	mov eax, [EBP - 4]						; EAX = high number
	mov ebx, [EBP - 8]						; EBX = low number
	sub eax, ebx
	inc eax
	call RandomRange
	add eax, ebx							; EAX now has the random number

	mov [esi], eax							; Put eax into the array
	add esi, TYPE WORD						; Go to the next element
	loop praLoop1

	POPFD
	POPAD
	LEAVE									; Remove the proc. anchor
	
	ret
populateRandomArray ENDP


;***************************************************************
multiplyArray PROC,
	multiplyAmnt :  SDWORD,
	arrayLength	 :  SDWORD,
	arrayOffset  :  PTR SDWORD
;	 RETURNS: Nothing
;***************************************************************
.code
	PUSHAD
	PUSHFD

	mov esi, arrayOffset					; ESI contains the offset of the array

;	*** Multiply every element by the multiplier and store it ***
	mov ecx, arrayLength					; Loop for the length of the array
maLoop1:
	mov ax, SWORD PTR multiplyAmnt			; ax contains the multiplier
	imul SWORD PTR[esi]						; Multiply the current element by the user multiplier
	
	mov [esi], ax							; Put ax into the WORD array
	add esi, TYPE WORD						; Go to the next element
	loop maLoop1

	POPFD
	POPAD
	ret
multiplyArray ENDP


;***************************************************************
divideArray PROC
;	RECEIVES: Stack Var1: Divisor
;			  Stack Var2: Current array element
;	 RETURNS: Answer in EAX
;    [EBP + 8]  = Divisor
;	 [EBP + 12] = Current array element
;***************************************************************
.code
	push ebp								; Create the proc. anchor
	mov ebp, esp
	PUSHFD
	
;	*** Divide the element ***
	mov edx, 0								; Clear edx
	mov eax, [EBP + 12]						; Divisor
	cdq
	mov ebx, [EBP + 8]						; Current array element
	idiv ebx								; EAX now has the result

	POPFD
	pop ebp									; Remove the proc. anchor
	ret										; EAX = answer
divideArray ENDP


;*************************************************************
printArrayInt PROC, 
	arrayLength		: DWORD,
	arrayType		: DWORD,
	arrayOffset		: PTR DWORD
;*************************************************************
.data
	comma BYTE ", ", 0
.code
	PUSHAD
	PUSHFD

	mov ecx, arrayLength				; Move the named parameters into the registers
	mov ebx, arrayType
	mov esi, arrayOffset

	mov al, '['							; print the opening bracket of the array
	call WriteChar
	dec ecx								; dec ecx so you can print the last element without a comma

L2:
	movsx eax, SWORD PTR [esi]			; print the next value of the array
	call WriteInt						
	mov edx, OFFSET comma				; write the comma and space for the next value
	call WriteString
	add esi, ebx						; go to the next element
	loop L2								; end of the loop
	
	movsx eax, SWORD PTR [esi]			; print the last value of the array
	call WriteInt
	mov al, ']'							; print the last bracket and end the print function
	call WriteChar
	call CrlF

	POPFD
	POPAD

	ret
printArrayInt ENDP

END main