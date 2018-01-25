;Воропаева Алина, группа П-402
;Практическая работа №8
;Вариант №8-1-8
;Задание: Во всех заданиях размерность массива не больше 10х10. В данном квадратном двумерном массиве 
;поменяйте местами часть, лежащую выше обоих диагоналей и часть, лежащую левее обоих диагоналей (путем 
;симметричного отражения относительно главной диагонали).

format mz
begin:
	;Установка сегментных регистров
	mov ax,cs
	mov ds,ax
	mov es,ax
	
	mov ah,09h			;Функция вывода строки на экран
	mov dx,task			;Строка с заданием
	int 21h 			;Вывод строки с заданием
	
	mov ah,09h			;Функция вывода строки на экран
	mov dx,readNumbersCount

	int 21h 			;Вывод строки 
	mov cx,10
	call inputNumber
	mov cl,[inputNumberResult]
	mov [numbersCount],cl

	call newLine

	mov di,array1
	call inputArray

	mov di,array1
	call outputArray

	call changeNumbers

	mov di,array1
	call outputArray
	
;Выход из программы
exit:
	mov ax,4c00h		
	int 21h

inputArray:
	push si
	push di
	push ax 
	push bx 
	push cx 
	push dx 
	
	xor cx,cx
	mov cl,[numbersCount]
inputArrayLoop1:
	push cx
	xor ax,ax
	xor bx,bx
	mov di,array1
	mov al,[numbersCount]
	sub al,cl
	mov cl,10
	mul cl
	add di,ax
	
	mov cl, [numbersCount]
	mov bx,ax	
inputArrayLoop2:
	push cx

	mov ah,09h			;Функция вывода строки на экран
	mov dx,readNumber
	int 21h 			;Вывод строки 

	call inputNumber
;       xor bx,bx
	xor dx,dx
	
	mov dl,[inputNumberResult]
;       mov bl,[numbersCount]
	mov [di+bx],dl
	call newLine
	inc bx
	pop cx
	loop inputArrayLoop2
	
	pop cx
	loop inputArrayLoop1	
	
	pop dx
	pop cx
	pop bx
	pop ax
	pop di
	pop si
	ret
	
	
inputNumber:	
	push ax
	push bx
	push cx
	push dx
	push si
	xor si,si
	xor dx,dx
	mov bp,10

