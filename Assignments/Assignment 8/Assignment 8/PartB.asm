TITLE PartB.asm
;***************************************************************
; -Michael Buffone
; -November 22th, 2019
; -COSC2406A19F Assignment 8, Question B

; -This program will create a 2D array and calculate column sum
;***************************************************************
INCLUDE Irvine32.inc

.data

; Constants
NUM_ROWS = 6
NUM_COLS = 8
array SWORD NUM_ROWS * NUM_COLS DUP(1)

; Prompts
userColumnMsg BYTE "Enter the column number to add: ", 0
userColumnSumMsg BYTE "The sum of the column is: ", 0

; Prototypes
;*************************************************************
SumColumnOfArray PROTO, 
	arrayOffset		: PTR SWORD,
	arrayRows		: DWORD,
	arrayCols		: DWORD,
	calcCol			: DWORD
;*************************************************************

;----------Main Code Section------------------------------------
.code
main PROC

	call Randomize												; Random seed

	call PopulateArray

	push NUM_COLS												; Push appropiate values for function call
	push NUM_ROWS
	push OFFSET array
	call PrintArray

	mov edx, OFFSET userColumnMsg								; User column I/O
	call WriteString
	call ReadInt
	invoke SumColumnOfArray, OFFSET array, NUM_ROWS, NUM_COLS, eax

	mov edx, OFFSET userColumnSumMsg							; Print sum information
	call WriteString
	call WriteInt

	call CrlF
	exit
main ENDP


;***************************************************************
PrintArray PROC 
;	RECEIVES: -Stack Var1 [EBP + 8] : Offset of the array
;			  -Stack Var2 [EBP + 12]: Number of rows in the array
;			  -Stack Var3 [EBP + 16]: Number of columns in the array
;	 RETURNS: Nothing
;***************************************************************

.code
	ENTER 0, 0													; Create proc. anchor
	pushad

	mov esi, [EBP + 8]											; esi = offset of array
	mov ecx, [EBP + 12]											; ecx = array row length
L1:
	push ecx
	mov edi, 0
	mov al, '|'													; Print | and a space
	call WriteChar	
	mov al, '	'											
	call WriteChar
	mov ecx, [EBP + 16]											; ecx = array column length
	dec ecx													
L2:
	movsx eax, SWORD PTR [esi + edi]							; Print every array[i][j] element at the current
	call WriteInt
	mov al, ','
	call WriteChar
	mov al, '	'
	call WriteChar
	add edi, TYPE SWORD											; Go to the next element
	loop L2														; Loop back to inner loop top

	movsx eax, SWORD PTR [esi + edi]							; Print the last item without a comma
	call WriteInt
	mov al, '	'											
	call WriteChar
	mov al, '|'													; Print |
	call WriteChar												
	call CrLf	
	add esi, edi												; esi = numCols * TYPE WORD
	pop ecx														; Restore outter loop
	loop L1														; Loop back to outter loop top
	call CrLf

	popad
	LEAVE
	ret
PrintArray ENDP


;*************************************************************
PopulateArray PROC USES eax ecx esi edi
;	RECEIVES: Nothing
;	 RETURNS: Nothing
;*************************************************************

.code
	mov esi, OFFSET array
	mov ecx, NUM_ROWS											; ecx = array row length
L1:
	push ecx
	mov edi, 0
	mov ecx, NUM_COLS											; ecx = array column length
L2:
	call BetterRandomRange
	mov [esi + edi], ax											; Store random int at array[i][j]

	add edi, TYPE SWORD											; Go to the next element
	loop L2														; Loop back to inner loop top

	add esi, edi												; esi = numCols * TYPE WORD
	pop ecx														; Restore outter loop
	loop L1														; Loop back to outter loop top
	call CrLf

	ret
populateArray ENDP


;*************************************************************
BetterRandomRange PROC USES ebx
;	RECEIVES: Nothing
;	 RETURNS: EAX = random number
;*************************************************************

.code
	mov eax, 100
	mov ebx, -100
	sub eax, ebx												; Subtract ebx from eax to get a negative number
	inc eax														; Increment eax to ensure inclusive range
	call RandomRange											; Returns a random number in the range in eax
	add eax, ebx												; Add the low range back to eax
	ret
BetterRandomRange ENDP


;*************************************************************
SumColumnOfArray PROC, 
	  arrayOffset	: PTR SWORD,
	  arrayRows		: DWORD,
	  arrayCols		: DWORD,
	  calcCol		: DWORD
;	 RETURNS: EAX = column sum
;*************************************************************
LOCAL rowLength    : DWORD
.code

	mov esi, arrayOffset										; Address of the array
	mov ebx, 0													; Zero out sum

;	*** Decrement arrayCols by 1 ***
	mov eax, arrayCols
	dec eax
	mov arrayCols, eax

;	*** Local variable defintion ***
	mov eax, arrayCols											; Move the amount of array columns into eax
	mov rowLength, eax											; Move the eax into rowLength twice
	add rowLength, eax

;	*** Traverse the 2D array to get to the corresponding column ***
	add esi, calcCol
	add esi, calcCol

;	*** Sum is in EBX ***
	mov ecx, arrayRows
L1:
	movsx eax, SWORD PTR[esi]									; Get the current element and move it in eax
	add ebx, eax												; Add the current element to ebx
	add esi, rowLength											; Go to the next element in the next row using rowLength
	loop L1

	mov eax, ebx												; Move ebx into eax
	ret
SumColumnOfArray ENDP

END main