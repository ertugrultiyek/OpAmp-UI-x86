
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

; add your code here  
.model small         
.stack
.data

    main_menu db "1. Resistances R1 and R2 from given gain of amplifier for non-inverting Op-Amp.", 10, 13, "2. Resistances R1 and R2 from given gain of amplifier for inverting Op-Amp.", 10, 13, "3. Gain of amplifier from resistances R1 and R2 for non-inverting Op-Amp." ,10 , 13, "4. Gain of amplifier from resistances R1 and R2 for inverting Op-Amp", 10, 13, '$'
    inp_1 db "please enter the gain in given format below.", 10, 13, "gain:___,__", 10, 13, '$'
    inp_gain_str db "00000" 
    ;gain_num dw 0        ; variable for multiplied input gain
    gain_num_int db 0     ; variable for integer part of input gain
    gain_num_flt db 0     ; variable for floating part of input gain
    
    ;gain_inv_int db 00h  ; variable for storing integer part of inverting gain
    ;gain_inv_flt db 00h  ; variable for storing floating part of inverting gain

.code
    
    mov ax, 0003h
    int 10h
    ;int 10h 

  	mov ch, 0
 	mov cl, 7
 	mov ah, 1
 	int 10h
    
    mov dx, offset main_menu
    mov ah, 9
    int 21h 
    
main_select: 
    mov ah, 00h    
    int 16h  
    cmp al, 27
    je terminate
    cmp al, 31h
    je inp1
    cmp al, 32h
    je inp2
    cmp al, 33h
    je inp3
    cmp al, 34h
    je inp4   

    MOV AH, 06h    ; Scroll up function
    XOR AL, AL     ; Clear entire screen
    mov dx, 054fh  ; lower rgt corner
    mov CX, 0400h  ; Upper left corner CH=row, CL=column
    MOV BH, 4Fh    ; YellowOnBlue
    INT 10H
    jmp main_select

terminate:
    hlt    

inp1:
    MOV AH, 06h    ; Scroll up function
    mov dx, 010Ah  ; lower rgt corner
    mov CX, 0100h  ; Upper left corner CH=row, CL=column
    MOV BH, 4Fh    ; white on red
    INT 10H    
    mov ax, 0003h
    int 10h
        
    mov dx, offset inp_1
    mov ah, 9
    int 21h 
    
    mov dx, 0105h
	mov bh, 0
	mov ah, 2
	int 10h
	
	push bp
	lea bp, [inp_gain_str]
	jmp key1
wrong:
    jmp key1	
flt1:
    cmp dl, 10
    je terminate
        
    inc dl 
    mov ah, 2
    int 10h
    
    
    
    jmp key1
    
int1:
    inc dl 
    mov ah, 2
    int 10h
    
    
    jmp key1
    
key1:    
    mov ah, 00h    
    int 16h  
    cmp al, 27
    je terminate
    cmp al, 30h
    jl wrong
    cmp al, 39h
    jg wrong
            
    mov ah, 0ah
    mov cx, 1
    int 10h
    
    mov [bp], al
    inc bp
             
    cmp dl, 7
    jl int1 
    cmp dl, 7
    jl flt1
    
    add dl, 2
    mov ah,2
    int 10h
    jmp key1

 
    
inp2:    
    mov ax, 0003h
    int 10h
    
    mov dx, offset inp_1
    mov ah, 9
    int 21h

inp3:    
    mov ax, 0003h
    int 10h
    
    mov dx, offset inp_1
    mov ah, 9
    int 21h 
    
inp4:    
    mov ax, 0003h
    int 10h
    
    mov dx, offset inp_1
    mov ah, 9
    int 21h 
    
    
     

ret

end
