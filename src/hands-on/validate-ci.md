# Validando nosso CI

Com tudo pronto, vamos criar nossa primeira release?

## Primeira saudação

Antes de tudo, vamos criar uma branch nova pra essa nossa feature?
```
git branch -b feat/add-hello
```

Precisamos adicionar um código para nossa biblioteca.

- `index.js`:

  ```js
  const { hello } = require("./src/hello");

  console.log(hello());

  module.exports = { hello };
  ```

- `src/hello.js`:
  ```js
  const hello = () => {
      return "Olá mundo!";
  };

  module.exports = { hello };
  ```

Vamos subir nossa modificação e criar nosso primeiro PR.

```
$ git add index.js src/hello.js
$ git commit -m 'feat: add greeting function'
$ git push --set-upstream origin feat/add-hello
```

Os testes falharam.
Essas falhas de pipeline incomodam, né? Pois bem, vamos corrigir isso tudo!


## Testes

Agora com o teste, vamos atualizar o script de testes no `package.json`:

```json
{
  ...
  "scripts": {
    "test": "jest"
  }
  ...
}
```

Subindo a alteração!!

```
$ git add package.json
$ git commit -m 'chore: use `jest` to run tests'
$ git push
```

Ainda está quebrado. Mas temos progresso! O erro que está dando agora é simples de resolver!
Vamos adicionar um teste em `src/hello.test.js` para deixar o `jest` feliz!

```js
const { hello } = require("./hello");

test("Retorna 'Olá mundo!'", () => {
    expect(hello()).toBe("Olá mundo!");
});
```

```
$ git add src/hello.test.js
$ git commit -m 'test: add `hello.test.js`'
$ git push
```

## Publicando

Bem, agora que nosso PR está testado e aprovado, vamos mergear!

Para mergear, vamos utilizar o método do `squash and merge`, recomendado pelo [`googleapis/release-please`](https://github.com/googleapis/release-please#linear-git-commit-history-use-squash-merge).

Pronto! Agora que nosso workflow rodou, foi criado um novo PR de release. É só mergearmos e correr pro abraço!

Se tudo der certo, você é a pessoa mais recente a publicar um novo pacote no NPM! Parabéns!!
