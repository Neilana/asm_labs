;��ய���� �����, ��㯯� �-402
;�ࠪ��᪠� ࠡ�� �2
;��ਠ�� �6-0-1
;�������: � ���� ������ ��ப�� ��।���� ������⢮ ᮢ������� ᨬ�����, ����� �� ���������� ����樨 � ��ப�.
;�ᯮ�짮���� ������� ��� ��ࠡ�⪨ ��ப: CLD.

format mz
begin:
	;��⠭���� ᥣ������ ॣ���஢
	mov ax,cs
	mov ds,ax
	mov es,ax
	
	mov ah,09h			;�㭪�� �뢮�� ��ப� �� �࠭
	mov dx,task			;��ப� � ��������
	int 21h				;�뢮� ��ப� � ��������
	
	mov ah,09h			;�㭪�� �뢮�� ��ப� �� �࠭
	mov dx,readString1	;��ப� �ਣ��襭�� ����� ��ࢮ� ��ப�
	int 21h				;�뢮� ��ப� 
	
	mov si, string1		;����㧪� � SI ���� ��砫� ��ࢮ� ��ப� (�㦭� ��� ���쭥�襣� ����� ��ப� � ��楤��
						;inputString)
	call inputString	;�맢��� ��楤��� inputString ��� ����� ��ࢮ� ��ப� � ����������
	
	call newLine		;�맮� ��楤��� newLine ��� ���室� �� ����� ��ப�
	
	mov ah,09h			;�㭪�� �뢮�� ��ப� �� �࠭
	mov dx,readString2	;��ப� �ਣ��襭�� ����� ��ࢮ� ��ப�
	int 21h				;�뢮� ��ப�
	
	mov si, string2		;����㧪� � SI ���� ��砫� ��ࢮ� ��ப� (�㦭� ��� ���쭥�襣� ����� ��ப� � ��楤��
						;inputString)
	call inputString	;�맢��� ��楤��� inputString ��� ����� ��ன ��ப� � ����������
	
	call newLine		;�맮� ��楤��� newLine ��� ���室� �� ����� ��ப�

	mov di, string1		;����㧪� � DI ���� ��砫� ��ࢮ� ��ப� (�㦭� ��� �ࠢ����� ��ப � ������� ������� �MPS)
	mov si, string2		;����㧪� � SI ���� ��砫� ��ன ��ப� (�㦭� ��� �ࠢ����� ��ப � ������� ������� �MPS)

	mov cx,100			;����㧪� � CX ���ᨬ��쭮� ����� ��ப (�㦭� ��� ��䨪� REP)
	cld					;��⠭���� 䫠�� DF = 0, � ���� ���� DI � SI (���� ⥪�㥣� 
						;ᨬ���� � ��ࢮ� � ��ன ��ப�� ᮮ⢥�ᢥ���) ���� 㢥��稢����� (�� 1 ����), � �� 
						;㬥�������
	
	xor bx,bx			;BX -- ����稪 ����������� ���
	xor cx,cx
	mov cl,'$'
A1:			

	cmpsb
	je incCounter		

	cmp [si],cx
	je answerOutput
	
	cmp [di],cx
	je answerOutput

	jmp	A1
	
incCounter:
	inc bx
	cmp [si],cx
	je answerOutput
	
	cmp [di],cx
	je answerOutput
	
	jmp A1

;�뢮� �⢥�
answerOutput:
	push bx
	mov ah,09h
	mov dx,answer
	int 21h

	pop ax				;��������� �� �⥪� � AX �������� १����
	push -1				;����頥� � �⥪ ���祭�� -1 ��� ᮧ࠭���� �ਧ���� ���� �᫠

	mov bp,10d			;��� ���쭥�襣� ������� �� 10 (��� ��ॢ��� � �������� ��⥬� ��᫥���)

;���࠭���� � ����� �᫠ (�� ����� ���)
keepNumber:	
	xor dx,dx			;���㫥��� ॣ���� DX
	div bp				;������� �� 10. DX:AX/BP � AX -- 楫��, � DX -- ���⮪
	push dx				;�����⨬ ���⮪ �� ������� � �⥪ (�� �� ��⮬ ���� ����� �뫮 ������� � �뢥�� �� �࠭)
	cmp ax,0			;�஢�ઠ: ���� �� 楫�� �� ������� �㫥� (��⨬��쭥� or ax,ax)
	jne keepNumber		;�᫨ ��, � ���⨣��� ����� �᫠
	mov ah,2h			;�㭪�� �뢮�� ᨬ����

;�뢮� �᫠ �� ����� (�� ����� ���)
outputNumber:	
	pop dx				;����⠭���� ���� �� �⥪� (�.� ����������� �� �⥪�, � �᫮ �뢮����� � ��ࢮ� ����)
	cmp dx,-1			;�ࠢ����� �����祭���� �᫠ � -1					
	je exit				;�᫨ ࠢ�� , ����� ���⨣��� ����� � ���� ��३� �� ���� endProg (��� ��室� ��
						;�ணࠬ��){��⨬��쭥�: or dx,dx jl endProg}
	add dl,'0'			;�८�ࠧ������ �����祭��� ���� � ᨬ���
	int 21h				;�뢮� ᨬ���� �� �࠭
	jmp outputNumber	;��३� �� ���� outputNumber ��� �뢮�� ���쭥��� ᨬ�����	

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
;�࠭���� � ॣ���� SI. � BX �࠭���� ������⢮ �⠭��� ᨬ����� (����� ��ப�). ����� ��ப� �� ����� �ॢ���� 
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
	mov [si],al
	
	mov dl,al			;�������� � DL �������� � ���������� ᨬ��� (�㦭� ��� �㭪樨 �뢮�� 02h ���뢠��� 		
						;int21h)
	mov ah,02h			;�㭪�� �뢮�� ᨬ����
	int 21h				;�뢮� ��⠭���� ᨬ����
	
	inc si
	inc bx
	jmp inputChar		;��३� �� inputString ��� �⥭�� � ����������
;�᫨ �� ����� Enter, � ��������� ����� � ��⠭��� ��ப� � ��� �� ��楤���
inputEnter:	
	mov dl,'$'			;�������� � DL ᨬ��� ���� ��ப�
	xor dh,dh			;���㫨�� ������ ���� ॣ���� DX
	mov [si],dx			;�������� � ����� 楯�窨 ᨬ����� (���⮢) ��魠� ���� ��ப�
	ret
	
task		db	'� ���� ������ ��ப�� ��।���� ������⢮ ᮢ������� ᨬ�����, ����� �� ���������� ����樨 � ��ப�.', 10,13,'$'
answer		db	'�⢥�: $'
readString1	db	'������ ����� ��ப�: $'
readString2	db	'������ ����� ��ப�: $'
string1		db	100 dup (' ')
string2		db	100 dup (' ')