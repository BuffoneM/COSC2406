TITLE QuestionC.asm
;***************************************************************
; -Michael Buffone
; -October 24th, 2019
; -COSC2406A19F Assignment 4, Question C

; -This program will collect a character and text / background
;  colour from the user, and perform operations on with them
;***************************************************************
INCLUDE Irvine32.inc

.data

prompt1 BYTE "Enter a character to print: ", 0
prompt2 BYTE "Enter a starting foreground colour (0-15): ", 0
prompt3 BYTE "Enter a starting background colour (0-15): ", 0

userChar BYTE 0
foreColour BYTE 0
backColour BYTE 0


;----------Main Code Section------------------------------------
.code
main PROC

;	****** User I/O ******
	mov edx, OFFSET prompt1								; Print char prompt
	call WriteString
	call ReadChar										
	mov userChar, al									; Store the character in userChar

	mov edx, OFFSET prompt2								; Print foreground prompt
	call WriteString
	call ReadInt									
	mov foreColour, al									; Store the byte in foreColour

	mov edx, OFFSET prompt3								; Print background prompt
	call WriteString
	call ReadInt									
	mov backColour, al									; Store the byte in backColour

;	****** Set colours ******
	mov ah, backColour
	mov al, foreColour
	call SetTextColor

	exit
main ENDP

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