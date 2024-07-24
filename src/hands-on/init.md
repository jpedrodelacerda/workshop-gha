# Criando um projeto

Essa etapa é a mais tranquila. É tipo aquela prova do colégio que o professor dava meio ponto só por preencher o cabeçalho.

## Criação do repositório

Vamos criar um repositório vazio. O nosso projeto vai ser uma biblioteca responsável por (pasme!!!) dizer um 'Olá' para o mundo!!

> Com a `gh-cli`, você pode criar o repositório com o comando
> ```
>  $ gh repo create jpedrodelacerda/workshop-gha --clone
> ```
>
> Ele também clona o repositório pra você.

## Criação do projeto

Depois do repositório clonado, vamos iniciar o projeto usando o `npm init`.

> Você pode utilizar também `pnpm` ou `yarn` se preferir, mas lembre de alterar as actions.

```
$ cd workshop-gha
$ npm init -y
```

Além de criar o projeto, é sempre bom ter um arquivo `README.md`no projeto.

```
$ echo "# Workshop GHA" >> README.md
```

Pronto. Temos nosso repositório iniciado.


## Desenvolvedores responsáveis

Como bons desenvolvedores que somos, não podemos esquecer dos testes!

Para isso, utilizaremos o [`jest`](https://jestjs.io).

```shell
$ npm install --save-dev jest
```

## Lembre de commitar e enviar

```
$ git add README.md package.json package-lock.json
$ git commit -m "chore: initial commit"
$ git push
```
Afinal, de que adianta se as alterações ficam só na nossa máquina?
