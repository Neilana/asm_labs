;Воропаева Алина, группа П-402
;Практическая работа №9
;Вариант №9-1-8
;Задание: Программа проверки того, что точка лежит внутри данного треугольника. 
;В основном меню два пункта - <проверка> и <выход>. При выборе пункта меню 
;<проверка> появляется возможность ввести координаты четырех точек 
;(переключение между ними - ТАБ). В оставшемся окошке выводится ответ - <да> 
;или <нет>. ESC - выход в меню. DEL - стирание всего значения.

format mz
begin:
;Установка сегментных регистров
	mov ax,cs
	mov ds,ax
	mov es,ax

	call clearValues
	
	mov ax,0003				;Функция выбора режима
	int 10h 				;Выбор режима

;Вывод строк меню
	mov bl,11				;Атрибут выводимых символов (синий текст)
	call menuStringCheckOutput
	
	mov bl,9				;Атрибут выводимых символов (синий текст)
	call menuStringExitOutput

	;Установка курсора на первый пункт      
	mov dh,[menuStringsBeginDh]
	mov dl,[menuStringsBeginDl]
	mov bh,0
	mov ah,02h	
	int 10h
	
checkKey:
	xor bx,bx
	xor dx,dx

	mov ah,0
	int 16h

	cmp ah,80
	je moveDown	
	
	cmp ah,72
	je moveUp	
	
	cmp al,13
	je enterKey
	
	jmp checkKey
	
;Выход из программы
exit:
	mov ax,4c00h		
	int 21h

enterKey:
	mov [currentWindow],0
	cmp [currentString],0
	je enterCheck
	jmp exit
enterCheck:
	mov bh,0
	mov ah,00
	int 10h
	mov ax,0003			;Функция выбора режима
	int 10h 			;Выбор режима
	call windowsOutput

checkKey2:
	mov ah,0
	int 16h

	call checkInputNumber	
	
	cmp ah,77
	je moveRight

	cmp ah,75
	je moveLeft
	
	cmp al,8
	jne notDel
	
	call delKey
	
notDel:
	cmp al,9
	jne checkKey21	
	
	call changeWindow
checkKey21:
	cmp al,27
	je begin

	cmp al,13
	jne checkKey2End
	
	call solution
	
checkKey2End:
	jmp checkKey2

moveRight:
	push ax
	push bx
	push cx
	push dx
	
	mov cl,[XorY]
	cmp cl,'y'
	je moveRightEnd
	
	xor bx,bx
	; mov bh,[currentWindow]
	mov bl,[currentWindow]
	mov dh,[windowsCoordinatesDh+bx]
	mov dl,[windowsCoordinatesDl+bx]

	add dl,4
	
	mov bh,0
	mov ah,02h	
	int 10h
	
	mov [XorY],'y'
	
	pop dx
	pop cx
	pop bx
	pop ax
	
moveRightEnd:
	jmp checkKey2
	
moveLeft:
	push ax
	push bx
	push cx
	push dx

	mov cl,[XorY]
	cmp cl,'x'
	je moveLeftEnd
	
	xor bx,bx
	;mov bh,[currentWindow]
	mov bl,[currentWindow]
	mov dh,[windowsCoordinatesDh+bx]
	mov dl,[windowsCoordinatesDl+bx]
	
	mov bh,0	

	mov ah,02h	
	int 10h
	
	mov [XorY],'x'
	
	pop dx
	pop cx
	pop bx
	pop ax
moveLeftEnd:
	jmp checkKey2
	
changeWindow:
	push ax
	push bx
	push cx
	push dx
	
	mov [XorY],'x'
	
	xor bx,bx
	;mov bh,[currentWindow]
	mov bl,[currentWindow]
	; inc bh
	inc bl
	inc [currentWindow]
	
	cmp bl,3
	jbe changeWindow2
	xor bx,bx
	mov [currentWindow],0
changeWindow2:	
	mov dh,[windowsCoordinatesDh+bx]
	mov dl,[windowsCoordinatesDl+bx]
	mov bh,0
	mov ah,02h	
	int 10h
	
	pop dx
	pop cx
	pop bx
	pop ax
	ret
	
