# Trabalho Prático 03 — Análise Sintática


## Execução do Projeto

### 1. Criação do ambiente

> Execute a partir da **raiz do repositório** (onde está o `Dockerfile`), no PowerShell do Windows:

```powershell
docker build -t tp-comp .                              # build da imagem (se necessário)
docker run -it -v ${PWD}:/root/workspace tp-comp       # entrar no container
```

> No Linux/Mac:

```bash
docker build -t tp-comp .
docker run -it -v $(pwd):/root/workspace tp-comp
```

### 2. Preparação do PA3

```bash
mkdir -p /root/workspace/tp03/PA3
cd /root/workspace/tp03/PA3
make -f /var/tmp/cool/assignments/PA3J/Makefile
```

### 3. Copiar arquivos do repositório para o PA3

```bash
cp /root/workspace/tp03/cool.cup /root/workspace/tp03/PA3/cool.cup
cp /root/workspace/tp03/good.cl  /root/workspace/tp03/PA3/good.cl
cp /root/workspace/tp03/bad.cl   /root/workspace/tp03/PA3/bad.cl
cp /root/workspace/tp03/README   /root/workspace/tp03/PA3/README
```

### 4. Compilar o parser

```bash
cd /root/workspace/tp03/PA3
make parser
```

### 5. Testar o parser

```bash
make dotest           # roda myparser em good.cl e bad.cl
```

### 6. Entrega do artefato

```bash
cd /root/workspace/tp03
make submit-clean -C PA3
tar cvzf PA3.tar.gz PA3
uuencode PA3.tar.gz PA3.tar.gz > PA3.u
rm PA3.tar.gz
```

Entregar o arquivo `PA3.u` via Canvas.

## Artefato Produzido

### cool.cup

O parser foi implementado em Java CUP, gerando uma AST a partir dos tokens produzidos pelo lexer do TP02.

#### Tipos da AST (`cool-tree.java`)

Os tipos abaixo são as classes Java usadas como tipos dos não-terminais no `cool.cup`. As classes abstratas agrupam as concretas:

| Tipo abstrato | Classes concretas | Representa |
|---|---|---|
| `Program` | `programc` | Raiz da AST — o programa inteiro |
| `Class_` | `class_c` | Definição de uma classe (nome, pai, features, arquivo) |
| `Classes` | — | Lista de `Class_` |
| `Feature` | `method`, `attr` | Membro de classe: método ou atributo |
| `Features` | — | Lista de `Feature` (corpo de uma classe) |
| `Formal` | `formalc` | Parâmetro formal de um método (`id : Type`) |
| `Formals` | — | Lista de `Formal` |
| `Expression` | `assign`, `dispatch`, `static_dispatch`, `cond`, `loop`, `block`, `let`, `typcase`, `new_`, `isvoid`, `plus`, `sub`, `mul`, `divide`, `neg`, `lt`, `leq`, `eq`, `comp`, `int_const`, `bool_const`, `string_const`, `object`, `no_expr` | Qualquer expressão executável da linguagem |
| `Expressions` | — | Lista de `Expression` (args de dispatch ou corpo de bloco) |
| `Case` | `branch` | Uma ramificação de um `case` (`id : Type => expr`) |
| `Cases` | — | Lista de `Case` |

#### Não-terminais definidos

| Não-terminal | Tipo | Descrição |
|---|---|---|
| `program` | `programc` | Raiz da gramática |
| `class_list` | `Classes` | Uma ou mais definições de classe |
| `class` | `class_c` | Definição de classe com ou sem `inherits` |
| `feat_list` | `Features` | Lista de features (pode ser vazia) |
| `feat` | `Feature` | Atributo ou método |
| `formal_list` | `Formals` | Lista de parâmetros (não vazia) |
| `formal` | `Formal` | Um parâmetro `id : Type` |
| `expr` | `Expression` | Qualquer expressão COOL |
| `args` | `Expressions` | Argumentos de chamada de método, separados por vírgula |
| `cmd_seq` | `Expressions` | Sequência de expressões dentro de `{ }`, separadas por `;` |
| `cases` | `Cases` | Branches de um `case/of/esac` |
| `case_branch` | `Case` | Um branch `id : Type => expr;` |
| `let_expr` | `Expression` | Bindings do `let`, desdobrados em `let`s aninhados |

### good.cl

O arquivo testa todas as construções legais da gramática COOL em três classes:

- **Classe `A`**: atributo sem inicializador (`x : Int`), atributos com inicializadores de tipos diferentes (`Int`, `Bool`, `String`), método sem parâmetros, método com um parâmetro, método com múltiplos parâmetros, bloco de expressões e assignment.
- **Classe `B inherits A`**: herança, atributo inicializado com `new`, dispatch dinâmico (`a.no_args()`), dispatch estático (`a@A.one_arg(1)`), self dispatch implícito (`one_arg(3)`), self dispatch explícito (`self.one_arg(2)`), `if/then/else/fi`, `while/loop/pool`, `let` com múltiplos bindings (com e sem inicializador), `case/of/esac` com múltiplos branches, `isvoid`, `not`, `=`, `~` (negação inteira), e os quatro operadores aritméticos com parênteses.
- **Classe `Main inherits IO`**: herança de classe built-in, chamada de `out_string`.

### bad.cl

O arquivo testa a recuperação de erros nos quatro pontos exigidos pela especificação:

| Erro | Linha | Descrição | Recuperação esperada |
|---|---|---|---|
| Erro de classe | 13 | `inherits parent` — `parent` é OBJECTID, não TYPEID | Parser pula e continua na próxima classe |
| Erro de feature | 19 | `broken_attr Int` — falta `:` entre nome e tipo | Parser pula a feature, continua com `good_attr` |
| Erro de feature | 23 | `broken_method(a : Int) { ... }` — falta `: Type` de retorno | Parser pula o método, continua com `good_method` |
| Erro de let | 33 | `bad_binding Int <- 1` — falta `:` no binding | Parser pula o binding, continua com `good` |
| Erro de bloco | 42–43 | `x <- ;` e `1 + ;` — expressões incompletas | Parser pula cada expr inválida, continua com `3;` |
| Erro de classe | 50 | `inherts` — palavra-chave `inherits` com typo | Parser pula a classe inteira |
| Válida | 55 | Classe `Recovered` — prova que o parser voltou ao trilho | AST gerada normalmente |

