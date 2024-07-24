# Automatizando etapas do PR

Nessa etapa, o objetivo é desenvolver um workflow que será executado para automatizar os testes de um PR. Dessa forma, conseguimos reduzir o ruído na hora da revisão do código. Afinal, não faz muito sentido revisar um PR em que os testes estão quebrados.


## Criação do primeiro workflow

Para criar um workflow, precisamos de um arquivo em `.github/workflows/`.

O primeiro passo vai ser definir quais são os gatilhos para o nosso workflow.

Queremos que a checagem sempre seja executada quando um PR é criado.

> Podemos especificar, por exemplo, que só execute os testes nos PRs que tenham como alvo uma branch com determinado nome combinando `pull_request` o atributo e `branches`. Mas esse não é o nosso caso!

```yaml
name: PR Checker
on:
  pull_request:
```

Isso é suficiente? Sim, mas podemos ser ainda mais específicos.

Faz sentido executar testes em PRs que alteram apenas arquivos de documentação? Se eu fiz uma alteração no `README.md`, tem motivo executarmos testes. Especificamos isso utilizando `paths`.

```yaml
name: PR Checker
on:
  pull_request:
    paths:
      - '**.js'
```

### Checkout

O próximo passo é garantir que o runner tem acesso ao repositório.

```yaml
name: PR Checker
on:
  pull_request:
    paths:
      - '**.js'

jobs:
  run-tests:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repo
        uses: actions/checkout@v4
```


### Configuração do Node

Agora que temos acesso ao repositório, precisamos garantir que temos o `node` instalado.

```yaml
name: PR Checker
on:
  pull_request:
    paths:
      - '**.js'

jobs:
  run-tests:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repo
        uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 22.x
```

### Execução dos testes

Para execução dos testes, precisamos instalar as dependências e executar o script.

```yaml
name: PR Checker
on:
  pull_request:
    paths:
      - '**.js'

jobs:
  run-tests:
    runs-on: ubuntu-latest
    steps:
      - name: Prepare | Checkout repo
        uses: actions/checkout@v4
      - name: Prepare | Setup node
        uses: actions/setup-node@v4
        with:
          node-version: 22.x
      - name: Prepare | Install dependencies
        run: npm i
      - name: Run tests
        run: npm run test
```

### Cache

O workflow está pronto e funcional! Porém, podemos fazer uma otimização boa nele.
Ao invés de baixar todas as dependências sempre que executar, que tal criarmos um cache das dependências e, caso nenhuma delas tenha sido atualizadas, utilizar o que deixamos nele?

Para isso, utilizaremos a [`actions/cache`](https://github.com/actions/cache).

```yaml
name: PR Checker
on:
  pull_request:
    paths:
      - '**.js'

jobs:
  run-tests:
    runs-on: ubuntu-latest
    steps:
      - name: Prepare | Checkout repo
        uses: actions/checkout@v4
      - name: Prepare | Setup node
        uses: actions/setup-node@v4
        with:
          node-version: 22.x

      - name: Prepare | Get npm cache directory
        id: npm-cache
        run: echo "dir=$(npm config get cache)" >> $GITHUB_OUTPUT

      - name: Prepare | Cache dependencies
        id: cache
        uses: actions/cache@v4
        with:
          path: ${{ steps.npm-cache.outputs.dir }}
          key: ${{ runner.os }}-node-${{ hashFiles('package-lock.json') }}
          restore-keys: |
            ${{ runner.os }}-node-

      - name: Prepare | Install dependencies
        if: steps.cache.outputs.cache-hit != 'true'
        run: npm i

      - name: Run tests
        run: npm run test
```

Adicionamos a `actions/cache` definindo os seguintes parâmetros:
- `path`: diretório que deve ser armazenado no cache
- `key`: um identificador para o cache. Neste caso utilizamos uma concatenação do sistema e uma hash do `package-lock.json`. Toda vez que houver uma alteração no sistema utilizado ou no arquivo de dependências, ele utilizará outro cache.
  > A expressão `hashFiles` e outras estão documentadas [aqui](https://docs.github.com/pt/actions/learn-github-actions/expressions).
- `restore-keys`: conjunto de padrões do cache. Caso não tenha um match exato, ele vai tentar restaurar o cache mais próximo.
  > Importante: a instalação de dependências só deixa de acontecer se houver um match **exato** da chave!
  >
  > Se não encontrar, ainda vai executar a instalação das dependências. Mas ainda assim, espera-se que seja num tempo menor, pois atualizaria apenas o necessário.

Perceba também que adicionamos uma [condicional](https://docs.github.com/pt/actions/using-jobs/using-conditions-to-control-job-execution) na etapa de instalação de dependências: só execute a instalação das dependências caso o cache não tenha encontrado  uma

### Múltiplas versões em diferentes arquiteturas

Você já reparou que em alguns projetos estão disponíveis várias versões de um executável? Você precisa decidir qual plataforma vai usar, qual sistema, etc.

Imagina ter que repetir o tamanho do workflow pra dar suporte pra isso!!


Mas calma, será que realmente precisamos fazer essa duplicação? Existe alguma solução para permitir suporte para todas as combinações de forma simples?

Se nossa biblioteca tivesse suporte para outras versões do Node e outros sistemas, poderíamos executar a nossa ação em cada uma das versões através das matrizes.

```yaml
name: PR Checker
on:
  pull_request:
    paths:
      - '**.js'

jobs:
  run-tests:
    strategy:
      matrix:
        os: [ubuntu-latest, macos-latest]
        node: [18, 20, 22]
    runs-on: ${{ matrix.os }}
    steps:
      - name: Prepare | Checkout repo
        uses: actions/checkout@v4
      - name: Prepare | Setup node ${{ matrix.node }}
        uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node }}.x

      - name: Prepare | Get npm cache directory
        id: npm-cache
        run: echo "dir=$(npm config get cache)" >> $GITHUB_OUTPUT

      - name: Prepare | Cache dependencies
        id: cache
        uses: actions/cache@v4
        with:
          path: ${{ steps.npm-cache.outputs.dir }}
          key: ${{ runner.os }}-node-${{ matrix.node }}-${{ hashFiles('package-lock.json') }}
          restore-keys: |
            ${{ runner.os }}-node-${{ matrix.node }}

      - name: Prepare | Install dependencies
        if: steps.cache.outputs.cache-hit != 'true'
        run: npm i

      - name: Run tests
        run: npm run test
```

> Atenção: caso você precise dar suporte a mais de uma arquitetura de processadores, é preciso também se atentar para o cache, sendo necessário mudar a chave para garantir compatibilidade do sistema.

Assim como na etapa anterior, se houver uma etapa específica de uma plataforma ou versão, você pode utilizar uma condicional para ignorá-la ou não.

## Finalizando

Agora vamos para a publicação!!
