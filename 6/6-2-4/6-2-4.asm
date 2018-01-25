;Воропаева Алина, группа П-402
;Практическая работа №6
;Вариант №6-2-3
;Задание: В заданиях каждая строка не превышает 100 символов; количество строк не более 20.
;Осуществите сортировку нескольких строк методом простого выбора в порядке, обратном алфавитному.

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
	mov dx,readStringsCount
	int 21h 			;Вывод строки 
	
	call inputStringsCount
	
	call newLine
	
	xor dx,dx
	xor cx,cx
	mov cl,[stringsCount]
	xor ax,ax
	xor bx,bx
;Ввод строк
loopStart1:
	mov ah,09h			;Функция вывода строки на экран
	mov dx,readString
	int 21h 			;Вывод строки 
	
	mov al,[stringsCount]
	sub al,cl
	mov bl,100
	mul bl
	mov bx,ax
	
	mov di,stringsArray
	add di,bx
	
	call inputString
	call newLine
	loop loopStart1
	
	mov di,stringsArray
	xor cx,cx
;       mov cl,[stringsCount]
push di
push si
;Начало сортировки
loopMainStart1:
	;mov bl,cl      
	
	;Вычисление смещения
	xor ax,ax
	mov al,cl
	mov bl,100
	mul bl
	mov bx,ax	
	mov si,stringsArray		
	add si,bx	
	
	mov ch,cl
	loopMainStart2:
	inc ch
	xor ax,ax
	mov al,ch
	mov bl,100
	mul bl
	mov bx,ax
	mov di,stringsArray		
	add di,bx
	call compareDiSi		;Сравнение двух строк   
	
	cmp ch,[stringsCount]
	jbe loopMainStart2
	
	inc cl
	cmp cl,[stringsCount]
	jb loopMainStart1
;Конец сортировки       
	pop si
	pop di
	
	call stringsArrayOutput ;Вывод введенных строк
		
;Выход из программы
exit:
	mov ax,4c00h		
	int 21h

inputStringsCount:	
	push ax
	push bx
	push dx
	push si
	xor si,si
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
	
	cmp ax,20			
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
	cmp si,0
	je inputCharNumber
	cmp al,13			;Если был нажат Enter, то перейти к вычислениям
	jne inputCharNumber	;Если был нажат не Enter, то продолжить чтение с клавиатуры
	mov dx,si
	mov [stringsCount],dl
	pop si
	pop dx
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
	
;inputString -- процедура для ввода строки с клавиатуры. Ввод осуществляется посимвольно, адрес начала строки
;хранится в регистре di. В BX хранится количество ситанных символов (длина строки). Длина строки не может превышать 
;100 символов 
inputString:
	push ax
	push bx
	push dx
	push di
	xor bx,bx			;Обнуления значения BX. В BX будет храниться количество считанных символов. 
inputChar:
	mov ah,08h			;Функция чтения символа с клавиатуры
	int 21h 			;Читаем символ; считанный  сохраняется в AL
	cmp al,13			;Сравнение введенного символа и символа '0'
	je inputEnter		;Если код введенного символа меньше кода цифры '0' (т.е. служебный символ), то перейти на 
						;inputCharService (для проверки нажатия Enter'а)
	cmp bx,100
	je inputChar
	;mov [di],al
	stosb
	
	mov dl,al			;Поместить в DL введенный с клавиатуры символ (нужно для функции вывода 02h прерывания          
						;int21h)
	mov ah,02h			;Функция вывода символа
	int 21h 			;Вывод считанного символа
	
	inc bx
	jmp inputChar		;Перейти на inputString для чтения с клавиатуры
;Если был нажат Enter, то обозначить конец в считанной строке и выйти из процедуры
inputEnter:	
	mov al,'$'			;Поместить в DL символ конца строки
	stosb

	pop di
	pop dx
	pop bx
	pop ax
	ret
		
stringsArrayOutput:
	push si
	push di
	push cx
	
	mov ah,09h			;Функция вывода строки на экран
	mov dx,stringsOutput;Строка с заданием
	int 21h 			;Вывод строки с заданием
	call newLine
	
	xor cx,cx
	xor dx,dx
	mov cl,[stringsCount]
	xor bx,bx
	mov ah,09h			;Функция вывода строки на экран
	
loopOutputStart:
	; ;Вычисление смещения (адреса) начала следующей строки
	mov al,[stringsCount]
	sub al,cl
	mov bl,100
	mul bl
	mov bx,ax
	
	mov dx,stringsArray		
	add dx,bx
	mov ah,09h
	int 21h 			
	call newLine
	loop loopOutputStart	
	pop cx
	pop di
	pop si
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
	
	; mov ah,02h
	; mov dl,[di]
	; int 21h               
	
	; mov ah,02h
	; mov dl,[si]
	; int 21h       
	; mov ah,08h
	; int 21h
	
	loop loopExchangeDiSiStart
	exchangeDiSiEnd:		
	pop cx
	pop ax
	pop si
	pop di
	ret	
	
task			db	'Осуществите сортировку нескольких строк методом простого выбора в порядке, обратном алфавитному.', 10,13,'$'
answer			db	'Преобразованная строка: $'
readString		db	'Введите строку: $'
readStringsCount	db	'Введите количество строк (до 20): $'
stringsOutput	db 'Отсортированные строки: $'
string1 		db	100 dup (' ')
bufString		db	100 dup (' ')
stringsCount	db	0
stringsArray	db	100 dup(' '), 100 dup(' '),	100 dup(' '), 100 dup(' '),	100 dup(' '), 100 dup(' '), 100 dup(' '),100 dup(' '), 100 dup(' '), 100 dup(' '), 100 dup(' '), 100 dup(' '), 100 dup(' '), 100 dup(' '), 100 dup(' '), 100 dup(' '), 100 dup(' '), 100 dup(' '), 100 dup(' '), 100 dup(' ')