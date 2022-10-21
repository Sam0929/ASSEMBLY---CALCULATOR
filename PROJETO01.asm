TITLE SAMUEL_VANINI_22900955

.model small

.data
    msg0 DB 'ESCOLHA A OPERACAO DESEJADA:',10,'1-ADICAO',10, '2-SUBTRACAO',10, '3-MULTIPLICACAO',10, '4-DIVISAO', 10, 10, '$'
    msg1 DB 'DIGITE UM NUMERO DE 0 A 9:', '$'
    msg2 DB 'DIGITE O NUMERO QUE DESEJA SOMAR:', '$'
    msg3 DB 'DIGITE O NUMERO QUE DESEJA SUBTRAIR:', '$'
    msg4 DB 'DIGITE O NUMERO QUE DESEJA MULTIPLICAR:', '$'
    msg5 DB 'DIGITE O NUMERO QUE DESEJA DIVIDIR:', '$'
    msg6 DB 'RESULTADO:', '$'
    msg7 DB 'ERRO, POR FAVOR SELECIONE UMA OPERACAO VALIDA', 10, 10, '$'
    msg8 DB 'PRESSIONE QUALQUER TECLA PARA VOLTAR', 10, 10, '$'

.code


MAIN PROC

MOV AX, @DATA
MOV DS, AX

INICIO:
MOV AH, 09H
LEA DX, msg0      ;exibicao msg0  - escolha operacao
INT 21H

MOV AH, 07H
INT 21H

CMP AL, 31H
JNE SALTA00           ;condicional adicao
JMP ADICAO
SALTA00:

CMP AL, 32H
JNE SALTA01        ;condicional subtracao
JMP SUBTRACAO
SALTA01:

CMP AL, 33H
JNE SALTA02           ;condicional multi
JMP MULTIPLICACAO
SALTA02:

CMP AL, 34H 
JNE SALTA03           ;condicional divisao
JMP DIVISAO
SALTA03:

MOV AH, 09H
LEA DX, msg7        ;se nenhuma condicao for verdadeira
INT 21H             ;um erro é impresso 
LEA DX, msg8        
INT 21H             ;pede-se para o usuario pressionar qualquer tecla para voltar

MOV AH, 07H         ;leitura da tecla, funciona como uma interrupcao, o caracter lido nao tem importancia para a logica do programa 
INT 21H
JMP INICIO          

ADICAO:
MOV AH, 09H
LEA DX, msg1      ;exibicao msg1  - digite
INT 21H

MOV AH, 01H
INT 21H           ;entrada primeiro numero
AND AL, 0FH
MOV BL, AL

MOV AH, 02H
MOV DL, 10        ;espacos
INT 21H

MOV AH,09H
LEA DX, msg2      ;exibicao msg2  - digite somar
INT 21H

MOV AH, 01H
INT 21H
AND AL, 0FH       ;entrada segundo numero
MOV BH, AL

MOV AH, 02H
MOV DL, 10        ;espacos
INT 21H

ADD BL, BH        ;operacao logica aritmetica adicao
AND BH, 0F0H
CMP BL, 9
JNG MENOR0A
MOV AX, BX 
JMP MAIOR
MENOR0A:
OR BL, 30H       ;+30h volta a ser caracter

MOV AH, 09H       
LEA DX, msg6      ;exibicao msg6 - resultado
INT 21H

MOV AH, 02H      
MOV DL, BL        ;exibicao resultado
INT 21H

JMP SAIDA

MAIOR:
MOV BL,10
DIV BL
MOV BX,AX
MOV DL,BL        ;logica para imprimir resultados maiores que 9
OR DL,30H
MOV AH,02H
INT 21H

MOV DL, BH
OR DL,30H
INT 21H


JMP SAIDA


SUBTRACAO:
MOV AH, 09H
LEA DX, msg1      ;exibicao msg1  - digite
INT 21H

MOV AH, 01H
INT 21H
AND AL, 0FH
MOV BH, AL

MOV AH, 02H
MOV DL, 10        ;espacos
INT 21H

MOV AH, 09H
LEA DX, msg3      ;exibicao msg3  - digite o que deseja sub
INT 21H

MOV AH, 01H
INT 21H
AND AL, 0FH
MOV BL, AL

MOV AH, 02H
MOV DL, 10        ;espacos
INT 21H

SUB BH,BL
CMP BH,0
JNG MENOR
OR BH, 30H

