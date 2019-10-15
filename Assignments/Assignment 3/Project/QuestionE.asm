TITLE QuestionE.asm
;***************************************************************
; -Michael Buffone
; -October 15th, 2019
; -COSC2406A19F Assignment 3, Question E

; -This program compute a fib sequence
;***************************************************************
INCLUDE Irvine32.inc

COMMENT !

public static void main(String[] args) {

		int f0 = 1;
		int f1 = 3; 
		int f2 = 2; 
		int f3 = 5; 
		int f4 = f3 + 2 * f0;
		
		for(int i = 5; i < 30; i++) {
				System.out.println(f0);
				f0 = f1;
				f1 = f2;
				f2 = f3;
				f3 = f4;
				f4 = f3 + 2 * f0;
		}
	}

END COMMENT !

.data

f0 DWORD 1										; base values of the algorithm
f1 DWORD 3
f2 DWORD 2
f3 DWORD 5
f4 DWORD 0

fibAmount DWORD 30

comma BYTE ", ", 0								; used for printing

;----------Main Code Section------------------------------------
.code
main PROC

;	int f4 = f3 + 2 * f0
	mov eax, f0									; 2 * f0
	add eax, f0
	add eax, f3									; add f3
	mov f4, eax									; move result into EAX

;	****** Loop for calculating sequence ******
;	-Shift each variable to be the next
	mov ecx, fibAmount
	dec ecx										; dec ECX so a comma isn't printed on the last value of the sequence
L1:
	mov eax, f0									
	mov edx, OFFSET comma					
	call WriteDec								; print the current value
	call WriteString							; print the comma and space

	mov eax, f1									; f0 = f1
	mov f0, eax

	mov eax, f2									; f1 = f2
	mov f1, eax

	mov eax, f3									; f2 = f3
	mov f2, eax

	mov eax, f4									; f3 = f4
	mov f3, eax

;	f4 = f3 + 2 * f0
	mov eax, f0									; 2 * f0
	add eax, f0
	add eax, f3									; add f3
	mov f4, eax									; move result into EAX

	loop L1

	mov eax, f4									; print the last value for the sequence
	call WriteDec
	call CrlF

main ENDP

END main