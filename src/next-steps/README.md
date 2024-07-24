# Próximos passos

Apesar de termos completado a publicação de nossa valiosíssima biblioteca, esse não precisa ser o final da sua jornada!

O Github Actions tem uma infinidade tanto de aplicações como suporte. Abaixo vou mostrar (bem superficialmente) algumas.

## `Testcontainers`

Você precisa fazer testes de integração com um serviço da AWS? Quer testar sua conexão com o banco? Nada tema!!

A ideia do [`Testcontainers`](https://testcontainers.com/) é facilitar o trabalho de subir containers descartáveis para seus testes.

O projeto possui vários [módulos](https://testcontainers.com/modules/) pra deixar ainda mais tranquila a configuração.
Procurou por um módulo que não existe? Não tem problema! Você pode especificar a imagem que precisa.

Quer um ecossistema mais completo e AWS é algo importante pra ti? Talvez as imagens do [`localstack`](https://www.localstack.cloud/) possam te ajudar.

## Teste local

Tá com vergonha de subir uma alteração e quebrar alguma coisa? Não precisa disso, mas já que tá rolando, que tal rodar seu workflow local?

Gostou da ideia?

É pra isso que o [`act`](https://nektosact.com/) tenta resolver. Com suporte a diversos eventos pra simular, ele vai subir containers para que você consiga validar localmente seu workflow!
