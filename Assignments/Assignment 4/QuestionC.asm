TITLE QuestionC.asm
;***************************************************************
; -Michael Buffone
; -October 24th, 2019
; -COSC2406A19F Assignment 4, Question C

; -This program will collect a character and text / background
;  colour from the user, print the first char with that 
;  colour scheme followed by random colours / positions
;***************************************************************
INCLUDE Irvine32.inc

.data

prompt1 BYTE "Enter a character to print: ", 0
prompt2 BYTE "Enter a starting background colour (0-15): ", 0
prompt3 BYTE "Enter a starting foreground colour (0-15): ", 0
testPrompt BYTE "=======================================", 0

userChar BYTE 0
foreColour BYTE 0
backColour BYTE 0


;----------Main Code Section------------------------------------
.code
main PROC
	call Randomize										; Seed the random generator

	mov eax, 15

;	****** User I/O ******
;	-The colours are 0-15 in bytes meaning they will be 0000 xxxx
	mov edx, OFFSET prompt1								; Print char prompt
	call WriteString
	call ReadChar
	call WriteChar
	mov userChar, al									; Store the character in userChar
	call CrlF

	mov edx, OFFSET prompt2								; Print background prompt
	call WriteString
	call ReadInt									
	mov backColour, al									; Store the byte in backColour

	mov edx, OFFSET prompt3								; Print foreground prompt
	call WriteString
	call ReadInt									
	mov foreColour, al									; Store the byte in foreColour

	mov edx, OFFSET testPrompt
	call WriteString
	call CrlF

;	*** Set text colours function ***
	call SetConsoleColours

;	****** Place the character at 500 locations ******
	mov ebx, 0											; The lowest possible range for X and Y, and colour is 0
	mov ecx, 500
L1:
	call GetMaxXY										; AX = num of rows, DX = number of columns
	call BetterRandomRange
	mov edx, eax

	call Gotoxy											; Go to the random location
	mov al, userChar									; Print the user's char
	call WriteChar

;	*** Generate random colours ***
	mov eax, 15											; 15 random colours
	call BetterRandomRange								; Generate a random number
	mov foreColour, al									; Move the random number into foreColour

	mov eax, 15
	call BetterRandomRange
	mov backColour, al

	call SetConsoleColours

;	*** Delay the loop ***
	mov eax, 200										; Delay by 1/5th of a second
	call Delay

	loop L1

	exit
main ENDP


;*************************************************************
SetConsoleColours PROC
;	RECEIVES: Nothing (Data is all in variables)
;	 RETURNS: Nothing
;	  SCHEMA: -Prepare eax for SetTextColor function
;			  -STC requires ----~~~~ -> backColour, foreColour
;*************************************************************

.code
	PUSH ecx

;	****** Change backColour from 0000 xxxx to xxxx 0000 ******
	mov al, backColour
	mov ecx, 15
;	imul eax, 16 ->	but we're not allowed to use imul so add eax 16 times
L2:	
	add al, backColour
	loop L2									
;	EAX now contains xxxx 0000

;	*** OR EAX with foreColour ***
	OR al, foreColour									; EAX = .... 0000 xxxx yyyy

;	*** Call the function ***
	call SetTextColor			
	
	POP ecx

	ret
SetConsoleColours ENDP


;*************************************************************
BetterRandomRange PROC
;	RECEIVES: EAX = high random num
;			  EBX = low random num
;	 RETURNS: EAX = random number
;*************************************************************

.code
	
	sub eax, ebx										; Subtract ebx from eax to get a negative number
	inc eax												; Increment eax to ensure inclusive range
	call RandomRange									; Returns a random number in the range in eax
	add eax, ebx										; Add the low range back to eax

	ret
BetterRandomRange ENDP

END main