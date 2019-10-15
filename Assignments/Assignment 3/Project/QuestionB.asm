TITLE QuestionB.asm
;***************************************************************
; -Michael Buffone
; -October 11th, 2019
; -COSC2406A19F Assignment 3, Question B

; -This program will create NUM, two arrays where their size
;  is based on NUM, and compute operations
;***************************************************************
INCLUDE Irvine32.inc

.data

num DWORD 4
wArray SWORD 4 DUP(0)
dwArray SDWORD 4 DUP(0)

prompt BYTE "Enter a signed integer: ", 0
wArrayTxt BYTE "WORD array:  ", 0
dwArrayTxt BYTE "DWORD array: ", 0


;----------Main Code Section------------------------------------
.code
main PROC

;	****** User I/O into the array ******
	mov edi, OFFSET wArray				; memory location of the array
	mov ebx, TYPE wArray				; the amount of bytes per index
	mov ecx, LENGTHOF wArray			; the length of the array
L1:
	mov edx, OFFSET prompt				; print the prompt and collect the user's input
	call WriteString
	call ReadInt

	mov [edi], eax						; store EAX into the value at the array
	add edi, ebx						; go to the next array index
	loop L1


;	****** Copy each value in wArray into dwArray ******
	mov edx, OFFSET wArray				; address of word array
	mov eax, TYPE wArray				; amount of bytes per index for the word array
	mov edi, OFFSET dwArray
	mov ebx, TYPE dwArray
	mov ecx, LENGTHOF dwArray			; both arrays have the same length
L2:
	mov esi, [edx]
	mov [edi], DWORD PTR esi			; add the BYTE at the current index into the DWORD array
	add edi, ebx						; go to the next element of the dWORD array
	add edx, eax						; go to the next element of the WORD array
	loop L2
	
; Print the WORD array
	mov esi, OFFSET wArray				; move appropiate values to the registers for printArray
	mov ebx, TYPE wArray
	mov ecx, LENGTHOF wArray
	call CrlF
	
	mov edx, OFFSET wArrayTxt			; call word array text statement
	call WriteString
	call printArray

; Print the DWORD array
	mov esi, OFFSET dwArray				; move appropiate values to the registers for printArray
	mov ebx, TYPE dwArray
	mov ecx, LENGTHOF dwArray

	mov edx, OFFSET dwArrayTxt			; call dword array text statement
	call WriteString
	call printArray
	
	exit
main ENDP

;*************************************************************
printArray PROC USES ecx ebx esi
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

L1:
	movsx eax, WORD PTR[esi]			; print the next value of the array into ax
	call WriteInt						
	mov edx, OFFSET comma				; write the comma and space for the next value
	call WriteString
	add esi, ebx						; go to the next element
	loop L1								; end of the loop
	
	movsx eax, WORD PTR[esi]			; print the last value of the array into ax
	call WriteInt
	mov al, ']'							; print the last bracket and end the print function
	call WriteChar
	call CrlF
	ret
printArray ENDP

END main

