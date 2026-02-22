# Trabalho Prático 01 — Preliminar

- [Documento da Atividade](01-tp-cool-extra.pdf)
- [Documento de Configuração](00-configuracoes-iniciais.pdf)

## Anunciado da Atividade

**Vencimento:** 22/02/2026, Domingo, às 23:59  
**Pontos:** 2  
**Envio:** Upload de arquivo  
**Disponível:** 09/02/2026, Segunda-feira, às 00:00 → 22/02/2026, Domingo, às 23:59  

### Descrição

Entrega preliminar do trabalho prático, **INDIVIDUAL**.  
**Não é uma entrega obrigatória**, mas sim **extra**.  

A apuração da pontuação será feita depois, apenas para os aprovados (**60+**), valendo **2 pontos**.

O conteúdo do trabalho está no arquivo [`01-tp-cool-extra.pdf`](01-tp-cool-extra.pdf).  
Como pré-requisito, é importante já ter realizado a configuração conforme o arquivo [`00-configuracoes-iniciais.pdf`](../00-configuracoes-iniciais.pdf).

### Requisitos Obrigatórios da Entrega
*(se não atendidos, a pontuação será zerada)*

- O código implementado deve **compilar e executar corretamente**.
- O arquivo **README** deve estar preenchido, em português ou inglês, com **análises verdadeiras e completas** sobre o uso da linguagem.

### Observação Importante

O compilador da linguagem **COOL** fornecido na atividade deve ser usado em:

- Sistema operacional **Linux** *(WSL pode funcionar)*  
- Arquitetura **x86**

> **MacBooks com arquitetura diferente não conseguirão executar o compilador**, inviabilizando a execução do trabalho nessas plataformas, mesmo em máquinas virtuais.

💡 **Alternativa:** usar instâncias gratuitas de nuvem  
*(AWS, Azure, Google Cloud, etc.)*

### Arquivos Adicionais

- `cool-manual.pdf` — Manual da linguagem com definições léxicas, sintáticas e semânticas  
- `cool-paper.pdf` — Artigo científico de divulgação da linguagem  
- `cool-runtime.pdf` — Detalhes do ambiente de execução da linguagem  
- `cool-tour.pdf` — Manual expresso da linguagem com informações das palavras reservadas  
- `x86_64u` — Pacote com código-fonte mencionado nos PDFs dos trabalhos  


## Artefato Produzido

Implementação de uma máquina de pilha em COOL (`stack.cl`), conforme especificado no PA1.

### 1. Criação do ambiente

```bash
docker build -t tp-comp . # buildar a imagem
docker run -it -v $(pwd):/root/workspace tp-comp # entrar no container
```

### 2. Preparação do PA1

```bash
cd workspace/tp01
mkdir -p PA1
make -C PA1 -f /var/tmp/cool/assignments/PA1/Makefile
cp stack.cl PA1/
cd PA1
```

### 3. Compilar, Executar e Testar programa

```bash
/var/tmp/cool/bin/coolc stack.cl atoi.cl  # compilar
/var/tmp/cool/bin/spim -file stack.s      # executar
make test                                 # testar de forma automática
```

### 4. Respostas das perguntas do PA1/README

**1. Describe your implementation of the stack machine in a single short paragraph.**

A implementação utiliza duas classes auxiliares: `Node`, que representa um nó da pilha encadeada armazenando uma `String` e uma referência ao próximo nó, e `Stack`, que encapsula a pilha e fornece operações de `push`, `pop`, `peek`, `isEmpty` e `toString`. A classe `Main` lê comandos em loop: qualquer string é empilhada diretamente, `d` exibe o conteúdo da pilha, `e` avalia o topo — somando dois inteiros se o topo for `+`, trocando os dois elementos seguintes se for `s`, e não fazendo nada caso contrário — e `x` encerra o programa.

**2. List 3 things that you like about the Cool programming language.**

1. A tipagem estática garante segurança em tempo de compilação sem precisar de anotações excessivas.
2. O modelo de orientação a objetos é simples e direto, com herança single e dispatch dinâmico funcionando de forma previsível.
3. O gerenciamento automático de memória (garbage collection) elimina a necessidade de desalocação manual, simplificando a implementação.

**3. List 3 things you DON'T like about Cool.**

1. Todo `if` precisa de um `else` obrigatoriamente, mesmo que o `else` não faça nada.
2. O uso do `in` para delimitar blocos de código é estranho e confuso.
3. Não existe um literal `null`/`void`, o que torna difícil inicializar explicitamente referências vazias e força o uso de `isvoid` para qualquer verificação de nulidade.

### 5. Entrega do artefato

```bash
cd ..
tar cvzf PA1.tar.gz PA1
uuencode PA1.tar.gz PA1.tar.gz > PA1.u
rm PA1.tar.gz
```