;Воропаева Алина, группа П-402
;Практическая работа №7
;Вариант №7-1-8
;Задание: С клавиатуры вводится массив из не более, чем 10 элементов. Осуществите его обработку и вывод на экран результата 
;Даны два массива, отсортированных по убыванию. Определите количество всех чисел, использованных в обоих массивах.
;Если число используется в обоих массивах, оно учитывается при подсчете один раз.

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
	
	mov di,numbersArray1
	call inputNumbersArray

	mov di,numbersArray1
	mov al,[numbersCount]
	mov [outputCount],al
	call numbersArrayOutput

	
	mov di,numbersArray2
	call inputNumbersArray
	
	mov di,numbersArray2
	mov al,[numbersCount]
	mov [outputCount],al
	call numbersArrayOutput
	
	call countNumbers
	
	mov di,bufArray 
	mov al,[bufCount]
	mov [outputCount],al
	call numbersArrayOutput
;Выход из программы
exit:
	mov ax,4c00h		
	int 21h

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
	
	cmp ax,cx			
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
	
numbersArrayOutput:
	push ax
	push si
	push di
	push cx
	push dx
	
	mov ah,09h			;Функция вывода строки на экран
	mov dx,numbersOutput;Строка с заданием
	int 21h 			;Вывод строки с заданием
	call newLine
	
	xor cx,cx
	xor dx,dx
	mov cl,[outputCount]
	xor bx,bx 
	mov ah,09h
loopOutputStart:
	; ;Вычисление смещения (адреса) начала следующей строки
	mov bl,[outputCount]
	sub bl,cl
	
	xor dx,dx
	;mov dl,[numbersArray1+bx]
	mov dl,[di+bx]
	call outputNumber
	
	call newLine
	loop loopOutputStart	
	pop dx
	pop cx
	pop di
	pop si
	pop ax
	ret

countNumbers:
	push ax
	push bx
	push cx
	push di
	push si

beginLoop:	
	mov di,numbersArray1
	mov si,numbersArray2
	
	mov ah,[numbersCount]
	mov al,[diAdress]
	cmp al,ah
	jne qwe1
	
	mov al,[siAdress]
	cmp al,ah
	je endLoop

qwe1:	xor ax,ax
	
	mov al,[diAdress]
	add di,ax

	mov al,[siAdress]
	add si,ax
	
	mov ah,[di]
	mov al,[si]
	cmp ah,al
	jbe loop1
	; jz loop3
	;jmp loop1c
	jmp loop2
loop1:
	xor bx,bx
	mov bl, [bufCount]
	dec bl
	mov dl,[bufArray+bx]
	cmp dl,al
	jne loop1a
	jmp loop1b
loop1a:
	mov bl,[bufCount]
	mov [bufArray+bx],al
	inc [bufCount] 
loop1b:
	mov al,[siAdress]
	mov ah,[numbersCount]
	cmp al,ah
	jb loop1c
	jmp beginLoop
loop1c:
	inc [siAdress]
	jmp beginLoop

loop2:
	xor bx,bx
	mov bl, [bufCount]
	dec bl
	mov dl,[bufArray+bx]
	cmp dl,ah
	jne loop2a
	jmp loop2b
loop2a:
	mov bl,[bufCount]
	mov [bufArray+bx],ah
	inc [bufCount] 
loop2b:
	mov al,[diAdress]
	mov ah,[numbersCount]
	cmp al,ah
	jb loop2c
	jmp beginLoop
loop2c:
	inc [diAdress]
	jmp beginLoop	

; loop3:

endLoop:	
	pop si
	pop di
	pop cx
	pop bx
	pop ax
	ret

compareDiSi:
	push cx
	push di
	push si
	mov cx,100
	repe cmpsb
	je compareDiSiEnd
	dec di
	dec si
	
	mov ah,[di]
	mov al,[si]
	
	pop si
	pop di
	call exchangeDiSi
	push di 
	push si
	
	compareDiSiEnd:
	pop si
	pop di
	pop cx
	ret
	
exchangeDiSi:
	push di
	push si
	push ax
	push cx
	
	cmp ah,al
	jb exchangeDiSiEnd
	xchg di,si
	mov cx,100
	loopExchangeDiSiStart:
	lodsb
	dec si
	mov ah,al
	xchg di,si
	lodsb
	dec si
	
	stosb
	xchg di,si
	xchg al,ah
	stosb

	loop loopExchangeDiSiStart
	exchangeDiSiEnd:		
	pop cx
	pop ax
	pop si
	pop di
	ret	
	
inputNumbersArray:
	push ax
	push bx
	push cx
	push di
	
	xor dx,dx
	xor cx,cx
	mov cl,[numbersCount]
	xor ax,ax
	xor bx,bx

;Ввод строк
loopStart1:
	
	mov ah,09h			;Функция вывода строки на экран
	mov dx,readNumber
	int 21h 			;Вывод строки 

	xor bx,bx
	
	mov bl,[numbersCount]
	sub bl,cl
	
	;mov di,numbersArray1
	;add di,ax
	
	push cx
	mov cx, 255
	call inputNumber
	xor cx,cx
	mov cl,[inputNumberResult]
	;mov [di],cl

	mov [di+bx],cl
	pop cx
	
	call newLine
	loop loopStart1
	
	pop di
	pop cx
	pop bx
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
	pop di
	pop dx
	pop cx
	pop bp
	pop ax
	ret
		
task			db	'С клавиатуры вводится массив из не более, чем 10 элементов. Осуществите его обработку и вывод на экран результата. Даны два массива, отсортированных по убыванию. Определите количество всех чисел, использованных в обоих массивах. Если число используется в обоих массивах, оно учитывается при подсчете один раз.', 10,13,'$'

answer			db	'Преобразованная строка: $'
readNumber		db	'Введите число: $'
readNumbersCount	db	'Введите количество чисел (до 10): $'
numbersOutput	db 'Массив: $'

numbersCount	db	0
numbersCount2	db	0

numbersArray1	db	10 dup (0)
numbersArray2	db	10 dup (0)

diAdress		db	0
siAdress		db	0

bufArray		db  20 dup (0)
bufCount		db	0

inputNumberResult	db	0
outputCount		db	0