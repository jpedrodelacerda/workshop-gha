# Executores

Mas fica a pergunta: onde vai rodar isso tudo?

Bem, existem duas opções para execução dos nossos workflow:
- Provisionados pelo github
- Autoprovisionado

Se reparar no exemplo que acabamos de ver, o job tem um parâmetro `runs-on` para indicação de qual é o executor a ser utilizado.

## O que é?

De forma bem resumida, um executor (ou runner), é um ambiente efêmero cuja única função é executar um job definido no nosso workflow.

Na introdução da estrutura de um workflow, comentei que eles pode conter mais de um job e cada um deles deve ter uma definição de qual runner é necessário.

Que tal um exemplo mais prático? Imagine que você está desenvolvendo uma aplicação Desktop e precisa garantir o suporte e a compilação de 3 ambientes: Linux, Windows e Mac. Como cada job tem um executor próprio, você pode definir os 3 jobs de compilação no mesmo workflow.

## `github-hosted`

Os runners provisionados pelo Github são os mais simples de serem utilizados.
Se você não tem muito requisito de ambiente, o mais comum é o `ubuntu-latest` com o `Linux`.

Há também runners com sistemas `Windows` e `macOS`.

Você pode encontrar [nesta tabela](https://docs.github.com/pt/actions/using-github-hosted-runners/about-github-hosted-runners/about-github-hosted-runners#executores-padr%C3%A3o-para-reposit%C3%B3rios-p%C3%BAblicos-hospedados-em-github) quais são as característica de cada uma das máquinas disponíveis para repositórios públicos e [nesta aqui](https://docs.github.com/pt/actions/using-github-hosted-runners/about-github-hosted-runners/about-github-hosted-runners#executores-padr%C3%A3o-hospedados-no-github-para--reposit%C3%B3rios-privados), para os repositórios privados.

Você certamente já ouviu a expressão "Não existe almoço grátis". Almoço eu não sei mas, uma coisa é certa: não existe executores grátis. Pelo menos não ilimitado! [Nessa página](https://docs.github.com/pt/actions/administering-github-actions/usage-limits-billing-and-administration#usage-limits) você consegue ver quais são os limites de cada um dos runners.

## `self-hosted`

Se na sua realidade for importante a execução do seu workflow em um ambiente específico (sua cloud ou servidores on-premises), não se desespere!

O Github permite também que você utilize a sua infra própria para subir os executores! Exige um pouco mais de configuração e não abordaremos isso aqui, mas é possível!

Assim como nos outros, também existem regras e limites de uso. A documentação está [aqui](https://docs.github.com/pt/actions/hosting-your-own-runners/managing-self-hosted-runners/about-self-hosted-runners#usage-limits), caso tenha curiosidade!
