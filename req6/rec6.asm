      .386
      .model flat, stdcall  ; 32 bit memory model
      option casemap :none  ; case sensitive


	

;__________________________________________________________________
; Includes
;¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
			
	includelib kernel32.lib
	includelib imsvcrt.lib

;__________________________________________________________________
;  MSVCRT/KERNEL32 LIBRARY FUNCTION PROTOYPES
;¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯

ExitProcess	PROTO	:DWORD		
printf		PROTO C	:DWORD,:VARARG	;<--- because printf has varying number of parameters
gets		PROTO C :DWORD
strlen		PROTO C :DWORD
;__________________________________________________________________
;  USER DEFINED FUNCTION PROTOTYPES
;¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯

UpperCaseStr	PROTO	:DWORD,:DWORD
LowerCaseStr	PROTO	:DWORD,:DWORD

MyStrCmp	PROTO	:DWORD,:DWORD,:DWORD
GetInputs	PROTO	
GetLength	PROTO

;__________________________________________________________________
;  DATA STORAGE
;¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯


.data
invalid1		db	'Insufficient input!...',0
szMainStr		db	'Enter Main-String:',0
szSubStr		db	'Enter Sub-String:',0

len_inputMainStr	dd	?
len_inputSubStr		dd	?



InputMainStr		db	100 dup(0)
InputSubStr		db	100 dup(0)
;__________________________________________________________________
;  EntryPoint....
;¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
									

.code

start:
			invoke	GetInputs
			cmp	eax,0
			jz	exit_program

			invoke	LowerCaseStr,addr InputMainStr,len_inputMainStr

			mov	esi,len_inputMainStr
			mov	edi,len_inputSubStr

			sub	ebx,ebx

		cmploop:
			
			mov	edx,offset InputMainStr
			add	edx,ebx
			invoke	MyStrCmp,edx,addr InputSubStr,len_inputSubStr

			cmp	eax,0
			jne	fnd
			

			mov	ecx,offset InputMainStr
			add	ecx,ebx

			invoke	UpperCaseStr,ecx,len_inputSubStr


			add	ebx,len_inputSubStr	
			dec	ebx

		    fnd:
			inc	ebx

			cmp	ebx,esi
			jl	cmploop

			invoke	printf,addr InputMainStr

		exit_program:
			invoke	ExitProcess,0


;__________________________________________________________________
;  Uppercase Proc
;  Uppercase's an input string based on given length 
;  disregards tabs,spaces,and big letters
;¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
			

UpperCaseStr		proc	string_loc:DWORD,
				len_substring:DWORD

			push	ebx
			push	esi
			push	edi
			
			sub	ebx,ebx
			mov	edi,len_substring
			mov	esi,string_loc

			cmp	edi,ebx
			jle	e_upc
		uloop1:	
			movsx	eax,byte ptr [esi+ebx]

				cmp	al,' '
				je	dsrgard1

				cmp	al,09h
				je	dsrgard1	;tabs

				cmp	al,'Z'	;5ah
				jle	dsrgard1	;

				add	al,'A'-'a'	;make it big
		dsrgard1:
			mov     byte ptr [esi+ebx],al
	      
			inc     ebx

			cmp     edi,ebx
			jg      uloop1


		 e_upc:
			pop	edi
			pop	esi
			pop	ebx
			ret
UpperCaseStr		endp


;__________________________________________________________________
;  Lowercase Proc 
;  lowercase an input string based on given length 
;  disregards tabs,spaces,and small letters
;¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
			

LowerCaseStr		proc	string_loc:DWORD,
				len_substring:DWORD

			push	ebx
			push	esi
			push	edi
			
			sub	ebx,ebx
			mov	edi,len_substring
			mov	esi,string_loc

			cmp	edi,ebx
			jle	e_upc
		uloop2:	
			movsx	eax,byte ptr [esi+ebx]

				cmp	al,' '
				je	dsrgard2

				cmp	al,09h	;tabs
				je	dsrgard2			

				cmp	al,'a'	;61h
				jge	dsrgard2	;

				add	al,'a'-'A'	;lowercase it
		dsrgard2:
			mov     byte ptr [esi+ebx],al
	       
			inc     ebx

			cmp     edi,ebx
			jg      uloop2


		 e_upc:
			pop	edi
			pop	esi
			pop	ebx
			ret
LowerCaseStr		endp			





;__________________________________________________________________
;  GetInput - Gets MainString and Substring,
;  Check if Substring is longer than MainString,returns 1 if inputs are ok,0 otherwise
;¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯


GetInputs		proc	
			
			
			push	ebx

			
			;first  input

			invoke	printf,addr szMainStr
			invoke	gets,addr InputMainStr
			
			;second input

			invoke	printf,addr szSubStr
			invoke	gets,addr InputSubStr
			
			;eax	returns the state of the input in eax
			invoke	GetLength  

			pop	ebx			
			ret
			
			

GetInputs		endp
;__________________________________________________________________
;  GetLength proc
;	returns 1 eax if input is ok
;	returns 0 eax if insufficiend input or sub-string is > main-string
;¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
			
GetLength		proc

			invoke	strlen,addr InputMainStr


			mov	ebx,eax
			mov	[len_inputMainStr],eax

			cmp	eax,0
			je	ret1		;no input?

			invoke	strlen,addr InputSubStr

			cmp	eax,0
			je	ret1		;no input?

			mov	[len_inputSubStr],eax
			cmp	eax,ebx		;substr should not be longer than mainstr
			jg	ret1		;exit if it is
			
			mov	eax,1						
			ret

		ret1:

			invoke	printf,addr invalid1

			sub	eax,eax		
			ret

GetLength		endp

;__________________________________________________________________
;  MyStrCmp 
;	These routine return an int value based on the result of comparing s1 (or
;	part of it) to s2 (or part of it):
;	returns <  0  if s1 <  s2
;	returns == 0  if s1 == s2
;	returns >  0  if s1 >  s2
;¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
			
MyStrCmp		proc	mStr:DWORD,
				sStr:DWORD,
				mStrlen:DWORD
			push	ebx
			push	esi
			push	edx
			
			mov	eax,mStr
			mov	edx,sStr
			mov	esi,mStrlen

			sub	ecx,ecx
			jmp	t1

		_eq:
			inc	eax
			inc	edx
			inc	ecx

			cmp	esi,ecx
			jne	t1

			sub	eax,eax
			jmp	xcmp

		t1:

			mov	bl,byte ptr [eax]
			cmp	bl,byte ptr [edx]
			je	_eq

			movsx	eax,byte ptr [eax]
			movsx	edx,byte ptr [edx]
			sub	eax,edx
		xcmp:
			pop	edx
			pop	esi
			pop	ebx
			
			ret
MyStrCmp		endp

end start