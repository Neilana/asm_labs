;��ய���� �����, ��㯯� �-402

;�������: �ணࠬ�� �஢�ન ⮣�, �� �窠 ����� ����� ������� ��㣮�쭨��. 
;� �᭮���� ���� ��� �㭪� - <�஢�ઠ> � <��室>. �� �롮� �㭪� ���� 
;<�஢�ઠ> ������ ����������� ����� ���न���� ����� �祪 
;(��४��祭�� ����� ���� - ���). � ��⠢襬�� ���誥 �뢮����� �⢥� - <��> 
;��� <���>. ESC - ��室 � ����. DEL - ��࠭�� �ᥣ� ���祭��.

format mz
begin:
;��⠭���� ᥣ������ ॣ���஢
	mov ax,cs
	mov ds,ax
	mov es,ax

	call clearValues
	
	mov ax,0003				;�㭪�� �롮� ०���
	int 10h 				;�롮� ०���

;�뢮� ��ப ����
	mov bl,11				;��ਡ�� �뢮����� ᨬ����� (ᨭ�� ⥪��)
	call menuStringCheckOutput
	
	mov bl,9				;��ਡ�� �뢮����� ᨬ����� (ᨭ�� ⥪��)
	call menuStringExitOutput

	;��⠭���� ����� �� ���� �㭪�      
	mov dh,[menuStringsBeginDh]
	mov dl,[menuStringsBeginDl]
	mov bh,0
	mov ah,02h	
	int 10h
	
checkKey:
	xor bx,bx
	xor dx,dx

	mov ah,0
	int 16h

	cmp ah,80
	je moveDown	
	
	cmp ah,72
	je moveUp	
	
	cmp al,13
	je enterKey
	
	jmp checkKey
	
;��室 �� �ணࠬ��
exit:
	mov ax,4c00h		
	int 21h

enterKey:
	mov [currentWindow],0
	cmp [currentString],0
	je enterCheck
	jmp exit
enterCheck:
	mov bh,0
	mov ah,00
	int 10h
	mov ax,0003			;�㭪�� �롮� ०���
	int 10h 			;�롮� ०���
	call windowsOutput

checkKey2:
	mov ah,0
	int 16h

	call checkInputNumber	
	
	cmp ah,77
	je moveRight

	cmp ah,75
	je moveLeft
	
	cmp al,8
	jne notDel
	
	call delKey
	
notDel:
	cmp al,9
	jne checkKey21	
	
	call changeWindow
checkKey21:
	cmp al,27
	je begin

	cmp al,13
	jne checkKey2End
	
	call solution
	
checkKey2End:
	jmp checkKey2

moveRight:
	push ax
	push bx
	push cx
	push dx
	
	mov cl,[XorY]
	cmp cl,'y'
	je moveRightEnd
	
	xor bx,bx
	; mov bh,[currentWindow]
	mov bl,[currentWindow]
	mov dh,[windowsCoordinatesDh+bx]
	mov dl,[windowsCoordinatesDl+bx]

	add dl,4
	
	mov bh,0
	mov ah,02h	
	int 10h
	
	mov [XorY],'y'
	
	pop dx
	pop cx
	pop bx
	pop ax
	
moveRightEnd:
	jmp checkKey2
	
moveLeft:
	push ax
	push bx
	push cx
	push dx

	mov cl,[XorY]
	cmp cl,'x'
	je moveLeftEnd
	
	xor bx,bx
	;mov bh,[currentWindow]
	mov bl,[currentWindow]
	mov dh,[windowsCoordinatesDh+bx]
	mov dl,[windowsCoordinatesDl+bx]
	
	mov bh,0	

	mov ah,02h	
	int 10h
	
	mov [XorY],'x'
	
	pop dx
	pop cx
	pop bx
	pop ax
moveLeftEnd:
	jmp checkKey2
	
