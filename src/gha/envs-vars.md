# Variáveis de ambiente

Assim como no ambiente de desenvolvimento, podemos definir variáveis para parametrizar o comportamento de alguns programas ou fluxos.

Um exemplo clássico é o uso da variável `NODE_ENV` para definir em qual ambiente o projeto será executado.

```bash
$ NODE_ENV=production npm run build
$ NODE_ENV=development npm run build
```
No ambiente de produção são feitas algumas otimizações que são dispensáveis no ambiente de desenvolvimento.

## Escopo

Podemos definir uma variável em 3 níveis:
- workflow
- job
- etapa

Para definir uma variável, basta definirmos um mapa `env`. Todos os elementos a abaixo daquele escopo terão acesso à variável. Por esse motivo, é bom seguirmos uma das regras de ouro da segurança: quanto menor o escopo, melhor.

## Exemplos

### Definir versão do NodeJS via NVM
```yaml
name: Instala a versão do NodeJS
on: # ...
env:
  NODEJS_VERSION: 22.3.0
jobs:
  install-node:
    runs-on: ubuntu-latest
    steps:
      # ... Instala o NVM
      - name: Define versão do NodeJS
        run: nvm use $NODEJS_VERSION
```
