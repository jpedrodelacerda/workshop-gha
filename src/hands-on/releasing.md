# Publicando uma release

Como estamos trabalhando com uma biblioteca, a publicação da release vai ser no `npm`. Para isso, basta ter uma conta registrada no site.
Queremos também gerar um texto contendo as mudanças que ocorreram deste a última release.

> Nesta etapa não nos preocuparemos com teste. Assumimos no nosso mundo ideal lindo e maravilhoso que toda alteração já passou previamente pelo teste na etapa de PR. Caso seja do seu interesse, você pode definir os jobs que utilizamos na etapa anterior para executar testes antes da publicação.

## Começando pelo começo

Vamos definir um nome e o gatilho que queremos para o nosso workflow no arquivo `./github/workflows/release.yaml`.

Definimos anteriormente que queremos publicar uma nova versão sempre que chegar alguma alteração na branch principal. De forma muito parecida com o gatilho do `pr-checker`, também só estaremos interessados se essas alterações aconteceram no código fonte do projeto ou arquivos que podem indicar a criação de uma release nova.

```yaml
name: Create release and publish
on:
  push:
    branches:
      - main
    paths:
      - '**.js'
      - 'package.json'
      - 'CHANGELOG.md'
```

> Pode ser interessante utilizar um gatilho manual na etapa de validação do seu workflow com um gatilho `workflow_dispatch`, mas lembre-se de retirá-lo quando o workflow estiver funcionando normalmente.

## Processo da release

Utilizaremos o conventional commit para padronização das mensagens de commit.

