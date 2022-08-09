
org 100h

; add your code here
.model small
.stack
.data

; variables for input interface
    main_menu db "1. Resistances R1 and R2 from given gain of amplifier for non-inverting Op-Amp.", 10, 13, "2. Resistances R1 and R2 from given gain of amplifier for inverting Op-Amp.", 10, 13, "3. Gain of amplifier from resistances R1 and R2 for non-inverting Op-Amp." ,10 , 13, "4. Gain of amplifier from resistances R1 and R2 for inverting Op-Amp", 10, 13, '$'
    inp_1 db "please enter the gain in given format below.", 10, 13, "gain: ___,__", 10, 13, '$'
    inp_2 db "please enter the gain in given format below.", 10, 13, "gain:-___,__", 10, 13, '$'
    inp_3 db "please enter the resistance values of R1 and R2 in given format below.", 10, 13, "R1:___,__          R2:___,__", 10, 13, '$'
    current_msg dw 00
; variables for calculations
    ten dw 10
    hundred dw 100

    r1_num dw 0           ; variable for storing numerical value of r1
    r2_num dw 0           ; variable for storing numerical value of r2
    gain_num dw 0         ; variable for input gain
    ratio_num dw 0        ; variable for ratio R1/R2
; variables for output interface
		l_len dw 00h         ; variable for length
    r_max dw 7          ; variable for resistor height
    r_min dw 7          ; variable for resistor height
    r_mid dw 0           ; variable for resistor mid
    o_mid dw 70

    vi db 'Vi','$'
    vo db 'Vo','$'
    rc db 'Rc','$'
    minus db '_','$'
    plus db '+','$'
    
    r1 db 'R1=___ R2','$'
    r2 db 'R2=R2    ','$'
    ratio_str db 'R1/R2= ___,__','$' 
    gain_str db 'gain= ______','$' 

.code
    main proc
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
        je mode1
        cmp al, 32h
        je mode2
        cmp al, 33h
        je mode3
        cmp al, 34h
        je mode4

        jmp main_select
    mode1:
        mov current_msg, offset inp_1
        call gain_inp
        sub gain_num, 100
        call calc_ratio
        call draw_non_inv_cct		               
        ;ratio
        mov ah, 2
        mov dx, 283Ch
        int 10h
        lea dx, [ratio_str]
        mov ah, 9
        int 21h
        hlt

    mode2:
        mov current_msg, offset inp_2
		lea si, [gain_str]
        add si, 5
        mov [si], '-'              
        call gain_inp
        call calc_ratio
		call draw_inv_cct
        ;ratio
        mov ah, 2
        mov dx, 283Ch
        int 10h
        lea dx, [ratio_str]
        mov ah, 9
        int 21h
        hlt
    mode3:
        mov current_msg, offset inp_3
        call res_inp
        call calc_gain
        add gain_num, 100
		call draw_non_inv_cct
        ;gain
        mov ah, 2
        mov dx, 283Ch
        int 10h
        lea dx, [gain_str]
        mov ah, 9
        int 21h
        hlt
    mode4:
        mov current_msg, offset inp_3
		lea si, [gain_str]
        add si, 5
        mov [si], '-'              
        call res_inp
        call calc_gain
		call draw_inv_cct
        ;gain
        mov ah, 2
        mov dx, 283Ch
        int 10h
        lea dx, [gain_str]
        mov ah, 9
        int 21h
        hlt
    err:

    terminate:
        hlt

        ret
    main endp

;-------------------------------------- other procedures -----------------------------

;---------------------- calculate gain  from given resistors -------------------------
calc_gain proc
		mov ax,r2_num
		mov dx, 0
		div r1_num
		mov bx, dx
    	mul hundred
    	mov gain_num, ax
    	mov ax, bx
		mov dx, 0
		mul hundred
		div r1_num
		add gain_num, ax
		ret
calc_gain endp

;----------------------- calculate ratio from given gain ----------------------------
calc_ratio proc
    mov ax, hundred
    mul hundred
    div gain_num
	mov ratio_num, ax
    ret
calc_ratio endp

;----------------------------------------- gain input --------------------------------

gain_inp proc
    MOV AH, 06h     ; Scroll up function
    mov dx, 010Bh   ; lower rgt corner
    mov CX, 0100h   ; Upper left corner CH=row, CL=column
    MOV BH, 0E5h    ; white on red
    INT 10H
    mov ax, 0003h
    int 10h

    mov dx, current_msg
    mov ah, 9
    int 21h

    mov dx, 0106h
	mov bh, 0
	mov ah, 2
	int 10h

    push bp
	mov bp, 10000
	jmp key1

wrong1:
    jmp key1

key1:
    mov ah, 00h
    int 16h
    cmp al, 27
    je terminate
    cmp al, 30h
    jl wrong1
    cmp al, 39h
    jg wrong1

    mov ah, 0ah
    mov cx, 1
    int 10h
    
    inc si
    mov [si], al              
   
    sub al, 30h

    cmp dl, 8
    jne store1
    inc dl
    jmp store1

 store1:
    inc dl
    mov ah, 2
    int 10h

    mov ah, 0
    push dx
    mul bp
    add gain_num, ax
    mov dx, 0
    mov ax, bp
    div ten
    mov bp, ax
    pop dx
    cmp bp, 1
    jnl key1
    pop bp
    ret