changeWindow:
	push ax
	push bx
	push cx
	push dx
	
	mov [XorY],'x'
	
	xor bx,bx
	;mov bh,[currentWindow]
	mov bl,[currentWindow]
	; inc bh
	inc bl
	inc [currentWindow]
	
	cmp bl,3
	jbe changeWindow2
	xor bx,bx
	mov [currentWindow],0
changeWindow2:	
	mov dh,[windowsCoordinatesDh+bx]
	mov dl,[windowsCoordinatesDl+bx]
	mov bh,0
	mov ah,02h	
	int 10h
	
	pop dx
	pop cx
	pop bx
	pop ax
	ret
	
moveDown: 
	push ax
	mov al,[currentString]
	; neg al
	cmp al,0	;first string of menu is selected now
	je moveDown2
	jmp moveDownEnd
moveDown2:
	call changeMenuStringExit
	xor al,1
	mov [currentString],al
moveDownEnd:
	pop ax
	jmp checkKey
	
moveUp: 
	push ax
	mov al,[currentString]
	; neg al
	cmp al,1	;second string of menu is selected now
	je moveUp2
	jmp moveUpEnd
moveUp2:
	call changeMenuStringCheck	
	xor al,1
	mov [currentString],al
moveUpEnd:
	pop ax
	jmp checkKey
	
changeMenuStringExit:
	push ax
	push bx
	push dx
	
	mov bl,9				;��ਡ�� �뢮����� ᨬ����� (ᨭ�� ⥪��)
	call menuStringCheckOutput
	
	mov bl,11				;��ਡ�� �뢮����� ᨬ����� (ᨭ�� ⥪��)
	call menuStringExitOutput
	
	;��⠭���� ����� �� ���� �㭪�      
	mov dh,[menuStringsBeginDh]
	mov dl,[menuStringsBeginDl]
	inc dh
	mov bh,0
	mov ah,02h	
	int 10h
	
	pop dx
	pop bx
	pop ax
	ret
	
changeMenuStringCheck:
	push ax
	push bx
	push dx
	
	mov bl,11				;��ਡ�� �뢮����� ᨬ����� (ᨭ�� ⥪��)
	call menuStringCheckOutput
	
	mov bl,9				;��ਡ�� �뢮����� ᨬ����� (ᨭ�� ⥪��)
	call menuStringExitOutput
	
	;��⠭���� ����� �� ���� �㭪�      
	mov dh,[menuStringsBeginDh]
	mov dl,[menuStringsBeginDl]

	mov bh,0
	mov ah,02h	
	int 10h
	
	pop dx
	pop bx
	pop ax
	ret
	
menuStringCheckOutput:
	push bp
	push cx
	push dx
	
	;�뢮� �㭪� ���� '�஢�ઠ' (� ������� �㭪樨 13h ���뢠��� 10h)
	mov bp,menuStringCheck		;����㧪� � BP ���� ��砫� ��ப� '�஢�ઠ' 
	mov cx,8					;����頥� � CX ������⢮ �뢮����� ᨬ����� 
	mov dh,[menuStringsBeginDh]	;��ப� ��砫� �뢮��
	call menuStringOutput
	
	pop dx
	pop cx
	pop bp
	ret
	
menuStringExitOutput:
	push bp
	push cx
	push dx

	;�뢮� �㭪� ���� '��室' (� ������� �㭪樨 13h ���뢠��� 10h)
	mov bp,menuStringExit		;����㧪� � BP ���� ��砫� ��ப� '�஢�ઠ' 
	mov cx,5					;����頥� � CX ������⢮ �뢮����� ᨬ�����
	mov dh,[menuStringsBeginDh]	
	inc dh
	call menuStringOutput
	
	pop dx
	pop cx
	pop bp
	ret	
	
