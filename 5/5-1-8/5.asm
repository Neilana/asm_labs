 ;Воропаева Алина, группа П-402
;Практическая работа №4
;Вариант №5-1-8
;Задание: Напишите программу перемещения с помощью клавиш стрелок двух букв. Между буквами переключение осуществляется
;при помощи клавиши ТАБ. Каждая из перемещаемых букв является большой буквы З, составленной из отрезков.

format mz
begin:
	mov ax,cs
	mov ds,ax
	mov es,ax
	
	mov ax,0010h		;Функция выбора режима
	int 10h 			;Выбор режима
   
	call drawLetter
	call changeLetter
	call drawLetter
	
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
	jne exit
	
	call changeLetter
	jmp checkKey

exit:
	; pop bx
	; mov cx,32000 ;загрузка числа записываемых в байт
	; mov ah,40h
	; int 21h                       ;Вывод символа на экран
	
	

	mov ah,3Eh	       ;закрываем файл res.txt
    int 21h 
  
	mov ax,4c00h		;Функция выхода
	int 21h 			;Выход

changeLetter:
	push si
	push di
	
	mov di,dx1Array
	mov si,dx1Array2
	call exchangeDiSi
	
	mov di,dx2Array
	mov si,dx2Array2
	call exchangeDiSi     
	
	mov di,cx1Array
	mov si,cx1Array2
	call exchangeDiSi
	
	mov di,cx2Array
	mov si,cx2Array2
	call exchangeDiSi
	
	pop di
	pop si
	ret

	
moveDown:
	mov dx,[dx1Array+6]

	cmp dx,310
	jl moveDown2
	
	jmp checkKey
moveDown2:
	push ax
	push bx
	push dx
	push si
	mov al,[currentColor]
	push ax
	mov [currentColor],0
	

	
	call drawLetter 
	pop ax
	mov [currentColor],al
	
	mov bx,10
	xor dx,dx
	call changeCoordinates

	call drawTwoLetters
	pop si
	pop dx
	pop bx
	pop ax
	jmp checkKey	
	
	
moveUp:
	mov dx,[dx1Array]

	cmp dx,0
	ja moveUp2

	jmp checkKey
moveUp2:
push ax
	push bx
	push dx
	mov al,[currentColor]
	push ax
	mov [currentColor],0

	call drawLetter 
	pop ax
	mov [currentColor],al
	
	mov bx,-10
	xor dx,dx
	call changeCoordinates

	call drawTwoLetters
	pop dx
	pop bx
	pop ax		
	jmp checkKey
	
	
moveRight:
	mov dx,[cx1Array+2]

	cmp dx,630
	jb moveRight2

	jmp checkKey

moveRight2:
	push ax
	push bx
	push si
	mov al,[currentColor]
	push ax
	mov [currentColor],0

	call drawLetter 
	pop ax
	mov [currentColor],al
	mov dx,10
	xor bx,bx
	call changeCoordinates
	call drawTwoLetters
	
	pop si
	pop bx
	pop ax
	jmp checkKey

moveLeft:
	; mov si,dlArray1       
	mov dx,[cx1Array]

	cmp dx,1
	ja moveLeft2

	jmp checkKey

moveLeft2:
	push ax
	push bx
	mov al,[currentColor]
	push ax
	mov [currentColor],0
	

	
	call drawLetter 
	pop ax
	mov [currentColor],al
	
	mov dx,-10
	xor bx,bx
	call changeCoordinates
	call drawTwoLetters
	pop bx
	pop ax
	jmp checkKey

	
changeCoordinates:	
	push cx
	push di
	push si
	push dx
	push bx
	mov cx,[countLines]
	mov di,bx
	loopStart2:
	mov bx,[countLines]
	sub bx,cx
	sal bx,1
	add [dx1Array+bx],di
	add [cx1Array+bx],dx
	loop loopStart2
	
	mov cx,[countLines]
	loopStart3:	
	mov bx,[countLines]
	sub bx,cx
	sal bx,1
	add [dx2Array+bx],di
	add [cx2Array+bx],dx
	loop loopStart3
		pop bx
		pop dx
	pop si
	pop di
	pop cx
ret
	
drawLetter:	
	push ax
	push bx
	push cx 
	xor bx,bx
	mov cx,[countLines]
	loop1:
	; mov [deltaDx],0
	; mov [deltaCx],0
	; mov [movDx],0
	; mov [movCx],0
	; mov [currentDx],0
	; mov [currentCx],0
	; mov [deltaCx],0
	; mov [error2],0
	; mov [errorDxCx],0
	
	mov bx,[countLines]
	sub bx,cx
	sal bx,1
	
	mov ax,[dx1Array+bx]
	mov [dx1],ax
	
	mov ax,[cx1Array+bx]
	mov [cx1],ax
	
	mov ax,[dx2Array+bx]
	mov [dx2],ax
	
	mov ax,[cx2Array+bx]
	mov [cx2],ax
	call drawLine
	loop loop1
	pop cx
	pop bx
	pop ax	
	ret

	
