TITLE QuestionB.asm
;***************************************************************
; -Michael Buffone
; -October 24th, 2019
; -COSC2406A19F Assignment 4, Question B

; -This program will generate a random number between user input
;***************************************************************
INCLUDE Irvine32.inc

.data

prompt1 BYTE "Enter the lower range number: ", 0
prompt2 BYTE "Enter the higher range number: ", 0

lowNum DWORD 0
highNum DWORD 0
randomNum DWORD 0

;----------Main Code Section------------------------------------
.code
main PROC

	call Randomize										; Seed the random generator

mov ecx, 5
L1:
;	****** User I/O ******
	mov edx, OFFSET prompt1								; Print lowNum prompt
	call WriteString
	call ReadInt							
	mov ebx, eax										; Store lowNum in ebx
	
	mov edx, OFFSET prompt2								; Print highNum prompt
	call WriteString
	call ReadInt									

;	****** Call random function ******
	call BetterRandomRange								; eax = highNum, ebx = lowNum
	call WriteInt										; eax contains the random number
	call CrlF
	call CrlF
	loop L1

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