;menuStringOutput - �㭪�� �뢮�� �㭪� ���� '�஢�ઠ' (� ������� �㭪樨 
;13h ���뢠��� 10h)    
menuStringOutput:
	push ax
	push bx
	push dx
	
	mov dl,[menuStringsBeginDl]				;������� ��砫� �뢮��
	mov bh,0				;����� ����� ��࠭���
	mov al,0				;��� ����㭪樨

	mov ah,13h				;�㭪�� �뢮�� ��ப�
	int 10h

	pop dx
	pop bx
	pop ax
	ret
	
oneWindowOutput:
	push ax
	push bx
	push cx
	push dx
	
	mov dh,[windowsOutputDh]
	mov dl,[windowsOutputDl]
	mov bh,0
	mov ah,02h	
	int 10h

	mov cx,1
	mov bl,9
	xor bh,bh
	mov al,'�'
	mov ah,09h
	int 10h 
	
	inc dl
	mov bh,0
	mov ah,02h	
	int 10h
	
	mov cx,3
	mov bl,9
	xor bh,bh
	mov al,'�'
	mov ah,09h
	int 10h 
	
	add dl,3
	mov bh,0
	mov ah,02h	
	int 10h
		
	mov cx,1
	mov bl,9
	xor bh,bh
	mov al,'�'
	mov ah,09h
	int 10h 
	
	add dh,2
	sub dl,3
	mov bh,0
	mov ah,02h	
	int 10h
	
	mov cx,3
	mov bl,9
	xor bh,bh
	mov al,'�'
	mov ah,09h
	int 10h 
	
	sub dh,1
	dec dl

	mov bh,0
	mov ah,02h	
	int 10h
	
	mov cx,1
	mov bl,9
	xor bh,bh
	mov al,'�'
	mov ah,09h
	int 10h 
	inc dh
	
	add dl,4
	sub dh,1
	mov cx,1
	
	mov bh,0
	mov ah,02h	
	int 10h
	
	mov cx,1
	mov bl,9
	xor bh,bh
	mov al,'�'
	mov ah,09h
	int 10h 
	
	inc dh
	mov bh,0
	mov ah,02h	
	int 10h
		
	mov cx,1
	mov bl,9
	xor bh,bh
	mov al,'�'
	mov ah,09h
	int 10h 
	
	sub dl,4
	mov bh,0
	mov ah,02h	
	int 10h
		
	mov cx,1
	mov bl,9
	xor bh,bh
	mov al,'�'
	mov ah,09h
	int 10h 
	
	sub dh,2
	add dl,5
	mov bh,0
	mov ah,02h	
	int 10h
	
	
		mov cx,3
	mov bl,9
	xor bh,bh
	mov al,'�'
	mov ah,09h
	int 10h 
	
	add dl,3
	mov bh,0
	mov ah,02h	
	int 10h
	
	
	mov cx,1
	mov bl,9
	xor bh,bh
	mov al,'�'
	mov ah,09h
	int 10h 
	
	add dh,2
	sub dl,3
	mov bh,0
	mov ah,02h	
	int 10h
	
	mov cx,3
	mov bl,9
	xor bh,bh
	mov al,'�'
	mov ah,09h
	int 10h 
	
	sub dh,1
	dec dl

	mov bh,0
	mov ah,02h	
	int 10h
	
	mov cx,1
	mov bl,9
	xor bh,bh
	mov al,'�'
	mov ah,09h
	int 10h 
	inc dh
	
	add dl,4
	sub dh,1
	mov cx,1
	
	mov bh,0
	mov ah,02h	
	int 10h
	
	mov cx,1
	mov bl,9
	xor bh,bh
	mov al,'�'
	mov ah,09h
	int 10h 
	
	inc dh
	mov bh,0
	mov ah,02h	
	int 10h
		
	mov cx,1
	mov bl,9
	xor bh,bh
	mov al,'�'
	
	mov ah,09h
	int 10h 
	; ; dec dh
	; ; inc dl
	; ; mov bh,0
	; ; mov ah,02h  
	; ; int 10h
	
	pop dx
	pop cx
	pop bx
	pop ax
	ret

