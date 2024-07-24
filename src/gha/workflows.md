# Workflows

Para definirmos o que é um workflow, podemos buscar a definição da própria documentação:

> Um fluxo de trabalho é um processo automatizado configurável que executa um ou mais trabalhos. Os fluxos de trabalho são definidos por um arquivo YAML verificado no seu repositório e será executado quando acionado por um evento no repositório, ou eles podem ser acionados manualmente ou de acordo com um cronograma definido.

Ou seja, são automações definidas via `yaml` que são configuradas de acordo com cada necessidade.

Um workflow é composto por **pelo menos** um gatilho e **pelo menos** um job.

Vamos dar uma olhada num workflow simples.

```yaml
name: workshop
on: [push]
jobs:
  hello-world:
    runs-on: ubuntu-latest
    steps:
      run: echo "Hello World"
```

Neste workflow, definimos:
- `name`: nome do workflow
- `on`: gatilho que acionará a automação
- `jobs`: uma lista de um ou mais processos
- `hello-world`: o nome do nosso job
- `runs-on`: definimos o runner
- `steps`: as etapas que compõem o nosso job

Apesar de simples, já tem bastante coisa envolvida.

Nessa parte, vamos nos aprofundar um pouco mais em cada um desses atributos.
