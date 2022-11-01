TITLE SAMUEL_VANINI_22900955

.model small

.data
    msg0 DB 13, 10, 30 DUP('-'), 'CALCULADORA ASSEMBLY', 30 DUP('-'),13, 10, '$'
    msg1 DB 13, 10,'DIGITE UM NUMERO DE 0 A 9:', '$'
    msg2 DB 13, 10,'DIGITE UM SEGUNDO NUMERO DE 0 A 9:', '$'
    msg3 DB 3 DUP (13,10), 32 DUP('-'), 'FEITO POR SAMUEL', 32 DUP('-'),13, 10,'ESCOLHA A OPERACAO DESEJADA:',2 DUP (13,10), '1-ADICAO',13, 10, '2-SUBTRACAO', 13, 10, '3-MULTIPLICACAO',13, 10, '4-DIVISAO', 2 DUP (13,10), '$'
    msg4 DB 13, 10,'RESULTADO:', '$'
    msg5 DB 13, 10,'QUOCIENTE:', '$'
    msg6 DB 'ERRO! , POR FAVOR SELECIONE UMA OPERACAO VALIDA!', 2 DUP (13,10), 'PRESSIONE QUALQUER TECLA PARA TENTAR NOVAMENTE','$'
    msg7 DB 3 DUP (13,10),'APERTE ENTER PARA REALIZAR UMA NOVA OPERACAO', 13, 10, 'OU PRESSIONER QUALQUER TECLA PARA SAIR','$'
    msg8 DB 13, 10, 'RESTO:', '$'
    ZERO DB 13, 10, 'DIVISOES POR 0 NAO EXISTEM, POR FAVOR, TENTE NOVAMENTE!', '$'
    Limpa DB 25 DUP (13, 10), '$'

.code


MAIN PROC

MOV AH,6              ;
XOR AL,AL             ;seta as flags necessarias
XOR CX,CX             ;
MOV DX,184FH          ;       
MOV BH,0Bh            ;0Bh equivale a ciano
INT 10H               ;muda a cor do texto exibido durante a execucao do programa

MOV AX, @DATA
MOV DS, AX

INICIO:
MOV AH, 09H
LEA DX, Limpa         ;exibicao Limpa  - vetor com espacos para limpar a tela
INT 21H

MOV AH, 09H
LEA DX, msg0          ;exibicao calculadora assembly 
INT 21H

MOV AH, 09H
LEA DX, msg1          ;exibicao msg1  - digite o primeiro
INT 21H

MOV AH, 01H
INT 21H               ;entrada do primeiro caracter
AND AL, 0FH           ;and 0fh transforma o caracter em numero para ser operado
MOV BL, AL

MOV AH, 09H
LEA DX, msg2          ;exibicao msg2  - digite o segundo
INT 21H

MOV AH, 01H
INT 21H               ;entrada do segundo caracter
AND AL, 0FH           ;and 0fh transforma o caracter em numero para ser operado
MOV BH, AL

MOV AH, 09H
LEA DX, msg3          ;exibicao msg3  - escolha operacao
INT 21H 

MOV AH, 07H       
INT 21H

CMP AL, 31H
JNE SALTA00           ;condicional adicao
JMP ADICAO
SALTA00:

CMP AL, 32H
JNE SALTA01           ;condicional subtracao
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
LEA DX, msg6          ;se nenhuma condicao for verdadeira
INT 21H               ;um erro é impresso

MOV AH, 07H           
INT 21H               ;leitura da tecla, tem a funcao de parar o programa ate a entrada de algum caracter, o caracter lido nao tem importancia para a logica do programa 
JMP INICIO            

ADICAO:

MOV AH, 09H       
LEA DX, msg4          ;exibicao msg4 - resultado
INT 21H
ADD BL, BH            ;operacao logica aritmetica adicao
CMP BL, 9
JNG MENOR0A           ;caso o resultado for menor do que 10, pula para MENOR0A
AND BH, 00H           ;limpa o registrador BH para BX so possuir o resultado da adicao em BL
MOV AX, BX 
JMP MAIOR             ;pula para a logica que imprime resultados maiores que 9
MENOR0A:

OR BL, 30H            ;OR 30h volta a ser caracter
MOV AH, 02H      
MOV DL, BL            
INT 21H               ;imprime o resultado

JMP SAIDA

MAIOR:                ;logica para imprimir resultados maiores que 9
MOV BL,10             
DIV BL                ;dividi-se o resultado, armazenado em bx por 10, obtendo o digito de maior ordem decimal em AL e o digito de menor ordem decimal em AH
MOV BX,AX             ;salvo o resultado em BX
MOV AH,02H
MOV DL,BL             
OR DL,30H             ;transforma o numero em caracter
INT 21H               ;imprime o digito de maior ordem decimal

