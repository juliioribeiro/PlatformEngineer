# Construindo a partir do SCM
Neste laboratório, configuramos o Maven para executar uma compilação. Isso inclui extrair o código-fonte da compilação do SCM. No final do processo de construção, também criamos um artefato para a construção.

Solução
- Configurar o instalador do Maven
1. Use um navegador para navegar até o endereço IP público fornecido para o servidor. Lembre-se de adicionar ":8080" ao final do endereço IP para especificar a porta padrão do Jenkins.

As informações de login do Jenkins são as seguintes:

# Atualizar plug-ins do Jenkins
1. Clique no ícone do sino.
2. Aplicar migração.
3. Clique no ícone do sino.
4. Escolha Gerenciar Jenkins.
5. Escolha Ir para o gerenciador de plug-ins.
6. Selecione tudo, baixe agora e instale após reiniciar
7. Aguarde para marcar "Reiniciar o Jenkins quando a instalação estiver concluída e nenhum trabalho estiver em execução" até que todos os itens tenham sido marcados para uma ação.
8. Reconecte-se ao Jenkins.

# Configurar o instalador do Maven
1. Clique em Gerenciar Jenkins .
2. Clique em Configuração de ferramenta global .
3. Em instalações do Maven , clique em Adicionar Maven .
4. Na caixa Nome , digite "M3".
5. Certifique -se de que Instalar automaticamente está marcado.
6. Clique em Salvar .

# Configure a compilação para usar o Maven e crie o arquivo de índice
1. Clique em Novo item .
2. Digite um nome de item de "mavenproject" na caixa fornecida.
3. Selecione projeto Freestyle .
4. Clique em OK .
5. Clique na guia Source Code Management na parte superior da tela.
6. Selecione a opção para um repositório Git .
7. Copie o link do repositório git e insira-o na caixa URL do repositório .
8. Clique na guia Construir na parte superior da tela.
9. Clique em Add build step e selecione a opção Invoke top-level Maven targets .
10. Em Versão Maven , selecione M3 .
11. Na caixa Objetivos , insira "pacote limpo".
12. Clique em Adicionar etapa de compilação e selecione a opção Executar shell .
13. Na janela de comando , digite "bin/makeindex".
14. Clique em Incluir ação pós-compilação e selecione a opção Arquivar os artefatos .
15. Dentro da caixa Arquivar os artefatos , clique em Avançado...
16. Marque a opção Impressão digital de todos os artefatos arquivados .
17. Na caixa Arquivos para arquivar , digite "index.jsp".
18. Clique em Salvar .
19. Clique em Construir agora .
20. Atualize a janela e clique no link Visualizar ao lado de index.jsp . Verifique o conteúdo do index.jsparquivo.
