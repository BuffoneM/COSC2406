TITLE PartA.asm
;***************************************************************
; -Michael Buffone
; -November 20th, 2019
; -COSC2406A19F Assignment 7

; -This program will read an edge length and utilize FPU
;***************************************************************
INCLUDE Irvine32.inc

.data

; Constants
one DWORD 1
two DWORD 2
three DWORD 3
four DWORD 4
five DWORD 5
ten DWORD 10
eleven DWORD 11
twFive DWORD 25
twNine DWORD 29
thirty DWORD 30
sixty DWORD 60

; Data
edgeLength					REAL4 ?
rhomArea					REAL4 ?
rhomVolume					REAL4 ?
circumRad					REAL4 ?
midsphereRad				REAL4 ?
outterSphereVolume			REAL4 ?
innerSphereVolume			REAL4 ?

; Square roots
rootThree					REAL4 ?		; root(3)
rootFive					REAL4 ?		; root(5)
areaRoot					REAL4 ?		; root(25 + 10*root(5))
circumRoot					REAL4 ?		; root(11 + 4*root(5))
midsphereRoot				REAL4 ?		; root(10 + 4*root(5))

; Prompts
invalidLengthMsg			BYTE "Enter a positive edge length... ", 0
edgeLengthMsg				BYTE "Enter the length of an edge (0 = exit) : ", 0
rhomAreaMsg					BYTE "Area of rhombicosidodecahedron         : ", 0
rhomVolumeMsg				BYTE "Volume of rhombicosidodecahedron       : ", 0
circumRadMsg				BYTE "Circumsphere radius                    : ", 0
midsphereRadMsg				BYTE "Midsphere radius                       : ", 0
outterSphereVolumeMsg		BYTE "Volume of outter sphere                : ", 0
innerSphereVolumeMsg		BYTE "Volume of inner sphere                 : ", 0

;----------Main Code Section------------------------------------
.code
main PROC

;	****** User I/O ******
mainL1:
	mov edx, OFFSET edgeLengthMsg				; Print msg and collect edge length
	call WriteString
	call ReadFloat

;	*** Comparing the user input ***
	FLDZ
	FCOMP
	FNSTSW ax
	SAHF
	je endProgram								; if(float == 0) exit
	ja negativeEntered							; if(float < 0) jmp to label

	FSTP edgeLength								; Pop and store the stack in the var
	call calculateEverything
	call CrlF

	jmp mainL1

negativeEntered:
	FFREE st(0)									; Remove the negative number off the stack
	mov edx, OFFSET invalidLengthMsg			; Print invalid length msg
	call WriteString
	call CrlF
	call CrlF
	jmp mainL1

endProgram:	
	FFREE st(0)									; Remove the zero off the stack
	call showFPUstack
	exit

main ENDP


;***************************************************************
calculateEverything PROC
;	RECEIVES: Nothing
;	 RETURNS: Nothing
;***************************************************************
.code

;	****** Calculate initial square roots ******
;	*** root(3) ***
	FILD three									; Load 3
	FSQRT
	FSTP rootThree								; Store root answer

;	*** root(5) ***
	FILD five									; Load 5
	FSQRT
	FSTP rootFive								; Store root answer

;	*** root(25 + 10*root(5)) ***
	FILD ten									; Load 10
	FMUL rootFive								; Multiply root 5
	FILD twFive									; Load 25
	FADD										; Add 25 to the 10*root(5)
	FSQRT										; Root the result
	FSTP areaRoot								; Store the root(result) in areaRoot

;	*** root(11 + 4*root(5)) ***	
	FILD four									; Load 4
	FMUL rootFive								; Multiply root 5
	FILD eleven									; Load 11
	FADD										; Add 11 to the 4*root(5)
	FSQRT										; Root the result
	FSTP circumRoot								; Store the root(result) in circumRoot

;	*** root(10 + 4*root(5)) ***	
	FILD four									; Load 4
	FMUL rootFive								; Multiply root 5
	FILD ten									; Load 10
	FADD										; Add 10 to the 4*root(5)
	FSQRT										; Root the result
	FSTP midsphereRoot							; Store the root(result) in midsphereRoot

;	****** Call calculation functions ******
	call calcRhomArea
	call calcRhomVol
	call calcCircumRad
	call calcMidsphereRad
	call calcOutterSphereVol
	call calcInnerSphereVol

;	****** Write the output ******
	mov edx, OFFSET rhomAreaMsg					; Write and print rhomArea information
	call WriteString
	FLD rhomArea
	call WriteFloat
	call CrlF
	FFREE st(0)

	mov edx, OFFSET rhomVolumeMsg				; Write and print rhomVolume information
	call WriteString
	FLD rhomVolume
	call WriteFloat
	call CrlF
	FFREE st(0)

	mov edx, OFFSET circumRadMsg				; Write and print circumRad information
	call WriteString
	FLD circumRad
	call WriteFloat
	call CrlF
	FFREE st(0)

	mov edx, OFFSET midsphereRadMsg				; Write and print midsphereRad information
	call WriteString
	FLD midsphereRad
	call WriteFloat
	call CrlF
	FFREE st(0)

	mov edx, OFFSET outterSphereVolumeMsg		; Write and print outterSphereVolume information
	call WriteString
	FLD outterSphereVolume
	call WriteFloat
	call CrlF
	FFREE st(0)

	mov edx, OFFSET innerSphereVolumeMsg		; Write and print outterSphereVolume information
	call WriteString
	FLD innerSphereVolume
	call WriteFloat
	call CrlF
	FFREE st(0)

	ret
