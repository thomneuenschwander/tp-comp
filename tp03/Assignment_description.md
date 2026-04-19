# Anunciado da Atividade

- [Documento da Atividade](03-tp-analise-sintatica.pdf)
- [Documento de Configuração](../00-configuracoes-iniciais.pdf)

**Vencimento:** 19/04/2026, Domingo, às 23:59
**Pontos:** 5 
**Envio:** Upload de arquivo  
**Disponível:** 08/02/2026, Segunda-feira, às 00:00 → 19/04/2026, Domingo, às 23:59

## Descrição

Esta etapa do **Trabalho Prático**, em grupo de até **5 pessoas**, consiste na **implementação de um parser para a linguagem Cool**. A saída do parser deve ser uma Árvore de Sintaxe Abstrata (AST — *Abstract Syntax Tree*), construída por meio de ações semânticas especificadas junto ao gerador de parser **Java CUP**.

## Requisitos Obrigatórios da Entrega

### 1. Funcionamento do código

O parser implementado deve:

- **Compilar corretamente**
- **Executar corretamente**
- Gerar uma **AST válida** para programas sintaticamente corretos
- Realizar **recuperação de erros** nas seguintes situações:
  - Erro em definição de classe → reinicia na próxima classe
  - Erro em *feature* (atributo/método) → passa para a próxima feature
  - Erro em binding de `let` → passa para a próxima variável
  - Erro em expressão dentro de bloco `{...}` → continua após o `}`

### 2. Arquivos de teste

- `good.cl` — testa **todas as construções legais** da gramática Cool
- `bad.cl` — testa o **maior número possível de erros sintáticos** em um único arquivo

### 3. Arquivo README

Deve conter explicações de decisões de design, casos de teste e justificativas.

### 4. Política de integridade

- **Cópias de trabalhos anteriores** → nota zero
- **Uso exclusivo de IA** → nota zero