drawLine:
	push cx
	push bx
	push ax
	
	call setDelta
	call setError
	
	mov ax,[dx2]
	mov [currentDx],ax
	
	mov ax,[cx2]
	mov [currentCx],ax
	
	call drawPoint
	
	mov ax,[dx1]
	mov [currentDx],ax
	
	mov ax,[cx1]
	mov [currentCx],ax

loopDrawLine:		;while
	; mov ah,08
	; int 21h
	xor cx,cx
	mov ax,[currentDx]
	mov bx,[dx2]
	cmp ax,bx
	jne loopDrawLine2
	
	mov ax,[currentCx]
	mov bx,[cx2]
	cmp ax,bx
	je loopEnd
	
loopDrawLine2:	
	call drawPoint

	mov ax,[errorDxCx]
	sal ax,1
	mov [error2],ax
	
	mov bx,[deltaDx]
	neg bx
	cmp ax,bx
	jle C1
	mov cx,[errorDxCx]
	add cx,bx
	mov [errorDxCx],cx
	mov cx,[currentCx]
	mov bx,[movCx]
	add cx,bx
	mov [currentCx],cx
	jmp loopDrawLine
	
	C1:
	mov bx,[deltaCx]
	cmp ax,bx
	jnl loopDrawLine
	
	C2:
	mov cx,[errorDxCx]
	add cx,bx
	mov [errorDxCx],cx
	mov cx,[currentDx]
	mov bx,[movDx]
	add cx,bx
	mov [currentDx],cx	
	jmp loopDrawLine	
	
loopEnd:	
	pop ax
	pop bx
	pop cx
	ret	
	
setError:
	push ax
	push bx
	
	mov ax,[deltaCx]
	mov bx,[deltaDx]
	sub ax,bx
	mov [errorDxCx],ax
	
	pop bx
	pop ax
	ret
		
setDelta:
	push ax
	push bx
	
	;Куда двигаться 
	mov ax,[dx1]
	mov bx,[dx2]

	cmp ax,bx
	jg A1 ;Если первая точка ниже второй
	
	cmp ax,bx
	jl A2 ;Если первая точка выше второй
	
	mov [movDx],0
	jmp A3

A3:	
	mov ax,[cx1]
	mov bx,[cx2]
	cmp ax,bx
	jg B1 ;Если первая точка правее второй
	
	cmp ax,bx
	jl B2 ;Если первая точка левее второй

	mov [movCx],0
	
	jmp setDelta1

A1:
	mov [movDx],-1
	sub ax,bx
	mov [deltaDx],ax
	jmp A3

A2:
	mov [movDx],1
	sub bx,ax
	mov [deltaDx],bx
	jmp  A3

B1:
	mov [movCx],-1
	sub ax,bx
	mov [deltaCx],ax
	jmp setDelta1
B2:	
	mov [movCx],1
	sub bx,ax
	mov [deltaCx],bx
	jmp setDelta1
setDelta1:
	pop bx
	pop ax
	ret

drawPoint:
	push ax
	push bx
	push dx
	push cx

	xor bx,bx
	mov ah,0ch
	mov al,[currentColor]
	mov dx,[currentDx]
	mov cx,[currentCx]	
	int 10h
	
	pop cx
	pop dx
	pop bx
	pop ax
	ret
	
exchangeDiSi:
	push di
	push si
	push ax
	push bx
	push cx

	cld

	mov cx,[countLines]
	loopExchangeDiSiStart:

	
	push cx
	mov bx,[countLines]
	sub bx,cx
	sal bx,1

	mov ax,[di+bx]
	mov dx,[si+bx]

	mov [di+bx],dx
	mov [si+bx],ax
	pop cx
	loop loopExchangeDiSiStart
	
	pop cx
	pop bx
	pop ax
	pop si
	pop di
	ret	

drawTwoLetters:
	push si
	push ax
	push bx
	push cx
	push dx
	
	call drawLetter
	call changeLetter


	call drawLetter
	call changeLetter

	pop dx
	pop cx
	pop bx
	pop ax
	pop si
	ret

	


	
dx1Array		dw	0,	0,	60,	30
cx1Array		dw	0,	30,	30,	30

dx2Array		dw	0,	60,	60,	30
cx2Array		dw	30,	30,	0,	15

dx1Array2		dw	70,	70,	130, 100
cx1Array2		dw	0,	30,	30,	30

dx2Array2		dw	70,	130, 130,100
cx2Array2		dw	30,	30,	0,	15

currentLetter	db	-1

dx1				dw 0
cx1				dw 0
dx2				dw 0
cx2				dw 0

currentDx		dw	1
currentCx		dw	10

movDx			dw	0
movCx			dw	0

deltaDx 		dw	0
deltaCx 		dw	0

errorDxCx		dw	0	
error2			dw	0	

countLines		dw	4	
currentColor	db	15

filename		db	'file.txt',0
fileString	db	400 dup(' ')
currentPos	dw	0
up			db	10,13,'UP',10,13

	