moveDown: 
	push ax
	mov al,[currentString]
	; neg al
	cmp al,0	;first string of menu is selected now
	je moveDown2
	jmp moveDownEnd
moveDown2:
	call changeMenuStringExit
	xor al,1
	mov [currentString],al
moveDownEnd:
	pop ax
	jmp checkKey
	
moveUp: 
	push ax
	mov al,[currentString]
	; neg al
	cmp al,1	;second string of menu is selected now
	je moveUp2
	jmp moveUpEnd
moveUp2:
	call changeMenuStringCheck	
	xor al,1
	mov [currentString],al
moveUpEnd:
	pop ax
	jmp checkKey
	
changeMenuStringExit:
	push ax
	push bx
	push dx
	
	mov bl,9				;Атрибут выводимых символов (синий текст)
	call menuStringCheckOutput
	
	mov bl,11				;Атрибут выводимых символов (синий текст)
	call menuStringExitOutput
	
	;Установка курсора на первый пункт      
	mov dh,[menuStringsBeginDh]
	mov dl,[menuStringsBeginDl]
	inc dh
	mov bh,0
	mov ah,02h	
	int 10h
	
	pop dx
	pop bx
	pop ax
	ret
	
changeMenuStringCheck:
	push ax
	push bx
	push dx
	
	mov bl,11				;Атрибут выводимых символов (синий текст)
	call menuStringCheckOutput
	
	mov bl,9				;Атрибут выводимых символов (синий текст)
	call menuStringExitOutput
	
	;Установка курсора на первый пункт      
	mov dh,[menuStringsBeginDh]
	mov dl,[menuStringsBeginDl]

	mov bh,0
	mov ah,02h	
	int 10h
	
	pop dx
	pop bx
	pop ax
	ret
	
menuStringCheckOutput:
	push bp
	push cx
	push dx
	
	;Вывод пункта меню 'Проверка' (с помощью функции 13h прерывания 10h)
	mov bp,menuStringCheck		;Загрузка в BP адреса начала строки 'Проверка' 
	mov cx,8					;Помещаем в CX количество выводимых символов 
	mov dh,[menuStringsBeginDh]	;Строка начала вывода
	call menuStringOutput
	
	pop dx
	pop cx
	pop bp
	ret
	
menuStringExitOutput:
	push bp
	push cx
	push dx

	;Вывод пункта меню 'Выход' (с помощью функции 13h прерывания 10h)
	mov bp,menuStringExit		;Загрузка в BP адреса начала строки 'Проверка' 
	mov cx,5					;Помещаем в CX количество выводимых символов
	mov dh,[menuStringsBeginDh]	
	inc dh
	call menuStringOutput
	
	pop dx
	pop cx
	pop bp
	ret	
	
;menuStringOutput - функция вывода пункта меню 'Проверка' (с помощью функции 
;13h прерывания 10h)    
menuStringOutput:
	push ax
	push bx
	push dx
	
	mov dl,[menuStringsBeginDl]				;Колонка начала вывода
	mov bh,0				;Номер видео страницы
	mov al,0				;Код подфункции

	mov ah,13h				;Функция вывода строки
	int 10h

	pop dx
	pop bx
	pop ax
	ret
	