windowsOutput:
	push ax
	push bx
	push cx
	push dx
	
	mov [windowsOutputDh],1
	mov [windowsOutputDl],1
	
	;���� ���न��� ��㣮�쭨��
	mov dh,[windowsOutputDh]
	mov dl,[windowsOutputDl]
	mov bh,0
	mov ah,02h	
	int 10h
	
	;�뢮� �㭪� ���� '�஢�ઠ' (� ������� �㭪樨 13h ���뢠��� 10h)
	mov bp,triangleString		;����㧪� � BP ���� ��砫� ��ப� '�஢�ઠ' 
	mov cx,32					;����頥� � CX ������⢮ �뢮����� ᨬ����� 
	mov dh,[windowsOutputDh]	;��ப� ��砫� �뢮��
	mov dl,[windowsOutputDl]				;������� ��砫� �뢮��
	mov bh,0				;����� ����� ��࠭���
	mov al,0				;��� ����㭪樨
	mov bl,9
	mov ah,13h				;�㭪�� �뢮�� ��ப�
	int 10h
	add [windowsOutputDl],33
	sub	[windowsOutputDh],1
	
	mov ah,[windowsOutputDl]
	inc ah
	mov [windowsCoordinatesDl],ah
	
	mov ah,[windowsOutputDh]
	inc ah
	mov [windowsCoordinatesDh],ah
	
	call oneWindowOutput
	
	xor bx,bx
	inc [currentWindow]
	mov cx,2
l3:
	; mov bh,[currentWindow]
	mov bl,[currentWindow]
	add [windowsOutputDl],10
	
	mov ah,[windowsOutputDl]
	inc ah
	mov [windowsCoordinatesDl+bx],ah
	
	mov ah,[windowsOutputDh]
	inc ah
	mov [windowsCoordinatesDh+bx],ah
	
	call oneWindowOutput
	
	inc [currentWindow]
	loop l3
	
	mov dh,[windowsCoordinatesDh]
	mov dl,[windowsCoordinatesDl]
	mov bh,0
	mov ah,02h	
	int 10h
	
;���� ���न��� �窨
	mov [windowsOutputDh],4
	mov [windowsOutputDl],1
	
	mov dh,[windowsOutputDh]
	mov dl,[windowsOutputDl]
	mov bh,0
	mov ah,02h	
	int 10h
	
	;�뢮� �㭪� ���� '�஢�ઠ' (� ������� �㭪樨 13h ���뢠��� 10h)
	mov bp,pointString		;����㧪� � BP ���� ��砫� ��ப� '�஢�ઠ' 
	mov cx,23					;����頥� � CX ������⢮ �뢮����� ᨬ����� 
	mov dh,[windowsOutputDh]	;��ப� ��砫� �뢮��
	mov dl,[windowsOutputDl]				;������� ��砫� �뢮��
	mov bh,0				;����� ����� ��࠭���
	mov al,0				;��� ����㭪樨
	mov bl,9
	mov ah,13h				;�㭪�� �뢮�� ��ப�
	int 10h
	add [windowsOutputDl],24
	sub	[windowsOutputDh],1
	
	xor bx,bx
	;mov bh,[currentWindow]	
	mov bl,[currentWindow]
	
	mov ah,[windowsOutputDl]
	inc ah
	mov [windowsCoordinatesDl+bx],ah
	
	mov ah,[windowsOutputDh]
	inc ah
	mov [windowsCoordinatesDh+bx],ah
	
	call oneWindowOutput
	
