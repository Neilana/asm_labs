;Воропаева Алина, группа П-402
;Практическая работа №3
;Вариант №3-2-1
;Задание:  Задание в заполнении некоторой фигуры цифрами. Между последовательно печатаемыми цифрами следует делать 
;паузу. Параметр n (1 <= n <= 10 ) вводится с клавиатуры. Заполните квадрат n на n по спирали в направлении часовой стрелки от наружной части квадрата к внутренней цифрами от 0 до 9 (циклически) с последовательно меняющимися цветами, начиная с левого верхнего угла.

format mz
begin:
	mov ax,cs
	mov ds,ax

	mov	ah,09h			;Функция вывода строки на экран
	mov dx,str1			;Строка с заданием
	int 21h				;Вывод строки приглашения
	
	xor si,si
	xor cx,cx	
	xor dx,dx	
	xor di,di
	xor bp,bp
	mov byte[incDecNumber],1
	mov byte[color],8
	mov	bp,10d			;Для дальнейшего умножения на 10 (для перевода в десятичную систему счисления)
	
inputChar:	
	mov ah,08h			;Функция чтения символа с клавиатуры
	int 21h				;Читаем символ; считанный  сохраняется в AL
	cmp al,'0'			;Сравнение введенного символа и символа '0'
	jb inputCharService	;Если код введенного симвjла меньше кода цифры '0' (т.е. служебный символ), то перейти на 
						;inputCharService (для проверки нажатия Enter'а)
	
	cmp al,'9'			;Сравнение введенного символа и символа '9'
	ja inputChar		;Если код введенного симовла больше кода цифры '9' (т.е. не служебный символ и не цифра), то 
						;перейти на inputChar (для повторного чтения с клавиатуры)
	
	;Иначе (если нажатый символ является цифрой)
	mov bl,al			;Сохраним символ в BL
	mov ax,di			;Поместим в AX уже считанную часть числа, хранящуюся в DI
	mul bp				;Умножаем содержимое регистра AX на 10 (для увеличения числа на еще 1 разряд); DX:AX = AX * BP
	
	cmp dx,0			;Сравнение содержимого регистра DX с 0
	jne inputChar		;Если DX <> 0, значит было переполнение (введенное значение больше, чем может 	
						;поместить в одном 16-разрядном регистре (65 535) ), то перейти на inputChar (для 
						;повторного чтения с клавиатуры)
	
	;Иначе (если переполнения не произошло)
	mov dl,bl			;Поместить в младшую часть DX считанный c клавиатуры символ
	
	sub dl,'0'			;Преобразование считанного символа в цифру
	xor dh,dh			;Обнуление старшей части DX (теперь в DX хранится только введенная цифра; нужно для 
						;дальнейшего сложения с AX (в котором хранится уже считанное число))
	
	add dx,ax			;Суммируем введенную с клавиатуры цифру с уже считанной частью числа
	cmp dx,10
	ja inputChar
	
	mov di,dx			;Поместить в DI считанное число
	
	mov dl,bl			;Поместить в DL введенный с клавиатуры символ (нужно для функции вывода 02h прерывания 		
	
	mov	ah,02h			;Функция вывода символа
	int	21h
			
	jmp inputChar		;Перейти на inputChar для чтения с клавиатуры

inputCharService:	
	cmp di,0
	je inputChar
	cmp	al,13			;Проверка: была ли нажатая клавиша Enter'ом
	je	squareOutputBegin
	
	jmp inputChar 		;Если был нажат не Enter, то продолжить чтение с клавиатуры

;Вывод треугольника
squareOutputBegin:
	mov ax,0003			;Функция выбора режима
	int 10h				;Выбор режима
	mov si,0			;SI -- будет хранить количество выведенных символов в данной строке

	mov ax,di			;Поместить в AX введенное число (число строк треугольника)
	xor ah,ah			;Обнулить старшую часть AX (т.к. введенное число от 1 до 9 и хранится в AL)
	
	mov bl,2
	div bl				;AX/BL; AL -- целое, AH -- остаток
	mov bl,al
	xor bh,bh
	mov si,bx
	;inc si
	mov bl,ah
	xor bh,bh
	mov bp,bx
	cmp ah,0    
	jz decEvenNumberPosition
	inc si
	
squareOutput2:
	mov dh,0
	mov dl,0
	
	mov cx,1			;CX -- количество повторений выводимого символа (нужно для функции 09h прерывания int10h)	
	push '0'			;Помещение в стек символа '0'. Нужно для вывода символов (цифр). Код выводимой цифры 
						;получается путем извлечения символа из стека и прибавления к нему единицы.
	dec di
	mov word [buffer],0
	mov word [buffer+4],1
	mov	byte [symbol],'0'

	
A1:	
	cmp di,0
	je endProg2
	
	call changeColor

	mov cx,di
B1:
	call rowOutputBegin
	loop B1
	
	; xor bx,bx
	mov cx,di	
B2:
	call columnOutputBegin
	loop B2	
	
	neg byte[incDecNumber]
	; xor bx,bx	
	mov cx,di
	inc cx
B3:
	call rowOutputBegin
	loop B3
	
	inc dl
	dec dh
	
	cmp si,1
	je endProg1
	
	; xor bx,bx
	
	dec di
	mov cx,di

	cmp si,1
	je endProg1
	
B4:
	call columnOutputBegin
	loop B4
	
	cmp si,1
	je endProg1
	
	; xor bx,bx
	
	inc word [buffer]
	inc word[buffer+4]
	inc dh
	inc dl
	
	dec di	
	dec si	
	
	neg byte[incDecNumber]	
	
	cmp di,0
	ja A1

	call changeColor
	cmp di,0
	je endProg2
	call rowOutputBegin	
	
endProg1:
	cmp bp,0
	je endProg
	mov si,0
	
	
endProg2:
	mov ah,02			;Функция установки позиции курсора
	int 10h				;Установка курсора
	mov cx,1

	mov al, byte[symbol]

	call newCharCycle
	mov ah,09h
	; mov bl,dh			;Помещаем в BL номер текущей строки. В BL хранится атрибут символов, выводимых в данной
						; ;строке (для функции 09h прерывания int10h)
	; add bl,dl			;К атрибуту прибавляем 8, потому что от 0 до 8 идут невзрачные атрибуты 	:)
	; inc bl
	int 10h				;Выводим символ
	mov byte[symbol],al

	; mov ah,8h			;Ожидание нажатия клавиши (для реализации паузы)
	; int 21h
	inc dl
	inc si	
		
;Выход из программы	
endProg:
	mov ah,02h
	add dh,dh
	inc dh
	inc dh
	mov dl,0
	int 10h
	
	mov	ah,09h			;Функция вывода строки на экран
	mov dx,str2			;Строка с заданием
	int 21h				;Вывод строки приглашения

	mov ah,8h			;Функция чтения с клавиатуры (для реализации паузы, чтобы программа сразу не закрывалась)
	int 21h			
	
	mov ax,4c00h		;Функция выхода
	int 21h				;Выход

decEvenNumberPosition:
	dec al
	jmp squareOutput2

			
;Установка выводимого символа в равного '0' (в дальнейшем код символа будет увеличен на 1). Переход на эту мутку осущесвтляется если последний выводимый символ был равен '9'.
newCharCycle:
	cmp al,'9'
	je newChar
	
newChar2:
	inc al
		
	ret
						
newChar:
	mov al,'0'			;Установка символа '0' (потом будет увеличен на 1, т.к. выводимый смимвол должен быть от '0'
						;до '9')
	jmp newChar2

changeColor:
	cmp byte[color],15
	je newColor

	inc byte[color]
newColor2:
	mov bl, byte[color]
ret
newColor:
	mov byte[color],8
	jmp newColor2
	
;Вывод строки
rowOutputBegin:
	push cx
	mov cx,1
	mov ah,02			;Функция установки позиции курсора
	int 10h				;Установка курсора	

	mov al, byte[symbol]
	call newCharCycle
	mov ah, 09h 		;Функция для вывода символа с различными атрибутами	
	;mov bl,dh			;Помещаем в BL номер текущей строки. В BL хранится атрибут символов, выводимых в данной
						;строке (для функции 09h прерывания int10h)
	;add bl,dl		;К атрибуту прибавляем 8, потому что от 0 до 8 идут невзрачные атрибуты 	:)
	;inc bl

	int 10h				;Выводим символ
	mov byte[symbol],al
	; mov ah,8h			;Ожидание нажатия клавиши (для реализации паузы)
	; int 21h
	call delay
	;inc dl
	add dl,byte[incDecNumber]
	
	pop cx
	ret