calculateEverything ENDP


;***************************************************************
calcRhomArea PROC
;	RECEIVES: Nothing
;	 RETURNS: Answer in rhomArea
;***************************************************************
.code
;	5 * root(3)
	FILD five									; Load 5
	FMUL rootThree								; 5 * root(3)

;	3 * areaRoot
	FILD three									; Load 3
	FLD areaRoot								; Load areaRoot
	FMUL										; Multiply st(0), st(1)

;   30 + 5*root(3) + 3 * areaRoot
	FILD thirty									; Load 30 and add the entire stack together
	FADD	
	FADD

;	Stack answer * edgeLength^2
	FLD edgeLength								; Load the edge length twice
	FLD edgeLength
	FMUL										; Square the edge length
	FMUL										; Multiply the stack answer by the edge^2
	FSTP rhomArea								; Store the result in rhomArea

	ret
calcRhomArea ENDP


;***************************************************************
calcRhomVol PROC
;	RECEIVES: Nothing
;	 RETURNS: Answer in rhomVolume
;***************************************************************
.code
;	60 + 29 * root(5)
	FILD twNine									; Load 29
	FMUL rootFive								; 29 * root(5)
	FILD sixty									; Load 60
	FADD										; Add the answer

;	1 / 3 * result
	FILD one									; Load 1
	FILD three									; Load 3
	FDIV										; 1 / 3 * result
	FMUL										

;	Result * edgeLength^3
	FLD edgeLength								; Load edgeLength 3 times
	FLD edgeLength
	FLD edgeLength
	FMUL										; edgeLength ^ 2
	FMUL										; edgeLength ^ 3
	FMUL										; Result  * edgeLength ^ 3
	FSTP rhomVolume								; Store the result in rhomVolume

	ret
calcRhomVol ENDP


;***************************************************************
calcCircumRad PROC
;	RECEIVES: Nothing
;	 RETURNS: Answer in circumRad
;***************************************************************
.code
;	1 / 2 * edgeLength * circumRoot
	FILD one									; Load 1
	FILD two									; Load 2
	FDIV										; 1 / 2
	FLD edgeLength								; Load edge length
	FMUL										
	FLD circumRoot								; Load the circumRoot
	FMUL										
	FSTP circumRad								; Store the result in circumRad

	ret
calcCircumRad ENDP


;***************************************************************
calcMidsphereRad PROC
;	RECEIVES: Nothing
;	 RETURNS: Answer in midsphereRad
;***************************************************************
.code
;	1 / 2 * edgeLength * midsphereRoot
	FILD one									; Load 1
	FILD two									; Load 2
	FDIV										; 1 / 2
	FLD edgeLength								; Load edge length
	FMUL
	FLD midsphereRoot							; Load the midsphereRoot
	FMUL
	FSTP midsphereRad							; Store the result in midsphereRad

	ret
calcMidsphereRad ENDP


;***************************************************************
calcOutterSphereVol PROC
;	RECEIVES: Nothing
;	 RETURNS: Answer in sphereVolume
;***************************************************************
.code
;	4 / 3 * pi * r^3
	FILD four									; Load 4
	FILD three									; Load 3
	FDIV										; 4 / 3
	FLDPI										; Load pi
	FMUL										; 4 / 3 * pi
	FLD circumRad								; Load circumRad^3 onto stack
	FLD circumRad
	FLD circumRad

	FMUL										; Calculate circumRad^2
	FMUL										; Calculate circumRad^3
	FMUL										; Calculate 4 / 3 * pi * circumRad^3

	FSTP outterSphereVolume						; Store the result in outterSphereVolume

	ret
calcOutterSphereVol ENDP


;***************************************************************
calcInnerSphereVol PROC
;	RECEIVES: Nothing
;	 RETURNS: Answer in sphereVolume
;***************************************************************
.code
;	4 / 3 * pi * r^3
	FILD four									; Load 4
	FILD three									; Load 3
	FDIV										; 4 / 3
	FLDPI										; Load pi
	FMUL										; 4 / 3 * pi
	FLD midsphereRad							; Load midsphereRad^3 onto stack
	FLD midsphereRad
	FLD midsphereRad

	FMUL										; Calculate midsphereRad^2
	FMUL										; Calculate midsphereRad^3
	FMUL										; Calculate 4 / 3 * pi * midsphereRad^3

	FSTP innerSphereVolume						; Store the result in innerSphereVolume

	ret
calcInnerSphereVol ENDP

END main