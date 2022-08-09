
org 100h

; ERTUGRUL TIYEK = 21828916  


.MODEL SMALL
.DATA
    
    MYSENTENCE DB 100 DUP() ;100, ' JHG KFG JGFH K KJGF K', '$' ;100 CHAR
    GUIDE DB 'WRITE YOUR SENTENCE. PRESS ENTER TO END SENTENCE', '$'
    RESULT DB 'THE STRING CONTAINS _ WORDS', '$'
    LONG_ALERT DB 'THE STRING CONTAINS 10 OR MORE WORDS', '$'   
.CODE
        
    MOV AH, 09H                 ; DISPLAY GUIDE
    LEA DX, [GUIDE]
    INT 21H
    
    MOV AH, 02                  ; SET CURSOR LOCATION
    MOV BH, 00
    MOV DX, 0100H
    INT 10H

    LEA BP, [MYSENTENCE]            ; POINTER FOR ADDRESS OF INPUT DATA 
    DEC BP
    MOV BX, 0
    
    GET_CHAR:                             ; GET INPUT AND SAVE 
    
    INC BP
    MOV AH, 00H                     ; SET FUNCTION TO KEY PRESSED
    INT 16H                         ; INTERRUPT FOR THE KEYBOARD INPUTS
    
    CMP AL, 0DH
    JE START
    
    MOV AH, 0EH                     ; SET FUNCTION TO DISPLAY INPUT CHAR
    INT 10H                         ; DISPLAY THE INPUT CHAR
    
    MOV [BP], AL                    ; STORE INPUT CHAR INTO MYSENTENCE
    INC BX
    
    JMP GET_CHAR                         ; REPEAT 10 TIMES

START:
    
    MOV [BP], '$'
    
    MOV CX, BX                ; LOAD THE LENGTH OF SOURCE STRING
    MOV BL, 0
    LEA BP, [MYSENTENCE]       ; LOAD OFFSET ADDRESS OF SOURCE STRING
    MOV AH, 1                  ; MARK THE PREVIOUS CHARACTER AS SPACE FOR FIRST CHAR
    LP:
        CMP BX, 10
        JE LIMIT
        MOV AL, [BP]
        CMP AL, ' '            ; COMPARE IF ASCII VALUE IS SPACE(' ')
        JE SPACE               
        
        JMP NOSPACE
                              
    NEXT:
        INC BP   
        LOOP LP
        
        ADD BX, 30H                 ; CONVERT NUMBER INTO ASCII
        LEA BP, [RESULT]            
        MOV [BP + 20], BL           ; SAVE RESULT NUMBER INTO RESULT STRING
        
        MOV AH, 02H                 ; SET CURSOR LOCATION
        MOV DX, 0200H
        MOV BH, 0
        INT 10H
        
        MOV AH, 09H            ; OUTPUT FUNCTION FOR 21H INTERRUPT
        LEA DX, [RESULT]       ; STORE OFFSET ADDRESS OF STRING
        INT 21H                ; OUTPUT STRING

        RET
        
    SPACE:                      ; CHAR IS SPACE
        ; CODE
        MOV AH, 1
        JMP NEXT
        
    NOSPACE:                    ; CHAR IS NOT SPACE
        ; CODE        
        CMP AH, 1
        JE INC_WORD
    CONT:
        MOV AH, 0  
        JMP NEXT
        
    INC_WORD:                   ; INCREMENT NUMBER OF WORDS
        INC BL
        JMP CONT
        
    LIMIT:                      ; WORD NUMBER IS MORE THAN 10
        MOV AH, 02H
        MOV DX, 0200H
        MOV BH, 0
        INT 10H
    
        MOV AH, 09H
        LEA DX, [LONG_ALERT]
        INT 21H
        
        






ret




