{\rtf1\ansi\ansicpg1254\cocoartf2578
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx566\tx1133\tx1700\tx2267\tx2834\tx3401\tx3968\tx4535\tx5102\tx5669\tx6236\tx6803\pardirnatural\partightenfactor0

\f0\fs24 \cf0 \
; You may customize this and other start-up templates; \
; The location of this template is c:\\emu8086\\inc\\0_com_template.txt\
\
;org 100h\
\
; add your code here  \
.model small         \
.stack\
.data\
\
    main_menu db "a. Resistances R1 and R2 from given gain of amplifier for non-inverting Op-Amp.", 10, 13, "b. Resistances R1 and R2 from given gain of amplifier for inverting Op-Amp.", 10, 13, "c. Gain of amplifier from resistances R1 and R2 for non-inverting Op-Amp." ,10 , 13, "d. Gain of amplifier from resistances R1 and R2 for inverting Op-Amp", 10, 13, '$'\
    inp_a db "please enter the gain in given format below.", 10, 13, "gain:__,___", 10, 13, '$'\
\
.code\
    \
    mov ax, 0012h\
    int 10h\
    int 10h\
    \
    lea dx, main_menu\
    mov ah, 9\
    int 21h\
    \
    mov ax, 0700h\
    int 10h\
    \
    lea dx, inp_a\
    mov ah, 9\
    int 21h\
    \
     \
\
ret\
\
\
\
\
           end\
}