;�⢥�  
	mov [windowsOutputDh],7
	mov [windowsOutputDl],1
	
	mov dh,[windowsOutputDh]
	mov dl,[windowsOutputDl]
	mov bh,0
	mov ah,02h	
	int 10h
	
	;�뢮� �㭪� ���� '�஢�ઠ' (� ������� �㭪樨 13h ���뢠��� 10h)
	mov bp,answerString		;����㧪� � BP ���� ��砫� ��ப� '�஢�ઠ' 
	mov cx,6					;����頥� � CX ������⢮ �뢮����� ᨬ����� 
	mov dh,[windowsOutputDh]	;��ப� ��砫� �뢮��
	mov dl,[windowsOutputDl]				;������� ��砫� �뢮��
	mov bh,0				;����� ����� ��࠭���
	mov al,0				;��� ����㭪樨
	mov bl,9
	mov ah,13h				;�㭪�� �뢮�� ��ப�
	int 10h
	
	xor bx,bx
	mov [currentWindow],0
	mov dh,[windowsCoordinatesDh+bx]
	mov dl,[windowsCoordinatesDl+bx]
	
	mov bh,0
	mov bl,11
	mov ah,02h	
	int 10h
	
	pop dx
	pop cx
	pop bx
	pop ax
	ret
	
inputNumber:	
;       push ax
	push bx
	push cx
	push dx
	push si

	xor si,si
	xor dx,dx
	mov bp,10

