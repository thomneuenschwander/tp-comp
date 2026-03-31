# Trabalho Prático 02 — Análise Léxica

- [Documento da Atividade](02-tp-analise-lexica.pdf)
- [Documento de Configuração](00-configuracoes-iniciais.pdf)

## Anunciado da Atividade

**Vencimento:** 15/03/2026, Domingo, às 23:59  
**Pontos:** 5 
**Envio:** Upload de arquivo  
**Disponível:** 08/02/2026, Segunda-feira, às 00:00 → 15/03/2026, Domingo, às 23:59

### Descrição

Esta etapa do **Trabalho Prático**, em grupo de até **4 pessoas**, consiste na **aplicação prática da teoria de construção de um Analisador Léxico**. O conteúdo detalhado do trabalho está disponível no arquivo [`02-tp-analise-lexica.pdf`](02-tp-analise-lexica.pdf). Como **pré-requisito**, é importante já ter realizado a configuração inicial descrita em [`00-configuracoes-iniciais.pdf`](00-configuracoes-iniciais.pdf).

### Requisitos Obrigatórios da Entrega
*(se não atendidos, a pontuação será zerada)*

#### 1. Funcionamento do código

O código implementado deve:

- **Compilar corretamente**
- **Executar corretamente**
- **Compilar todos os elementos da linguagem**

O produto criado deve funcionar com **diversos testes feitos com códigos corretos escritos em Cool**.

#### 2. Arquivo README

O arquivo `README` deve ser preenchido **em português ou inglês** e deve conter:

- Análises **verdadeiras e completas** do uso da linguagem
- Explicações detalhadas das implementações
- Descrição das **escolhas e decisões tomadas** em relação às regras ou gramáticas
- Explicação dos **testes realizados**
- Justificativa de **por que os testes cobrem o que foi implementado**
- **Dificuldades encontradas**
- **Soluções adotadas**

> O **README possui peso alto na avaliação do trabalho**.

#### 3. Arquivos de teste

Arquivos de teste são **obrigatórios**.

Não é suficiente apenas um código simples como `hello world`.

É necessário incluir:

- Uma **bateria de testes relevantes**
- **Códigos variados escritos em Cool**

Além disso:

- O que cada teste verifica deve estar **documentado no README**.

#### 4. Política de integridade

- **Cópias de trabalhos de semestres anteriores** resultarão em **nota zero**.
- **Indícios de uso exclusivo de IA** para realização do trabalho também resultarão em **nota zero**.

#### 5. Avaliação

- O trabalho é realizado **em grupo**.
- A **avaliação é individual**.

Pode haver **ajuste individual de nota**, com base em **questões específicas na prova escrita**.

### Materiais e manuais

O enunciado menciona alguns manuais importantes:

