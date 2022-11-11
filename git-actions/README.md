# Listas de Tarefas
- Ficar de olho no repositório
- Executar os testes que foram escritos
- Baixar a aplicação e rodar os testes

# Instalar Docker ubuntu
```bash
sudo apt-get update

sudo apt-get install ca-certificates curl gnupg lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io

```

# Install go ubuntu
```bash
sudo apt install golang-go
```
Subir aplicação
- Copiar a aplicação, utilizando o git: git clone https://github.com/alura-cursos/api_rest_gin_go_2-validacoes-e-testes
- Subir o banco de dados, usando o docker compose: `docker-compose up -d`
- iniciar a aplicação, com o Go: `go run main.go`
- Acessar URL: `http://localhost:8080/leo`
- Encerrar aplicação: Ctrl + c
- acessar branch `git checkout aula_5`
- Subir o banco de dados, usando o docker compose: `docker-compose up -d`
- `go test -v main_test.go`