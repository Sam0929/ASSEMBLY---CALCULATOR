TITLE SAMUEL_VANINI_22900955

.model small

.data
    msg0 DB 'ESCOLHA A OPERACAO DESEJADA: 1-ADICAO 2-SUBTRACAO 3-MULTIPLICACAO 4-DIVISAO', 10, 10, '$'
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
JE ADICAO        ;condicional adicao

CMP AL, 32H
JE SUBTRACAO     ;condicional subtracao

CMP AL, 33H
JE MULTIPLICACAO    ;condicional multi

CMP AL, 34H 
JE DIVISAO          ;condicional divisao

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
SUB AL, 30H
MOV BL, AL

MOV AH, 02H
MOV DL, 10        ;espacos
INT 21H

MOV AH,09H
LEA DX, msg2      ;exibicao msg2  - digite somar
INT 21H

MOV AH, 01H
INT 21H
SUB AL, 30H       ;entrada segundo numero
MOV BH, AL

MOV AH, 02H
MOV DL, 10        ;espacos
INT 21H

ADD BL, BH        ;opercao logica aritmetica adicao
ADD BL, 30H       ;+30h volta a ser caracter

MOV AH, 09H       
LEA DX, msg6      ;exibicao msg6 - resultado
INT 21H

MOV AH, 02H      
MOV DL, BL        ;exibicao resultado
INT 21H

JMP SAIDA


SUBTRACAO:
MOV AH, 09H
LEA DX, msg1      ;exibicao msg1  - digite
INT 21H

MOV AH, 01H
INT 21H
SUB AL, 30H
MOV BL, AL

MOV AH, 09H
LEA DX, msg3      ;exibicao msg3  - digite o que deseja sub
INT 21H

JMP SAIDA

MULTIPLICACAO:

MOV AH, 09H
LEA DX, msg1      ;exibicao msg1  - digite
INT 21H

MOV AH, 01H
INT 21H
SUB AL, 30H
MOV BL, AL

MOV AH, 09H
LEA DX, msg4      ;exibicao msg4  - digite o que deseja mul
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