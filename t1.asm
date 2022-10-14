DATA   SEGMENT                               
BUFFER1 DB 20
        DB  ?
        DB  20  DUP(?)           ;定义了一个20字节的字符数组,接收起始数字
BUFFER2 DB 20
        DB  ?
        DB  20  DUP(?)           ;定义了一个20字节的字符数组,接收结束数字
BUFFER3  DB  20  DUP(?),'$'       ;定义了一个20字节的字符数组,存放结果数字
CRLF   DB  0AH, 0DH,'$' 
INPUT1  DB  "Please enter a starting number(1-100) : ",'$'
INPUT2  DB  "Please enter an end number(1-100)     : ",'$'
OUTPUT1 DB  "The addition operation begins ",'$'
OUTPUT2 DB  "The result of the calculation is: DEC:",'$'     
OUTPUT3 DB  "Input error, please try again",'$'

DATA   ENDS                                  
STACK  SEGMENT   STACK                       
       DW  20  DUP(0)                      
STACK  ENDS                                  
CODE   SEGMENT                              
ASSUME CS:CODE, DS:DATA, SS:STACK            
START:                                       
        MOV AX, DATA                         
        MOV DS, AX                      
        LEA DX, INPUT1                        ;打印提示输入开始的数字   
        MOV AH, 09H							 
        INT 21H

        LEA DX, CRLF                         ;换行                 
        MOV AH, 09H							 
        INT 21H

AGA:    LEA DX, BUFFER1                       ;接收字符串
        MOV AH, 0AH
        INT 21H

        CMP BUFFER1[1],1                       ;判断是否输入非法
        JB  AG
        CMP BUFFER1[1],3
        JA  AG
        MOV CX,0
        MOV CL,BUFFER1[1]
        
        MOV BX,CX
        INC BX
ER:     CMP BUFFER1[BX],30H
        JB  AG
        CMP BUFFER1[BX],39H
        JA  AG
        DEC BX
        LOOP ER
        JMP TRUE

AG:     LEA DX, OUTPUT3                        ;输入非法，重新输入  
        MOV AH, 09H							 
        INT 21H
        LEA DX, CRLF                         ;换行                 
        MOV AH, 09H							 
        INT 21H
        MOV BYTE PTR BUFFER1[1],0
        JMP AGA

TRUE:   LEA DX, CRLF                         ;换行                 
        MOV AH, 09H							 
        INT 21H

        MOV BL, BUFFER1[1]                  ;BL存放开始数字的位数
        CMP BL,3                                   
        JZ  TH
        CMP BL,2
        JZ  SE
        CMP BL,1
        JZ  FR 

        
TH:     MOV SI,0                                      ;如果起始数字是三位数，存放起始数字到SI中
        SUB BYTE PTR BUFFER1[2],30H                          
        SUB BYTE PTR BUFFER1[3],30H
        SUB BYTE PTR BUFFER1[4],30H
        MOV AX,100
        MUL BYTE PTR BUFFER1[2]
        ADD SI,AX
        MOV AX,10
        MUL BYTE PTR BUFFER1[3]
        ADD SI,AX
        MOV AX,0
        MOV AL,BYTE PTR BUFFER1[4]
        ADD SI,AX
        CMP SI,63H                                  ;输入非法，重新输入
        JA AG
        JMP NEXT
SE:     MOV SI,0                                      ;如果起始数字是两位数，存放起始数字到SI中
        SUB BYTE PTR BUFFER1[2],30H
        SUB BYTE PTR BUFFER1[3],30H
        MOV AX,10
        MUL BYTE PTR BUFFER1[2]
        ADD SI,AX
        MOV AX,0
        MOV AL,BYTE PTR BUFFER1[3]
        ADD SI,AX
        JMP NEXT
FR:     MOV SI,0                                      ;如果起始数字是一位数，存放到SI中
        SUB BYTE PTR BUFFER1[2],30H
        MOV AX,0
        MOV AL,BYTE PTR BUFFER1[2]
        ADD SI,AX   
        CMP SI,1H                                  ;输入非法，重新输入
        JB AGG
        JMP NEXT

AGG:    LEA DX, OUTPUT3                        ;输入非法，重新输入  
        MOV AH, 09H							 
        INT 21H
        LEA DX, CRLF                         ;换行                 
        MOV AH, 09H							 
        INT 21H
        MOV BYTE PTR BUFFER1[1],0
        JMP AGA

NEXT:   LEA DX, INPUT2                        ;打印提示输入结束的数字 
        MOV AH, 09H							 
        INT 21H

        LEA DX, CRLF                         ;换行                 
        MOV AH, 09H							 
        INT 21H

AGAS:   LEA DX,BUFFER2                            ;接收字符串
        MOV AH, 0AH
        INT 21H

        CMP BUFFER2[1],1                          ;判断是否输入非法
        JB  AGS
        CMP BUFFER2[1],3
        JA  AGS
        MOV CX,0
        MOV CL,BUFFER2[1]
        
        MOV BX,CX
        INC BX
