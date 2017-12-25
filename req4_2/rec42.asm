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
multiplicand	dword	06
multiplier	dword	08

fm		db	'%.2d',0
output		db	10 dup(0)
        .code
Start:
			
			mov	eax,offset multiplicand
			mov	edx,offset multiplier
			call	mymultiply
			
	
			push	ebx
			push	offset fm
			call	printf
			add	esp,4*2
			
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
