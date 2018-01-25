format mz
begin:
	mov ax,cs
	mov ds,ax
	
	mov ax,0003			
	int 10h	
	
	mov di,dhArray
	mov si,dlArray
	call snakeOutput

	mov ax,4c00h		;Функция выхода
	int 21h				;Выход

snakeOutput:
	push di
	push si	
	mov al,'-'
	xor cx,cx
	mov cl,byte[n]
loopStart:
	call oneSymbolOutput
	loop loopStart
	pop si
	pop di
	ret

oneSymbolOutput:
	push cx
	push bx
	mov bh,0
	mov cx,1
	
	mov dh,[di]
	mov dl,[si]
	mov ah,02h	
	int 10h

	mov bl,9
	xor bh,bh
	mov ah,09h
	int 10h	
	pop bx
	
	inc di
	inc si

	pop cx
	ret
	
dhArray	db 0,1,2
dlArray	db 0,0,0
n		db	2