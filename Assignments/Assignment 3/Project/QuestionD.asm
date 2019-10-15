TITLE QuestionD.asm
;***************************************************************
; -Michael Buffone
; -October 11th, 2019
; -COSC2406A19F Assignment 3, Question D

; -This program will create an array of 10 DWORD values,
;  populate the array with user defined values, and rotate the
;  array's values by 1 index to the right
;***************************************************************
INCLUDE Irvine32.inc

; Java program for the algorithm used
COMMENT !
public static void main(String[] args) {

		int[] array = {1,2,3,4,5};
		System.out.println(Arrays.toString(array));
		
		int prevNum = array[0];
		for(int i = 1; i < array.length; i++) {
			int prevNum2 = array[i];
			array[i] = prevNum;
			prevNum = prevNum2;
		}
		array[0] = prevNum;
		System.out.println(Arrays.toString(array));
	}
END COMMENT !

.data
array DWORD 10 DUP(?)

prompt BYTE "Enter a number: ", 0

prevNum DWORD 0									; Used when re-indexing the array

comma BYTE ", ", 0


;----------Main Code Section------------------------------------
.code
main PROC

	mov edi, OFFSET array						; EDI = address of the array
	mov esi, OFFSET array						; Used for printArray function
	mov ebx, TYPE array							; Move the number of bytes for the array type = 4 bytes (DWORD)
	mov ecx, LENGTHOF array						; Loop for the length of the array

;	****** User I/O Into the Array ******
L1:
	mov edx, OFFSET prompt						; Print user input statement
	call WriteString
	call ReadInt
	mov [edi], eax								; Store the inputted value into edi
	add edi, ebx								; Proceed to the next index
	loop L1
	call CrlF


;	****** Re-index the Array ******
	mov edi, OFFSET array						; EDI = address of the array
	mov ecx, LENGTHOF array						; ECX = amount of elements in the array
	
	mov eax, [edi]								; Store array[0] in prevNum
	mov prevNum, eax
	add edi, ebx								; Go to the next element
	dec ecx
L2:
	mov eax, [edi]								; Move array[i] into eax (the upcoming number)
	mov edx, prevNum
	mov [edi], edx								; Set the current value in the array to the previous number
	mov prevNum, eax							; Set the prevNum to be the next number to be moved over (eax)
	add edi, ebx								; Go to the next element
	loop L2

	mov edi, OFFSET array						; EDI = address of the array
	mov edx, prevNum
	mov [edi], edx								; Move the last prevNum (last number in the array) to be the first element in the array

;   ****** Print the final array ******
	mov esi, OFFSET array
	mov ebx, TYPE array
	mov ecx, LENGTHOF array	

;   ****** Print array ******
;	RECEIVES: ESI = offset of the source array
;			  EBX = type of the source
;			  ECX = number of elements in the source
;	*************************************************************
	mov al, '['									; print the opening bracket of the array
	call WriteChar
	dec ecx										; decrease the loop amount of ecx by one so you can print the last elements without a comma

L3:
	mov ax, [esi]								; print the next value of the array into ax
	call WriteInt						
	mov edx, OFFSET comma						; write the comma and space for the next value
	call WriteString
	add esi, ebx								; go to the next element
	loop L3										; end of the loop
	
	mov ax, [esi]								; print the last value of the array into ax
	call WriteInt
	mov al, ']'									; print the last bracket and end the print function
	call WriteChar
	call CrlF
	call CrlF

	exit
main ENDP

END main