oneWindowOutput:
	push ax
	push bx
	push cx
	push dx
	
	mov dh,[windowsOutputDh]
	mov dl,[windowsOutputDl]
	mov bh,0
	mov ah,02h	
	int 10h

	mov cx,1
	mov bl,9
	xor bh,bh
	mov al,'┌'
	mov ah,09h
	int 10h 
	
	inc dl
	mov bh,0
	mov ah,02h	
	int 10h
	
	mov cx,3
	mov bl,9
	xor bh,bh
	mov al,'─'
	mov ah,09h
	int 10h 
	
	add dl,3
	mov bh,0
	mov ah,02h	
	int 10h
		
	mov cx,1
	mov bl,9
	xor bh,bh
	mov al,'┬'
	mov ah,09h
	int 10h 
	
	add dh,2
	sub dl,3
	mov bh,0
	mov ah,02h	
	int 10h
	
	mov cx,3
	mov bl,9
	xor bh,bh
	mov al,'─'
	mov ah,09h
	int 10h 
	
	sub dh,1
	dec dl

	mov bh,0
	mov ah,02h	
	int 10h
	
	mov cx,1
	mov bl,9
	xor bh,bh
	mov al,'│'
	mov ah,09h
	int 10h 
	inc dh
	
	add dl,4
	sub dh,1
	mov cx,1
	
	mov bh,0
	mov ah,02h	
	int 10h
	
	mov cx,1
	mov bl,9
	xor bh,bh
	mov al,'│'
	mov ah,09h
	int 10h 
	
	inc dh
	mov bh,0
	mov ah,02h	
	int 10h
		
	mov cx,1
	mov bl,9
	xor bh,bh
	mov al,'┴'
	mov ah,09h
	int 10h 
	
	sub dl,4
	mov bh,0
	mov ah,02h	
	int 10h
		
	mov cx,1
	mov bl,9
	xor bh,bh
	mov al,'└'
	mov ah,09h
	int 10h 
	
	sub dh,2
	add dl,5
	mov bh,0
	mov ah,02h	
	int 10h
	
	
		mov cx,3
	mov bl,9
	xor bh,bh
	mov al,'─'
	mov ah,09h
	int 10h 
	
	add dl,3
	mov bh,0
	mov ah,02h	
	int 10h
	
	
	mov cx,1
	mov bl,9
	xor bh,bh
	mov al,'┐'
	mov ah,09h
	int 10h 
	
	add dh,2
	sub dl,3
	mov bh,0
	mov ah,02h	
	int 10h
	
	mov cx,3
	mov bl,9
	xor bh,bh
	mov al,'─'
	mov ah,09h
	int 10h 
	
	sub dh,1
	dec dl

	mov bh,0
	mov ah,02h	
	int 10h
	
	mov cx,1
	mov bl,9
	xor bh,bh
	mov al,'│'
	mov ah,09h
	int 10h 
	inc dh
	
	add dl,4
	sub dh,1
	mov cx,1
	
	mov bh,0
	mov ah,02h	
	int 10h
	
	mov cx,1
	mov bl,9
	xor bh,bh
	mov al,'│'
	mov ah,09h
	int 10h 
	
	inc dh
	mov bh,0
	mov ah,02h	
	int 10h
		
	mov cx,1
	mov bl,9
	xor bh,bh
	mov al,'┘'
	
	mov ah,09h
	int 10h 
	; ; dec dh
	; ; inc dl
	; ; mov bh,0
	; ; mov ah,02h  
	; ; int 10h
	
	pop dx
	pop cx
	pop bx
	pop ax
	ret

windowsOutput:
	push ax
	push bx
	push cx
	push dx
	
	mov [windowsOutputDh],1
	mov [windowsOutputDl],1
	
	;Ввод координат треугольника
	mov dh,[windowsOutputDh]
	mov dl,[windowsOutputDl]
	mov bh,0
	mov ah,02h	
	int 10h
	
	;Вывод пункта меню 'Проверка' (с помощью функции 13h прерывания 10h)
	mov bp,triangleString		;Загрузка в BP адреса начала строки 'Проверка' 
	mov cx,32					;Помещаем в CX количество выводимых символов 
	mov dh,[windowsOutputDh]	;Строка начала вывода
	mov dl,[windowsOutputDl]				;Колонка начала вывода
	mov bh,0				;Номер видео страницы
	mov al,0				;Код подфункции
	mov bl,9
	mov ah,13h				;Функция вывода строки
	int 10h
	add [windowsOutputDl],33
	sub	[windowsOutputDh],1
	
	mov ah,[windowsOutputDl]
	inc ah
	mov [windowsCoordinatesDl],ah
	
	mov ah,[windowsOutputDh]
	inc ah
	mov [windowsCoordinatesDh],ah
	
	call oneWindowOutput
	
	xor bx,bx
	inc [currentWindow]
	mov cx,2
