      .386p
      locals
      jumps
      .model flat,STDCALL

          extrn printf:proc
	  extrn ExitProcess:proc

      
			;**NOTE**
			;everything after a semicolon in a line is a comment

			;compiled using Borland's TASM32,linked using Borland's TLINK32 under WindowsXP sp2
			;Using Library imsvcrt.lib for the printf function
			;Using Library import32.lib for ExitProcess
			;see compile32.bat in current directory for assembler and linker options
  
        .data    
arr1		dword	1,4,5,6,7
arr2		dword	5,4,1,2,1
sum		dword	0,0,0,0,0

dsum		db	'the sum of the array are:',0
fm1		db	'%d ',0
fm2		db	'%s',0
output		db	20 dup(0)
        .code
Start:


			mov	ecx,0

			mov	esi,offset arr1
			mov	edi,offset arr2
			mov	ebp,offset sum
		theloop:
			mov	eax,dword ptr [esi+ecx]
			mov	edx,dword ptr [edi+ecx]
			add	eax,edx
			mov	[ebp+ecx],eax
			add	ecx,4
			cmp	ecx,4*5
			jne	theloop

			push	offset dsum
			push	offset fm2
			call	printf
			add	esp,4*2

			mov	esi,offset sum
			mov	ecx,5
		anotherloop:
			push	ecx
			lodsd
			push	eax
			push	offset fm1
			call	printf
			add	esp,4*2
			pop	ecx
			loop	anotherloop
				
		exit:
			push	0
			call	ExitProcess

mymultiply	proc
			mov	edx,dword ptr [edx]
			mov	eax,dword ptr [eax]
			mul	edx
			;edx:eax
			mov	ebx,eax

			ret

mymultiply	endp
			
End Start