columnOutputBegin:
	push cx
	mov cx,1
	mov ah,02			;Функция установки позиции курсора
	int 10h				;Установка курсора
	
	mov al,byte[symbol]
	call newCharCycle
	mov ah, 09h 		;Функция для вывода символа с различными атрибутами	
	; mov bl,dh			;Помещаем в BL номер текущей строки. В BL хранится атрибут символов, выводимых в данной
						; ;строке (для функции 09h прерывания int10h)
	; add bl,dl			;К атрибуту прибавляем 8, потому что от 0 до 8 идут невзрачные атрибуты 	:)
	; inc bl
	int 10h				;Выводим символ
	mov byte[symbol],al
	; mov ah,8h			;Ожидание нажатия клавиши (для реализации паузы)
	; int 21h
	call delay
	;inc dh
	add dh,byte[incDecNumber]
	pop cx
	ret
		
delay:
	mov     cx, 9999h
delayLoop1:        loop    delayLoop1
	 mov     cx, 9999h
delayLoop2:        loop    delayLoop2
	 mov     cx, 9999h
delayLoop3:        loop    delayLoop3
	 mov     cx, 9999h
delayLoop4:        loop    delayLoop4
	 mov     cx, 9999h
delayLoop5:        loop    delayLoop5
	 mov     cx, 9999h
delayLoop6:        loop    delayLoop6
 mov     cx, 9999h
delayLoop7:        loop    delayLoop7
 mov     cx, 9999h
delayLoop8:        loop    delayLoop8
		ret
		
		
str1	db	'Задание в заполнении некоторой фигуры цифрами. Между последовательно печатаемыми цифрами следует делать паузу. Параметр n (1 <= n <= 10 ) вводится с клавиатуры. Заполните квадрат n на n по спирали в направлении часовой стрелки от наружной части квадрата к внутренней цифрами от 0 до 9 (циклически) с последовательно меняющимися цветами.',10,13
		db	'Введите N: $'
str2	db	'Нажмите любую клавишу...$'
buffer	db	10
symbol	db	18
incDecNumber	db 20
color	db	22