MOV DL, BH
OR DL,30H             ;transforma o numero em caracter
INT 21H               ;imprime o digito de menor ordem decimal

JMP SAIDA

SUBTRACAO:

MOV AH, 09H       
LEA DX, msg4          ;exibicao msg4 - resultado
INT 21H

SUB BL,BH             ;executa a subtracao dos numeros
CMP BL,-1             ;compara se o resultado e maior do que -1
JNG MENOR             ;se nao for maior pula para a logica que imprime resultados menores do que 0
OR BL, 30H            ;transforma o numero em caracter

MOV AH,02H
MOV DL,BL          
INT 21H               ;imprime o resultado da subtracao

JMP SAIDA

MENOR:                ;logica que imprime resultados menores que 0
MOV AH,02             
NEG BL                ;aplica o C2 no resultado e se obtem o numero resultante da subtracao como um numero positivo novamente
OR BL,30H             ;transforma o numero em caracter
MOV DL,2DH            ;2DH se refere ao caracter '-'
INT 21H               ;imprime o sinal de menos '-'
MOV DL,BL
INT 21H               ;imprime o resultado

JMP SAIDA            

MULTIPLICACAO:

MOV AH, 09H       
LEA DX, msg4          ;exibicao msg - resultado
INT 21H

JMP CONTROL           ;logica para multiplicacao
INI:                  ; 
CMP BH, 0             ;compara o conteudo do multiplicador com 0, se for, jmp RESUL, terminando a multiplicacao
JNZ PULA          
JMP RESUL
PULA:
SHL BL, 1             ;desloca o multiplicando uma casa para a esquerda, equivale a x2
CONTROL:              ;logica que decide se vai somar ou nao, depende do flag carry
SHR BH, 1             ;desloca o multiplicador para a direita, verificando o flag carry
JNC INI               ;se c=1 add depois volta para INI:, se c=0 vai para o label INI:
ADD CH, BL
JMP INI

RESUL:
CMP CH, 9             ;compara se o resultado e maior que 9
JNG MENOR0            ;se for continua, se nao menor0:
MOV CL, CH       
AND CX, 00FFH 
MOV AX, CX
JMP MAIOR             ;salta para a logica que imprime resultados maiores que 9
MENOR0:
MOV DL, CH        
MOV AH, 02
OR DL, 30H
INT 21H               ;impressao do resultado
JMP SAIDA

DIVISAO:

MOV AH, 09H
CMP BH,0              ;compara se o divisor e 0 logo no inicio, caso z=1, salta para ERRO
JZ ERRO        
LEA DX, msg5          ;exibicao msg - quociente
INT 21H
           
INI0:
CMP BH,BL            
JNG POSIT             ;se o divisor for menor que o dividendo, executa o algoritmo de divisao, representado pelo label POSIT
JMP RESUL0            ;se o divisor for maior, pula para RESUL0, imprimindo quantas vezes o dividendo pode ser dividido pelo divisor
POSIT:
SUB BL,BH             ;subtrai do dividendo o divisor
ADD CH, 1             ;adiciona 1 em CH que representa quantas vezes o divisor pode ser multiplicado sem ser maior que o dividendo
JMP INI0              ;volta para o INI0 ate o divisor ser maior que o dividendo

RESUL0:
MOV AH, 02H
OR CH, 30H
MOV DL, CH
INT 21H               ;impressao do resultado da divisao
CMP BL,0              ;comparacao para ver se a divisao e exata
JE P                  ;caso for, pula para SAIDA
JMP RESTO             ;caso nao, pula para RESTO
P:
JMP SAIDA

RESTO:
MOV AH,09
LEA DX, msg8          ;exibicao msg - resto
INT 21H 
MOV AH,02             
OR BL, 30H
MOV DL, BL
INT 21H               ;imprime quanto sobrou do dividendo, que nao pode ser dividido
JMP SAIDA

ERRO:
LEA DX, ZERO
INT 21H

SAIDA:
MOV AH,09H
LEA DX, msg7          ;exibicao msg7 - deseja voltar ou sair?
INT 21H

MOV AH,07H            ;interrupcao para escolha
INT 21H

CMP AL, 13            ;condicao para voltar
JNE SAIDA0       
XOR AX,AX             ;zerando os registradores para realizar novas operacoes
XOR BX,BX             ;
XOR CX,CX             ;
XOR DX,DX             ;
JMP INICIO
SAIDA0:
MOV AH, 4CH       
INT 21H               ;saida
 
 
MAIN ENDP

END MAIN
