TITLE Counting and Sorting Random Integers     (randomArray.asm)

; Author: Daniel Dubisz
; Last Modified: 3/1/2020
; OSU email address: dubiszd@oregonstate.edu
; Course number/section: 271
; Project Number: 5                Due Date: 3/2/2020
; Description: Program that creates an array of random integers,
; displays them, then displays median, then sorts and displays,
; then displays an array of how many times each value is in the array.

INCLUDE Irvine32.inc

LO = 10
HI = 29
ARRAYSIZE = 200




.data

list	DWORD	ARRAYSIZE DUP (?)
count	DWORD	ARRAYSIZE
blank	DWORD	'  ', 0 ; spaces between numbers
counts	DWORD	20 DUP (0) ; array of times each int is in list
author	BYTE	"Programmed by Daniel", 0
pTitle	BYTE	"Counting and Sorting Random Integers				", 0
note	BYTE	"This program generates 200 random numbers in the range [10 ... 29], displays the original list, sorts the list, displays the median value, displays the list sorted in ascending order, then displays the number of instances of each generated value.", 0
sorted	BYTE	"Your sorted random numbers: ", 0
unsort	BYTE	"Your unsorted random numbers: ", 0
med		BYTE	"List Median: ", 0
inst	BYTE	"Your list of isntances of each generated number, starting with the number of 10's: ", 0
bye		BYTE	"Goodbye, thanks for utilizing this! ", 0





.code
main PROC
call	Randomize ; seeds random generator
push	OFFSET note
push	OFFSET author
push	OFFSET pTitle
call	greeting
push	OFFSET unsort
push	HI
push	OFFSET list		
push	count
call	random
push	OFFSET blank
push	OFFSET list
push	count
push	20	; uses to keep track of when to put new line
call	write
push	OFFSET list		
push	count
call	displayMedian
push	OFFSET list		
push	count
call	sortList
push	OFFSET blank
push	OFFSET list
push	count
push	20
call	write
push	OFFSET list
push	count
push	OFFSET counts
call	countList
push	OFFSET counts
push	20	
push	20
call	write
call	goodBye

; call	sortList



exit	; exit to operating system
main ENDP

;Procedure to introduce the program.
;receives: none
;returns: none
;preconditions:  none
;registers changed: edx
greeting PROC

mov		pop edx
call	WriteString
mov		pop edx
call	WriteString
call	CrLf
mov		pop edx
call	WriteString
call	CrLf
call	CrLf

ret

greeting ENDP
;Procedure to fill list with random ints, creates stack to do so
;receives: list, count passed onto stack
;returns: list filled with random ints
;preconditions:  HI and LO must have ints of the range you want you array to be filled with
; count must have the size of the array. 
;registers changed: edx, esp, esi holds list, ecx holds count, eax holds various ints 

random PROC
mov	 edx [ebp+20]
call WriteString
call CrLf
push ebp
mov ebp,esp
mov esi,[ebp+12] ;@list
mov ecx,[ebp+8] ;ecx is loop control
; works cited: 
; powerpoint slide on randomRange from lectures
randomLoop:
mov	eax, [ebp+16]
sub eax,LO ;31-18 = 13
inc eax ;14
call RandomRange ;eax in [0..13]
add eax,LO ;eax in [18..31]
mov	[esi], eax
add esi,4 ;next element
loop randomLoop
RandomEnd:
pop ebp
ret 16

random	ENDP

;Procedure to print out values in an array, creates stack to do so
;receives: array(what we iterate through), count (how large the array is), and 20, to see when we need a new line
;returns: none, prints out each item in array pushed on and returns stack
;preconditions:  all things recieved must be pushed on before hand. 
;registers changed: edx, esi, ecx

write	PROC

push ebp
mov ebp,esp
mov esi,[ebp+16] ;@list
mov ecx,[ebp+12] ;ecx is loop control
mov	edx,[ebp+8]	 ; edx counts how many spaces

writeLoop:
cmp		edx, 20 ; if first number, no space
je		noSpace
push	edx ; so we can use it for write
mov		edx, [ebp+20]
call	WriteString
pop		edx	; so we use it for main function, iteration
noSpace:
mov eax,[esi] ;get current element
call	WriteDec
dec		edx
cmp		edx, 0
je		space
jmp		ending

