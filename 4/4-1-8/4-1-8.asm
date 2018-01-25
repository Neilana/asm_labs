;Воропаева Алина, группа П-402
;Практическая работа №4
;Вариант №4-1-8
;Задание: Напишите программу перемещения с помощью клавиш стрелок двух букв. Между буквами переключение осуществляется
;при помощи клавиши ТАБ. Каждая из перемещаемых букв является большой буквы З, составленной из символов З.

format mz
begin:
	mov ax,cs
	mov ds,ax
	
	mov ax,0003			;Функция выбора режима
	int 10h				;Выбор режима
	
	xor bx,bx
	; mov si,dlArray1
	; mov di,dhArray1	
	call twoBigLettersOutput
	mov si,dlArray1
	mov di,dhArray1	

checkKey:
	xor bx,bx
	xor dx,dx
	mov ah,0
	int 16h

	cmp aH,80
	je moveDown	
	
	cmp aH,77
	je moveRight

	cmp aH,72
	je moveUp

	cmp aH,75
	je moveLeft
	
	cmp al,9
	je changeLetter
		
	mov ax,4c00h		;Функция выхода
	int 21h				;Выход

changeLetter:
	neg byte[currentLetter]
	cmp byte [currentLetter],1
	je letter2

 letter1:
	mov si,dlArray1
	mov di,dhArray1
	jmp checkKey
	
letter2:
	mov si,dlArray2
	mov di,dhArray2
	jmp checkKey
	
moveDown:
	; mov di,dhArray1	
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
	call changeCoordinates
	call twoBigLettersOutput		
	;call bigLetterOutput

	jmp checkKey
	
moveUp:
	; mov di,dhArray1	
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
	call changeCoordinates
	call twoBigLettersOutput		
	jmp checkKey
	
moveRight:
	; mov si,dlArray1	
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
		call changeCoordinates
call twoBigLettersOutput		
;	call bigLetterOutput

	jmp checkKey

moveLeft:
	; mov si,dlArray1	
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
	call changeCoordinates
call twoBigLettersOutput		
;	call bigLetterOutput
	jmp checkKey

changeCoordinates:	
	mov cx,12
	push di
	push si
	add [di],bh
	add [si],bl

	loopStart2:
	inc di
	inc si
	add [di],bh
	add [si],bl
	loop loopStart2

	pop si
	pop di
	ret
		
bigLetterOutput:
	mov al,'з'
	mov cx,12
loopStart:
	call smallLetterOutput
	loop loopStart
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

	mov bl,9
	xor bh,bh
	mov ah,09h
	int 10h	
	pop bx
	
	inc di
	inc si

	pop cx
	ret

twoBigLettersOutput:
	push si
	push di
	mov si,dlArray1
	mov di,dhArray1	
	call bigLetterOutput
	
	mov si,dlArray2
	mov di,dhArray2	
	call bigLetterOutput
	pop di
	pop si
	ret
	
dlArray1 db 0,1,2,3,3,3,2,3,3,2,1,0,0
dhArray1 db 0,0,0,0,1,2,2,3,4,4,4,4,0

dlArray2 db 0,1,2,3,3,3,2,3,3,2,1,0,0
dhArray2 db 5,5,5,5,6,7,7,8,9,9,9,9,0

currentLetter db	-1