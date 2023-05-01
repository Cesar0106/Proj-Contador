inputASM = 'ASM.txt' #Arquivo de entrada de contém o assembly
outputBIN = 'BIN.txt' #Arquivo de saída que contém o binário formatado para VHDL
outputMIF = 'initROM.mif' #Arquivo de saída que contém o binário formatado para .mif

noveBits = True

#definição dos mnemônicos e seus
#respectivo OPCODEs (em Hexadecimal)
mne =	{ 
       "NOP":   "0",
       "LDA":   "1",
       "SOMA":  "2",
       "SUB":   "3",
       "LDI":   "4",
       "STA":   "5",
       "JMP":   "6",
       "JEQ":   "7",
       "CEQ":   "8",
       "JSR":   "9",
       "RET":   "A",
}

#Converte o valor após o caractere arroba '@'
#em um valor hexadecimal de 2 dígitos (8 bits)
def  converteArroba(line):
    line = line.split('@')
    line[1] = hex(int(line[1]))[2:].upper().zfill(2)
    line = ''.join(line)
    return line
    
#Converte o valor após o caractere arroba '@'
#em um valor hexadecimal de 2 dígitos (8 bits) e...
#concatena com o bit de habilita 
def converteArroba9bits(line):
    line = line.split('@')
    if line[1] not in dict_labels.keys():
        if line[1].isdigit():
            if(int(line[1]) > 255 ):
                line[1] = str(int(line[1]) - 256)
                line[1] = hex(int(line[1]))[2:].upper().zfill(2)
                line[1] = "\" & '1' & x\"" + line[1]
            else:
                line[1] = hex(int(line[1]))[2:].upper().zfill(2)
                line[1] = "\" & '0' & x\"" + line[1]
        else:
            print("Warning: Non-integer value found after '@':", line[1])
            line[1] = "\" & '0' & x\"00"
    else:
        line[1] = hex(int(dict_labels[line[1]]))[2:].upper().zfill(2)
        line[1] = "\" & '0' & x\"" + line[1]
    line = ''.join(line)
    return line


 
#Converte o valor após o caractere cifrão'$'
#em um valor hexadecimal de 2 dígitos (8 bits) 
def  converteCifrao(line):
    line = line.split('$')
    line[1] = hex(int(line[1]))[2:].upper().zfill(2)
    line = ''.join(line)
    return line
    
def converteCifrao9bits(line):
    line = line.split('$')
    if line[1] in dict_labels.keys():
        line[1] = hex(int(dict_labels[line[1]]))[2:].upper().zfill(2)
        line[1] = "\" & '0' & x\"" + line[1]
    else:
        if line[1].isdigit():
            if(int(line[1]) > 255):
                line[1] = str(int(line[1]) - 256)
                line[1] = hex(int(line[1]))[2:].upper().zfill(2)
                line[1] = "\" & '1' & x\"" + line[1]
            else:
                line[1] = hex(int(line[1]))[2:].upper().zfill(2)
                line[1] = "\" & '0' & x\"" + line[1]
        else:
            print("Warning: Non-integer value found after '$':", line[1])
            line[1] = "\" & '0' & x\"00"
    line = ''.join(line)
    return line


        
#Define a string que representa o comentário
#a partir do caractere cerquilha '#'
def defineComentario(line):
    if '--' in line:
        splitted_line = line.split('--', 1)
        return splitted_line[0].strip(), splitted_line[1].strip()
    else:
        return line.strip(), ""


#Remove o comentário a partir do caractere cerquilha '#',
#deixando apenas a instrução
def defineInstrucao(line):
    line = line.split('--')
    line = line[0]
    return line
    
#Consulta o dicionário e "converte" o mnemônico em
#seu respectivo valor em hexadecimal
def trataMnemonico(line):
    line = line.replace("\n", "") #Remove o caracter de final de linha
    line = line.replace("\t", "") #Remove o caracter de tabulacao
    line = line.split(' ')
    line[0] = mne[line[0]]
    line = "".join(line)
    return line
    

with open(inputASM, "r") as f: #Abre o arquivo ASM
    lines = f.readlines() #Verifica a quantidade de linhas

