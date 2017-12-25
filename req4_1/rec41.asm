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
			;see compile32.bat current directory for assembler and linker options
      .data    
num1		dword	6
num2		dword	8

fm		db	'sum is %d',0
output		db	20 dup(0)
        .code
Start:
			
			call	myaddition
			
			push	eax
			push	offset fm
			call	printf
			add	esp,4*2
			
		exit:
			push	0
			call	ExitProcess

myaddition	proc
			mov	eax,offset num1
			mov	edx,offset num2
			mov	eax,dword ptr [eax]
			mov	edx,dword ptr [edx]
			add	eax,edx
			ret

myaddition	endp
			
End Start