gain_inp endp

;----------------------------------------- resistor input --------------------------------

res_inp proc
    MOV AH, 06h    ; Scroll up function
    mov dx, 0108h  ; lower rgt corner
    mov CX, 0100h  ; Upper left corner CH=row, CL=column
    MOV BH, 0E5h    ; white on red
    INT 10H
    MOV AH, 06h    ; Scroll up function
    mov dx, 011Ch  ; lower rgt corner
    mov CX, 0113h  ; Upper left corner CH=row, CL=column
    MOV BH, 0E5h    ; white on red
    INT 10H
    mov ax, 0003h
    int 10h

    mov dx, current_msg
    mov ah, 9
    int 21h

    mov dx, 0103h
	mov bh, 0
	mov ah, 2
	int 10h

    push bp
	mov bp, 10000
	jmp key2

wrong2:
    jmp key2

key2:
    mov ah, 00h
    int 16h
    cmp al, 27
    je terminate
    cmp al, 30h
    jl wrong2
    cmp al, 39h
    jg wrong2

    mov ah, 0ah
    mov cx, 1
    int 10h

    sub al, 30h
    cmp dl, 10
    jg R_2
    cmp dl, 5
    jne storeR1
    inc dl
    jmp storeR1
R_2:
    cmp dl, 24
    jne storeR2
    inc dl
    jmp storeR2
 storeR1:
    inc dl
    mov ah, 2
    int 10h

    mov ah, 0
    push dx
    mul bp
    add R1_num, ax
    mov dx, 0
    mov ax, bp
    div ten
    mov bp, ax
    pop dx
    cmp bp, 1
    jnl key2
    cmp R1_num, 0
    je err
    mov bp, 10000
    mov dx, 0116h
    mov ah, 02h
    int 10h
    jmp key2

 storeR2:
    inc dl
    mov ah, 2
    int 10h

    mov ah, 0
    push dx
    mul bp
    add R2_num, ax
    mov dx, 0
    mov ax, bp
    div ten
    mov bp, ax
    pop dx
    cmp bp, 1
    jnl key2

    cmp R2_num, 0
    je err
    pop bp
    ret
res_inp endp
; -------------------------- output interface --------------------------------
    draw_inv_cct proc
        ; set the video mode 640x480p
        mov ax, 0012h
        int 10h
        int 10h


        mov l_len, 50
        mov dx, 200
        mov cx, 100
        call h_line
        call h_res 
        mov l_len, 50
        call h_line
        sub cx, 25
        sub dx, 50
        mov l_len, 50
        call v_line
        sub dx, 50
        mov l_len, 35
        call h_line
        call h_res
        mov l_len, 45
        call h_line
        mov l_len, 68
        call v_line
        sub cx, 18
        mov l_len, 100
        call h_line        
        mov dx,180
        mov cx, 235
        call opamp
        sub dx, 20
        sub cx, 25
        mov l_len, 25
        call h_line
        sub cx, 25
        mov l_len, 50
        call v_line
        call v_res
        mov l_len, 50
        call v_line
        sub cx, 11
        mov l_len, 21
        call h_line
        add dx, 5
        sub cx, 17
        mov l_len, 11 
        call h_line
        add dx, 5
        sub cx, 10
        mov l_len, 5
        call h_line

        mov bx, 0        
        ;desciptions 
        ; R1
        mov ah, 2
        mov dx, 160Fh
        int 10h
        lea dx, [r1]
        mov ah, 9
        int 21h
        ;R2
        mov ah, 2
        mov dx, 0F1Ch
        int 10h
        lea dx, [r2]
        mov ah, 9
        int 21h
        ;Rc
        mov ah, 2
        mov dx, 251Ch
        int 10h
        lea dx, [rc]
        mov ah, 9
        int 21h        
        ;Vo
        mov ah, 2
        mov dx, 1B34h
        int 10h
        lea dx, [vo]
        mov ah, 9
        int 21h
        ;minus
        mov ah, 2
        mov dx, 181Eh
        int 10h
        lea dx, [minus]
        mov ah, 9
        int 21h        
        ;plus
        mov ah, 2
        mov dx, 1D1Eh
        int 10h
        lea dx, [plus]
        mov ah, 9
        int 21h
        
        ;ayrý tut
        ;Vi for inv
        mov ah, 2
        mov dx, 1809h
        int 10h
        lea dx, [vi]
        mov ah, 9
        int 21h         
        ret
    draw_inv_cct endp
