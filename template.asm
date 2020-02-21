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
sorted	DWORD	ARRAYSIZE
step	DWORD	0	; tells you what step you are in

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

; HOLY SHIT THIS WILL BE LONG. But, leggo yo. 

	
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
mov		step, 0
call	random		; 0
call	write
call	sortList


exit	; exit to operating system
main ENDP
;	
random PROC
cmp		step, 0
ja		body
push	OFFSET list		; 4
push	count		; 8
mov		step, random
call	iterate	; 12
jmp		ending

body:

mov eax,HI ;31
sub eax,LO ;31-18 = 13
inc eax ;14
call RandomRange ;eax in [0..13]
add eax,LO ;eax in [18..31]
mov	[esi], eax


ending:
ret
random	ENDP




iterate PROC
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

write	PROC
cmp		step, 0 ; each proc compares step to 0, the first time it's called, it goes to itera
ja		body
mov		edx, 20
push	OFFSET list
push	count
mov		step, write
call	iterate
mov		step, 0
jmp		ending

body:
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
ret
write	ENDP

sortList	PROC
cmp		step, 0
ja		body
mov		edx, 0
mov		ebx, OFFSET	sorted
push	OFFSET list		; 4
push	count		; 8
mov		step, sortList
call	iterate	; 12
mov		step, 0
jmp		ending

body:




ending:
ret

sortList	ENDP



; (insert additional procedures here)

END main
