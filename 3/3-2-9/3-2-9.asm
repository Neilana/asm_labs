;��ய���� �����, ��㯯� �-402
;�ࠪ��᪠� ࠡ�� �3
;��ਠ�� �3-2-9
;�������: ������� � ���������� �����ன 䨣��� ��ࠬ�. ����� ��᫥����⥫쭮 ���⠥�묨 ��ࠬ� ᫥��� ������
;����. ��ࠬ��� n (1 <= n <= 10 ) �������� � ����������. �������� ������ n �� n �� ᯨࠫ� � ���ࠢ����� �ᮢ��
;��५�� �� ���㦭�� ��� ������ � ����७��� ��ࠬ� �� 0 �� 9 (横���᪨) � ��᫥����⥫쭮 �����騬��� 
;梥⠬�, ��稭�� � �ࠢ��� ���孥�� 㣫�.

format mz
begin:
	mov ax,cs
	mov ds,ax

	mov ah,09h			;�㭪�� �뢮�� ��ப� �� �࠭
	mov dx,str1			;��ப� � �������� � �ਣ��襭���
	int 21h				;�뢮� ��ப� � �������� � �ਣ��襭���
	
	xor dx,dx	
	xor di,di
	mov byte[incDecNumber],1	;
	mov byte[color],8
	mov bp,10d			;��� ���쭥�襣� 㬭������ �� 10 (��� ��ॢ��� � �������� ��⥬� ��᫥���)
	