l3:
	; mov bh,[currentWindow]
	mov bl,[currentWindow]
	add [windowsOutputDl],10
	
	mov ah,[windowsOutputDl]
	inc ah
	mov [windowsCoordinatesDl+bx],ah
	
	mov ah,[windowsOutputDh]
	inc ah
	mov [windowsCoordinatesDh+bx],ah
	
	call oneWindowOutput
	
	inc [currentWindow]
	loop l3
	
	mov dh,[windowsCoordinatesDh]
	mov dl,[windowsCoordinatesDl]
	mov bh,0
	mov ah,02h	
	int 10h
	
;Ввод координат точки
	mov [windowsOutputDh],4
	mov [windowsOutputDl],1
	
	mov dh,[windowsOutputDh]
	mov dl,[windowsOutputDl]
	mov bh,0
	mov ah,02h	
	int 10h
	
	;Вывод пункта меню 'Проверка' (с помощью функции 13h прерывания 10h)
	mov bp,pointString		;Загрузка в BP адреса начала строки 'Проверка' 
	mov cx,23					;Помещаем в CX количество выводимых символов 
	mov dh,[windowsOutputDh]	;Строка начала вывода
	mov dl,[windowsOutputDl]				;Колонка начала вывода
	mov bh,0				;Номер видео страницы
	mov al,0				;Код подфункции
	mov bl,9
	mov ah,13h				;Функция вывода строки
	int 10h
	add [windowsOutputDl],24
	sub	[windowsOutputDh],1
	
	xor bx,bx
	;mov bh,[currentWindow]	
	mov bl,[currentWindow]
	
	mov ah,[windowsOutputDl]
	inc ah
	mov [windowsCoordinatesDl+bx],ah
	
	mov ah,[windowsOutputDh]
	inc ah
	mov [windowsCoordinatesDh+bx],ah
	
	call oneWindowOutput
	
;Ответ  
	mov [windowsOutputDh],7
	mov [windowsOutputDl],1
	
	mov dh,[windowsOutputDh]
	mov dl,[windowsOutputDl]
	mov bh,0
	mov ah,02h	
	int 10h
	
	;Вывод пункта меню 'Проверка' (с помощью функции 13h прерывания 10h)
	mov bp,answerString		;Загрузка в BP адреса начала строки 'Проверка' 
	mov cx,6					;Помещаем в CX количество выводимых символов 
	mov dh,[windowsOutputDh]	;Строка начала вывода
	mov dl,[windowsOutputDl]				;Колонка начала вывода
	mov bh,0				;Номер видео страницы
	mov al,0				;Код подфункции
	mov bl,9
	mov ah,13h				;Функция вывода строки
	int 10h
	
	xor bx,bx
	mov [currentWindow],0
	mov dh,[windowsCoordinatesDh+bx]
	mov dl,[windowsCoordinatesDl+bx]
	
	mov bh,0
	mov bl,11
	mov ah,02h	
	int 10h
	
	pop dx
	pop cx
	pop bx
	pop ax
	ret
	
inputNumber:	
;       push ax
	push bx
	push cx
	push dx
	push si

	xor si,si
	xor dx,dx
	mov bp,10

