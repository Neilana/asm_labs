;��ய���� �����, ��㯯� �-402
;�ࠪ��᪠� ࠡ�� �7
;��ਠ�� �7-1-8
;�������: � ���������� �������� ���ᨢ �� �� �����, 祬 10 ����⮢. �����⢨� ��� ��ࠡ��� � �뢮� �� �࠭ १���� 
;���� ��� ���ᨢ�, �����஢����� �� �뢠���. ��।���� ������⢮ ��� �ᥫ, �ᯮ�짮������ � ����� ���ᨢ��.
;�᫨ �᫮ �ᯮ������ � ����� ���ᨢ��, ��� ���뢠���� �� ������ ���� ࠧ.

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
;��室 �� �ணࠬ��
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
	
	cmp ax,cx			
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
	
numbersArrayOutput:
	push ax
	push si
	push di
	push cx
	push dx
	
	mov ah,09h			;�㭪�� �뢮�� ��ப� �� �࠭
	mov dx,numbersOutput;��ப� � ��������
	int 21h 			;�뢮� ��ப� � ��������
	call newLine
	
	xor cx,cx
	xor dx,dx
	mov cl,[outputCount]
	xor bx,bx 
	mov ah,09h
loopOutputStart:
	; ;���᫥��� ᬥ饭�� (����) ��砫� ᫥���饩 ��ப�
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

;���� ��ப
loopStart1:
	
	mov ah,09h			;�㭪�� �뢮�� ��ப� �� �࠭
	mov dx,readNumber
	int 21h 			;�뢮� ��ப� 

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
	pop di
	pop dx
	pop cx
	pop bp
	pop ax
	ret
		
task			db	'� ���������� �������� ���ᨢ �� �� �����, 祬 10 ����⮢. �����⢨� ��� ��ࠡ��� � �뢮� �� �࠭ १����. ���� ��� ���ᨢ�, �����஢����� �� �뢠���. ��।���� ������⢮ ��� �ᥫ, �ᯮ�짮������ � ����� ���ᨢ��. �᫨ �᫮ �ᯮ������ � ����� ���ᨢ��, ��� ���뢠���� �� ������ ���� ࠧ.', 10,13,'$'

answer			db	'�८�ࠧ������� ��ப�: $'
readNumber		db	'������ �᫮: $'
readNumbersCount	db	'������ ������⢮ �ᥫ (�� 10): $'
numbersOutput	db '���ᨢ: $'

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