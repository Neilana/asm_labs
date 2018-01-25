;��ய���� �����, ��㯯� �-402
;�ࠪ��᪠� ࠡ�� �2
;��ਠ�� �6-1-1
;�������: �뢥��� ᫮�� ������ ��ப�, ᮤ�ঠ騥 ���⭮� ������⢮ ᨬ�����, �� ����� �� ��ப� ��࠭�.

format mz
begin:
	;��⠭���� ᥣ������ ॣ���஢
	mov ax,cs
	mov ds,ax
	mov es,ax
	
	mov ah,09h			;�㭪�� �뢮�� ��ப� �� ��࠭
	mov dx,task			;��ப� � ��������
	int 21h				;�뢮� ��ப� � ��������
	
	mov ah,09h			;�㭪�� �뢮�� ��ப� �� ��࠭
	mov dx,readString1	;��ப� �ਣ��襭�� ����� ��ࢮ� ��ப�
	int 21h				;�뢮� ��ப� 
	
	mov di, string1		;����㧪� � di ���� ��砫� ��ࢮ� ��ப� (�㦭� ��� ���쭥�襣� ����� ��ப� � ��楤��
						;inputString)
	call inputString	;�맢��� ��楤��� inputString ��� ����� ��ࢮ� ��ப� � ����������
	
	call newLine		;�맮� ��楤��� newLine ��� ���室� �� ����� ��ப�

	mov si, string1
	mov di, bufString
	
	cld					;��⠭���� 䫠�� DF = 0, � ���� ���� DI � di (���� ⥪�㥣� 
						;ᨬ���� � ��ࢮ� � ��ன ��ப�� ᮮ⢥�ᢥ���) ���� 㢥��稢����� (�� 1 ����), � �� 
						;㬥�������
	
	xor cx,cx
	mov cl,'$'
A0:
	xor bx,bx
	mov di,bufString
	
A1:			
	lodsb
	cmp al,' '
	je A2
	cmp al,'$'
	je A2
	inc bx
	stosb
	jmp A1
A2:
	push ax
	xor ax,ax
	mov al,'$'
	stosb
	mov ax,bx
	mov bl,2
	div bl
	cmp ah,0
	jne A3
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


;��室 �� �ணࠬ��
exit:
	mov ax,4c00h		
	int 21h			

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
	xor bx,bx			;���㫥��� ���祭�� BX. � BX �㤥� �࠭����� ������⢮ ��⠭��� ᨬ�����. 
inputChar:
	mov ah,08h			;�㭪�� �⥭�� ᨬ���� � ����������
	int 21h				;��⠥� ᨬ���; ��⠭��  ��࠭���� � AL
	cmp al,13			;�ࠢ����� ���������� ᨬ���� � ᨬ���� '0'
	je inputEnter		;�᫨ ��� ���������� ᨬ���� ����� ���� ���� '0' (�.�. �㦥��� ᨬ���), � ��३� �� 
						;inputCharService (��� �஢�ન ������ Enter'�)
	cmp bx,100
	je inputChar
	mov [di],al
	
	mov dl,al			;�������� � DL �������� � ���������� ᨬ��� (�㦭� ��� �㭪樨 �뢮�� 02h ���뢠��� 		
						;int21h)
	mov ah,02h			;�㭪�� �뢮�� ᨬ����
	int 21h				;�뢮� ��⠭���� ᨬ����
	
	inc di
	inc bx
	jmp inputChar		;��३� �� inputString ��� �⥭�� � ����������
;�᫨ �� ����� Enter, � ��������� ����� � ��⠭��� ��ப� � ��� �� ��楤���
inputEnter:	
	mov dl,'$'			;�������� � DL ᨬ��� ���� ��ப�
	xor dh,dh			;���㫨�� ������ ���� ॣ���� DX
	mov [di],dx			;�������� � ����� 楯�窨 ᨬ����� (���⮢) ��魠� ���� ��ப�
	ret
	
task		db	'� ������ ��ப� �������� �� ���� �㪢� ᫮� (�᫨ �� ��⨭᪨� �㪢�) �� ��������.', 10,13,'$'
answer		db	'�८�ࠧ������� ��ப�: $'
readString1	db	'������ ��ப�: $'
string1		db	100 dup (' ')
bufString	db	100 dup (' ')