ERS:    CMP BUFFER2[BX],30H
        JB  AGS
        CMP BUFFER2[BX],39H
        JA  AGS
        DEC BX
        LOOP ERS
        JMP TRUES

AGS:    LEA DX, OUTPUT3                        ;输入非法，重新输入  
        MOV AH, 09H							 
        INT 21H
        LEA DX, CRLF                         ;换行                 
        MOV AH, 09H							 
        INT 21H
        MOV BYTE PTR BUFFER2[1],0
        JMP AGAS



TRUES:  LEA DX, CRLF                         ;换行                 
        MOV AH, 09H							 
        INT 21H

        MOV BL,BUFFER2[1]                   ;BL存放结束数字的位数
        CMP BL,3                                   
        JZ  THS
        CMP BL,2
        JZ  SES
        CMP BL,1
        JZ  FRS

THS:    MOV DI,0                                      ;如果结束数字是三位数，存放到DI中
        SUB BYTE PTR BUFFER2[2],30H                          
        SUB BYTE PTR BUFFER2[3],30H
        SUB BYTE PTR BUFFER2[4],30H
        MOV AX,100
        MUL BYTE PTR BUFFER2[2]
        ADD DI,AX
        MOV AX,10
        MUL BYTE PTR BUFFER2[3]
        ADD DI,AX
        MOV AX,0
        MOV AL,BYTE PTR BUFFER2[4]
        ADD DI,AX
        CMP DI,64H                                  ;输入非法，重新输入
        JA AGS
        JMP NEXTS

SES:    MOV DI,0                                      ;如果结束数字是两位数，存放到DI中
        SUB BYTE PTR BUFFER2[2],30H
        SUB BYTE PTR BUFFER2[3],30H
        MOV AX,10
        MUL BYTE PTR BUFFER2[2]
        ADD DI,AX
        MOV AX,0
        MOV AL,BYTE PTR BUFFER2[3]
        ADD DI,AX
        JMP NEXTS
FRS:    MOV DI,0                                      ;如果结束数字是一位数，存放到DI中
        SUB BYTE PTR BUFFER2[2],30H
        MOV AX,0
        MOV AL,BYTE PTR BUFFER2[2]
        ADD DI,AX
        CMP DI,1H                                  ;输入非法，重新输入
        JB AGSS
        JMP NEXTS

AGSS:    LEA DX, OUTPUT3                        ;输入非法，重新输入  
        MOV AH, 09H							 
        INT 21H
        LEA DX, CRLF                         ;换行                 
        MOV AH, 09H							 
        INT 21H
        MOV BYTE PTR BUFFER2[1],0
        JMP AGAS

NEXTS:  CMP DI,SI                            ;判断输入非法
        JBE AGSS
        SUB DI,SI
        MOV CX,DI                          ;计算累加结果
        MOV AX,SI
        MOV BX,AX
ADDIT:  INC BX
        ADD AX,BX
        LOOP ADDIT                           ;累加结果存放在AX中
  
                                            

        MOV DI,OFFSET CRLF-2
        CMP AX,0AH                                      ;判断转成十进制有几位数，从而判断除几次
        JB  NUMCXFR
        CMP AX,64H
        JB  NUMCXSE
        CMP AX,3E8H
        JB  NUMCXTR
        CMP AX,2710H
        JB  NUMCXFO

NUMCXFR: MOV CX,1
         JMP JYB
NUMCXSE: MOV CX,2
         JMP JYB
NUMCXTR: MOV CX,3
         JMP JYB
NUMCXFO: MOV CX,4
         JMP JYB


JYB:    MOV DX,0                              ;将AX数据转化成数字字符，存放到BUFFER3中，进制转换
        MOV BX,10                                    
        DIV BX                                ;除数16位，被除数32位，余数存放在AX中，商存放在DL中
        OR      DL,30H
        MOV     BYTE PTR [DI],DL
        DEC     DI
        LOOP    JYB


        LEA DX, CRLF                         ;换行                 
        MOV AH, 09H							 
        INT 21H

        LEA DX, OUTPUT1                       ;打印提示输出信息
        MOV AH, 09H							 
        INT 21H

        LEA DX, CRLF                         ;换行                 
        MOV AH, 09H							 
        INT 21H

        LEA DX, OUTPUT2                       ;打印提示输出信息
        MOV AH, 09H							 
        INT 21H
       

        LEA DX, BUFFER3                     ;输出输入的字符串
        MOV AH, 09H							 
        INT 21H

        LEA DX, CRLF                         ;换行                 
        MOV AH, 09H							 
        INT 21H
 

        MOV AH, 4CH                          ;返回DOS系统
        INT 21H




       



CODE   ENDS                                  
END    START              

