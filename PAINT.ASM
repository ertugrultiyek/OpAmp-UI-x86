
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

;
.model small
.data
    eg db 8
.code
    main proc
        mov ax, 0003h
        int 10h
        int 10h
        mov ax, 0001h
        int 33h
    clck:
        call click
        call pos
        
        MOV AH, 06h    ; Scroll up function
        XOR AL, AL     ; Clear entire screen
        mov CX, dx     ; Upper left corner CH=row, CL=column
        MOV BH, 1Eh    ; YellowOnBlue
        INT 10H
        jmp clck
        ret
    main endp
        

    click proc
    cont:
        mov ax, 0003h
        int 33h
        
        cmp bx, 0
        jz cont
        ret
    click endp
    
    pos proc

        mov ax, dx
        div [eg]
        mov dh, al
        mov ax, cx
        div [eg]
        mov dl, al
        mov ah, 02h
        int 10h
        
        mov bx, 0000h
        mov ah, 03h
        int 10h 
        ret
    pos endp
        END




