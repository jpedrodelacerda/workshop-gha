# Segredos e variáveis

Um dos primeiros conceitos que encontramos ao iniciar no mundo da programação é o uso de variáveis. Isso se deve ao fato de que às vezes o nosso código precisa receber alguma entrada do usuário ou até mesmo facilitar a manutenção do mesmo.

Com os workflows não é diferente. Para isso, existem os `secrets` e as `variables`.

Além disso, o Github Actions possui uma abstração chamada `environments` para facilitar o controle de *secrets* e *variables* em diferentes ambientes como `dev`, `tst` e `prod`, por exemplo.

## `secrets` e `variables`

Um `secret` e uma `variable` são parâmetros que podem ser acessados pelo workflow e a principal diferença entre eles é que o `secret`, como o nome dá a entender, é secreto. Ou seja, depois de definido, apenas os workflows podem acessá-los. O próprio GHA vai ocultar os valores dos `secrets` se eles fossem exibidos no log.
Se for um dado sensível, como uma credencial, crie um `secret`. Caso contrário, use uma `variable`.

Mas como fazemos para criar um secret? Vamos ver isso agora!

## Níveis e criação dos parâmetros

Esses parâmetros podem ser definidos a nível de organização, repositório e ambientes. Se houver colisão de nomes, ou seja, um `secret` chamado `SECRET_SECRETO_DO_JP` a nível de organização e um outro chamado `SECRET_SECRETO_DO_JP` a nível do repositório, a preferência é sempre do `secret` do **repositório**!
Se ainda houvesse um `secret` chamado `SECRET_SECRETO_DO_JP` a nível de ambiente, a preferência seria do **ambiente**!

> Em resumo: quanto menor o escopo, maior a preferência.

Para a criação, basta ir na configuração do nível desejado:
- repositório: aba de configurações do repositório > Segurança > Segredos e variáveis > Actions > Segredos / Variáveis > Novo segredo/variável
- ambiente: aba de configurações do repositório > Ambientes > Selecione o ambiente > Segredos / Variáveis > Novo segredo/variável
- organização: aba de configurações da organização > Segurança > Segredos e variáveis

## Utilização

Os secredos e variáveis estão disponíveis através do objeto `secrets` e `vars`, respectivamente. Ou seja, para acessar o valor do secret `SECRET_SECRETO_DO_JP`, basta expandirmos o valor via `${{ secrets.SECRET_SECRETO_DO_JP }}`.

## Exemplos

### Notificação de webhook

```yaml
name: Notifica no slack
on: # ...
jobs:
  send-notification:
    runs-on: ubuntu-latest
    steps:
      - uses: slackapi/slack-github-action@v1.26.0
        env:
          SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}
```

### Credenciais da AWS

```yaml
name: Autentica credencial da AWS
on: # ...
jobs:
  publish:
    runs-on: ubuntu-latest
    steps:
      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v4.0.2
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_KEY }}
          aws-region: ${{ vars.AWS_DEFAULT_REGION }}
          role-to-assume: ${{ vars.AWS_ROLE_ARN }}
          role-duration-seconds: 3600
```