inputCharNumber:	
	cmp al,'0'			;�ࠢ����� ���������� ᨬ���� � ᨬ���� '0'
	jb inputCharService	;�᫨ ��� ���������� ᨬ���� ����� ���� ���� '0' (�.�. �㦥��� ᨬ���), � ��३� �� 
						;inputCharService (��� �஢�ન ������ Enter'�)
	
	cmp al,'9'			;�ࠢ����� ���������� ᨬ���� � ᨬ���� '9'
	ja inputCharNumberEnd		;�᫨ ��� ���������� ᨬ���� ����� ���� ���� '9' (�.�. �� �㦥��� ᨬ��� � �� ���), � 
						;��३� �� inputChar (��� ����୮�� �⥭�� � ����������)
							
	;���� (�᫨ ������ ᨬ��� ���� ��ன)
	mov bl,al			;���࠭�� ᨬ��� � BL
	mov ax,si			;�����⨬ � AX 㦥 ��⠭��� ���� �᫠, �࠭������ � DI
	mul bp				;�������� ᮤ�ন��� ॣ���� AX �� 10 (��� 㢥��祭�� �᫠ �� �� 1 ࠧ��); DX:AX = AX * BP
	
	cmp ax,255			
	jae inputCharNumberEnd		;�᫨ DX <> 0, ����� �뫮 ��९������� (��������� ���祭�� �����, 祬 �����   
						;�������� � ����� 16-ࠧ�來�� ॣ���� (65 535) ), � ��३� �� inputChar (��� 
						;����୮�� �⥭�� � ����������)
	
	;���� (�᫨ ��९������� �� �ந��諮)
	mov dl,bl			;�������� � ������� ���� DX ��⠭�� c ���������� ᨬ���
	
	sub dl,'0'			;�८�ࠧ������ ��⠭���� ᨬ���� � ����
	xor dh,dh			;���㫥��� ���襩 ��� DX (⥯��� � DX �࠭���� ⮫쪮 ��������� ���; �㦭� ��� 
						;���쭥�襣� ᫮����� � AX (� ���஬ �࠭���� 㦥 ��⠭��� �᫮))
	
	add dx,ax			;�㬬��㥬 ��������� � ���������� ���� � 㦥 ��⠭��� ����� �᫠
	jc inputCharNumberEnd	    ;�᫨ �뫮 ��९������� (��������� ���祭�� �����, 祬 ����� �������� 
						;� ����� 16-ࠧ�來�� ॣ���� (65 535) ), � ��३� �� inputChar (��� ����୮�� �⥭�� � 
						;����������)
	
	mov si,dx			;�������� � DI ��⠭��� �᫮
	 
	mov dl,bl			;�������� � DL �������� � ���������� ᨬ��� (�㦭� ��� �㭪樨 �뢮�� 02h ���뢠���          
						;int21h)
	
	mov ah,02h			;�㭪�� �뢮�� ᨬ����
	int 21h 			;�뢮� ��⠭���� ᨬ����
	
inputCharNumberEnd:
	
	mov ah,0
	int 16h
	
	jmp inputCharNumber		;��३� �� inputChar ��� �⥭�� � ����������

inputCharService:	
	mov dx,si
	
	xor bx,bx
	mov bl,[currentWindow]
	mov cl,[XorY]
	
	cmp cl,'x'
	jne writeY
	
	mov [windowsX+bx],dl
	jmp inputNumberEnd

writeY:
	mov [windowsY+bx],dl
	;mov [inputNumberResult],dl
inputNumberEnd:
	pop si
	pop dx
	pop cx
	pop bx
	; pop ax
	ret	
	
delKey:
	push ax
	push bx
	push cx
	push dx
	
	xor bx,bx
	;mov bh,[currentWindow]
	mov bl,[currentWindow]
	

	mov dh,[windowsCoordinatesDh+bx]
	mov dl,[windowsCoordinatesDl+bx]

	mov cl,[XorY]
	
	cmp cl,'x'
	jne deleteY

	mov [windowsX+bx],0
	jmp delKeyEnd

deleteY:
	mov [windowsY+bx],0
	add dl,4
	
delKeyEnd:
	xor bx,bx
	mov bh,0
	mov ah,02h	
	int 10h
	
	mov bp,deleteString
	mov cx,3
	mov bl,11
	mov bh,0				;����� ����� ��࠭���
	mov al,0				;��� ����㭪樨

	mov ah,13h				;�㭪�� �뢮�� ��ப�
	int 10h
	
	mov bh,0
	mov ah,02h	
	int 10h
	
	pop dx
	pop cx
	pop bx
	pop ax
	ret
	
solution:
	push ax
	push bx
	push cx
	push dx

	call fillSolutionArguments1
	call solveEquation
	mov ax,[solveEquationResult]
	mov [result1],ax
	
	call fillSolutionArguments2	
	call solveEquation
	mov ax,[solveEquationResult]
	mov [result2],ax

	call fillSolutionArguments3
	call solveEquation
	mov ax,[solveEquationResult]
	mov [result3],ax
	
	;call outputNumber
	
	call compareResults
	
	call answerOutput

	pop dx
	pop cx
	pop bx
	pop ax
	ret	
	
; outputNumber:
	; push ax
	; push bp
	; push cx
	; push dx
	; push di

	; push ax
	; mov dh,15
	; mov dl,15
	; mov bh,0
	; mov ah,02h	
	; int 10h
	; pop ax
	
	; mov dx,ax
	; push -1 			;����頥� � �⥪ ���祭�� -1 ��� ᮧ࠭���� �ਧ���� ���� �᫠

	; mov bp,10d			;��� ���쭥�襣� ������� �� 10 (��� ��ॢ��� � �������� ��⥬� ��᫥���)

; ;���࠭���� � ����� �᫠ (�� ����� ���)
; keepNumber:	
	; xor dx,dx			;���㫥��� ॣ���� DX
	; div bp				;������� �� 10. DX:AX/BP � AX -- 楫��, � DX -- ���⮪
	; push dx 			;�����⨬ ���⮪ �� ������� � �⥪ (�� �� ��⮬ ���� ����� �뫮 ������� � �뢥�� �� �࠭)
	; cmp ax,0			;�஢�ઠ: ���� �� 楫�� �� ������� �㫥� (��⨬��쭥� or ax,ax)
	; jne keepNumber		;�᫨ ��, � ���⨣��� ����� �᫠
	; mov ah,2h			;�㭪�� �뢮�� ᨬ����

; ;�뢮� �᫠ �� ����� (�� ����� ���)
; outputFigure:	
	; pop dx				;����⠭���� ���� �� �⥪� (�.� ����������� �� �⥪�, � �᫮ �뢮����� � ��ࢮ� ����)
	; cmp dx,-1			;�ࠢ����� �����祭���� �᫠ � -1                                      
	; je outputNumberEnd		;�᫨ ࠢ�� , ����� ���⨣��� ����� � ���� ��३� �� ���� endProg (��� ��室� ��
						; ;�ணࠬ��){��⨬��쭥�: or dx,dx jl endProg}
	; add dl,'0'			;�८�ࠧ������ �����祭��� ���� � ᨬ���
	; int 21h 			;�뢮� ᨬ���� �� �࠭
	; jmp outputFigure	;��३� �� ���� outputNumber ��� �뢮�� ���쭥��� ᨬ�����
	
; outputNumberEnd:

	; pop di
	; pop dx
	; pop cx
	; pop bp
	; pop ax
	; ret
	
solveEquation:
	push ax
	push bx
	push cx
	push dx
	push si
	
	xor ax,ax
	xor bx,bx
	xor cx,cx
	xor dx,dx
	
	mov si,solutionArguments
	mov al,[si]	
	mov bl,[si+1]
	sub al,bl
	mov bl,[si+2]
	mov cl,[si+3]
	sub bl,cl
	imul bl
	mov bx,ax
	
	
	mov al,[si+4]
	mov cl,[si]
	sub al,cl
	mov cl,[si+3]
	mov dl,[si+5]
	sub cl,dl
	imul cl
	
	sub bx,ax

	mov [solveEquationResult],bx
	
	pop si
	pop dx
	pop cx
	pop bx
	pop ax

	
fillSolutionArguments1:
	push ax
	push bx
	push cx
	push dx
	push si
	
	mov si,solutionArguments
	
	mov al,[windowsX]
	mov [si],al
	inc si
	
	mov al,[windowsX+3]
	mov [si],al
	inc si
	
	mov al,[windowsY+1]
	mov [si],al
	inc si	
	
	mov al,[windowsY]
	mov [si],al
	inc si
	
	mov al,[windowsX+1]
	mov [si],al
	inc si
	
	mov al,[windowsY+3]
	mov [si],al

	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	ret
	
fillSolutionArguments2:
	push ax
	push bx
	push cx
	push dx
	push si
	
	mov si,solutionArguments
	
	mov al,[windowsX+1]
	mov [si],al
	inc si
	
	mov al,[windowsX+3]
	mov [si],al
	inc si
	
	mov al,[windowsY+2]
	mov [si],al
	inc si	
	
	mov al,[windowsY+1]
	mov [si],al
	inc si
	
	mov al,[windowsX+2]
	mov [si],al
	inc si
	
	mov al,[windowsY+3]
	mov [si],al

	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	ret
	
fillSolutionArguments3:
	push ax
	push bx
	push cx
	push dx
	push si
	
	mov si,solutionArguments
	
	mov al,[windowsX+2]
	mov [si],al
	inc si
	
	mov al,[windowsX+3]
	mov [si],al
	inc si
	
	mov al,[windowsY]
	mov [si],al
	inc si	
	
	mov al,[windowsY+2]
	mov [si],al
	inc si
	
	mov al,[windowsX]
	mov [si],al
	inc si
	
	mov al,[windowsY+3]
	mov [si],al

	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	ret	
	
	
checkInputNumber:
	cmp al,'0'
	jb checkInputNumberEnd
	
	cmp al,'9'
	ja checkInputNumberEnd
	
	call delKey
	call inputNumber
	
checkInputNumberEnd:
	ret	
	
	
compareResults:
	push ax
	push bx
	push cx
	push dx
		
	mov ax,[result1]	
	mov bx,[result2]	
	mov cx,[result3]	
	cmp ax,0
	jl compareResultsMinus1	
	
	cmp ax,0
	jg compareResultsPlus1
	
	jmp compareResultsEnd2
	
compareResultsPlus1:
	cmp bx,0
	jg compareResultsPlus2
	jmp compareResultsEnd2
compareResultsPlus2:
	cmp cx,0
	jg compareResultsEnd1
	jmp compareResultsEnd2
	
compareResultsMinus1:
	cmp bx,0
	jl compareResultsMinus2
	jmp compareResultsEnd2

compareResultsMinus2:
	cmp cx,0
	jl compareResultsEnd1
	jmp compareResultsEnd2
	
compareResultsEnd1:
	mov [resultStringNumber],1
	jmp compareResultsEnd3
compareResultsEnd2:
	mov [resultStringNumber],2

compareResultsEnd3:	
	pop dx
	pop cx
	pop bx
	pop ax
	ret
	
	
answerOutput:
	push ax
	push bx
	push cx
	push dx
	
	mov dh,7
	mov dl,8
	mov bh,0
	mov ah,02h	
	int 10h

	mov bp,deleteString2
	mov cx,40
	mov bl,11
	mov bh,0				;����� ����� ��࠭���
	mov al,0				;��� ����㭪樨

	mov ah,13h				;�㭪�� �뢮�� ��ப�
	int 10h
	
	xor ax,ax

	mov al,[resultStringNumber]
	cmp ax,2
	je answerOutput2

answerOutput1:	
	mov bp,resultString1		;����㧪� � BP ���� ��砫� ��ப� '�஢�ઠ' 
	jmp answerOutput3
	
answerOutput2:
	mov bp,resultString2		;����㧪� � BP ���� ��砫� ��ப� '�஢�ઠ' 
	
answerOutput3:
	xor ax,ax
	
	mov cx,34					;����頥� � CX ������⢮ �뢮����� ᨬ����� 
	
	mov dh,7	;��ப� ��砫� �뢮��
	mov dl,8				;������� ��砫� �뢮��
	
	mov bh,0				;����� ����� ��࠭���
	mov al,0				;��� ����㭪樨
	mov bl,11
	mov ah,13h				;�㭪�� �뢮�� ��ப�
	int 10h
		
	xor bx,bx
	; mov bh,[currentWindow]
	mov bl,[currentWindow]
	mov [XorY],'x'
	mov dh,[windowsCoordinatesDh+bx]
	mov dl,[windowsCoordinatesDl+bx]
	
	mov bh,0
	mov ah,02h	
	int 10h
	
	pop dx
	pop cx
	pop bx
	pop ax
	ret
	
clearValues:
	push bx
	push cx

	mov [result1],0
	mov [result2],0
	mov [result3],0
	
	mov bx,4
	mov cx,4
clearValuesLoopStart:
	dec bx
	mov [windowsX+bx],0
	mov [windowsY+bx],0
	loop clearValuesLoopStart

	pop cx
	pop bx
	ret	
	
menuStringCheck 		db	'�஢�ઠ$'
menuStringExit			db	'��室$'
menuStringsBeginDh		db	05
menuStringsBeginDl		db	32
currentString			db 0

windowsOutputDh 		db 1
windowsOutputDl 		db 1

windowsCoordinatesDh	db	0,0,0,0
windowsCoordinatesDl	db	0,0,0,0

windowsX				db	0,0,0,0
windowsY				db	0,0,0,0

XorY					db	'x'


currentWindow			db	0

triangleString			db '���न���� ��㣮�쭨�� (Xn,Yn):$'
pointString				db '���न���� �窨 (X,Y):$'
answerString			db '�⢥�:$'

deleteString			db	'   $'
deleteString2			db	'                                             $'

solveEquationResult		dw	0
result1					dw	0
result2					dw	0
result3					dw	0
resultString1			db	'��窠 ����� ����� ��㣮�쭨��   $'
resultString2			db	'��窠 �� ����� ����� ��㣮�쭨��$'
resultStringNumber		db	0

solutionArguments		db	1,0,0,0,0,0