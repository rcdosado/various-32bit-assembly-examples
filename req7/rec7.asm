
code	segment
assume cs:code,ds:code


org	100h


main:
			;entrypoint--------------
			jmp	start
			;__________________________________________________________________
			;  DATA Storage	
			;  since this is a COM program (64kb max size)
			;  my data is included in the code
			;¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯

	
		input_buffer	equ	$
			max_number_read db	24		;set to 24 because int 10,function 2 cannot print more than row 24
			len_buffer	db	0
			str_loc		db	100	dup(0)	
			
			titulo		db	'input the string: $'
      

start:
			;__________________________________________________________________
			;  Main Program
			;¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯

			call	clrscr

			mov	dh,0	
			mov	dl,0
			call	gotoxy

			mov	dx,offset titulo
			mov	ah,9
			int	21h


			mov	dx,offset input_buffer
			call	get_string


			call	clrscr	


			mov	si,offset str_loc
			mov	bl,byte ptr [len_buffer]
			mov	bh,0

			add	si,bx	;
			dec	si	;si points to last element of the string w/o the 0x0d
			
			;bx here contains len_buffer
			;cx is counter

			mov	cx,0
			mov	dh,0	;first row
			mov	dl,0	;first column
			
			push	si

			std		;set direction flag, so string is reversed
			
		loops:


			call	gotoxy
			
			push	dx	;dx had to be saved because print_letter function uses it

			lodsb
			mov	dl,al	;<-here
			call	print_letter

			pop	dx	;restore row,column values

			inc	cx	;ctr++
			inc	dh	;row++
			inc	dl	;column++

			cmp	cx,bx
			jne	loops

			pop	si
			
			

			mov	cx,0	;set counter 0
			mov	dl,0	;start printing in first column
			call	gotoxy
		sloops:	
			lodsb			
			mov	dl,al
			call	print_letter
			inc	cx	;ctr++

			cmp	cx,bx	;if(cx <= bx) : (jump sloops),
			jl	sloops

			cld	;restore direction flag to default


			mov	ax,4ch
			int	21h	;exit program
			;__________________________________________________________________
			;  print_letter proc - displays the letter in DL
			;¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
			
print_letter	proc
			mov	ah,2
			int	21h
			ret
print_letter	endp


			;__________________________________________________________________
			;  gotoxy proc
			; on entry: DH Row (Y)
			;	    DL Column (X)
			;¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
			
gotoxy	proc
	
			push	bx
			push	cx
			push	dx

			mov	bh,0
			mov	ah,2
			int	10h

			pop	dx
			pop	cx
			pop	bx
			ret

endp
			;__________________________________________________________________
			;  get_string proc
			;  set DX to address of buffer
			;  buffer[0]->maximum size set before interrupt
			;  buffer[1]->size of string after interrupt returns
			;  buffer[2]->start of string 
			;  *NOTE* this function appends 0xd at the end of the string!
			;¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
			
get_string	proc
			mov	ah,0ah
			int	21h			
			ret

get_string	endp
			;__________________________________________________________________
			;  clrscr proc
			;¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
			
clrscr	proc

			push	ax 
			push	bx 
			push	cx 
			push	dx
			sub	ax,ax	;blank entire window
			sub	cx,cx
			mov	dh,24	;up to 24 downwards 
			mov	dl,79	;up to 79 forwards
			mov	bh,7	;normal attribute
			mov	ah,6	;function 6,scroll up
			int	10h
			pop	dx 
			pop	cx 
			pop	bx 
			pop	ax
			ret

clrscr	endp
	

code	ends
	end	main