with open(outputBIN, "w+") as f:  #Abre o destino BIN

    cont = 0 #Cria uma variável para contagem
    dict_labels = {} #Cria um dicionário para armazenar as labels

    for line in lines:
            #Verifica se a linha começa com alguns caracteres invalidos ('\n' ou ' ' ou '#')
        if(line.startswith('\n') or line.startswith(' ') or line.startswith('#')):
            line = line.replace("\n", "")
            print("-- Sintaxe invalida" + ' na Linha: ' + ' --> (' + line + ')') #Print apenas para debug
        else:
            if ':' in line:
                label = line.split(':')[0]
                comentario = line.split(':')[1]
                dict_labels[label] = cont
                lines[cont]="NOP"+" "+comentario
        cont+=1

    cont = 0
    for line in lines:        
        if (" ") in line:
            if line.split(" ")[1] in dict_labels.keys():
                label = line.split(" ")[1]
                line = line.replace(line, "JEQ" + " " + "@" + f"{dict_labels[label]}") 

        #Verifica se a linha começa com alguns caracteres invalidos ('\n' ou ' ' ou '#')
        if (line.startswith('\n') or line.startswith(' ') or line.startswith('#')):
            line = line.replace("\n", "")
            print("-- Sintaxe invalida" + ' na Linha: ' + ' --> (' + line + ')') #Print apenas para debug
        
        #Se a linha for válida para conversão, executa
        else:
            
            #Exemplo de linha => 1. JSR @14 #comentario1
            sem_comentarios, comentarioLine = defineComentario(line)  # Separate the code and comments
            instrucaoLine = defineInstrucao(sem_comentarios).replace("\n","") #Define a instrução. Ex: JSR @14

            instrucaoLine = defineInstrucao(line).replace("\n","") #Define a instrução. Ex: JSR @14
            
            instrucaoLine = trataMnemonico(instrucaoLine) #Trata o mnemonico. Ex(JSR @14): x"9" @14
                  
            if '@' in instrucaoLine: #Se encontrar o caractere arroba '@' 
                if noveBits == False:
                    instrucaoLine = converteArroba(instrucaoLine) #converte o número após o caractere Ex(JSR @14): x"9" x"0E"
                else:
                    instrucaoLine = converteArroba9bits(instrucaoLine) #converte o número após o caractere Ex(JSR @14): x"9" x"0E"
                    
            elif '$' in instrucaoLine: #Se encontrar o caractere cifrao '$'
                if noveBits == False:
                    instrucaoLine = converteCifrao(instrucaoLine) #converte o número após o caractere Ex(LDI $5): x"4" x"05"
                else:
                    instrucaoLine = converteCifrao9bits(instrucaoLine) #converte o número após o caractere Ex(LDI $5): x"4" x"05"
                
            else: #Senão, se a instrução nao possuir nenhum imediato, ou seja, nao conter '@' ou '$'
                instrucaoLine = instrucaoLine.replace("\n", "") #Remove a quebra de linha
                if noveBits == False:
                    instrucaoLine = instrucaoLine + '00' #Acrescenta o valor x"00". Ex(RET): x"A" x"00"
                else:
                    instrucaoLine = instrucaoLine + "\" & " + "\'0\' & " + "x\"00" #Acrescenta o valor x"00". Ex(RET): x"A" x"00"
                
            for instru in mne:
                if mne[instru] == instrucaoLine[0]:
                    instrucaoLine=instru+instrucaoLine[2:]
            line = 'tmp(' + str(cont) + ') := ' + instrucaoLine + '";\t-- ' + comentarioLine + '\n'   #Formata para o arquivo BIN
                                                                                                       #Entrada => 1. JSR @14 #comentario1
                                                                                                       #Saída =>   1. tmp(0) := x"90E";	-- JSR @14 	#comentario1
                                        
            cont+=1 #Incrementa a variável de contagem, utilizada para incrementar as posições de memória no VHDL
            f.write(line) #Escreve no arquivo BIN.txt
            
            print(line,end = '') #Print apenas para debug
            
            
with open(outputMIF, "r") as f: #Abre o arquivo de MIF
    headerMIF = f.readlines() #Faz a leitura das linhas do arquivo,
                              #para fazer a aquisição do header
    
    
with open(outputBIN, "r") as f: #Abre o arquivo BIN
    lines = f.readlines() #Faz a leitura das linhas do arquivo
    
    
with open(outputMIF, "w") as f:  #Abre o destino MIF

    cont = 0 #Cria uma variável para contagem
    
    for lineHeader in headerMIF:       
        if cont < 21:           #Contagem das linhas de cabeçalho
            f.write(lineHeader) #Escreve no arquivo se saída .mif o cabeçalho (21 linhas)
        cont = cont + 1         #Incrementa varíavel de contagem
        
    for line in lines:
    
        replacements = [('t', ''), ('m', ''), ('p', ''), ('(', ''), (')', ''), ('=', ''), ('x', ''), ('"', '')] #Define os caracteres que serão excluídos
        
        for char, replacement in replacements:
            if char in line:
                line = line.replace(char, replacement) #Remove os caracteres que foram definidos

        line = line.split('--') #Remove o comentário da linha
        
        if "\n" in line[0]:
            line = line[0] 
        else:
            line = line[0] + '\n' #Insere a quebra de linha ('\n') caso não tenha

        f.write(line) #Escreve no arquivo initROM.mif
    f.write("END;") #Acrescente o indicador de finalização da memória.