format mz
begin:
	mov ax,cs
	mov ds,ax
	mov es,ax

	mov di, string1
	mov si, string2

	mov cx,6
	cld
	
;A1:	
	; jcxz exit
	
	; ; repe cmpsb
	; ; jnz fail1
	repe cmpsb
	;jcxz exit
	je exit
	
	; mov ax,[di]
	; mov bx,[si]

	; cmp ax,bx
	; jne fail1
	
; jmp A1

fail1:
	mov ah,09h
	mov dx,fail
	int 21h
	
	dec di
	dec si
	
	mov ah,02h
	mov dx,cx
	add dl,'0'
	int 21h
	mov ah,02h
	mov dx,[si]
	int 21h
	
exit:
	mov ax,4c00h		
	int 21h			
	
fail		db	'Строки не совпадают$'
; string1		db	'1234$'
; string2		db	'1234$'
string1		db	'124qwe$'
string2		db	'123qwe$'