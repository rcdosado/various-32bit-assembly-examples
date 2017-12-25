      .386p
      locals
      jumps
      .model flat,STDCALL

	  extrn gets:proc
          extrn printf:proc
	  extrn strlen:proc
	  extrn ExitProcess:proc


	      
			;**NOTE**
			;everything after a semicolon in a line is a comment

			;compiled using Borland's TASM32,linked using Borland's TLINK32 under WindowsXP sp2
			;Using Library imsvcrt.lib for gets,printf,strlen function
			;Using Library import32.lib for ExitProcess
			;see compile32.bat for compiler and linker options

	buffersize	equ	100	;100 would suffice
	crlf		equ	0ah,0dh
  
        .data    
szMainStr	db	crlf,'[+] Please enter the string:',0
szSubStr	db	crlf,'[+] Please enter the substring to be searched:',0
szProcss	db	crlf,'[+] Processing...',0

szNumOccur	db	crlf,'[+] The number of Occurence(s) of the substring is %d',0
szStLoc		db	crlf,'[+] The starting location(s) of the substring in the mainstring is/are',0
szLocation	db	crlf,'[+] Location %d',0
szNotFound	db	crlf,'[-]Sub-string was not found!',0

len_inputMainStr dd	0
len_inputSubStr	dd	0

inputMainStr	db	buffersize dup(0)
inputSubStr	db	buffersize dup(0)

num_occurence	dd	0
found_location	dd	100 dup(0)
        .code
Start:

			;__________________________________________________________________
			;  Program Entrypoint 
			;¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
			
			call	getInput
			cmp	eax,0
			je	exit


			push	offset szProcss
			call	printf
			add	esp,4

			mov	edx,offset inputMainStr
			mov	edi,offset found_location			
			mov	ecx,0
		loop1:
			mov	eax,offset inputSubStr
			call	myStrcmp

			cmp	eax,1
			jge	found_it
		loop2:
			cmp	byte ptr [edx],0	;test if End of MainString
			je	test2

			inc	edx			;EDX = holds the current index

			jmp	loop1	
		test2:
			cmp	[num_occurence],0
			jnz	display
			
			push	offset szNotFound
			call	printf
			add	esp,4
			
		exit:
			
			push	0
			call	ExitProcess


		display:
			call	FindCountSubstrings
			jmp	exit


			;__________________________________________________________________
			;  FindCountSubstrings - displays the number of occurences of substring
			;  to mainstring, also displays its location, in mainstring
			;  *NOTE* 0 is the 1st element
			;¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
			
	FindCountSubstrings:
			
			
			push	dword ptr [num_occurence]
			push	offset szNumOccur
			call	printf
			add	esp,4*2

			push	offset szStLoc
			call	printf
			add	esp,4

			mov	esi,offset found_location
			mov	ecx,dword ptr [num_occurence]
		__prntLoop:
			lodsd	
			push	ecx

			sub	eax,offset inputMainStr
			push	eax
			push	offset szLocation
			call	printf
			add	esp,4*2

			pop	ecx
			dec	ecx
			jnz	__prntLoop


			ret

			;__________________________________________________________________
			; thie procedure executes if a the substring is found
			;¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯				
		found_it:
			
			inc	dword ptr [num_occurence]
			push	eax
			mov	eax,edx
			stosd
			pop	eax
			add	edx,eax
			jmp	loop2

			;__________________________________________________________________
			;  GetInput - Gets MainString and Substring,
			;  Check if Substring is longer than MainString,returns 0 if TRUE
			;¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
			
		getInput:
			
			;first input

			push	offset szMainStr
			call	printf
			add	esp,4

			push	offset inputMainStr
			call	gets
			add	esp,4
			
			;second input
			push	offset szSubStr
			call	printf
			add	esp,4

			push	offset inputSubStr
			call	gets
			add	esp,4

		
			
			
			push	offset inputMainStr
			call	strlen
			add	esp,4

			mov	ebx,eax
			mov	[len_inputMainStr],eax

			push	offset inputSubStr
			call	strlen
			add	esp,4

			mov	[len_inputSubStr],eax
			cmp	eax,ebx		;substr should not be longer than mainstr
			jg	ret1		;exit if it is

			mov	eax,1						
			ret

		ret1:
			sub	eax,eax
			ret



			;__________________________________________________________________
			;  myStrcmp proc			
			; returns 0 is equal, > 0 otherwise
			; EAX = str2, EDX = str1
			;¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
			
myStrcmp:
			

			push	ecx
			push	edx
			push	esi
			
			mov	ecx,-1
			mov	esi,eax
			sub	eax,eax
		_mySCLoop:
			

			inc	ecx

			cmp	ecx,dword ptr [len_inputSubStr]
			jge	_equal

			lodsb
			cmp	al,byte ptr [edx+ecx]
			jne	_nequal

			cmp	al,20h
			je	_nequal
			

			jmp	_mySCLoop
		_nequal:
			sub	eax,eax
		
			pop	esi
			pop	edx
			pop	ecx
			ret
		
		_equal:
			mov	eax,ecx
			pop	esi
			pop	edx
			pop	ecx
			ret

			
			
			
End Start
