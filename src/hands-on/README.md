# Mão na massa

Beleza. Tudo lindo, tudo bacana. Mas vamos pra prática?

## Requisitos

- Conta no [Github](https://github.com): afinal de contas é a plataforma que estamos falando desde o início
  - Criação de repositório
  - Criação de um secret para armazenar a credencial do NPM
  - Criação de um Personal Access Token (PAT) para utilização no workflow
- Conta no [NPM](https://npmjs.com): onde publicaremos nossa biblioteca
  - Criação de uma credencial para publicação da biblioteca

> Pessoalmente gosto bastante de CLIs e recomendo também a [`gh-cli`](https://cli.github.com/). É opcional, mas facilita bastante em algumas etapas.

## Agenda

Nessa etapa do workshop vamos criar workflows para resolver dois pontos importantíssimos da etapa de desenvolvimento:
- análise de PRs
- criação de release

Na etapa de análise de PR estamos interessados em verificar se os testes estão passando. Você pode (e deve) ser mais criterioso do que o nosso exemplo. Lembre-se que contexto é tudo!

Já na criação da release, vamos assumir um mundo perfeito: toda alteração que chega na branch é uma release nova, afinal tudo passou pelo crivo das nossas análises dos PRs.

Vamos utilizar como base um projeto em `node`, mas você é livre para escolher a linguagem/ecossistema que preferir.
> Lembre de atualizar as actions para refletir a sua escolha.