MOV AH, 09H       
LEA DX, msg6      ;exibicao msg6 - resultado
INT 21H

MOV AH,02H
MOV DL,BH
INT 21H

JMP SAIDA

MENOR:
MOV AH,02
NEG BH
OR BH,30H
MOV DL,2DH
INT 21H
MOV DL,BH
INT 21H

JMP SAIDA

MULTIPLICACAO:

MOV AH, 09H
LEA DX, msg1      ;exibicao msg1  - digite
INT 21H

MOV AH, 01H
INT 21H
AND AL, 0FH
MOV BL, AL

MOV AH, 02H
MOV DL, 10        ;espacos
INT 21H

MOV AH, 09H
LEA DX, msg4      ;exibicao msg4  - digite o que deseja mul
INT 21H

MOV AH, 01H
INT 21H
AND AL, 0FH
MOV BH, AL

MOV AH, 02H
MOV DL, 10        ;espacos
INT 21H

MOV AH, 09H       
LEA DX, msg6      ;exibicao msg6 - resultado
INT 21H

CMP BH, 1
JNE X2

MOV AH, 02
OR  BL, 30H
MOV DL, BL
INT 21H
JMP SAIDA
X2:

CMP BH,2
JNE X3
MOV AH, 02
SHL BL, 1
MOV DL,BL
CMP DL, 9
JNG MENOR0
AND DX, 00FFH
MOV AX, DX
JMP MAIOR
MENOR0:
OR DL, 30H
INT 21H
JMP SAIDA
X3:

CMP BH,3
JNE X4
MOV AH,02
MOV BH, BL
SHL BL, 1
ADD BL, BH
MOV DL, BL
CMP DL, 9
JNG MENOR1
AND DX, 00FFH
MOV AX, DX
JMP MAIOR
MENOR1:
OR DL,30H
INT 21H
JMP SAIDA

X4:
CMP BH,4
JNE X5
MOV AH, 02
SHL BL, 2
MOV DL,BL
CMP DL, 9
JNG MENOR2
AND DX, 00FFH
MOV AX, DX
JMP MAIOR
MENOR2:
OR DL,30H
INT 21H
JMP SAIDA

X5:
CMP BH,5
JNE X6
MOV AH, 02
MOV BH, BL
SHL BL, 2
ADD BL, BH
MOV DL,BL
CMP DL, 9
JNG MENOR3
AND DX, 00FFH
MOV AX, DX
JMP MAIOR
MENOR3:
OR DL,30H
INT 21H
JMP SAIDA

X6:
CMP BH,6
JNE X7
MOV AH, 02
MOV BH, BL
SHL BL, 2
SHL BH, 1
ADD BL, BH
MOV DL,BL
CMP DL, 9
JNG MENOR4
AND DX, 00FFH
MOV AX, DX
JMP MAIOR
MENOR4:
OR DL,30H
INT 21H
JMP SAIDA

X7:
CMP BH,7
JNE X8
MOV AH, 02
MOV BH, BL
SHL BL, 3
SUB BL, BH
MOV DL, BL
CMP DL, 9
JNG MENOR5
AND DX, 00FFH
MOV AX, DX
JMP MAIOR
MENOR5:
OR DL,30H
INT 21H
JMP SAIDA

X8:
CMP BH,8
JNE X9
MOV AH, 02
SHL BL, 3
MOV DL,BL
CMP DL, 9
JNG MENOR6
AND DX, 00FFH
MOV AX, DX
JMP MAIOR
MENOR6:
OR DL,30H
INT 21H
JMP SAIDA

X9:

MOV AH, 02
MOV BH,BL
SHL BL, 3
ADD BL, BH
MOV DL,BL
CMP DL, 9
JNG MENOR7
AND DX, 00FFH
MOV AX, DX
JMP MAIOR
MENOR7:
OR DL,30H
INT 21H
JMP SAIDA

DIVISAO:

MOV AH, 09H
LEA DX, msg1      ;exibicao msg1  - digite
INT 21H

MOV AH, 01H
INT 21H
SUB AL, 30H
MOV BL, AL


MOV AH, 09H
LEA DX, msg5      ;exibicao msg5  - digite o que deseja div 
INT 21H


JMP SAIDA

SAIDA:
MOV AH, 4CH       
INT 21H           ;saida
 
 
MAIN ENDP

END MAIN
