# Etapas / Steps

Nos capítulos anteriores vimos alguns exemplos de workflows mas passamos batido por um detalhe importante: apesar de sabermos que um job é composto por etapas, o que compõe uma etapa?

Podemos definir dois tipos de etapas:
- Comandos
- Ações (Actions)

## Comandos

Podemos indicar a execução de um comando através da palavra chave `run`. Como vimos em alguns exemplos anteriores, ao utilizar o `run`, interagimos diretamente com uma shell e podemos inclusive fazer uma cadeia de comandos.

```yaml
# ...
    steps:
      - name: Dá oi
        run: echo "Olá mundo!"
      - name: Pergunta se está tudo bem e se despede
        run: |
          echo "Tudo bem?"
          echo "Tchau!"
```

### Parâmetros

A melhor maneira de passarmos parâmetros para os comandos através das `envs`.

```yaml
# ...
    steps:
      - name: Imprime BAR
        env:
          FOO = "BAR"
        run: echo "$FOO"
```

## Actions

Para tarefas mais complexas, podemos utilizar `actions`. Elas são componentes que permitem a repetição de atividades e reduzem a complexidade do seu workflow.

Para invocarmos uma `action`, utilizamos a palavra chave `uses`.

### Versão

Imagina só esse cenário: na semana passada o seu time gerou uma release utilizando o pipeline. Quando chegou a sua vez de tirar a release você se depara com um erro. O mantenedor de uma das actions que você utiliza aproveitou pra trabalhar nela no tempo livre do fim de semana e acabou subindo uma alteração que quebrou a compatibilidade com o seu workflow.

> COMO ASSIM????

É. Isso pode acontecer.
Esse workshop é pra mostrar como o Github Actions é legal e útil, não que sua relação com ele vai ser perfeita e mil maravilhas.

Mas calma, tem uma maneira da gente se proteger desse tipo de problema. E não é uma surpresa pra ninguém que tenha passado pelo [Inferno de dependências](https://pt.wikipedia.org/wiki/Inferno_de_depend%C3%AAncias).

E se a gente especificar exatamente qual a versão da action estamos interessado no nosso workflow? Para fazer isso, basta passarmos uma referência via `@` depois do nome da action. Essa referência pode ser uma tag ou, caso o criador da action não tenha sua confiança, a chave `SHA` do commit para garantir mais [segurança](https://docs.github.com/pt/actions/security-guides/security-hardening-for-github-actions#using-third-party-actions).

```yaml
# ...
       uses: uma/actionmuitomaneira@<SHA/tag>
```

### Parâmetros

Para passarmos parâmetros para as actions, geralmente utilizamos a palavra chave `with`.

```yaml
# ...
    steps:
      - name: Clona o repositório e vai pra branch principal
        uses: actions/checkout@v4
        with:
          ref: main
```

## Actions úteis

Abaixo destaco algumas actions que acho interessantes.

1. [`actions/checkout`](https://github.com/actions/checkout): permite clonar o repositório e fazer o `checkout` em uma revisão específica.
2. [`actions/setup-node`](https://github.com/actions/setup-node): instala a versão especificada do `node`.
3. [`googleapis/release-please-action`](https://github.com/googleapis/release-please-action): Criação automática de releases utilizando Conventional Commits.
4. [`aws-actions/configure-aws-credentials`](https://github.com/aws-actions/configure-aws-credentials): configura uma credencial da AWS para utilização de serviços como `aws-cli` e outros.
5. [`SonarSource/sonarcloud-github-action`](https://github.com/SonarSource/sonarcloud-github-action): integração com o SonarQube.
6. [`softprops/action-gh-release`](https://github.com/softprops/action-gh-release): criação automática de release.
7. [`actions/cache`](https://github.com/actions/cache): permite o cache de artefatos para redução do tempo de execução do workflow
8. [`actions/upload-artifact`](https://github.com/actions/upload-artifact): realiza upload de arquivos como `CHANGELOG.md` ou arquivos de cobertura de testes do código.
9. [`actions/install-nix`](https://github.com/marketplace/actions/install-nix): instala `nix` no runner.
10. [`actions/docker-setup-buildx`](https://github.com/marketplace/actions/docker-setup-buildx): instala `docker` no runner.

Além dessas, há uma infinitude de actions que você pode buscar no [Github Marketplace - Actions](https://github.com/marketplace?type=actions) e filtrar por categorias.

## Actions extremamente específicas pra caramba

Caso você tenha buscado e não encontrou uma action que resolva o seu problema, não se desespere! Assim como aquela pizza de nutella e abacaxi que a pizzaria se resolveu a fazer pra ti, é sempre possível partirmos para uma solução caseira.

Existem 3 tipos de actions a serem criadas:
- container Docker
- JavaScript
- Ações compostas

Não vamos abordar isso no workshop, mas você sempre pode contar com a [documentação oficial](https://docs.github.com/pt/actions/creating-actions) para aprofundar nos tópicos discutidos aqui!
