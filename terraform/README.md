# Terraform para Provisionamento de RDS na AWS

Este projeto Terraform automatiza a criação e configuração de uma instância de banco de dados PostgreSQL no Amazon RDS. Ele foi projetado para ser uma solução rápida para implantar um banco de dados para a "Oficina RDS", incluindo a configuração de rede, segurança e inicialização do esquema do banco de dados.

## Funcionalidades

- **Criação de RDS:** Provisiona uma instância PostgreSQL `db.t3.micro`.
- **Geração de Senha Segura:** Utiliza o provedor `random` para gerar uma senha forte para o banco de dados.
- **Gerenciamento de Segredos:** Armazena as credenciais do banco de dados (usuário, senha, host, etc.) de forma segura no AWS Secrets Manager.
- **Configuração de Rede:** Cria um *Security Group* que permite o acesso público à instância RDS na porta `5432`. **Atenção:** Para ambientes de produção, é altamente recomendável restringir o CIDR para IPs conhecidos.
- **Backend S3:** Configurado para armazenar o arquivo de estado do Terraform (`terraform.tfstate`) em um bucket S3, facilitando o trabalho em equipe e a manutenção do estado.
- **Inicialização do Banco de Dados:** Após a criação do RDS, um script (`init.sql`) é executado para criar todas as tabelas e relacionamentos necessários para a aplicação da oficina.

## Pré-requisitos

Antes de executar este projeto, certifique-se de que você tem:

1.  **Terraform CLI:** Instalado e configurado em sua máquina.
2.  **AWS CLI:** Instalado e configurado com as credenciais de acesso (`aws configure`). As credenciais devem ter permissões para criar os recursos descritos nos arquivos `.tf`.
3.  **psql:** O cliente de linha de comando do PostgreSQL precisa estar instalado e disponível no `PATH` do sistema para que o script de inicialização do banco seja executado.
4.  **Bucket S3:** Um bucket S3 para armazenar o `tfstate`. O nome do bucket deve ser atualizado no arquivo `backend.tf`.

## Estrutura do Projeto

```
.
├── backend.tf          # Configuração do backend S3 para o state
├── main.tf             # Definição do provedor AWS
├── rds.tf              # Recursos do RDS, subnet group e provisioner para o script SQL
├── secret-manager.tf   # Recursos para criar e popular o AWS Secrets Manager
├── sg.tf               # Definição do Security Group para o RDS
├── variables.tf        # Variáveis de entrada (IDs de VPC e subnets)
├── output.tf           # Saídas do Terraform (endpoint do RDS, nome do secret)
└── scripts/
    └── init.sql        # Script de inicialização do schema do banco de dados
```

## Como Usar

1.  **Clone o repositório:**
    ```bash
    git clone <url-do-repositorio>
    cd <diretorio-do-repositorio>
    ```

2.  **Configure o Backend:**
    Abra o arquivo `backend.tf` e altere o valor de `bucket` para o nome do seu bucket S3.

3.  **Inicialize o Terraform:**
    Este comando irá baixar os provedores necessários (`aws`, `random`).
    ```bash
    terraform init
    ```

4.  **Planeje a Execução:**
    Revise os recursos que serão criados pelo Terraform.
    ```bash
    terraform plan
    ```

5.  **Aplique a Configuração:**
    Este comando provisionará todos os recursos na AWS. O processo pode levar alguns minutos.
    ```bash
    terraform apply --auto-approve
    ```
    Ao final, o Terraform exibirá as saídas (`outputs`) com as informações de conexão.

## Acessando o Banco de Dados

Após a execução, as credenciais do banco de dados estarão armazenadas no AWS Secrets Manager. Você pode recuperá-las usando a AWS CLI, conforme mostrado na saída `connection_info`:

```bash
# Comando para obter o nome do secret
SECRET_NAME=$(terraform output -raw secret_name)

# Recuperar o secret
aws secretsmanager get-secret-value --secret-id $SECRET_NAME --query SecretString --output text | jq .
```

O endpoint para conexão estará disponível na saída `rds_endpoint`.

## Limpeza

Para destruir todos os recursos criados por este projeto e evitar custos desnecessários, execute:

```bash
terraform destroy --auto-approve
```