> Se quiser dar uma lida com calma, a documentação está [aqui](https://www.conventionalcommits.org/pt-br/v1.0.0).

Em resumo, nossas mensagens terão o seguinte formato:

```
<tipo>[escopo opcional]: <descrição>
```

Caso a tenha uma quebra de compatibilidade, podemos indicar isso para o sistema utilizando um ponto de exclamação: `<tipo>!: <descrição>`. Isso fará com que a major version seja atualizada.

Escolhemos o conventional commits pois utilizaremos a action [`googleapis/release-please`](https://github.com/googleapis/release-please-action).

Eu falei que tudo que chegasse na `main` seria uma release, né? Mas não vai ser chegou e publicou. O processo vai ser com as seguintes etapas:
1. Criação de PR apontando para `main`
   Desenvolveremos nossa feature em uma branch de vida curta. Assim que finalizarmos o desenvolvimento dela, abriremos um PR para a branch principal.
2. Merge na `main`
   Acionará o workflow da release.
3. A action irá criar um novo PR da release
   Com a execução do workflow da release, um novo PR é criado. Até então nossa release não foi publicada.
4. Merge do PR da release
   Com esse merge, a action criará uma release do Github e executará o resto do nosso workflow, publicando o pacote no NPM.


## Preparando a publicação

Antes de começar a fazer nosso workflow de release, vamos preparar o terreno!

Por padrão, o `npm` publica no repositório público. Caso você deseja fazer o deploy para outro repositório, pode configurar isso via `publishConfig` no `package.json`.

Vamos aproveitar e atualizar algumas informações:
- `name`: vamos adicionar um [escopo](https://docs.npmjs.com/cli/v10/using-npm/scope)
- `author`: informações pessoais.
- `license`: eu vou utilizar a MIT ou Apache-2.0. Sinta-se livre para escolher a que preferir.
- `publishConfig.access`: para definir que o pacote é publico. Pacotes privados no NPM requerem pagamento. Caso não queira configurar isso no `package.json`, você pode passar a flag `--access public` no comando de publicação do workflow.

```json
{
  "name": "@jpedrodelacerda/workshop-gha-n7ff5",
  "author": "João Lacerda <dev@jpedrodelacerda.com> (https://ddb.jpedrodelacerda.com/)",
  "license": "(MIT OR Apache-2.0)",
  "publishConfig": {
    "access": "public"
  }
  ...
}
```

## Autenticação

Mesmo com um escopo, o que impede alguém de publicar uma nova versão do meu pacote? Ou melhor, como o NPM consegue confiar que, ao publicar uma versão, sou eu mesmo?

Para fazer a autenticação, precisamos de algum identificador gerado pelo NPM. Esse identificador é secreto e deve ser utilizado com muito cuidado.

Se você pensou em armazenar isso em um secret do repositório, pensou certo!

Depois de logar na conta do NPM, clique no seu perfil e procure por tokens de acesso. Vamos gerar um novo token de acesso granular.
Coloquei o nome no meu de `workshop-gha`. ~(Que original, não?)~ O tempo de vida do token fica a seu critério. Quanto menor, melhor. A não ser que vá utilizar para outros projetos.

Não se esqueça de dar permissão de leitura e escrita (read and write).
Por desencargo de consciência, vou definir também o escopo apenas para o `@jpedrodelacerda`.

Depois de criado, vá nas configurações do seu projeto no Github e adicione o secret `NPM_TOKEN` com o token criado.

> Se estiver com a `gh-cli`, você pode criar o secret do repositório com o seguinte comando:
> ```
> $ gh secret set NPM_TOKEN
> ```

### Criando uma release

Para adicionar a release, precisamos garantir algumas permissões para o workflow. Vamos aproveitar e adicionar a action também.

Ações utilizando o token padrão do workflow não geram novos acionamentos para evitar loops indesejados. Portanto, vamos criar um Personal Access Token para que tanto o PR quanto o commit da release possam acionar nosso workflow.

> Se tiver logado com a `gh-cli` e quiser reutilizar o token que está configurado para ela, você pode executar o seguinte comando:
> ```
> $ gh secret set PAT_TOKEN -b $(gh auth token)
> ```

> Para mais informações sobre as permissões, veja a [documentação da action](https://github.com/googleapis/release-please-action?tab=readme-ov-file#workflow-permissions).

```yaml
name: Create release and publish
on:
  push:
    branches:
      - main
    paths:
      - '**.js'
      - 'CHANGELOG.md'
      - 'package.json'

jobs:
  release-please:
    permissions:
      contents: write # Permitir a criação do commit de release
      pull-requests: write # Permitir a criação do PR de release

    runs-on: ubuntu-latest
    steps:
      - name: Prepare | Create github release
        uses: googleapis/release-please-action@v4
        with:
          token: ${{ secrets.PAT_TOKEN }}
          release-type: node
```


## Publicação da biblioteca

Para publicar um pacote no NPM, é necessário ter uma conta registrada e precisamos também atualizar o `package.json`.

```yaml
name: Create release and publish
on:
  push:
    branches:
      - main
    paths:
      - '**.js'
      - 'CHANGELOG.md'
      - 'package.json'

jobs:
  release-please:
    permissions:
      contents: write # Permitir a criação do commit de release
      pull-requests: write # Permitir a criação do PR de release

    runs-on: ubuntu-latest
    steps:
      - name: Prepare | Create github release
        uses: googleapis/release-please-action@v4
        id: release
        with:
          release-type: node

      - name: Prepare | Checkout repo
        if: ${{ steps.release.outputs.release_created }}
        uses: actions/checkout@v4

      - name: Prepare | Configure Node+NPM
        if: ${{ steps.release.outputs.release_created }}
        uses: actions/setup-node@v4
        with:
          version: 22.x
          registry-url: 'https://registry.npmjs.org'

      - name: Prepare | Install deps
        if: ${{ steps.release.outputs.release_created }}
        run: npm ci

      - name: Publish | Publish package to NPM
        run: npm publish
        if: ${{ steps.release.outputs.releases_created }}
        env:
          NODE_AUTH_TOKEN: ${{ secrets.NPM_TOKEN }}
```

Perceba que só publicamos se nossa release foi criada.

Não esqueça de commitar nossas alterações e vamos validar nosso trabalho!!
