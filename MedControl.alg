algoritmo "MedControl"
// Desafio 1 - Logica de Programacao - Tema 2
// Os vetores globais representam o estado unico do sistema nesta execucao.
// VisuAlg 3.0.7 nao aceita vetor de registros como parametro de sub-rotina.

const
   MAX_PACIENTES = 30
   EMERGENCIA = 1
   MUITO_URGENTE = 2
   URGENTE = 3
   POUCO_URGENTE = 4
   AGUARDANDO = 0
   ATENDIDO = 1
   CADASTRADOS = 1
   EM_ESPERA = 2
   CONCLUIDOS = 3
   NAO_ENCONTRADO = 0

tipo
   TPaciente = registro
      codigo: inteiro
      nome: caractere
      idade: inteiro
      sexo: caractere
      prioridade: inteiro
      pressaoSistolica: inteiro
      pressaoDiastolica: inteiro
      temperatura: real
      status: inteiro
      ordemCadastro: inteiro
   fimregistro

var
   pacientes: vetor[1..30] de TPaciente
   fila: vetor[1..30] de TPaciente
   estatisticas: vetor[1..4, 1..3] de inteiro
   totalPacientes, opcao: inteiro

// Valida um inteiro antes de converter, evitando erro com letras e sinais.
funcao ehInteiroPositivo(texto: caractere): logico
var
   i: inteiro
   digito: caractere
   valido: logico
inicio
   valido <- (compr(texto) > 0) e (compr(texto) <= 6)
   para i de 1 ate compr(texto) faca
      digito <- copia(texto, i, 1)
      se (digito < "0") ou (digito > "9") entao
         valido <- falso
      fimse
   fimpara
   retorne valido
fimfuncao

// Aceita numeros nao negativos com um ponto decimal opcional.
funcao ehRealPositivo(texto: caractere): logico
var
   i, pontos, digitos: inteiro
   letra: caractere
   valido: logico
inicio
   valido <- (compr(texto) > 0) e (compr(texto) <= 7)
   pontos <- 0
   digitos <- 0
   para i de 1 ate compr(texto) faca
      letra <- copia(texto, i, 1)
      se letra = "." entao
         pontos <- pontos + 1
      senao
         se (letra >= "0") e (letra <= "9") entao
            digitos <- digitos + 1
         senao
            valido <- falso
         fimse
      fimse
   fimpara
   se (pontos > 1) ou (digitos = 0) entao
      valido <- falso
   fimse
   se compr(texto) > 0 entao
      se (copia(texto, 1, 1) = ".") ou (copia(texto, compr(texto), 1) = ".") entao
         valido <- falso
      fimse
   fimse
   retorne valido
fimfuncao

funcao lerInteiro(mensagem: caractere; minimo, maximo: inteiro): inteiro
var
   entrada: caractere
   numero: inteiro
   valido: logico
inicio
   repita
      escreva(mensagem)
      leia(entrada)
      valido <- ehInteiroPositivo(entrada)
      se valido entao
         numero <- caracpnum(entrada)
         valido <- (numero >= minimo) e (numero <= maximo)
      fimse
      se nao valido entao
         escreval("Entrada invalida. Informe um inteiro de ", minimo, " a ", maximo, ".")
      fimse
   ate valido
   retorne numero
fimfuncao

funcao lerReal(mensagem: caractere; minimo, maximo: real): real
var
   entrada: caractere
   numero: real
   valido: logico
inicio
   repita
      escreva(mensagem)
      leia(entrada)
      valido <- ehRealPositivo(entrada)
      se valido entao
         numero <- caracpnum(entrada)
         valido <- (numero >= minimo) e (numero <= maximo)
      fimse
      se nao valido entao
         escreval("Entrada invalida. Use numero entre ", minimo:0:1, " e ", maximo:0:1, " (ex.: 36.5).")
      fimse
   ate valido
   retorne numero
fimfuncao

funcao localizarPaciente(codigo, quantidade: inteiro): inteiro
var
   i, posicao: inteiro
inicio
   posicao <- NAO_ENCONTRADO
   i <- 1
   enquanto (i <= quantidade) e (posicao = NAO_ENCONTRADO) faca
      se pacientes[i].codigo = codigo entao
         posicao <- i
      fimse
      i <- i + 1
   fimenquanto
   retorne posicao
fimfuncao

// Caso-base: fim do vetor valido ou codigo encontrado.
funcao localizarRecursivo(codigo, posicao, quantidade: inteiro): inteiro
inicio
   se posicao > quantidade entao
      retorne NAO_ENCONTRADO
   senao
      se pacientes[posicao].codigo = codigo entao
         retorne posicao
      senao
         retorne localizarRecursivo(codigo, posicao + 1, quantidade)
      fimse
   fimse
