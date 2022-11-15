# Construindo em Jenkins
Introdução

Neste laboratório, você criará uma compilação de shell simples em uma pasta em um servidor preparado com o Jenkins instalado para ajudá-lo a se familiarizar com a interface e a navegação no tipo de compilação de estilo livre. Depois de executar a compilação, você verificará a saída e verificará se a compilação está progredindo conforme o esperado.

Acesse o ambiente Jenkins copiando o endereço IP público fornecido com as credenciais do laboratório. Em seguida, em uma janela do navegador, navegue até esse endereço IP usando:
```bash
http://<public IP address>:8080
```
Quando solicitado, faça login no Jenkins com o nome de usuário studente a senhaOmgPassword!

# Crie uma pasta nomeada Test
1. Depois de fazer login no Jenkins, clique em Novo item no painel esquerdo.
2. No campo Digite um nome de item , digite "Teste".
3. Na lista de tipos de itens disponíveis, selecione Pasta .
4. Clique em OK .
5. Clique em Salvar para aceitar as configurações padrão da pasta.

# Crie e execute um trabalho de teste de usuário que salve sua saída em um arquivo chamadouser_test.txt
1. Na pasta Teste que você acabou de criar, clique no link criar novos trabalhos .

`Observação:` você também pode clicar em Novo item no painel esquerdo.

2. No campo Digite um nome de item , digite "user_test".
3. Na lista de tipos de itens disponíveis, certifique-se de que o projeto Freestyle esteja selecionado.
4. Clique em OK .
5. Na configuração do projeto, role para baixo até a seção Build e clique na seta suspensa Add build step .
6. No menu suspenso, selecione Executar shell .
7. Na caixa de texto Comando , adicione o código contendo os comandos `uname` e `whoami` necessários para enviar as informações desejadas para o nome do arquivo solicitado:
```bash
uname -a && whoami > user_test.txt
```
8. Clique em Salvar .
9. No projeto user_test , clique em Build Now no painel esquerdo.
10. Verifique se a compilação foi concluída no painel Histórico de compilação .
11. Depois de concluído, clique em Workspace no painel do projeto.
12. Clique no link de visualização à direita do arquivo user_test.txt .
13. Verifique se a saída no arquivo é exibida jenkins.
14. Clique no botão Voltar na janela do navegador.
15. Clique na seta suspensa ao lado da compilação no painel Histórico de compilação e clique em Saída do console .
16. Na Saída do Console , visualize a saída no arquivo e verifique o seguinte:
- O nome de usuário do usuário que executou a compilação (que deve ser student, o nome de usuário com o qual você está conectado).
- A versão do Linux em que a compilação estava sendo executada.
