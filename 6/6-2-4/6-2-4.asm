;��ய���� �����, ��㯯� �-402
;�ࠪ��᪠� ࠡ�� �6
;��ਠ�� �6-2-3
;�������: � �������� ������ ��ப� �� �ॢ�蠥� 100 ᨬ�����; ������⢮ ��ப �� ����� 20.
;�����⢨� ���஢�� ��᪮�쪨� ��ப ��⮤�� ���⮣� �롮� � ���浪�, ���⭮� ��䠢�⭮��.

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
	mov dx,readStringsCount
	int 21h 			;�뢮� ��ப� 
	
	call inputStringsCount
	
	call newLine
	
	xor dx,dx
	xor cx,cx
	mov cl,[stringsCount]
	xor ax,ax
	xor bx,bx
;���� ��ப
loopStart1:
	mov ah,09h			;�㭪�� �뢮�� ��ப� �� �࠭
	mov dx,readString
	int 21h 			;�뢮� ��ப� 
	
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
;��砫� ���஢��
loopMainStart1:
	;mov bl,cl      
	
	;���᫥��� ᬥ饭��
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
	call compareDiSi		;�ࠢ����� ���� ��ப   
	
	cmp ch,[stringsCount]
	jbe loopMainStart2
	
	inc cl
	cmp cl,[stringsCount]
	jb loopMainStart1
;����� ���஢��       
	pop si
	pop di
	
	call stringsArrayOutput ;�뢮� ��������� ��ப
		
;��室 �� �ணࠬ��
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
	
	cmp ax,20			
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
	cmp si,0
	je inputCharNumber
	cmp al,13			;�᫨ �� ����� Enter, � ��३� � ���᫥���
	jne inputCharNumber	;�᫨ �� ����� �� Enter, � �த������ �⥭�� � ����������
	mov dx,si
	mov [stringsCount],dl
	pop si
	pop dx
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
	
;inputString -- ��楤�� ��� ����� ��ப� � ����������. ���� �����⢫���� ��ᨬ���쭮, ���� ��砫� ��ப�
;�࠭���� � ॣ���� di. � BX �࠭���� ������⢮ �⠭��� ᨬ����� (����� ��ப�). ����� ��ப� �� ����� �ॢ���� 
;100 ᨬ����� 
inputString:
	push ax
	push bx
	push dx
	push di
	xor bx,bx			;���㫥��� ���祭�� BX. � BX �㤥� �࠭����� ������⢮ ��⠭��� ᨬ�����. 
inputChar:
	mov ah,08h			;�㭪�� �⥭�� ᨬ���� � ����������
	int 21h 			;��⠥� ᨬ���; ��⠭��  ��࠭���� � AL
	cmp al,13			;�ࠢ����� ���������� ᨬ���� � ᨬ���� '0'
	je inputEnter		;�᫨ ��� ���������� ᨬ���� ����� ���� ���� '0' (�.�. �㦥��� ᨬ���), � ��३� �� 
						;inputCharService (��� �஢�ન ������ Enter'�)
	cmp bx,100
	je inputChar
	;mov [di],al
	stosb
	
	mov dl,al			;�������� � DL �������� � ���������� ᨬ��� (�㦭� ��� �㭪樨 �뢮�� 02h ���뢠���          
						;int21h)
	mov ah,02h			;�㭪�� �뢮�� ᨬ����
	int 21h 			;�뢮� ��⠭���� ᨬ����
	
	inc bx
	jmp inputChar		;��३� �� inputString ��� �⥭�� � ����������
;�᫨ �� ����� Enter, � ��������� ����� � ��⠭��� ��ப� � ��� �� ��楤���
inputEnter:	
	mov al,'$'			;�������� � DL ᨬ��� ���� ��ப�
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
	
	mov ah,09h			;�㭪�� �뢮�� ��ப� �� �࠭
	mov dx,stringsOutput;��ப� � ��������
	int 21h 			;�뢮� ��ப� � ��������
	call newLine
	
	xor cx,cx
	xor dx,dx
	mov cl,[stringsCount]
	xor bx,bx
	mov ah,09h			;�㭪�� �뢮�� ��ப� �� �࠭
	
loopOutputStart:
	; ;���᫥��� ᬥ饭�� (����) ��砫� ᫥���饩 ��ப�
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
	
task			db	'�����⢨� ���஢�� ��᪮�쪨� ��ப ��⮤�� ���⮣� �롮� � ���浪�, ���⭮� ��䠢�⭮��.', 10,13,'$'
answer			db	'�८�ࠧ������� ��ப�: $'
readString		db	'������ ��ப�: $'
readStringsCount	db	'������ ������⢮ ��ப (�� 20): $'
stringsOutput	db '�����஢���� ��ப�: $'
string1 		db	100 dup (' ')
bufString		db	100 dup (' ')
stringsCount	db	0
stringsArray	db	100 dup(' '), 100 dup(' '),	100 dup(' '), 100 dup(' '),	100 dup(' '), 100 dup(' '), 100 dup(' '),100 dup(' '), 100 dup(' '), 100 dup(' '), 100 dup(' '), 100 dup(' '), 100 dup(' '), 100 dup(' '), 100 dup(' '), 100 dup(' '), 100 dup(' '), 100 dup(' '), 100 dup(' '), 100 dup(' ')