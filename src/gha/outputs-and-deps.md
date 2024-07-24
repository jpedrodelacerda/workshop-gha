# Saídas (outputs) e dependências

Às vezes precisamos passar informações de uma etapa para outra e até de um job para outro. Para resolver esse problema, podemos utilizar as saídas (outputs).

É importante notar que os outputs são apenas strings e ficam armazenados em um arquivo de saída do workflow.
O caminho deste arquivo está disponível através da variável `GITHUB_OUTPUT` e este arquivo é compartilhado por todos os etapas de um job.

Para definir uma saída de um job, basta usar o atributo `outputs`. Para acessar, utilizamos o `steps.<nome da etapa>.outputs.<nome da saída>` ou `needs.<nome do job>.outputs.<nome da saída>`.


```yaml
name: Job com uma saída
# ...

jobs:
  job1:
    runs-on: ubuntu-latest
    outputs:
      olamundo: ${{ steps.etapa1.outputs.ola }}
    steps:
      - id: etapa1
        run: echo 'ola=mundo' >> $GITHUB_OUTPUT
  job2:
    runs-on: ubuntu-latest
    needs: job1
    steps:
      - env:
           SAIDA1: ${{ needs.job1.outputs.ola }}
        run: echo "Olá $SAIDA1"
```

Observe que na linha `needs: job1` definimos que o `job2` só será executado após uma execução bem sucedida do `job1`. Caso essa dependência não fosse definida, o `job2` seria executado de forma paralela ao `job1` e o comportamento do nosso workflow poderia não ser o desejado.

Perceba que na definição do output, utilizamos a keyword `run` para executar um comando dentro do runner. Para quem não é muito chegado no `bash`, utilizamos um print com o comando `echo` e redirecionamos a saída para o arquivo presente em `$GITHUB_OUTPUT`.


## Alguns casos de uso

### Gerar tag do projeto utilizando a versão do `package.json`

```yaml
# ...
    steps:
    # ... Checkout e configuração de credenciais do git
      - name: Atualiza versão
        run: npm version minor
      - name: Versão do projeto
        id: version
        run: echo version=$(npm pkg get version | sed 's/"//g') >> $GITHUB_OUTPUT
      - name: Cria tag com a nova versão
        env:
          VERSION= ${{ steps.version.outputs.version }}
        run: |
          git tag -a "v$VERSION"
          git push --tags
```

## Referências

1. Documentação oficial: [Definindo saídas para trabalhos](https://docs.github.com/pt/actions/using-jobs/defining-outputs-for-jobs)
