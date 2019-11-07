TITLE QuestionB.asm
;***************************************************************
; -Michael Buffone
; -November 4th, 2019
; -COSC2406A19F Assignment 5, Question B

; -This program will test if a value is a power of two by using
;  only shift or rotate operations to determine each bit
;***************************************************************
INCLUDE Irvine32.inc

.data

prompt BYTE "Enter a positive number: ", 0
binPrompt BYTE " -> binary : ", 0
powerTruePrompt BYTE " is a power of 2", 0
powerFalsePrompt BYTE " isn't a power of 2", 0


userNum DWORD 0

;----------Main Code Section------------------------------------
.code
main PROC
	PUSHFD
;	****** User I/O ******
	mov edx, OFFSET prompt								; Write prompt and read user num
	call WriteString
	call ReadInt
	mov userNum, eax
	
	mov edx, OFFSET binPrompt							; Write user num in binary with prompt
	mov eax, userNum
	call WriteDec
	call WriteString
	call WriteBin
	call CrlF

	call isPower										; Call the function
	jz itsAPower										; Jump if the zero flag is set

	mov edx, OFFSET powerFalsePrompt					; if(!itsAPower)
	call WriteDec										; Write the number
	call WriteString
	jmp continue

itsAPower:												; if(itsAPower)
	mov edx, OFFSET powerTruePrompt
	call WriteDec										; Write the number
	call WriteString

continue:
	call CrlF
	POPFD
	exit
main ENDP

;*************************************************************
isPower PROC USES EAX
; - If eax is a power of 2, there will only be a single '1' in eax	
;	RECEIVES: EAX = userNum
;	 RETURNS: ZF = 1 if userNum is a power of 2
;*************************************************************
.code

	mov ecx, 32											; Loop for the size of eax register
moveRight:
	cmp eax, 1											; if(eax == ....0001) set zero flag
	je setFlag
	ror eax, 1											; else rotate it to the right one
	loop moveRight
	jmp finish											; eax is not a power of 2, jump to finish

setFlag:
	test eax, 0											; Set zero flag to one

finish:
	ret
isPower ENDP

END main