fimfuncao

// Caso-base: nenhuma posicao restante.
funcao contarAguardandoRec(posicao, quantidade: inteiro): inteiro
inicio
   se posicao > quantidade entao
      retorne 0
   senao
      se pacientes[posicao].status = AGUARDANDO entao
         retorne 1 + contarAguardandoRec(posicao + 1, quantidade)
      senao
         retorne contarAguardandoRec(posicao + 1, quantidade)
      fimse
   fimse
fimfuncao

funcao nomePrioridade(prioridade: inteiro): caractere
inicio
   escolha prioridade
      caso EMERGENCIA
         retorne "Emergencia"
      caso MUITO_URGENTE
         retorne "Muito urgente"
      caso URGENTE
         retorne "Urgente"
      caso POUCO_URGENTE
         retorne "Pouco urgente"
   fimescolha
   retorne "Desconhecida"
fimfuncao

procedimento mostrarPaciente(posicao: inteiro)
inicio
   escreval("Codigo: ", pacientes[posicao].codigo)
   escreval("Nome: ", pacientes[posicao].nome)
   escreval("Idade: ", pacientes[posicao].idade)
   escreval("Sexo: ", pacientes[posicao].sexo)
   escreval("Prioridade: ", pacientes[posicao].prioridade, " - ", nomePrioridade(pacientes[posicao].prioridade))
   escreval("Pressao arterial: ", pacientes[posicao].pressaoSistolica, "/", pacientes[posicao].pressaoDiastolica)
   escreval("Temperatura: ", pacientes[posicao].temperatura:0:1)
   se pacientes[posicao].status = AGUARDANDO entao
      escreval("Status: Aguardando atendimento")
   senao
      escreval("Status: Atendido")
   fimse
fimprocedimento

procedimento cadastrarPaciente(var quantidade: inteiro)
var
   novo: TPaciente
   codigo: inteiro
   valido: logico
inicio
   se quantidade >= MAX_PACIENTES entao
      escreval("Capacidade maxima de ", MAX_PACIENTES, " pacientes atingida.")
   senao
      repita
         codigo <- lerInteiro("Codigo (1 a 999999): ", 1, 999999)
         valido <- localizarPaciente(codigo, quantidade) = NAO_ENCONTRADO
         se nao valido entao
            escreval("Codigo ja cadastrado. Informe outro.")
         fimse
      ate valido
      novo.codigo <- codigo
      repita
         escreva("Nome: ")
         leia(novo.nome)
         valido <- compr(novo.nome) > 0
         se nao valido entao
            escreval("Nome obrigatorio.")
         fimse
      ate valido
      novo.idade <- lerInteiro("Idade (0 a 130): ", 0, 130)
      repita
         escreva("Sexo (F/M/O): ")
         leia(novo.sexo)
         novo.sexo <- maiusc(novo.sexo)
         valido <- (novo.sexo = "F") ou (novo.sexo = "M") ou (novo.sexo = "O")
         se nao valido entao
            escreval("Informe F, M ou O.")
         fimse
      ate valido
      escreval("Prioridade: 1 Emergencia; 2 Muito urgente; 3 Urgente; 4 Pouco urgente")
      novo.prioridade <- lerInteiro("Prioridade (1 a 4): ", EMERGENCIA, POUCO_URGENTE)
      novo.pressaoSistolica <- lerInteiro("Pressao sistolica (1 a 300): ", 1, 300)
      novo.pressaoDiastolica <- lerInteiro("Pressao diastolica (1 a 200): ", 1, 200)
      novo.temperatura <- lerReal("Temperatura em C (0.0 a 50.0): ", 0, 50)
      novo.status <- AGUARDANDO
      quantidade <- quantidade + 1
      novo.ordemCadastro <- quantidade
      pacientes[quantidade] <- novo
      estatisticas[novo.prioridade, CADASTRADOS] <- estatisticas[novo.prioridade, CADASTRADOS] + 1
      estatisticas[novo.prioridade, EM_ESPERA] <- estatisticas[novo.prioridade, EM_ESPERA] + 1
      escreval("Paciente cadastrado com sucesso.")
   fimse
fimprocedimento

procedimento listarPacientes(quantidade: inteiro)
var
   i: inteiro
inicio
   se quantidade = 0 entao
      escreval("Nenhum paciente cadastrado.")
   senao
      para i de 1 ate quantidade faca
         escreval("------------------------------")
         mostrarPaciente(i)
      fimpara
   fimse
fimprocedimento

procedimento consultarPaciente(quantidade: inteiro)
var
   codigo, posicao: inteiro
