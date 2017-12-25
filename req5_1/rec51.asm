      .386p
      locals
      jumps
      .model flat,STDCALL

	  extrn scanf:proc
          extrn printf:proc
	  extrn ExitProcess:proc


	      
			;**NOTE**
			;everything after a semicolon in a line is a comment

			;compiled using Borland's TASM32,linked using Borland's TLINK32 under WindowsXP sp2
			;Using Library imsvcrt.lib for scanf and printf function
			;Using Library import32.lib for ExitProcess
			;see compile32.bat for compiler and linker options

	buffersize	equ	100
	crlf		equ	0ah,0dh
  
        .data    
szMainStr	db	crlf,'[+] Enter the number = ',0
szProcss	db	crlf,'[+] Processing...',0

szfmt		db	'%d',0
szfmt2		db	'%c',0
input_num1	dd	0

        .code
Start:

			;__________________________________________________________________
			;  Program Entrypoint 
			;¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
			
			call	getInput
			cmp	eax,1
			jl	bad_input

			push	offset szProcss
			call	conv_display	
			add	esp,4

	bad_input:
			push	0
			call	ExitProcess
			

	getInput:
			push	offset szMainStr
			call	printf
			add	esp,4
	
			push	offset input_num1
			push	offset szfmt
			call	scanf
			add	esp,4*2
			mov	eax,dword ptr [input_num1]

			ret


			;__________________________________________________________________
			;  converts pushed values into printable chars
			;¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
			

	conv_display:
			;a word could have as much as 5 digits e.g 65535
			sub	ecx,ecx
			inc	ecx
		loop1:
			inc	ecx
			mov	esi,10
			xor	edx,edx
			div	esi
			push	edx
			cmp	edx,0
			jnz	loop1


		loop2:
			dec	ecx
			jle	back_to_main
			pop	eax
			add	eax,30h
			
			push	ecx

			push	eax
			push	offset szfmt2
			call	printf
			add	esp,4*2

			pop	ecx
			jmp	loop2
		back_to_main:
			ret






			
			
End Start



