# Gatilhos

## Como os workflows são acionados

Os gatilhos são definidos sempre no atributo `on` dos workflows.
Existem diversos métodos para acionarmos os workflows, mas os principais são:
- `workflow_dispatch`: acionamento manual. É possível definirmos entradas para parametrização da execução
- `workflow_call`: acionado via outro workflow. Também é possível definirmos entradas.
- `schedule`: acionado em um determinado padrão de horário.
- `push`: acionado sempre que acontecer um **push**.
  > Se quiser ignorar algum gatilho via push/pr, basta utilizar um `[skip ci]` na mensagem de um commit.
- `pull_request`: acionado sempre que um **pull request** for criado, fechado, etc. Podemos especificar coisas como:
  - `branches`/`branches-ignore`: acionar apenas quando acontecer em uma determinada branch ou evitar a execução nela. No caso dos pull requests é verificada a branch alvo do PR.
  - `paths`/`paths-ignore`: acionar apenas quando acontecer alteração em um caminho ou ignorar se algum arquivo for alterado. Um bom uso para ignorar caminhos é evitar deploys de arquivos que não são parte do código fonte, por exemplo, o `README.md` de um projeto.

  > O uso do `paths`/`paths-ignore` é mutuamente exclusivo. Para ignorar um caminho ao usar o `paths`, basta utilizar o prefixo de negação `!`.
  >
  > A inclusão de um caminho depois de uma exclusão, adiciona o caminho novamente. Ou seja, a preferência é sempre decrescente.

## Exemplos

### Acionamento manual
```yaml
name: Aciona aqui
on: workflow_dispatch
# ...
```


### `cronjob`
```yaml
name: Roda todos os dias às 07h (UTC)
on:
  schedule:
    - cron: '0 7 * * *'
# ...
```

### Deploy com push na `main`
```yaml
name: Deploy da main
on:
  push:
    branches:
      - 'main'
# ...
```

### Deploy apenas com alterações em código na `main`
```yaml
name: Deploy na main com alteração de código
on:
  push:
    branches: [main]
    paths:
      - "src/**.js"
# ...
```


## Referências

1. Documentação oficial: [Eventos que disparam fluxos de trabalho](https://docs.github.com/pt/actions/using-workflows/events-that-trigger-workflows)
2. Documentação oficial: [Ignorar execuções de fluxo de trabalho](https://docs.github.com/pt/actions/managing-workflow-runs/skipping-workflow-runs)
