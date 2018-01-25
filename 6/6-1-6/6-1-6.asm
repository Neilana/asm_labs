;Воропаева Алина, группа П-402
;Практическая работа №2
;Вариант №6-1-6
;Задание:  Выведите слова данной строки, включающие буквосочетание <аб>, по одной на строку экрана.

format mz
begin:
	;Установка сегментных регистров
	mov ax,cs
	mov ds,ax
	mov es,ax
	
	mov ah,09h			;Функция вывода строки на экран
	mov dx,task			;Строка с заданием
	int 21h				;Вывод строки с заданием
	
	mov ah,09h			;Функция вывода строки на экран
	mov dx,readString1	;Строка приглашения ввода первой строки
	int 21h				;Вывод строки 
	
	mov di, string1		;Загрузка в di адреса начала первой строки (нужно для дальнейшего ввода строки в процедуре
						;inputString)
	call inputString	;Вызвать процедуру inputString для ввода первой строки с клавиатуры
	
	call newLine		;Вызов процедуры newLine для перехода на новую строку

	mov si, string1
	mov di, bufString
	
	cld					;Установка флага DF = 0, то есть адреса DI и di (адреса текщуего 
						;символа в первой и второй строках соответсвенно) будут увеличиваться (на 1 байт), а не 
						;уменьшаться
	
A0:
	xor cx,cx
	xor bx,bx
	mov di,bufString
	
A1:			
	lodsb
	cmp al,' '
	je A2
	
	cmp al,'$'
	je A2

	cmp al,'а'
	je A4

	cmp al,'б'
	je A5
	
	cmp cx,1 
	je A7
	
	stosb
	jmp A1

A7:
	stosb
	xor cx,cx
	jmp A1
	
A4:
	stosb
	cmp cx,2
	je A1
	mov cx,1
	jmp A1
A5:
	stosb
	cmp cx,1
	je A6
	jmp A1

A6:
	inc cx
	jmp A1
	
A2:
	push ax
	xor ax,ax
	mov al,'$'
	stosb
	cmp cx,2
	je A3
	pop ax
	cmp al,'$'
	je exit	
	jmp A0

A3:		
	mov ah,09h
	mov dx,bufString
	int 21h
	call newLine
	jmp A0


;Выход из программы
exit:
	mov ax,4c00h		
	int 21h			

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
	xor bx,bx			;Обнуления значения BX. В BX будет храниться количество считанных символов. 
inputChar:
	mov ah,08h			;Функция чтения символа с клавиатуры
	int 21h				;Читаем символ; считанный  сохраняется в AL
	cmp al,13			;Сравнение введенного символа и символа '0'
	je inputEnter		;Если код введенного символа меньше кода цифры '0' (т.е. служебный символ), то перейти на 
						;inputCharService (для проверки нажатия Enter'а)
	cmp bx,100
	je inputChar
	mov [di],al
	
	mov dl,al			;Поместить в DL введенный с клавиатуры символ (нужно для функции вывода 02h прерывания 		
						;int21h)
	mov ah,02h			;Функция вывода символа
	int 21h				;Вывод считанного символа
	
	inc di
	inc bx
	jmp inputChar		;Перейти на inputString для чтения с клавиатуры
;Если был нажат Enter, то обозначить конец в считанной строке и выйти из процедуры
inputEnter:	
	mov dl,'$'			;Поместить в DL символ конца строки
	xor dh,dh			;Обнулить старшую часть регистра DX
	mov [di],dx			;Добавить в конец цепочки символов (байтов) прищнак конца строки
	ret
	
task		db	'Выведите слова данной строки, включающие буквосочетание <аб>, по одной на строку экрана.', 10,13,'$'
answer		db	'Преобразованная строка: $'
readString1	db	'Введите строку: $'
string1		db	100 dup (' ')
bufString	db	100 dup (' ')
