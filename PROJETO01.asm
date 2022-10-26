TITLE SAMUEL_VANINI_22900955

.model small

.data
    msg0 DB 10, 80 DUP('-'),10,'ESCOLHA A OPERACAO DESEJADA:',10,'1-ADICAO',10, '2-SUBTRACAO',10, '3-MULTIPLICACAO',10, '4-DIVISAO', 10, 10, '$'
    msg1 DB 10,'DIGITE UM NUMERO DE 0 A 9:', '$'
    msg2 DB 10,'DIGITE UM SEGUNDO NUMERO DE 0 A 9:', '$'
    msg3 DB 10, 30 DUP('-'), 'CALCULADORA ASSEMBLY', 30 DUP('-'),10,10, '$'
    msg6 DB 10,'RESULTADO:', '$'
    msg7 DB 'ERRO, POR FAVOR SELECIONE UMA OPERACAO VALIDA', 10, 10, '$'
    msg8 DB 'PRESSIONE QUALQUER TECLA PARA VOLTAR', 10, 10, '$'
    msg9 DB 10,10,10,'APERTE ENTER PARA REALIZAR UMA NOVA OPERACAO', 10, 'OU PRESSIONER QUALQUER TECLA PARA SAIR','$'
    msg10 DB 10, 'RESTO:', '$'
    Limpa DB 25 DUP (10), '$'

.code


MAIN PROC

MOV AX, @DATA
MOV DS, AX

INICIO:
MOV AH, 09H
LEA DX, Limpa     ;exibicao Limpa  - vetor com espacos para limpar a tela
INT 21H

MOV AH, 09H
LEA DX, msg3    ;exibicao Limpa  - vetor com espacos para limpar a tela
INT 21H

MOV AH, 09H
LEA DX, msg1      ;exibicao msg1  - digite
INT 21H

MOV AH, 01H
INT 21H
AND AL, 0FH
MOV BL, AL

MOV AH, 09H
LEA DX, msg2      ;exibicao msg4  - digite o segundo
INT 21H

MOV AH, 01H
INT 21H
AND AL, 0FH
MOV BH, AL

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
LEA DX, msg6      ;exibicao msg6 - resultado
INT 21H

SUB BL,BH
CMP BL,-1
JNG MENOR
OR BL, 30H

MOV AH,02H
MOV DL,BL
INT 21H

JMP SAIDA

MENOR:
MOV AH,02
NEG BL
OR BL,30H
MOV DL,2DH
INT 21H
MOV DL,BL
INT 21H

JMP SAIDA

MULTIPLICACAO:

MOV AH, 09H       
LEA DX, msg6      ;exibicao msg6 - resultado
INT 21H

JMP CONTROL       ;logica para multiplicacao
INI:              ; 
CMP BH, 0         ;compara o conteudo do multiplicador com 0, se for, jmp resul, terminando a multiplicacao
JNZ PULA          
JMP RESUL
PULA:
SHL BL, 1         ;desloca o multiplicando uma casa para a esquerda, equivale a x2
CONTROL:          ;logica que decide se vai somar ou nao, depende do flag carry
SHR BH, 1         ;desloca o multiplicador para a direita, verificando o flag carry
JNC INI           ;se c=1 add depois volta para ini:, se c=0 ini:
ADD CH, BL
JMP INI

RESUL:
CMP CH, 9         ;compara se o resultado e maior que 9
JNG MENOR0        ;se for continua, se nao menor0:
MOV CL, CH       
AND CX, 00FFH 
MOV AX, CX
JMP MAIOR
MENOR0:
MOV DL, CH        
MOV AH, 02
OR DL, 30H
INT 21H           ;impressao do resultado
JMP SAIDA

DIVISAO:

MOV AH, 09H       
LEA DX, msg6      ;exibicao msg6 - resultado
INT 21H

JMP INI0

NEGAT:
MOV AH,09
LEA DX, msg10
INT 21H 
MOV AH,02
OR BL, 30H
MOV DL, BL
INT 21H
JMP SAIDA

INI0:
CMP BH,BL
JNG POSIT
JMP RESUL0
POSIT:
SUB BL,BH
ADD CH, 1B
CMP BL,0
JNE C
JMP RESUL0
C:
JMP INI0

RESUL0:
MOV AH, 02H
OR CH, 30H
MOV DL, CH
INT 21H
CMP BL,0
JE P
JMP NEGAT
P:
JMP SAIDA

SAIDA:
MOV AH,09H
LEA DX, msg9      ;exibicao msg9 - deseja voltar ou sair?
INT 21H

MOV AH,07H        ;interrupcao para escolha
INT 21H

CMP AL, 13        ;condicao para voltar
JNE SAIDA0       
XOR AX,AX         ;zerando os registradores para realizar novas operacoes
XOR BX,BX         ;
XOR CX,CX         ;
XOR DX,DX         ;
JMP INICIO
SAIDA0:
MOV AH, 4CH       
INT 21H           ;saida
 
 
MAIN ENDP

END MAIN