space:
mov		edx, 20
call	CrLf

ending:
add esi,4 ;next element
loop writeLoop
writeEnd:
; at the end of the loop
pop ebp
ret 12
write	ENDP

;Procedure to sort the array given, creates stack to do so
;receives: list, count
;returns: sorted array that it was given.
;preconditions: random PROC must have been called, or it will be an empty array.
;registers changed: edx, eax, esi, ecx

sortList	PROC
mov		edx, OFFSET sorted
call	WriteString
call	CrLf
push ebp
mov ebp,esp
mov esi,[ebp+12] ;@list
mov ecx,[ebp+8] ;ecx is how far up to go
add	esi, 4		; starts on the second element
mov	eax, 1 ; eax will be counter
sortLoop:
cmp		eax, ecx	; if we've gone through, it's done sorting
jge		endSort
call	exchangeElements
inc		eax
add		esi,4 ;next element
jmp	sortLoop
endSort:


pop ebp
ret 8


sortList	ENDP

;Procedure to take the number given from sortList and put it in the correct spot in list
;receives: esi from calling procedure sortList
;returns: pops eax and esi back before returing, to be used by sortList more
;preconditions:  sortList must have been called
;registers changed: edx, ebx, eax, esi

exchangeElements	PROC
push	eax ; save eax, esi to be used by calling proc later
push	esi


; works cited: 
; gnome sort from http://www.miguelcasillas.com/?mcportfolio=sorting-algorithms-asm-x86
exchangeLoop:
mov		ebx, [esi] ; put current value in ebx
mov		edx, [esi-4] ; put value before in edx
cmp		eax, 0
je		endExchange

cmp	edx, ebx
jge	switch
jmp	endExchange

switch:
mov		[esi], edx
mov		[esi-4], ebx
dec		eax
sub		esi, 4
jmp		exchangeLoop

endExchange:
pop		esi
pop		eax
ret 

exchangeElements	ENDP

;Procedure to create a stack, loop through list and find the median of the values in that array
;receives: list, count
;returns: prints out median and then returns
;preconditions:  list and count must be set
;registers changed: edx, esi, eax, ebx

displayMedian		PROC
push ebp
mov ebp,esp
mov esi,[ebp+12] ;@list
mov ecx,[ebp+8] ;ecx is loop control
mov	eax, 0	; getting the median

more:
mov edx,[esi] ;get current element
add	eax, edx ; add number and divide by 200 later
add esi,4 ;next element
loop more
endMore:

mov		ebx, ARRAYSIZE
xor		edx, edx
div		ebx
call	CrLf
mov		edx, OFFSET med
call	WriteString
call	WriteDec	; shows median
call	CrLf

pop ebp
ret 8

displayMedian		ENDP

;Procedure to create stack, go through list, see how many times each int shows up,
; and then increments that point in counts. i.e, if there is a 10 in list, then counts[0] would increase by 1, and so on...
;receives: list, count, counts
;returns: counts array is now holding how many times each value appears in list
;preconditions:  random proc must have already been run
;registers changed: edx, eax, esi, ecx, 
countList			PROC
call CrLf
mov	edx, OFFSET inst
call WriteString
call CrLf
push ebp
mov ebp,esp
mov esi,[ebp+16] ;@list
mov ecx,[ebp+12] ;ecx is loop control

more:
mov edx,[esi] ;get current element
push esi ; saves esi
mov  esi, [ebp+8] ; move esi to counts
sub	edx, 10	; grabs number between 0 and 18
imul edx, 4 ; multiplies it by 4
mov	eax, [esi + edx] ; that is the spot on the array we increment
inc	eax
mov [esi + edx], eax
pop	esi ; gives back esi to keep looping through array
add esi,4 ;next element
loop more

endMore:
pop ebp
ret 12

CountList			ENDP

;Procedure to say goodbye to user
;receives: none
;returns: none
;preconditions:  none
;registers changed: edx
goodBye		PROC
call	CrLf
call	CrLf
call	CrLf
mov		edx, OFFSET bye
call	WriteString

ret
goodBye		ENDP





END main
