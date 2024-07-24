# Entrega Contínua (<ins>C</ins>ontinuous <ins>D</ins>elivery)

A etapa de entrega contínua é o passo seguinte ao CI. Consiste em ter automações para a entrega do novo código nos ambientes: seja de `dev`, `tst` ou `prod`.

A automação do processo de entrega de código para os ambientes finais, quando feito como código, serve também como uma documentação e pode ser versionada no próprio repositório. Além disso, acaba reduzindo a carga da pessoa desenvolvedora em dois níveis:
- carga cognitiva: a pessoa desenvolvedora não precisa ficar redescobrindo comandos arcanos para realizar o deploy. Idealmente o processo é iniciado com alguns cliques (ou automaticamente).
- carga processual: a máquina da pessoa desenvolvedora não fica onerada com o processamento de construção do artefato para ser implantado já que todo esse processamento ocorrerá em um servidor especifico para essa tarefa.
> Até pouco tempo atrás, deploys consistiam em copiar o build local para um servidor via [FTP](https://pt.wikipedia.org/wiki/Protocolo_de_Transfer%C3%AAncia_de_Arquivos). Olha só como avançamos!!

## Diferença entre CDs?

Existe também a prática de Implantação Contínua (<ins>C</ins>ontinuous <ins>D</ins>eployment). Enquanto o deploy para produção é feito de forma manual na Entrega Contínua, com a Implantação Contínua deploy para produção/cliente final, é feito de forma automática e apoiado por uso de [feature flags](https://pt.wikipedia.org/wiki/Feature_toggle).