; ---------------- non inverting cct ----------------
    draw_non_inv_cct proc
        ; set the video mode 640x480p
        mov ax, 0012h
        int 10h
        int 10h


        mov dx, 200
        mov cx, 100
        mov l_len, 20
        call v_line
        ;gnd
        sub cx, 11
        mov l_len, 21
        call h_line
        add dx, 5
        sub cx, 17
        mov l_len, 11 
        call h_line
        add dx, 5
        sub cx, 10
        mov l_len, 5
        call h_line

        mov l_len, 50
        mov dx, 200
        mov cx, 100
        call h_line
        call h_res 
        mov l_len, 50
        call h_line
        sub cx, 25
        sub dx, 50
        mov l_len, 50
        call v_line
        sub dx, 50
        mov l_len, 35
        call h_line
        call h_res
        mov l_len, 45
        call h_line
        mov l_len, 68
        call v_line
        sub cx, 18
        mov l_len, 100
        call h_line        
        mov dx,180
        mov cx, 235
        call opamp
        sub dx, 20
        sub cx, 25
        mov l_len, 25
        call h_line

        mov bx, 0        
        ;desciptions 
        ; R1
        mov ah, 2
        mov dx, 160Fh
        int 10h
        lea dx, [r1]
        mov ah, 9
        int 21h
        ;R2
        mov ah, 2
        mov dx, 0F1Ch
        int 10h
        lea dx, [r2]
        mov ah, 9
        int 21h
        ;Vo
        mov ah, 2
        mov dx, 1B34h
        int 10h
        lea dx, [vo]
        mov ah, 9
        int 21h
        ;minus
        mov ah, 2
        mov dx, 181Eh
        int 10h
        lea dx, [minus]
        mov ah, 9
        int 21h        
        ;plus
        mov ah, 2
        mov dx, 1D1Eh
        int 10h
        lea dx, [plus]
        mov ah, 9
        int 21h
        
        ;ayrý tut
        ;Vi for ninv
        mov ah, 2
        mov dx, 1D18h
        int 10h
        lea dx, [vi]
        mov ah, 9
        int 21h
                
        ;ratio
        mov ah, 2
        mov dx, 283Ch
        int 10h
        lea dx, [ratio_str]
        mov ah, 9
        int 21h
        ;gain
        mov ah, 2
        mov dx, 283Ch
        int 10h
        lea dx, [gain_str]
        mov ah, 9
        int 21h
        ret
    draw_non_inv_cct endp

;------ parts -------------------
;--------opamp -----------------

opamp proc
add o_mid, cx
mov ax, 0c0fh
int 10h
o_first:
	inc cx
	int 10h
	inc dx
	int 10h
	inc cx
	int 10h
	cmp cx, o_mid
	jng o_first
	sub o_mid, 70
o_second:
	dec cx
	int 10H
	inc dx
	int 10h
	dec cx
	int 10H
	cmp cx, o_mid
	jnl o_second
o_third:
		inc cx
	sub dx,72
	mov l_len, 72
	call v_line
		mov o_mid, 70
	ret
opamp endp

;---------lines------------------
v_line proc
		add l_len, dx
		mov ax, 0c0fh
v_pix:
		int 10h
		inc dx
		cmp dx, l_len
		jng v_pix

		;mov l_len, 0
		ret
v_line endp

h_line proc
		add l_len, cx
		mov ax, 0c0fh
h_pix:
		int 10h
		inc cx
		cmp cx, l_len
		jng h_pix

		ret
h_line endp

;------------ resistors ---------------
h_res proc
		mov r_mid, dx
		add r_min, dx
		mov r_max, dx
		sub r_max, 7
		mov ax, 0c0fh

h_first:
		inc cx
		int 10h
		dec dx
		int 10h
		dec dx
		int 10h
		cmp dx, r_max
		jnl h_first
h_second:
		inc cx
		int 10h
		inc dx
		int 10h
		inc dx
		int 10h
		cmp dx, r_min
		jng h_second

h_third:
		inc cx
		int 10h
		dec dx
		int 10h
		dec dx
		int 10h
		cmp dx, r_max
		jnl h_third
h_fourth:
		inc cx
		int 10h
		inc dx
		int 10h
		inc dx
		int 10h
		cmp dx, r_min
		jng h_fourth

h_fifth:
		inc cx
		int 10h
		dec dx
		int 10h
		dec dx
		int 10h
		cmp dx, r_mid
		jnl h_fifth

		mov r_min, 7
		mov r_max, 7
		ret
h_res endp

v_res proc
		mov r_mid, cx
		add r_max, cx
		mov r_min, cx
		sub r_min, 7
		mov ax, 0c0fh

v_first:
		inc dx
		int 10h
		dec cx
		int 10h
		dec cx
		int 10h
		cmp cx, r_min
		jnl v_first
v_second:
		inc dx
		int 10h
		inc cx
		int 10h
		inc cx
		int 10h
		cmp cx, r_max
		jng v_second

v_third:
		inc dx
		int 10h
		dec cx
		int 10h
		dec cx
		int 10h
		cmp cx, r_min
		jnl v_third
v_fourth:
		inc dx
		int 10h
		inc cx
		int 10h
		inc cx
		int 10h
		cmp cx, r_max
		jng v_fourth

v_fifth:
		inc dx
		int 10h
		dec cx
		int 10h
		dec cx
		int 10h
		cmp cx, r_mid
		jnl v_fifth

		mov r_min, 7
		mov r_max, 7
		ret
v_res endp

end