inicio
   se quantidade = 0 entao
      escreval("Nenhum paciente cadastrado.")
   senao
      codigo <- lerInteiro("Codigo para consulta: ", 1, 999999)
      posicao <- localizarPaciente(codigo, quantidade)
      se posicao = NAO_ENCONTRADO entao
         escreval("Paciente nao encontrado.")
      senao
         mostrarPaciente(posicao)
      fimse
   fimse
fimprocedimento

// Copia apenas quem aguarda. Ordena registros inteiros, preservando os campos.
// Troca quando prioridade e menor (numero maior), idade menor ou cadastro posterior.
procedimento montarFila(quantidade: inteiro; var tamanhoFila: inteiro)
var
   i, j: inteiro
   auxiliar: TPaciente
   trocar: logico
inicio
   tamanhoFila <- 0
   para i de 1 ate quantidade faca
      se pacientes[i].status = AGUARDANDO entao
         tamanhoFila <- tamanhoFila + 1
         fila[tamanhoFila] <- pacientes[i]
      fimse
   fimpara
   para i de 1 ate tamanhoFila faca
      para j de 1 ate tamanhoFila - i faca
         trocar <- falso
         se fila[j].prioridade > fila[j + 1].prioridade entao
            trocar <- verdadeiro
         senao
            se fila[j].prioridade = fila[j + 1].prioridade entao
               se fila[j].idade < fila[j + 1].idade entao
                  trocar <- verdadeiro
               senao
                  se (fila[j].idade = fila[j + 1].idade) e (fila[j].ordemCadastro > fila[j + 1].ordemCadastro) entao
                     trocar <- verdadeiro
                  fimse
               fimse
            fimse
         fimse
         se trocar entao
            auxiliar <- fila[j]
            fila[j] <- fila[j + 1]
            fila[j + 1] <- auxiliar
         fimse
      fimpara
   fimpara
fimprocedimento

procedimento exibirFila(quantidade: inteiro)
var
   i, tamanhoFila: inteiro
inicio
   montarFila(quantidade, tamanhoFila)
   se tamanhoFila = 0 entao
      escreval("Fila vazia: nao ha pacientes aguardando.")
   senao
      escreval("ORDEM | CODIGO | NOME | PRIORIDADE | IDADE")
      para i de 1 ate tamanhoFila faca
         escreval(i, " | ", fila[i].codigo, " | ", fila[i].nome, " | ", fila[i].prioridade, " | ", fila[i].idade)
      fimpara
   fimse
fimprocedimento

procedimento realizarAtendimento(quantidade: inteiro)
var
   tamanhoFila, codigo, posicao, prioridade: inteiro
inicio
   montarFila(quantidade, tamanhoFila)
   se tamanhoFila = 0 entao
      escreval("Nao ha pacientes aguardando atendimento.")
   senao
      escreval("Proximo: ", fila[1].codigo, " - ", fila[1].nome, " (", nomePrioridade(fila[1].prioridade), ")")
      codigo <- lerInteiro("Confirme o codigo do paciente a atender: ", 1, 999999)
      posicao <- localizarPaciente(codigo, quantidade)
      se posicao = NAO_ENCONTRADO entao
         escreval("Codigo inexistente. Nenhum atendimento registrado.")
      senao
         se pacientes[posicao].status = ATENDIDO entao
            escreval("Paciente ja atendido. Nenhum atendimento registrado.")
         senao
            se codigo <> fila[1].codigo entao
               escreval("Fora da ordem da fila. Atenda primeiro o codigo ", fila[1].codigo, ".")
            senao
               pacientes[posicao].status <- ATENDIDO
               prioridade <- pacientes[posicao].prioridade
               estatisticas[prioridade, EM_ESPERA] <- estatisticas[prioridade, EM_ESPERA] - 1
               estatisticas[prioridade, CONCLUIDOS] <- estatisticas[prioridade, CONCLUIDOS] + 1
               escreval("Atendimento concluido para ", pacientes[posicao].nome, ".")
            fimse
         fimse
      fimse
   fimse
fimprocedimento

procedimento exibirAtendidos(quantidade: inteiro)
var
   i, total: inteiro
inicio
   total <- 0
   para i de 1 ate quantidade faca
      se pacientes[i].status = ATENDIDO entao
         total <- total + 1
         escreval(pacientes[i].codigo, " - ", pacientes[i].nome, " - prioridade ", pacientes[i].prioridade)
      fimse
   fimpara
   se total = 0 entao
      escreval("Nenhum paciente foi atendido.")
   fimse
fimprocedimento

procedimento exibirEstatisticas(quantidade: inteiro)
var
   i, prioridade, totalEspera, totalAtendidos, maiorIdade, menorIdade: inteiro
   somaIdades, somaTemperaturas, percentualAtendidos, percentualEspera: real