inputCharNumber:	
	cmp al,'0'			;Сравнение введенного символа и символа '0'
	jb inputCharService	;Если код введенного символа меньше кода цифры '0' (т.е. служебный символ), то перейти на 
						;inputCharService (для проверки нажатия Enter'а)
	
	cmp al,'9'			;Сравнение введенного символа и символа '9'
	ja inputCharNumberEnd		;Если код введенного симовла больше кода цифры '9' (т.е. не служебный символ и не цифра), то 
						;перейти на inputChar (для повторного чтения с клавиатуры)
							
	;Иначе (если нажатый символ является цифрой)
	mov bl,al			;Сохраним символ в BL
	mov ax,si			;Поместим в AX уже считанную часть числа, хранящуюся в DI
	mul bp				;Умножаем содержимое регистра AX на 10 (для увеличения числа на еще 1 разряд); DX:AX = AX * BP
	
	cmp ax,255			
	jae inputCharNumberEnd		;Если DX <> 0, значит было переполнение (введенное значение больше, чем может   
						;поместить в одном 16-разрядном регистре (65 535) ), то перейти на inputChar (для 
						;повторного чтения с клавиатуры)
	
	;Иначе (если переполнения не произошло)
	mov dl,bl			;Поместить в младшую часть DX считанный c клавиатуры символ
	
	sub dl,'0'			;Преобразование считанного символа в цифру
	xor dh,dh			;Обнуление старшей части DX (теперь в DX хранится только введенная цифра; нужно для 
						;дальнейшего сложения с AX (в котором хранится уже считанное число))
	
	add dx,ax			;Суммируем введенную с клавиатуры цифру с уже считанной частью числа
	jc inputCharNumberEnd	    ;Если было переполнение (введенное значение больше, чем может поместить 
						;в одном 16-разрядном регистре (65 535) ), то перейти на inputChar (для повторного чтения с 
						;клавиатуры)
	
	mov si,dx			;Поместить в DI считанное число
	 
	mov dl,bl			;Поместить в DL введенный с клавиатуры символ (нужно для функции вывода 02h прерывания          
						;int21h)
	
	mov ah,02h			;Функция вывода символа
	int 21h 			;Вывод считанного символа
	
inputCharNumberEnd:
	
	mov ah,0
	int 16h
	
	jmp inputCharNumber		;Перейти на inputChar для чтения с клавиатуры

inputCharService:	
	mov dx,si
	
	xor bx,bx
	mov bl,[currentWindow]
	mov cl,[XorY]
	
	cmp cl,'x'
	jne writeY
	
	mov [windowsX+bx],dl
	jmp inputNumberEnd

writeY:
	mov [windowsY+bx],dl
	;mov [inputNumberResult],dl
inputNumberEnd:
	pop si
	pop dx
	pop cx
	pop bx
	; pop ax
	ret	
	
delKey:
	push ax
	push bx
	push cx
	push dx
	
	xor bx,bx
	;mov bh,[currentWindow]
	mov bl,[currentWindow]
	

	mov dh,[windowsCoordinatesDh+bx]
	mov dl,[windowsCoordinatesDl+bx]

	mov cl,[XorY]
	
	cmp cl,'x'
	jne deleteY

	mov [windowsX+bx],0
	jmp delKeyEnd

deleteY:
	mov [windowsY+bx],0
	add dl,4
	
delKeyEnd:
	xor bx,bx
	mov bh,0
	mov ah,02h	
	int 10h
	
	mov bp,deleteString
	mov cx,3
	mov bl,11
	mov bh,0				;Номер видео страницы
	mov al,0				;Код подфункции

	mov ah,13h				;Функция вывода строки
	int 10h
	
	mov bh,0
	mov ah,02h	
	int 10h
	
	pop dx
	pop cx
	pop bx
	pop ax
	ret
	
solution:
	push ax
	push bx
	push cx
	push dx

	call fillSolutionArguments1
	call solveEquation
	mov ax,[solveEquationResult]
	mov [result1],ax
	
	call fillSolutionArguments2	
	call solveEquation
	mov ax,[solveEquationResult]
	mov [result2],ax

	call fillSolutionArguments3
	call solveEquation
	mov ax,[solveEquationResult]
	mov [result3],ax
	
	;call outputNumber
	
	call compareResults
	
	call answerOutput

	pop dx
	pop cx
	pop bx
	pop ax
	ret	
	
; outputNumber:
	; push ax
	; push bp
	; push cx
	; push dx
	; push di

	; push ax
	; mov dh,15
	; mov dl,15
	; mov bh,0
	; mov ah,02h	
	; int 10h
	; pop ax
	
	; mov dx,ax
	; push -1 			;Помещаем с стек значение -1 для созранения признака конца числа

	; mov bp,10d			;Для дальнейшего деления на 10 (для перевода в десятичную систему счисления)

; ;Сохранение в памяти числа (по одной цифре)
; keepNumber:	
	; xor dx,dx			;Обнуление регистра DX
	; div bp				;Деление на 10. DX:AX/BP в AX -- целое, в DX -- остаток
	; push dx 			;Поместим остаток от деления в стек (что бы потом цифру можно было извлечь и вывести на экран)
	; cmp ax,0			;Проверка: является ли целое от деления нулем (оптимальнее or ax,ax)
	; jne keepNumber		;Если да, то достигнут конец числа
	; mov ah,2h			;Функция вывода символа

; ;Вывод числа из памяти (по одной цифре)
; outputFigure:	
	; pop dx				;Восстановим цифру из стека (т.к извлекается из стека, то число выводится с первой цифры)
	; cmp dx,-1			;Сравнение извлеченного числа с -1                                      
	; je outputNumberEnd		;Если равно , значит достигнут конец и надо перейти на метку endProg (для выхода из
						; ;программы){оптимальнее: or dx,dx jl endProg}
	; add dl,'0'			;Преобразование извлеченной цифры в символ
	; int 21h 			;Вывод символа на экран
	; jmp outputFigure	;Перейти на метку outputNumber для вывода дальнейших символов
	
; outputNumberEnd:

	; pop di
	; pop dx
	; pop cx
	; pop bp
	; pop ax
	; ret
	
solveEquation:
	push ax
	push bx
	push cx
	push dx
	push si
	
	xor ax,ax
	xor bx,bx
	xor cx,cx
	xor dx,dx
	
	mov si,solutionArguments
	mov al,[si]	
	mov bl,[si+1]
	sub al,bl
	mov bl,[si+2]
	mov cl,[si+3]
	sub bl,cl
	imul bl
	mov bx,ax
	
	
	mov al,[si+4]
	mov cl,[si]
	sub al,cl
	mov cl,[si+3]
	mov dl,[si+5]
	sub cl,dl
	imul cl
	
	sub bx,ax

	mov [solveEquationResult],bx
	
	pop si
	pop dx
	pop cx
	pop bx
	pop ax

	
fillSolutionArguments1:
	push ax
	push bx
	push cx
	push dx
	push si
	
	mov si,solutionArguments
	
	mov al,[windowsX]
	mov [si],al
	inc si
	
	mov al,[windowsX+3]
	mov [si],al
	inc si
	
	mov al,[windowsY+1]
	mov [si],al
	inc si	
	
	mov al,[windowsY]
	mov [si],al
	inc si
	
	mov al,[windowsX+1]
	mov [si],al
	inc si
	
	mov al,[windowsY+3]
	mov [si],al

	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	ret
	
fillSolutionArguments2:
	push ax
	push bx
	push cx
	push dx
	push si
	
	mov si,solutionArguments
	
	mov al,[windowsX+1]
	mov [si],al
	inc si
	
	mov al,[windowsX+3]
	mov [si],al
	inc si
	
	mov al,[windowsY+2]
	mov [si],al
	inc si	
	
	mov al,[windowsY+1]
	mov [si],al
	inc si
	
	mov al,[windowsX+2]
	mov [si],al
	inc si
	
	mov al,[windowsY+3]
	mov [si],al

	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	ret
	
fillSolutionArguments3:
	push ax
	push bx
	push cx
	push dx
	push si
	
	mov si,solutionArguments
	
	mov al,[windowsX+2]
	mov [si],al
	inc si
	
	mov al,[windowsX+3]
	mov [si],al
	inc si
	
	mov al,[windowsY]
	mov [si],al
	inc si	
	
	mov al,[windowsY+2]
	mov [si],al
	inc si
	
	mov al,[windowsX]
	mov [si],al
	inc si
	
	mov al,[windowsY+3]
	mov [si],al

	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	ret	
	
	
checkInputNumber:
	cmp al,'0'
	jb checkInputNumberEnd
	
	cmp al,'9'
	ja checkInputNumberEnd
	
	call delKey
	call inputNumber
	
checkInputNumberEnd:
	ret	
	
	
compareResults:
	push ax
	push bx
	push cx
	push dx
		
	mov ax,[result1]	
	mov bx,[result2]	
	mov cx,[result3]	
	cmp ax,0
	jl compareResultsMinus1	
	
	cmp ax,0
	jg compareResultsPlus1
	
	jmp compareResultsEnd2
	
compareResultsPlus1:
	cmp bx,0
	jg compareResultsPlus2
	jmp compareResultsEnd2
compareResultsPlus2:
	cmp cx,0
	jg compareResultsEnd1
	jmp compareResultsEnd2
	
compareResultsMinus1:
	cmp bx,0
	jl compareResultsMinus2
	jmp compareResultsEnd2

compareResultsMinus2:
	cmp cx,0
	jl compareResultsEnd1
	jmp compareResultsEnd2
	
compareResultsEnd1:
	mov [resultStringNumber],1
	jmp compareResultsEnd3
compareResultsEnd2:
	mov [resultStringNumber],2

compareResultsEnd3:	
	pop dx
	pop cx
	pop bx
	pop ax
	ret
	
	
answerOutput:
	push ax
	push bx
	push cx
	push dx
	
	mov dh,7
	mov dl,8
	mov bh,0
	mov ah,02h	
	int 10h

	mov bp,deleteString2
	mov cx,40
	mov bl,11
	mov bh,0				;Номер видео страницы
	mov al,0				;Код подфункции

	mov ah,13h				;Функция вывода строки
	int 10h
	
	xor ax,ax

	mov al,[resultStringNumber]
	cmp ax,2
	je answerOutput2

answerOutput1:	
	mov bp,resultString1		;Загрузка в BP адреса начала строки 'Проверка' 
	jmp answerOutput3
	
answerOutput2:
	mov bp,resultString2		;Загрузка в BP адреса начала строки 'Проверка' 
	
answerOutput3:
	xor ax,ax
	
	mov cx,34					;Помещаем в CX количество выводимых символов 
	
	mov dh,7	;Строка начала вывода
	mov dl,8				;Колонка начала вывода
	
	mov bh,0				;Номер видео страницы
	mov al,0				;Код подфункции
	mov bl,11
	mov ah,13h				;Функция вывода строки
	int 10h
		
	xor bx,bx
	; mov bh,[currentWindow]
	mov bl,[currentWindow]
	mov [XorY],'x'
	mov dh,[windowsCoordinatesDh+bx]
	mov dl,[windowsCoordinatesDl+bx]
	
	mov bh,0
	mov ah,02h	
	int 10h
	
	pop dx
	pop cx
	pop bx
	pop ax
	ret
	
clearValues:
	push bx
	push cx

	mov [result1],0
	mov [result2],0
	mov [result3],0
	
	mov bx,4
	mov cx,4
clearValuesLoopStart:
	dec bx
	mov [windowsX+bx],0
	mov [windowsY+bx],0
	loop clearValuesLoopStart

	pop cx
	pop bx
	ret	
	
menuStringCheck 		db	'Проверка$'
menuStringExit			db	'Выход$'
menuStringsBeginDh		db	05
menuStringsBeginDl		db	32
currentString			db 0

windowsOutputDh 		db 1
windowsOutputDl 		db 1

windowsCoordinatesDh	db	0,0,0,0
windowsCoordinatesDl	db	0,0,0,0

windowsX				db	0,0,0,0
windowsY				db	0,0,0,0

XorY					db	'x'


currentWindow			db	0

triangleString			db 'Координаты треугольника (Xn,Yn):$'
pointString				db 'Координаты точки (X,Y):$'
answerString			db 'Ответ:$'

deleteString			db	'   $'
deleteString2			db	'                                             $'

solveEquationResult		dw	0
result1					dw	0
result2					dw	0
result3					dw	0
resultString1			db	'Точка лежит внутри треугольника   $'
resultString2			db	'Точка не лежит внутри треугольника$'
resultStringNumber		db	0

solutionArguments		db	1,0,0,0,0,0