inputChar:	
	mov ah,08h			;�㭪�� �⥭�� ᨬ���� � ����������
	int 21h				;��⠥� ᨬ���; ��⠭�� ��࠭���� � AL
	cmp al,'0'			;�ࠢ����� ���������� ᨬ���� � ᨬ���� '0'
	jb inputCharService	;�᫨ ��� ���������� ᨬ���� ����� ���� ���� '0' (�.�. �㦥��� ᨬ���), � ��३� �� 
						;inputCharService (��� �஢�ન ������ Enter'�)
	
	cmp al,'9'			;�ࠢ����� ���������� ᨬ���� � ᨬ���� '9'
	ja inputChar		;�᫨ ��� ���������� ᨬ���� ����� ���� ���� '9' (�.�. �� �㦥��� ᨬ��� � �� ���), � 
						;��३� �� inputChar (��� ����୮�� �⥭�� � ����������)
	
	;���� (�᫨ ������ ᨬ��� ���� ��ன)
	mov bl,al			;���࠭�� ᨬ��� � BL
	mov ax,di			;�����⨬ � AX 㦥 ��⠭��� ���� �᫠, �࠭������ � DI
	mul bp				;�������� ᮤ�ন��� ॣ���� AX �� 10 (��� 㢥��祭�� �᫠ �� �� 1 ࠧ��); DX:AX = AX * BP
	
	cmp dx,0			;�ࠢ����� ᮤ�ন���� ॣ���� DX � 0
	jne inputChar		;�᫨ DX <> 0, ����� �뫮 ��९������� (��������� ���祭�� �����, 祬 ����� 	
						;�������� � ����� 16-ࠧ�來�� ॣ���� (65 535) ), � ��३� �� inputChar (��� 
						;����୮�� �⥭�� � ����������)
	
	;���� (�᫨ ��९������� �� �ந��諮)
	mov dl,bl			;�������� � ������� ���� DX ��⠭�� c ���������� ᨬ���
	
	sub dl,'0'			;�८�ࠧ������ ��⠭���� ᨬ���� � ����
	xor dh,dh			;���㫥��� ���襩 ��� DX (⥯��� � DX �࠭���� ⮫쪮 ��������� ���; �㦭� ��� 
						;���쭥�襣� ᫮����� � AX (� ���஬ �࠭���� 㦥 ��⠭��� �᫮))
	
	add dx,ax			;�㬬��㥬 ��������� � ���������� ���� � 㦥 ��⠭��� ����� �᫠
	cmp dx,10
	ja inputChar
	
	mov di,dx			;�������� � DI ��⠭��� �᫮
	
	mov dl,bl			;�������� � DL �������� � ���������� ᨬ��� (�㦭� ��� �㭪樨 �뢮�� 02h ���뢠��� 	
	
	mov ah,02h			;�㭪�� �뢮�� ᨬ����
	int 21h
			
	jmp inputChar		;��३� �� inputChar ��� �⥭�� � ����������

inputCharService:	
	cmp di,0
	je inputChar
	cmp al,13			;�஢�ઠ: �뫠 �� ������ ������ Enter'��
	je squareOutputBegin
	
	jmp inputChar 		;�᫨ �� ����� �� Enter, � �த������ �⥭�� � ����������

;�뢮� ������
squareOutputBegin:
	mov ax,0003			;�㭪�� �롮� ०���
	int 10h				;�롮� ०���
	xor si,si			;SI -- �㤥� �࠭��� ������⢮ �뢥������ ᨬ����� � ������ ��ப�

	mov ax,di			;�������� � AX ��������� �᫮ (ࠧ��୮��� ������)
	xor ah,ah			;���㫨�� ������ ���� AX (�.�. ��������� �᫮ �� 1 �� 9 � �࠭���� � AL)
	
	mov bl,2			;� BL ����頥� 2 ��� ���쭥�襣� ������� �� 2
	div bl				;AX/BL; AL -- 楫��, AH -- ���⮪
	mov bl,al			;����頥� 楫�� �᫮, ����祭��� � १���� ������� �� 2 � BL
	xor bh,bh			;���㫨�
	
	mov si,bx			
	mov bl,ah			
	xor bh,bh
	mov bp,bx
	
	cmp ah,0 
	jz decEvenNumberPosition
	inc si
	
squareOutput2:
	mov dh,0
	mov dl,0
	
	mov cx,1			;CX -- ������⢮ ����७�� �뢮������ ᨬ���� (�㦭� ��� �㭪樨 09h ���뢠��� int10h)	
	push '0'			;����饭�� � �⥪ ᨬ���� '0'. �㦭� ��� �뢮�� ᨬ����� (���). ��� �뢮����� ���� 
						;����砥��� ��⥬ �����祭�� ᨬ���� �� �⥪� � �ਡ������� � ���� �������.
	dec di
	mov word [buffer],0
	mov word [buffer+4],1
	mov byte [symbol],'0'
	dec byte[symbol]
	call changeColor
	
A1:
	cmp di,0				;�ࠢ����� DI � 0
	je endProg2				;�᫨ DI = 0, ����� ��������� �᫮ (ࠧ��୮��� ������) ࠢ�� 1 � ��३� �� ���� endProg2	(��� ��室� �� �ணࠬ��)
	
	mov cx,di				;� CX �࠭����� �᫮, ������饥 ������⢮ ᨬ�����, ����� ���� �뢥�� � ������ ��ப�
;����� ᨬ����� � ���孥� ��ਧ����쭮� �࠭�� ������ (���������� ��ப� �ࠢ� ������)
B1:
	call rowOutputBegin		;�맮� �㭪樨 ���� ������ ᨬ���� � ��ப�
	loop B1					;�������� 横�, ���� � ��ப� �� �뢥���� ����室���� ������⢮ ᨬ�����
	
	call changeColor		;�맮� ��楤��� ᬥ�� 梥� ���⠥���� ᨬ����
	
	mov cx,di				;� CX �࠭����� �᫮, ������饥 ������⢮ ᨬ�����, ����� ���� �뢥�� � ������ �⮫��
;����� ᨬ����� � �ࠢ�� �࠭�� ������ (���������� �⮫�� ᢥ��� ����)
B2:
	call columnOutputBegin	;�맮� �㭪樨 ���� ������ ᨬ���� � ������ �⮫��
	loop B2					;�������� 横�, ���� � �⮫�� �� �뢥���� ����室���� ������⢮ ᨬ�����
	
	neg byte[incDecNumber]	;���塞 ���ࠢ����� �뢮�� ᨬ����� (�ࠢ� ������ � ᭨�� ����� ��� ��ப� � �⮫�� ᮮ⢥�ᢥ���)
	
	mov cx,di				;� CX �࠭����� �᫮, ������饥 ������⢮ ᨬ�����, ����� ���� �뢥�� � ������ ��ப�
	inc cx					
;�뢮� ������ �࠭��� ������ (���������� ��ப� �ࠢ� ������)
B3:
	call rowOutputBegin		;�맮� �㭪樨 ���� ������ ᨬ���� � ������ ��ப�
	loop B3					;�������� 横�, ���� � ��ப� �� �뢥���� ����室���� ������⢮ ᨬ�����
	
	inc dl					;���室 �� 1 �⮫��� ��ࠢ�
	dec dh					;���室 �� 1 ��ப� �����
	
	cmp si,1				;�ࠢ����� ����� ���⠥���� ������ � 1
	je endProg1				;�᫨ ⥪�騩 ������� ��᫥����, � ��३� �� ���� endProg1 (��� ��室� �� �ணࠬ��)
	
	
	dec di
	mov cx,di

	cmp si,1
	je endProg1
	
B4:
	call columnOutputBegin
	loop B4
	
	cmp si,1
	je endProg1
		
	inc word [buffer]
	inc word[buffer+4]
	inc dh
	inc dl
	
	dec di	
	dec si	
	
	neg byte[incDecNumber]	
	
	cmp di,0
	ja A1

	cmp di,0
	je endProg2
	call rowOutputBegin	

;�����⢫�� �஢��� ࠧ��୮�� ������
endProg1:
	cmp bp,0			;�᫨ ���⮪ �� ������� ���������� � ���������� �᫠ ࠢ�� 0 (�᫨ ��� ��⭮�)
	je endProg			
	mov si,0
	
endProg2:
	mov ah,02			;�㭪�� ��⠭���� ����樨 �����
	int 10h				;��⠭���� �����
	mov cx,1

	mov al, byte[symbol]

	call newCharCycle
	mov ah,09h
	int 10h				;�뢮��� ᨬ���
	mov byte[symbol],al

	inc dl
	inc si	
		
;��室 �� �ணࠬ��	
endProg:
	mov ah,02h
	add dh,dh
	inc dh
	inc dh
	mov dl,0
	int 10h
	
	mov	ah,09h			;�㭪�� �뢮�� ��ப� �� �࠭
	mov dx,str2			;��ப� � ��������
	int 21h				;�뢮� ��ப� �ਣ��襭��

	mov ah,8h			;�㭪�� �⥭�� � ���������� (��� ॠ����樨 ����, �⮡� �ணࠬ�� �ࠧ� �� ����뢠����)
	int 21h			
	
	mov ax,4c00h		;�㭪�� ��室�
	int 21h				;��室

decEvenNumberPosition:
	dec al
	jmp squareOutput2

			
;��⠭���� �뢮������ ᨬ���� � ࠢ���� '0' (� ���쭥�襬 ��� ᨬ���� �㤥� 㢥��祭 �� 1). ���室 �� ��� ���� ���������� �᫨ ��᫥���� �뢮���� ᨬ��� �� ࠢ�� '9'.
newCharCycle:
	inc al
		
	cmp al,'9'
	ja newChar
newChar2:	
	ret
						
newChar:
	mov al,'0'			;��⠭���� ᨬ���� '0' (��⮬ �㤥� 㢥��祭 �� 1, �.�. �뢮���� ᬨ���� ������ ���� �� 
						;'0' �� '9')
	jmp newChar2

changeColor:
	cmp byte[color], 15
	je newColor

	inc byte[color]
newColor2:
	mov bl, byte[color]
ret
newColor:
	mov byte[color], 8
	jmp newColor2
	
;�㭪�� �뢮�� ��ப�
rowOutputBegin:
	push cx
	mov cx,1
	mov ah,02			;�㭪�� ��⠭���� ����樨 �����
	int 10h				;��⠭���� �����	

	mov al, byte[symbol]
	call newCharCycle
	mov ah, 09h 		;�㭪�� ��� �뢮�� ᨬ���� � ࠧ���묨 ��ਡ�⠬�	

	int 10h				;�뢮��� ᨬ���
	mov byte[symbol], al
	call delay
	add dl, byte[incDecNumber]
	
	pop cx
	ret

;�㭪�� �뢮�� �⮫��	
columnOutputBegin:
	push cx
	mov cx, 1
	mov ah, 02			;�㭪�� ��⠭���� ����樨 �����
	int 10h				;��⠭���� �����
	
	mov al, byte[symbol]
	call newCharCycle
	mov ah, 09h 		;�㭪�� ��� �뢮�� ᨬ���� � ࠧ���묨 ��ਡ�⠬�	
	int 10h				;�뢮��� ᨬ���
	mov byte[symbol], al
	call delay
	add dh,byte[incDecNumber]
	pop cx
	ret
	
;�㭪��, �����⢫���� ���� ����� ���⠥�묨 ᨬ������. �㭪�� ॠ�������� ������� ��᪮�쪨� 横���, ����� ��祣� �� ������, � ⮫쪮 �������� ᠬ� � ᥡ� � ����� �६�.
delay:
	mov cx, 9999h					;����頥� � CX �᫮, ��������饥 ᪮�쪮 ࠧ ������ �믮������� 横� (横�, ����� ���頥��� ᠬ � ᥡ� � ��祣� �� ������)
	delayLoop1: loop delayLoop1		;�ந�室�� 㬥��襭�� CX � ���室 �� ��砫� 横��, �᫨ ������⢮ CX �� ࠢ�� 0
		
	;������騥 ��᪮�쪮 ��ப ��������� ��� �।��騬. �㦭� ��� �����⢫���� ����⭮� ����প� ����� �뢮���묨 ᨬ������
	mov cx, 9999h
	delayLoop2: loop delayLoop2
		
	mov cx, 9999h
	delayLoop3: loop delayLoop3
		
	mov cx, 9999h
	delayLoop4: loop delayLoop4
		
	mov cx, 9999h
	delayLoop5: loop delayLoop5
		
	mov cx, 8000h
	delayLoop6: loop delayLoop6
		
	mov cx, 8000h
	delayLoop7: loop delayLoop7
		
	mov cx, 8000h
	delayLoop8: loop delayLoop8
ret

str1	db	'������� � ���������� �����ன 䨣��� ��ࠬ�. ����� ��᫥����⥫쭮 ���⠥�묨 ��ࠬ� ᫥��� ������ ����. ��ࠬ��� n (1 <= n <= 10 ) �������� � ����������. �������� ������ n �� n �� ᯨࠫ� � ���ࠢ����� �ᮢ�� ��५�� �� ���㦭�� ��� ������ � ����७��� ��ࠬ� �� 0 �� 9 (横���᪨) � ��᫥����⥫쭮 �����騬��� 梥⠬�, ��稭�� � �ࠢ��� ���孥�� 㣫�.',10,13
		db	'������ N: $'
str2	db	'������ ���� �������...$'
buffer	db	10
symbol	db	18
incDecNumber	db 20
color	db	22