inicio
   se quantidade = 0 entao
      escreval("Nao ha dados para estatisticas.")
   senao
      somaIdades <- 0
      somaTemperaturas <- 0
      maiorIdade <- pacientes[1].idade
      menorIdade <- pacientes[1].idade
      para i de 1 ate quantidade faca
         somaIdades <- somaIdades + pacientes[i].idade
         somaTemperaturas <- somaTemperaturas + pacientes[i].temperatura
         se pacientes[i].idade > maiorIdade entao
            maiorIdade <- pacientes[i].idade
         fimse
         se pacientes[i].idade < menorIdade entao
            menorIdade <- pacientes[i].idade
         fimse
      fimpara
      totalEspera <- 0
      totalAtendidos <- 0
      escreval("PRIORIDADE | CADASTRADOS | AGUARDANDO | ATENDIDOS")
      para prioridade de EMERGENCIA ate POUCO_URGENTE faca
         escreval(nomePrioridade(prioridade), " | ", estatisticas[prioridade, CADASTRADOS], " | ", estatisticas[prioridade, EM_ESPERA], " | ", estatisticas[prioridade, CONCLUIDOS])
         totalEspera <- totalEspera + estatisticas[prioridade, EM_ESPERA]
         totalAtendidos <- totalAtendidos + estatisticas[prioridade, CONCLUIDOS]
      fimpara
      percentualAtendidos <- (totalAtendidos * 100) / quantidade
      percentualEspera <- (totalEspera * 100) / quantidade
      escreval("Total de pacientes: ", quantidade)
      escreval("Aguardando: ", totalEspera, " | Atendidos: ", totalAtendidos)
      escreval("Media de idade: ", (somaIdades / quantidade):0:2)
      escreval("Media de temperatura: ", (somaTemperaturas / quantidade):0:2)
      escreval("Maior idade: ", maiorIdade, " | Menor idade: ", menorIdade)
      escreval("Percentual atendido: ", percentualAtendidos:0:2, "%")
      escreval("Percentual aguardando: ", percentualEspera:0:2, "%")
      escreval("Prioridade 1 ou 2: ", estatisticas[EMERGENCIA, CADASTRADOS] + estatisticas[MUITO_URGENTE, CADASTRADOS])
   fimse
fimprocedimento

procedimento executarConsultaRecursiva(quantidade: inteiro)
var
   codigo, posicao: inteiro
inicio
   se quantidade = 0 entao
      escreval("Nenhum paciente cadastrado.")
   senao
      codigo <- lerInteiro("Codigo para busca recursiva: ", 1, 999999)
      posicao <- localizarRecursivo(codigo, 1, quantidade)
      se posicao = NAO_ENCONTRADO entao
         escreval("Paciente nao encontrado pela busca recursiva.")
      senao
         mostrarPaciente(posicao)
      fimse
      escreval("Aguardando (contagem recursiva): ", contarAguardandoRec(1, quantidade))
   fimse
fimprocedimento

inicio
   totalPacientes <- 0
   para opcao de EMERGENCIA ate POUCO_URGENTE faca
      estatisticas[opcao, CADASTRADOS] <- 0
      estatisticas[opcao, EM_ESPERA] <- 0
      estatisticas[opcao, CONCLUIDOS] <- 0
   fimpara
   repita
      escreval("")
      escreval("MEDCONTROL - GERENCIAMENTO DE ATENDIMENTOS")
      escreval("1. Cadastrar paciente")
      escreval("2. Listar pacientes")
      escreval("3. Consultar paciente")
      escreval("4. Exibir fila de atendimento")
      escreval("5. Realizar atendimento")
      escreval("6. Exibir pacientes atendidos")
      escreval("7. Exibir estatisticas")
      escreval("8. Executar consulta recursiva")
      escreval("9. Encerrar sistema")
      opcao <- lerInteiro("Opcao: ", 0, 99)
      escolha opcao
         caso 1
            cadastrarPaciente(totalPacientes)
         caso 2
            listarPacientes(totalPacientes)
         caso 3
            consultarPaciente(totalPacientes)
         caso 4
            exibirFila(totalPacientes)
         caso 5
            realizarAtendimento(totalPacientes)
         caso 6
            exibirAtendidos(totalPacientes)
         caso 7
            exibirEstatisticas(totalPacientes)
         caso 8
            executarConsultaRecursiva(totalPacientes)
         caso 9
            escreval("Sistema encerrado.")
         outrocaso
            escreval("Opcao inexistente. Escolha de 1 a 9.")
      fimescolha
   ate opcao = 9
fimalgoritmo
