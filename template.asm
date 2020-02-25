TITLE Program Template     (template.asm)

; Author:
; Last Modified:
; OSU email address: 
; Course number/section:
; Project Number:                 Due Date:
; Description:

INCLUDE Irvine32.inc

LO = 10
HI = 29
ARRAYSIZE = 200


; (insert constant definitions here)

.data

list	DWORD	ARRAYSIZE DUP (?)
count	DWORD	ARRAYSIZE
blank	DWORD	'  ', 0
sorted	BYTE	"Here is the array as a sorted array", 0


; (insert variable definitions here)




; Introduction

; FIll array
	; generate an array of ARRAYSIZE integers, this'll be 200
	; they are all random between LOW and HIGH
	; use iterateList, then each thing list gives you, give it a random
	; number 
	

; sortList
	; will have another array with blank 200, then, iterate through unsorted
	; array, take value, iterate through sorted array, update count, update count,
	; I think it should be fine

	; exchangeElements
	; this is where I'll have most of the meat happen

; displayMedian
	; iterate list, except each return gets added, 
	; then at end divide

; displayList
	; iterate through list, except each term displayed, 
	; this will just be displaying your list

; countList
	; iterate through list, each time thing is shown, put it
	; into other array, I guess just put it in OFFSET of like 10
	; is 0 so you'll be able to math that out, at the end, display
	; it

; iterateList
	; I'm thinking I'll have a proc that basically just starts at the 
	; array, and goes through it, and then when it gets the next value
	; it passes it to my other calls like count list or display median,
	; and then those things will do to the array what is needed.

;WOWEE WOW THIS WILL BE LONG. But, leggo yo. 

	
; what this does, is it takes the list pointer, 
; puts ecx to counter, then edx is the pointer element
; then it goes into a loop where it looks at each element
; in the array and prints it out, until it gets to the end of 
; whats in counter. 

; WHAT you've gotta do
; generate an array of ARRAYSIZE integers, this'll be 200
; they are all random between LOW and HIGH
; display integers before sorting
;	I'm thinking for this, I'll use this display PROC but
;	modify it so that it just fills the array, then 
;	have another proc that actually goes through it all
;	and then prints every value instead of putting a random
;	int in it
;sort the list in ascended order
;	now this will be tough, I'm thinking, go through array,
;	with the same display proc: Note, I'll just turn it into
;	an array iteration proc. Or just copy paste code. But
;	take a number, do the iterate array, if it's less than 
;	push it that step + 4, and then at the end you can just

.code
main PROC
push	OFFSET list		; 4
push	count
call	random
push	OFFSET list
push	count
push	20
call	write
push	OFFSET list		; 4
push	count
call	sortList
push	OFFSET list
push	count
push	20
call	write
; call	sortList



exit	; exit to operating system
main ENDP
;	
random PROC
push ebp
mov ebp,esp
mov esi,[ebp+12] ;@list
mov ecx,[ebp+8] ;ecx is loop control
randomLoop:
mov eax,HI ;31
sub eax,LO ;31-18 = 13
inc eax ;14
call RandomRange ;eax in [0..13]
add eax,LO ;eax in [18..31]
mov	[esi], eax
add esi,4 ;next element
loop randomLoop
RandomEnd:
pop ebp
ret 8

random	ENDP


COMMENT #

; iterate PROC
push ebp
mov ebp,esp
mov esi,[ebp+12] ;@list
mov ecx,[ebp+8] ;ecx is loop control
more:
mov eax,[esi] ;get current element
call step ; 16
add esi,4 ;next element
loop more
endMore:
mov	step, 0	; at the end of the loopz
pop ebp
ret 8
iterate ENDP
#

write	PROC

push ebp
mov ebp,esp
mov esi,[ebp+16] ;@list
mov ecx,[ebp+12] ;ecx is loop control
mov	edx,[ebp+8]	 ; edx counts how many spaces

writeLoop:
mov eax,[esi] ;get current element
push	edx ; so we can use it for write
mov		edx, OFFSET blank
call	WriteString
call	WriteDec
pop		edx	; so we use it for main function, iteration
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
; at the end of the loopz
pop ebp
ret 12
write	ENDP



sortList	PROC

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
call	CrLf
mov		edx, OFFSET sorted
call	WriteString
call	CrLf

pop ebp
ret 8


sortList	ENDP

exchangeElements	PROC
push	eax
push	esi

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





; (insert additional procedures here)

END main
