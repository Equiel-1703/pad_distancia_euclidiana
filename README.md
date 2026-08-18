# Distância Euclidiana entre Vetores - Disciplina de PAD

Trabalho desenvolvido para a disciplina de PAD (Programação de Alto Desempenho) com o objetivo de calcular a distância euclidiana entre um vetor `q` e um conjunto de vetores `X` com `N` vetores, todos de dimensão `D`.

O valor de `D` é informado pelo usuário, enquanto `N` foi _hard-coded_ para 3,584 (explicação no relatório).

O projeto foi desenvolvido em Elixir utilizando a DSL PolyHok com backend em OpenCL, executando em paralelo na GPU.

## Como executar

1. Clone o repositório e entre na pasta do projeto:

   ```bash
   git clone https://github.com/Equiel-1703/pad_distancia_euclidiana.git
   cd pad_distancia_euclidiana
   ```

2. Baixe as dependências e compile o projeto:

   ```bash
   mix deps.get
   mix compile
   ```

3. Execute o script informando o valor de `D` (dimensão dos vetores):

   ```bash
   mix run scripts/calculate_distance.exs D
   ```

   Substitua `D` pelo valor desejado.

## Saída Verbosa

Se desejar, você pode ver os valores que foram calculados na GPU e os resultados esperados habilitando a saída verbosa. Para isso, execute o script com a flag `--verbose` ou `-v`.

Por exemplo:

```bash
mix run scripts/calculate_distance.exs 32 --verbose
```

O comando acima irá calcular a distância euclidiana para vetores de dimensão 32 e imprimir os valores calculados na GPU, bem como os resultados esperados.

## Licensa

Esse projeto está licenciado sob a Licença GNU General Public License v3.0.
