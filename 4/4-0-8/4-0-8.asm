;Воропаева Алина, группа П-402
;Практическая работа №4
;Вариант №4-0-8
;Задание: Напишите программу перемещения с помощью клавиш стрелок большой буквы З, составленной из символов З.

format mz
begin:
	mov ax,cs
	mov ds,ax
	
	mov ax,0003			;Функция выбора режима
	int 10h				;Выбор режима
	
	xor bx,bx
	call bigLetterOutput
	
checkKey:
	xor bx,bx
	xor dx,dx
	mov ah,0
	int 16h

	cmp al,0
	je serviceKey
							
serviceKey:
	cmp al,80
	je moveDown	
	
	cmp al,77
	je moveRight

	cmp al,72
	je moveUp

	cmp al,75
	je moveLeft

	mov dl,al
	add dl,80
	mov ah,02
	int 21h
	
	mov ax,4c00h		;Функция выхода
	int 21h				;Выход

moveDown:
	mov di,dhArray	
	mov dh,[di]

	cmp dh,20
	jb moveDown2

	jmp checkKey
moveDown2:
	mov bh,0
	mov ah,00
	int 10h
	mov ax,0003			;Функция выбора режима
	int 10h				;Выбор режима
	
	mov bh,1
	xor bl,bl
	call bigLetterOutput

	jmp checkKey
	
moveUp:
	mov di,dhArray	
	mov dh,[di]

	cmp dh,0
	ja moveUp2

	jmp checkKey
moveUp2:
	mov bh,0
	mov ah,00
	int 10h
	mov ax,0003			;Функция выбора режима
	int 10h				;Выбор режима
	
	mov bh,-1
	xor bl,bl
	call bigLetterOutput

	jmp checkKey
	
moveRight:
	mov si,dlArray	
	mov dl,[si]

	cmp dl,76
	jb moveRight2

	jmp checkKey

moveRight2:
	mov bh,0
	mov ah,00
	int 10h
	mov ax,0003			;Функция выбора режима
	int 10h				;Выбор режима
	
	mov bl,1
	xor bh,bh

	call bigLetterOutput

	jmp checkKey

moveLeft:
	mov si,dlArray	
	mov dl,[si]

	cmp dl,0
	ja moveLeft2

	jmp checkKey

moveLeft2:
	mov bh,0
	mov ah,00
	int 10h
	mov ax,0003			;Функция выбора режима
	int 10h				;Выбор режима
	
	mov bl,-1
	xor bh,bh

	call bigLetterOutput

	jmp checkKey
	
bigLetterOutput:
	xor si,si
	xor di,di
	mov si,dlArray
	mov di,dhArray	
	add [di],bh
	add [si],bl
	mov al,'з'
	;mov cx,12d
	mov cx,12
loopStart:
	call smallLetterOutput
	loop loopStart
	
	; mov dh,[di]
	; mov dl,[si]
	; mov ah,02h	
	; int 10h
	
	; mov cx,1
	; mov bl,9
	; xor bh,bh
	; mov ah,09h
	; int 10h	
	
	ret
	
smallLetterOutput:
	push cx
	push bx
	mov bh,0
	mov cx,1
	
	mov dh,[di]
	mov dl,[si]
	mov ah,02h	
	int 10h
		
	; mov al,[Di]
	; add al,'0'

	mov bl,9
	xor bh,bh
	mov ah,09h
	int 10h	
	pop bx
	
	inc di
	inc si

	add [di],bh
	add [si],bl
	pop cx
	ret
	
dlArray db 0,1,2,3,3,3,2,3,3,2,1,0,0
dhArray db 0,0,0,0,1,2,2,3,4,4,4,4,0