inputCharNumber:	
	mov ah,08h			;Функция чтения символа с клавиатуры
	int 21h 			;Читаем символ; считанный  сохраняется в AL
	cmp al,'0'			;Сравнение введенного символа и символа '0'
	jb inputCharService	;Если код введенного симвjла меньше кода цифры '0' (т.е. служебный символ), то перейти на 
						;inputCharService (для проверки нажатия Enter'а)
	
	cmp al,'9'			;Сравнение введенного символа и символа '9'
	ja inputCharNumber		;Если код введенного симовла больше кода цифры '9' (т.е. не служебный символ и не цифра), то 
						;перейти на inputChar (для повторного чтения с клавиатуры)
	
	;Иначе (если нажатый символ является цифрой)
	mov bl,al			;Сохраним символ в BL
	mov ax,si			;Поместим в AX уже считанную часть числа, хранящуюся в DI
	mul bp				;Умножаем содержимое регистра AX на 10 (для увеличения числа на еще 1 разряд); DX:AX = AX * BP
	
	cmp ax,255			
	jae inputCharNumber		;Если DX <> 0, значит было переполнение (введенное значение больше, чем может   
						;поместить в одном 16-разрядном регистре (65 535) ), то перейти на inputChar (для 
						;повторного чтения с клавиатуры)
	
	;Иначе (если переполнения не произошло)
	mov dl,bl			;Поместить в младшую часть DX считанный c клавиатуры символ
	
	sub dl,'0'			;Преобразование считанного символа в цифру
	xor dh,dh			;Обнуление старшей части DX (теперь в DX хранится только введенная цифра; нужно для 
						;дальнейшего сложения с AX (в котором хранится уже считанное число))
	
	add dx,ax			;Суммируем введенную с клавиатуры цифру с уже считанной частью числа
	jc inputCharNumber	    ;Если было переполнение (введенное значение больше, чем может поместить 
						;в одном 16-разрядном регистре (65 535) ), то перейти на inputChar (для повторного чтения с 
						;клавиатуры)
	
	mov si,dx			;Поместить в DI считанное число
	 
	mov dl,bl			;Поместить в DL введенный с клавиатуры символ (нужно для функции вывода 02h прерывания          
						;int21h)
	mov ah,02h			;Функция вывода символа
	int 21h 			;Вывод считанного символа
	
	jmp inputCharNumber		;Перейти на inputChar для чтения с клавиатуры

inputCharService:	
	; cmp si,0
	; je inputCharNumber
	cmp al,13			;Если был нажат Enter, то перейти к вычислениям
	jne inputCharNumber	;Если был нажат не Enter, то продолжить чтение с клавиатуры
	mov dx,si
	mov [inputNumberResult],dl
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	ret

;newLine -- процедура для перехода новую строку
newLine:
	push ax
	push dx
	mov ah,02h			
	mov dx,13
	int 21h
	
	mov ah,02h	
	mov dx,10
	int 21h
	pop dx
	pop ax
	ret	

outputArray:
	push ax
	push si
	push di
	push cx
	push dx
	
	mov ah,09h			;Функция вывода строки на экран
	mov dx,numbersOutput
	int 21h 			;Вывод строки с заданием
	call newLine
	
	xor cx,cx
	mov cl,[numbersCount]
outputArrayLoop1:
	push cx
	xor ax,ax
	xor bx,bx
	mov di,array1
	mov al,[numbersCount]
	sub al,cl
	mov cl,10
	mul cl
	mov bx,ax
	add di,bx
	
	mov cl, [numbersCount]

outputArrayLoop2:
	push cx

	xor dx,dx
	mov dl,[di+bx]	

	call outputNumber
	inc bx
	pop cx
	loop outputArrayLoop2
	
	call newLine
	pop cx
	loop outputArrayLoop1	
	
	pop dx
	pop cx
	pop di
	pop si
	pop ax
	ret

outputNumber:
	push ax
	push bp
	push cx
	push dx
	push di

	xor ax,ax
	mov ax,dx
	push -1 			;Помещаем с стек значение -1 для созранения признака конца числа

	mov bp,10d			;Для дальнейшего деления на 10 (для перевода в десятичную систему счисления)

;Сохранение в памяти числа (по одной цифре)
keepNumber:	
	xor dx,dx			;Обнуление регистра DX
	div bp				;Деление на 10. DX:AX/BP в AX -- целое, в DX -- остаток
	push dx 			;Поместим остаток от деления в стек (что бы потом цифру можно было извлечь и вывести на экран)
	cmp ax,0			;Проверка: является ли целое от деления нулем (оптимальнее or ax,ax)
	jne keepNumber		;Если да, то достигнут конец числа
	mov ah,2h			;Функция вывода символа

;Вывод числа из памяти (по одной цифре)
outputFigure:	
	pop dx				;Восстановим цифру из стека (т.к извлекается из стека, то число выводится с первой цифры)
	cmp dx,-1			;Сравнение извлеченного числа с -1                                      
	je outputNumberEnd		;Если равно , значит достигнут конец и надо перейти на метку endProg (для выхода из
						;программы){оптимальнее: or dx,dx jl endProg}
	add dl,'0'			;Преобразование извлеченной цифры в символ
	int 21h 			;Вывод символа на экран
	jmp outputFigure	;Перейти на метку outputNumber для вывода дальнейших символов
	
outputNumberEnd:
	mov ah,02h			
	mov dx,' '
	int 21h

	pop di
	pop dx
	pop cx
	pop bp
	pop ax
	ret
	
changeNumbers:
	push ax
	push bx
	push cx
	push di
	push si
	
	mov di, array1
	mov si, array1

	xor cx,cx
	mov cl,[numbersCount]
	sub cx,2

	inc si
	add di,20	
	
	cmp cx,0
	jle a1
changeNumbersLoop1:
	push cx
	push di
	push si
	
changeNumbersLoop2:
	call exchange
	add di,20
	inc si
	loop changeNumbersLoop2

	pop si
	pop di
	pop cx
	
	add di,20
	inc si
	
	sub cx,2
	cmp cx,0
	jle a1

	add si,20
	inc di	;inc j
	jmp changeNumbersLoop1
	
	a1:

	pop si	
	pop di	
	pop cx
	pop bx
	pop ax
	ret

exchange:
	push di
	push si
	push ax


	mov ah,[di]
	mov al,[si]
	
	;mov ax,0908h
	mov [di],al
	mov [si],ah
	
	pop ax
	pop si
	pop di
	ret
	
	readNumber			db	'Введите число: $'
	readNumbersCount	db	'Введите размерность массива NxN: $'	
	numbersOutput		db	'Массив: $'
	
	numbersCount		db	0
	array1				db	10 dup(0), 10 dup(0), 10 dup(0), 10 dup(0), 10 dup(0), 10 dup(0), 10 dup(0), 10 dup(0), 10 dup(0), 10 dup(0)
	inputNumberResult	db	0
	task				db	'Во всех заданиях размерность массива не больше 10x10. В данном квадратном двумерном массиве поменяйте местами часть, лежащую выше обоих диагоналей и часть, лежащую левее обоих диагоналей (путем симметричного отражения относительно главной диагонали).', 10,13,'$'