- [Manual do **Flex**](https://pucminas.instructure.com/courses/264310/files/16129953/download?download_frd=1)
- [Manual do **Bison**](https://pucminas.instructure.com/courses/264310/files/16129968/download?download_frd=1)
- [Manual do **JLex**](https://www.cs.princeton.edu/~appel/modern/java/JLex/current/manual.html)
- [Manual do **Java CUP**](http://www2.cs.tum.edu/projects/cup/manual.html)
- [Manual do **SPIM (Simulador MIPS)**](https://pucminas.instructure.com/courses/264310/files/16129974/download?download_frd=1)

## Formato JLex

O JLex é um gerador de analisadores léxicos para Java. Ele gera um arquivo Java que implementa um analisador léxico para a linguagem Cool. Pode-se dividir o arquivo em 3 partes, separadas por `%%`:

```text
PARTE 1: código do usuário
%%
PARTE 2: diretivas
%%
PARTE 3: regras
```
### 1. Código do usuário

Todo o código escrito nesta área é copiado de forma exata (verbatim) para o topo do arquivo fonte Java (.java) que o JLex vai gerar. Serve para você declarar o package ou fazer imports de classes externas e bibliotecas (como `import java_cup.runtime.Symbol;`)

### 2. Diretivas

É usada para configurar parâmetros do analisador léxico, declarar variáveis e preparar macros. Nessa seção pode-se colocar:

- **Definições de Macros**: Atribuição de nomes a expressões regulares repetitivas (ex: `DIGIT = [0-9]`)
- **Declaração de Estados**: Criação de estados léxicos personalizados (ex: `%state COMMENT`)
- **Diretivas de Configuração**: Comandos como `%cup` (para compatibilidade com o parser Java CUP), `%class CoolLexer` (para nomear a classe gerada), entre outros.
- **Injeção de Código Interno**: Blocos delimitados por `%{ ... %}` para declarar variáveis globais da classe, ou `%init{ ... %init}` para colocar código dentro do construtor do analisador.

### 3. Regras léxicas

O formato de regras léxicas do JLex é: `<ESTADO>PADRÃO { AÇÃO }`. 

> "Quando estiver no estado X, identifique o padrão Y e execute a ação Z"

#### Estados léxicos

São um mecanismo poderoso usado para controlar quando determinadas ERs devem ser avaliadas/ativadas.    

##### `YYINITIAL`

Estado default. O analisador léxico inicia a execução de forma padrão sempre neste estado e é nele que a maioria das regras gerais do programa Cool (como palavras-chave, inteiros, identificadores e símbolos) deverão funcionar.

##### Criar novos estados

Para criar estados, deve declará-los na seção de diretivas do JLex (a segunda parte do arquivo, antes das regras léxicas) usando o comando `%state`. Por exemplo:

- `%state COMMENT` 
- `%state STRING` 

Internamente, o JLex transforma essas declarações em números inteiros constantes na sua classe analisadora. Por isso, é uma boa convenção escrevê-los em letras maiúsculas.

##### Alterar estado

Você controla a mudança de um estado para o outro chamando a função Java `yybegin(ESTADO);` dentro das ações atreladas às suas regras. O lexer continuará no estado novo até que você faça outra transição explícita. Exemplo: Processar comentários de múltiplas linhas.

1. `<YYINITIAL>(* { yybegin(COMMENT); })`. Detectou `(*` alterou para o estado de comentário.
2. Agora o lexer só irá avaliar ERs que são do estado `<COMMENT>`. Tudo o que for texto de código normal será ignorado e não vai gerar erro.
3. `<COMMENT>*) { yybegin(YYINITIAL); })`. Detectou `*)` voltou para o estado inicial.

#### Expressão Regular

#### Ação

É o bloco de código java que será executado imiediatamente após a identificação da ER. No scanner, o principal objetivo é **retornar um token identificado** ou então alterar o [estado](#estados-léxicos). Dessa forma, se não for mudar de estado ou não tomar nenhuma ação, o lexer deve retornar o token identificado.

##### Token simples 

Tokens podem não requerer ter atributo (valor semântico), como keywords e operators.

**Exemplo**: ação para `class` é `return new Symbol(TokenConstants.CLASS);`

##### Token com atributo 

Tokens podem requerer ter atributo (o valor semântico, carregar o valor real do texto que foi lido), como integers, strings e operators. É preciso inserir os simbolos nas hash tables fornecidas pelo código de suporte. Existem três tabelas separadas para isso: `AbstractTable.inttable` para integers, `AbstractTable.stringtable` para textos (strings literais) e `AbstractTable.idtable` para identificadores de variáveis, tipos e classes.

**Exemplo**:  `return new Symbol(TokenConstants.INT_CONST, AbstractTable.inttable.addString(yytext()));`, sendo a função `yytext()` que retorna o lexema.

Para **booleans** (true ou false) retorna-se `return new Symbol(TokenConstants.BOOL_CONST, Boolean.TRUE);`

## Cool Tokens

Abaixo, segue os tokens que o scanner deve reconhecer e retornar

### 1. Keywords
Em Cool, palavras-chave (exceto `true` e `false`) são *case-insensitive* (não diferenciam maiúsculas de minúsculas).
*   **`CLASS`**: Keywords `class`.
*   **`ELSE`**: Keywords `else`.
*   **`FI`**: Keywords `fi` (fecha o bloco if).
*   **`IF`**: Keywords `if`.
*   **`IN`**: Keywords `in` (usada junto com `let`).
*   **`INHERITS`**: Keywords `inherits` (herança de classes).
*   **`ISVOID`**: Keywords `isvoid` (verifica se algo é nulo).
*   **`LET`**: Keywords `let` (declaração de variáveis locais).
*   **`LOOP`**: Keywords `loop` (início do corpo do while).
*   **`POOL`**: Keywords `pool` (fecha o bloco loop).
*   **`THEN`**: Keywords `then`.
*   **`WHILE`**: Keywords `while`.
*   **`CASE`**: Keywords `case`.
*   **`ESAC`**: Keywords `esac` (fecha o bloco case).
*   **`OF`**: Keywords `of` (usada no case).
*   **`NEW`**: Keywords `new` (instanciação de objetos).
*   **`NOT`**: Keywords `not` (negação booleana).

### 2. Símbolos e Operadores (Symbols & Operators)
Correspondem à pontuação e aos operadores matemáticos/lógicos da linguagem:
*   **`MULT`**: Operador de multiplicação `*`.
*   **`DIV`**: Operador de divisão `/`.
*   **`PLUS`**: Operador de adição `+`.
*   **`MINUS`**: Operador de subtração `-`.
*   **`NEG`**: Operador de complemento/negação inteira `~`.
*   **`LT`**: Operador "menor que" `<`.
*   **`LE`**: Operador "menor ou igual" `<=`.
*   **`EQ`**: Operador lógico de igualdade `=`.
*   **`ASSIGN`**: Operador de atribuição `<-`.
*   **`DARROW`**: Seta dupla `=>` (usada nas ramificações do `case`).
*   **`LPAREN`**: Parêntese esquerdo `(`.
*   **`RPAREN`**: Parêntese direito `)`.
*   **`LBRACE`**: Chave esquerda `{`.
*   **`RBRACE`**: Chave direita `}`.
*   **`SEMI`**: Ponto e vírgula `;`.
*   **`COLON`**: Dois pontos `:` (usado em declarações de tipo).
*   **`COMMA`**: Vírgula `,`.
*   **`DOT`**: Ponto `.` (usado para despacho de métodos, ex: `obj.metodo()`).
*   **`AT`**: Arroba `@` (usado no despacho estático de métodos, ex: `obj@Classe.metodo()`).

### 3. Identificadores e Constantes (Identifiers & Constants)
Estes tokens obrigatoriamente precisam de um **valor semântico** atrelado a eles quando retornados:
*   **`TYPEID`**: Identificador de Tipo (Classes). Deve sempre começar com uma letra **maiúscula** (ex: `Int`, `String`, `Main`). O valor semântico vai para a tabela `idtable`.
*   **`OBJECTID`**: Identificador de Objeto (Nomes de variáveis ou métodos). Deve sempre começar com uma letra **minúscula** (ex: `x`, `myVar`, `self`). O valor semântico vai para a tabela `idtable`.
*   **`INT_CONST`**: Constante inteira (sequência de dígitos). O valor semântico vai para a tabela `inttable`.
*   **`STR_CONST`**: Constante de string (texto entre aspas). O valor semântico vai para a tabela `stringtable`.
*   **`BOOL_CONST`**: Constante booleana (`true` ou `false`). A primeira letra obrigatoriamente é minúscula, o resto é case-insensitive. O valor semântico é do tipo nativo `java.lang.Boolean`.

### 4. Tokens Especiais (Special Tokens)
Estes são fundamentais para o controle do compilador e tratamento de erros:
*   **`EOF`**: Fim do arquivo (*End Of File*). Informa que não há mais texto para ser lido.
*   **`ERROR`** (tudo maiúsculo): É o token que o seu analisador léxico deve retornar **sempre que encontrar um erro léxico** (como string não terminada, caractere inválido, etc.). Você deve passar a mensagem de erro como valor semântico (do tipo `String` do Java) para este token.
*   **`error`** (tudo minúsculo): **Você deve ignorar este token no seu analisador léxico.** Ele é um recurso interno usado apenas pelo parser (analisador sintático) na fase seguinte do compilador (TP03) para fazer recuperação de erros sintáticos.
*   **`LET_STMT`**: **Você deve ignorar este token.** O manual estabelece explicitamente que o scanner não deve gerá-lo, pois ele é exclusivo para o uso do parser sintático nas próximas etapas do projeto.

## Artefato Produzido

Abaixo, segue a implementação do trabalho.

### cool.lex
Este são os trechos do cool.lex que foram implementados:

#### States e Macros

```text
%state STRING
%state COMMENT

DIGIT      = [0-9]
ALPHANUM   = [a-zA-Z0-9_]
NEWLINE    = \n
WHITESPACE = [\ \t\f\r]
```

##### Keywords case-insensitive

```text
IF         = [Ii][Ff]
FI         = [Ff][Ii]
THEN       = [Tt][Hh][Ee][Nn]
ELSE       = [Ee][Ll][Ss][Ee]
IN         = [Ii][Nn]
ISVOID     = [Ii][Ss][Vv][Oo][Ii][Dd]
LET        = [Ll][Ee][Tt]
LOOP       = [Ll][Oo][Oo][Pp]
POOL       = [Pp][Oo][Oo][Ll]
WHILE      = [Ww][Hh][Ii][Ll][Ee]
CASE       = [Cc][Aa][Ss][Ee]
ESAC       = [Ee][Ss][Aa][Cc]
OF         = [Oo][Ff]
CLASS      = [Cc][Ll][Aa][Ss][Ss]
INHERITS   = [Ii][Nn][Hh][Ee][Rr][Ii][Tt][Ss]
NEW        = [Nn][Ee][Ww]
NOT        = [Nn][Oo][Tt]
```

#### Regras e Ações
```text
{NEWLINE}           # incrementar o contador de linha
{WHITESPACE}+       # ignorar
{DIGIT}+            # retornar INT_CONST token e armazenar literal

```

##### Keywords

```text
<YYINITIAL>{IF}        { return new Symbol(TokenConstants.IF); }
<YYINITIAL>{FI}        { return new Symbol(TokenConstants.FI); }
<YYINITIAL>{THEN}      { return new Symbol(TokenConstants.THEN); }
<YYINITIAL>{ELSE}      { return new Symbol(TokenConstants.ELSE); }
<YYINITIAL>{IN}        { return new Symbol(TokenConstants.IN); }
<YYINITIAL>{ISVOID}    { return new Symbol(TokenConstants.ISVOID); }
<YYINITIAL>{LET}       { return new Symbol(TokenConstants.LET); }
<YYINITIAL>{LOOP}      { return new Symbol(TokenConstants.LOOP); }
<YYINITIAL>{POOL}      { return new Symbol(TokenConstants.POOL); }
<YYINITIAL>{WHILE}     { return new Symbol(TokenConstants.WHILE); }
<YYINITIAL>{CASE}      { return new Symbol(TokenConstants.CASE); }
<YYINITIAL>{ESAC}      { return new Symbol(TokenConstants.ESAC); }
<YYINITIAL>{OF}        { return new Symbol(TokenConstants.OF); }
<YYINITIAL>{CLASS}     { return new Symbol(TokenConstants.CLASS); }
<YYINITIAL>{INHERITS}  { return new Symbol(TokenConstants.INHERITS); }
<YYINITIAL>{NEW}       { return new Symbol(TokenConstants.NEW); }
<YYINITIAL>{NOT}       { return new Symbol(TokenConstants.NOT); }
```

##### Symbols & Operators

```text
<YYINITIAL>"*"        { return new Symbol(TokenConstants.MULT); }
<YYINITIAL>"/"        { return new Symbol(TokenConstants.DIV); }
<YYINITIAL>"+"        { return new Symbol(TokenConstants.PLUS); }
<YYINITIAL>"-"        { return new Symbol(TokenConstants.MINUS); }
<YYINITIAL>"~"        { return new Symbol(TokenConstants.NEG); }
<YYINITIAL>"<"        { return new Symbol(TokenConstants.LT); }
<YYINITIAL>"<="       { return new Symbol(TokenConstants.LE); }
<YYINITIAL>"="        { return new Symbol(TokenConstants.EQ); }
<YYINITIAL>"<-"       { return new Symbol(TokenConstants.ASSIGN); }
<YYINITIAL>"=>"       { return new Symbol(TokenConstants.DARROW); }
<YYINITIAL>"("        { return new Symbol(TokenConstants.LPAREN); }
<YYINITIAL>")"        { return new Symbol(TokenConstants.RPAREN); }
<YYINITIAL>"{"        { return new Symbol(TokenConstants.LBRACE); }
<YYINITIAL>"}"        { return new Symbol(TokenConstants.RBRACE); }
<YYINITIAL>";"        { return new Symbol(TokenConstants.SEMI); }
<YYINITIAL>":"        { return new Symbol(TokenConstants.COLON); }
<YYINITIAL>","        { return new Symbol(TokenConstants.COMMA); }
<YYINITIAL>"."        { return new Symbol(TokenConstants.DOT); }
<YYINITIAL>"@"        { return new Symbol(TokenConstants.AT); }
```

##### Identifiers & Constants
```
<YYINITIAL>{OBJECTID}       { return new Symbol(TokenConstants.OBJECTID, AbstractTable.idtable.addString(yytext())); }
<YYINITIAL>{TYPEID}         { return new Symbol(TokenConstants.TYPEID, AbstractTable.idtable.addString(yytext())); }

<YYINITIAL>{DIGIT}+         { return new Symbol(TokenConstants.INT_CONST, AbstractTable.inttable.addString(yytext())); }
<YYINITIAL>{BOOLEAN}        { return new Symbol(TokenConstants.BOOL_CONST, yytext().charAt(0) == 't' ? Boolean.TRUE : Boolean.FALSE); }

<YYINITIAL>"--"[^\n]* { /* comentário de linha, ignorar */ }
<YYINITIAL>"(*"       { comment_depth = 1; yybegin(COMMENT); }
<YYINITIAL>"*)"       { return new Symbol(TokenConstants.ERROR, "Unmatched *)"); }

<COMMENT>"(*"         { comment_depth++; }
<COMMENT>"*)"         { if (--comment_depth == 0) yybegin(YYINITIAL); }
<COMMENT>{NEWLINE}     { curr_lineno++; }
<COMMENT>.            { /* ignorar */ }

<YYINITIAL>"\""       { string_buf.setLength(0); string_too_long = false; yybegin(STRING); }


<STRING>\"              { yybegin(YYINITIAL);
                         if (string_too_long) 
                           return new Symbol(TokenConstants.ERROR, "String constant too long");
                        return new Symbol(TokenConstants.STR_CONST, AbstractTable.stringtable.addString(string_buf.toString())); }

<STRING>\n              { curr_lineno++; yybegin(YYINITIAL); return new Symbol(TokenConstants.ERROR, "Unterminated string constant"); }
<STRING>\\\n            { curr_lineno++; if (!string_too_long) string_buf.append('\n'); }
<STRING>\\n             { if (!string_too_long) string_buf.append('\n'); }
<STRING>\\t             { if (!string_too_long) string_buf.append('\t'); }
<STRING>\\b             { if (!string_too_long) string_buf.append('\b'); }
<STRING>\\f             { if (!string_too_long) string_buf.append('\f'); }
<STRING>\\\"            { if (!string_too_long) string_buf.append('"'); }
<STRING>\\\\            { if (!string_too_long) string_buf.append('\\'); }
<STRING>\\[^\n]         { if (!string_too_long) string_buf.append(yytext().charAt(1)); }
<STRING>\000            { return new Symbol(TokenConstants.ERROR, "String contains null character"); }
<STRING>[^\"\n\\\000]+  { if (string_buf.length() + yytext().length() > MAX_STR_CONST - 1) {
                              string_too_long = true;
                          } else if (!string_too_long) {
                              string_buf.append(yytext());
                          } }

.                       { return new Symbol(TokenConstants.ERROR, yytext()); }
```

### Execução do Projeto

Siga os passos abaixo para executar o projeto:

#### 1. Criação do ambiente

> Execute os comandos abaixo a partir da **raiz do repositório** (onde está o `Dockerfile`).

```bash
docker build -t tp-comp . # buildar a imagem (se necessário)
docker run -it -v $(pwd):/root/workspace tp-comp # entrar no container
```

#### 2. Preparação do PA2

```bash
cd workspace/tp02
make -C PA2 -f /var/tmp/cool/assignments/PA2J/Makefile
cd PA2
```

#### 3. Compilar, Executar e Testar programa

```bash
# 1. Compila o cool.lex → CoolLexer.java → lexer
make lexer

# 2. Testa no test.cl (arquivo de teste padrão do PA2)
make dotest

# 3. Ou teste em um arquivo qualquer
echo "42 => 0" > /tmp/teste.cl
lexer /tmp/teste.cl
```