; dikd�rtgen �izmek i�in yazilmis program    31.5.2015
; daha fazla bilgi icin  ... c:\emu8086\documentation\

name "int10h"

org     100h

 	MOV AX,0600H
	MOV BH,07
	MOV CX,0000
	MOV DX,184Fh
	INT 10H

	MOV AH,00
	MOV AL,13h
	INT 10h

	MOV CX,100
	MOV DX,50

B1:	MOV AH,0Ch
	MOV AL,02
	INT 10h

	INC CX
	CMP CX,200
	JNZ B1


	MOV CX,200
	MOV DX,50

B2:	MOV AH,0Ch
	MOV AL,02
	INT 10h

	INC DX
	CMP DX,150
	JNZ B2


    MOV CX,200
	MOV DX,150

B3:	MOV AH,0Ch
	MOV AL,02
	INT 10h

	DEC CX
	CMP CX,100
	JNZ B3



    MOV CX,100
	MOV DX,150

B4:	MOV AH,0Ch
	MOV AL,02
	INT 10h

	DEC DX
	CMP DX,50
	JNZ B4

ret  ; ana programa geri-don.
