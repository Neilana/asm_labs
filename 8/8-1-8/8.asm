;��ய���� �����, ��㯯� �-402
;�ࠪ��᪠� ࠡ�� �8
;��ਠ�� �8-1-8
;�������: �� ��� �������� ࠧ��୮��� ���ᨢ� �� ����� 10�10. � ������ �����⭮� ��㬥୮� ���ᨢ� 
;������� ���⠬� ����, ������� ��� ����� ���������� � ����, ������� ����� ����� ���������� (��⥬ 
;ᨬ����筮�� ��ࠦ���� �⭮�⥫쭮 ������� ���������).

format mz
begin:
	;��⠭���� ᥣ������ ॣ���஢
	mov ax,cs
	mov ds,ax
	mov es,ax
	
	mov ah,09h			;�㭪�� �뢮�� ��ப� �� �࠭
	mov dx,task			;��ப� � ��������
	int 21h 			;�뢮� ��ப� � ��������
	
	mov ah,09h			;�㭪�� �뢮�� ��ப� �� �࠭
	mov dx,readNumbersCount

	int 21h 			;�뢮� ��ப� 
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
	
;��室 �� �ணࠬ��
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

	mov ah,09h			;�㭪�� �뢮�� ��ப� �� �࠭
	mov dx,readNumber
	int 21h 			;�뢮� ��ப� 

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
	mov ah,08h			;�㭪�� �⥭�� ᨬ���� � ����������
	int 21h 			;��⠥� ᨬ���; ��⠭��  ��࠭���� � AL
	cmp al,'0'			;�ࠢ����� ���������� ᨬ���� � ᨬ���� '0'
	jb inputCharService	;�᫨ ��� ���������� ᨬ�j�� ����� ���� ���� '0' (�.�. �㦥��� ᨬ���), � ��३� �� 
						;inputCharService (��� �஢�ન ������ Enter'�)
	
	cmp al,'9'			;�ࠢ����� ���������� ᨬ���� � ᨬ���� '9'
	ja inputCharNumber		;�᫨ ��� ���������� ᨬ���� ����� ���� ���� '9' (�.�. �� �㦥��� ᨬ��� � �� ���), � 
						;��३� �� inputChar (��� ����୮�� �⥭�� � ����������)
	
	;���� (�᫨ ������ ᨬ��� ���� ��ன)
	mov bl,al			;���࠭�� ᨬ��� � BL
	mov ax,si			;�����⨬ � AX 㦥 ��⠭��� ���� �᫠, �࠭������ � DI
	mul bp				;�������� ᮤ�ন��� ॣ���� AX �� 10 (��� 㢥��祭�� �᫠ �� �� 1 ࠧ��); DX:AX = AX * BP
	
	cmp ax,255			
	jae inputCharNumber		;�᫨ DX <> 0, ����� �뫮 ��९������� (��������� ���祭�� �����, 祬 �����   
						;�������� � ����� 16-ࠧ�來�� ॣ���� (65 535) ), � ��३� �� inputChar (��� 
						;����୮�� �⥭�� � ����������)
	
	;���� (�᫨ ��९������� �� �ந��諮)
	mov dl,bl			;�������� � ������� ���� DX ��⠭�� c ���������� ᨬ���
	
	sub dl,'0'			;�८�ࠧ������ ��⠭���� ᨬ���� � ����
	xor dh,dh			;���㫥��� ���襩 ��� DX (⥯��� � DX �࠭���� ⮫쪮 ��������� ���; �㦭� ��� 
						;���쭥�襣� ᫮����� � AX (� ���஬ �࠭���� 㦥 ��⠭��� �᫮))
	
	add dx,ax			;�㬬��㥬 ��������� � ���������� ���� � 㦥 ��⠭��� ����� �᫠
	jc inputCharNumber	    ;�᫨ �뫮 ��९������� (��������� ���祭�� �����, 祬 ����� �������� 
						;� ����� 16-ࠧ�來�� ॣ���� (65 535) ), � ��३� �� inputChar (��� ����୮�� �⥭�� � 
						;����������)
	
	mov si,dx			;�������� � DI ��⠭��� �᫮
	 
	mov dl,bl			;�������� � DL �������� � ���������� ᨬ��� (�㦭� ��� �㭪樨 �뢮�� 02h ���뢠���          
						;int21h)
	mov ah,02h			;�㭪�� �뢮�� ᨬ����
	int 21h 			;�뢮� ��⠭���� ᨬ����
	
	jmp inputCharNumber		;��३� �� inputChar ��� �⥭�� � ����������

inputCharService:	
	; cmp si,0
	; je inputCharNumber
	cmp al,13			;�᫨ �� ����� Enter, � ��३� � ���᫥���
	jne inputCharNumber	;�᫨ �� ����� �� Enter, � �த������ �⥭�� � ����������
	mov dx,si
	mov [inputNumberResult],dl
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	ret

;newLine -- ��楤�� ��� ���室� ����� ��ப�
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
	
	mov ah,09h			;�㭪�� �뢮�� ��ப� �� �࠭
	mov dx,numbersOutput
	int 21h 			;�뢮� ��ப� � ��������
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
	push -1 			;����頥� � �⥪ ���祭�� -1 ��� ᮧ࠭���� �ਧ���� ���� �᫠

	mov bp,10d			;��� ���쭥�襣� ������� �� 10 (��� ��ॢ��� � �������� ��⥬� ��᫥���)

;���࠭���� � ����� �᫠ (�� ����� ���)
keepNumber:	
	xor dx,dx			;���㫥��� ॣ���� DX
	div bp				;������� �� 10. DX:AX/BP � AX -- 楫��, � DX -- ���⮪
	push dx 			;�����⨬ ���⮪ �� ������� � �⥪ (�� �� ��⮬ ���� ����� �뫮 ������� � �뢥�� �� �࠭)
	cmp ax,0			;�஢�ઠ: ���� �� 楫�� �� ������� �㫥� (��⨬��쭥� or ax,ax)
	jne keepNumber		;�᫨ ��, � ���⨣��� ����� �᫠
	mov ah,2h			;�㭪�� �뢮�� ᨬ����

;�뢮� �᫠ �� ����� (�� ����� ���)
outputFigure:	
	pop dx				;����⠭���� ���� �� �⥪� (�.� ����������� �� �⥪�, � �᫮ �뢮����� � ��ࢮ� ����)
	cmp dx,-1			;�ࠢ����� �����祭���� �᫠ � -1                                      
	je outputNumberEnd		;�᫨ ࠢ�� , ����� ���⨣��� ����� � ���� ��३� �� ���� endProg (��� ��室� ��
						;�ணࠬ��){��⨬��쭥�: or dx,dx jl endProg}
	add dl,'0'			;�८�ࠧ������ �����祭��� ���� � ᨬ���
	int 21h 			;�뢮� ᨬ���� �� �࠭
	jmp outputFigure	;��३� �� ���� outputNumber ��� �뢮�� ���쭥��� ᨬ�����
	
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
	
	readNumber			db	'������ �᫮: $'
	readNumbersCount	db	'������ ࠧ��୮��� ���ᨢ� NxN: $'	
	numbersOutput		db	'���ᨢ: $'
	
	numbersCount		db	0
	array1				db	10 dup(0), 10 dup(0), 10 dup(0), 10 dup(0), 10 dup(0), 10 dup(0), 10 dup(0), 10 dup(0), 10 dup(0), 10 dup(0)
	inputNumberResult	db	0
	task				db	'�� ��� �������� ࠧ��୮��� ���ᨢ� �� ����� 10x10. � ������ �����⭮� ��㬥୮� ���ᨢ� ������� ���⠬� ����, ������� ��� ����� ���������� � ����, ������� ����� ����� ���������� (��⥬ ᨬ����筮�� ��ࠦ���� �⭮�⥫쭮 ������� ���������).', 10,13,'$'