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
			;Using Library imsvcrt.lib for the printf,scanf function
			;Using Library import32.lib for ExitProcess function
			;see compile32.bat in current directory for assembler and linker options
  
        .data    
inputNum		dd	0

search_me		dd	1,3,4,5,6,7,7,8,8,8,8,1,1,1,12,8
sizeofSearch		equ	($ - search_me)/4		;i divide by 4 because its a dword i.e 4 bytes

scanf_fmt		db	'%d',0
sztitle			db	'Enter a DWORD value to search:',0
szGiven 		db	'DWORD %d found at position(s)',0
whatposition		db	',%d',0
same_num_ctr		dd	0
szNotFound		db	'The given  DWORD %d was not found',0
found_dwords		dd	sizeofSearch dup(0)


        .code
Start:
			;printf(sztitle);

			push	offset sztitle
			call	printf
			add	esp,4

			;scanf("%d",&inputNum);

			push	offset inputNum
			push	offset scanf_fmt
			call	scanf
			add	esp,4*2

			mov	esi,offset search_me
			mov	edi,offset found_dwords
			mov	ecx,0
			dec	ecx		;make it -1 so that count still starts in zero
			;
			;
			;this part enumerate the array of dwords
			;ecx is the counter of dwords
			;eax holds the element of every iteration

	  lookagain:
			inc	ecx
			cmp	ecx,sizeofSearch
			jge	all_tried
			
			lodsd

			cmp	eax,dword ptr [inputNum]
			je	save_it

			jmp	lookagain
						
	 all_tried:
						
			sub	eax,eax
			cmp	[same_num_ctr],eax
			jg	prntOccurences

			;printf("%s",szNotFound);
			push	dword ptr [inputNum]
			push	offset szNotFound
			call	printf
			add	esp,4*2
			
	     exit:
			push	0
			call	ExitProcess

	  save_it:
			mov	eax,ecx
			stosd
			inc	dword ptr [same_num_ctr]

			jmp	lookagain

	;---------------------------------------------------
  prntOccurences:
			;printf("DWORD %d found at position(s)",inputNum);
			push	dword ptr [inputNum]
			push	offset szGiven
			call	printf
			add	esp,4*2

						
			mov	esi,offset found_dwords
			mov	ecx,[same_num_ctr]
	  loopz2:
			lodsd	
			push	ecx
	
			;printf(",%d",eax)
			push	eax
			push	offset whatposition
			call	printf			;this function modifies ecx so, save ecx before call
			add	esp,4*2			

			pop	ecx			;restore it afterwards
			dec	ecx
			jnz	loopz2

			jmp	exit
			
			
End Start
