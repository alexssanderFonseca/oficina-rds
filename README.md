# Infraestrutura AWS para Banco de Dados RDS com Terraform

Este projeto utiliza Terraform para provisionar e gerenciar a infraestrutura de um banco de dados PostgreSQL na AWS. A automação garante um ambiente consistente, versionado e replicável.

## Visão Geral

O projeto cria os seguintes recursos na AWS:

-   **AWS RDS**: Uma instância de banco de dados PostgreSQL (`db.t3.micro`).
-   **AWS Secrets Manager**: Um segredo para armazenar de forma segura as credenciais (usuário e senha) do banco de dados.
-   **AWS VPC Security Group**: Um grupo de segurança que libera o acesso público à porta `5432` do PostgreSQL.
-   **AWS DB Subnet Group**: Um grupo de sub-redes para a instância RDS.

O estado do Terraform (`tfstate`) é armazenado remotamente em um bucket S3 para colaboração e segurança.

## Estrutura do Repositório

```
/
├── .github/workflows/   # Workflows de CI/CD (GitHub Actions)
│   ├── ci-pipeline.yml       # Valida e cria PR para features
│   └── cd-pipeline.yml       # Aplica a infraestrutura no ambiente principal
├── terraform/             # Código da infraestrutura
│   ├── rds.tf                # Define a instância RDS
│   ├── sg.tf                 # Define o Security Group
│   ├── secret-manager.tf     # Gerencia as credenciais no Secrets Manager
│   ├── backend.tf            # Configuração do S3 como backend
│   ├── variables.tf          # Variáveis de entrada
│   └── output.tf             # Saídas da infraestrutura
└── README.md              # Este arquivo
```

## Pré-requisitos

1.  **Conta na AWS**: Acesso a uma conta AWS com as devidas permissões.
2.  **AWS CLI**: [Instalado](https://aws.amazon.com/cli/) e [configurado](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html) com suas credenciais.
3.  **Terraform**: [Instalado](https://learn.hashicorp.com/tutorials/terraform/install-cli) na máquina.
4.  **Bucket S3**: Um bucket S3 para armazenar o `terraform.tfstate`. O bucket configurado neste projeto é `tfstate-fiap-alex-academy-rds`. Altere o arquivo `terraform/backend.tf` se precisar usar outro.

## Como Executar Localmente

1.  **Navegue até a pasta `terraform`**:
    ```bash
    cd terraform
    ```

2.  **Inicialize o Terraform**:
    Este comando inicializa os plugins e o backend.
    ```bash
    terraform init
    ```

3.  **Planeje as alterações**:
    O Terraform irá mostrar o que será criado, alterado ou destruído.
    ```bash
    terraform plan
    ```

4.  **Aplique as alterações**:
    Este comando provisiona a infraestrutura na AWS.
    ```bash
    terraform apply
    ```

5.  **Destrua a infraestrutura**:
    Para remover todos os recursos criados, execute:
    ```bash
    terraform destroy
    ```

## Automação com CI/CD (GitHub Actions)

O projeto está configurado com pipelines de Integração e Entrega Contínua:

-   **CI Pipeline (`ci-pipeline.yml`)**:
    -   **Gatilho**: Push em branches com o padrão `feature/**`.
    -   **Ações**:
        1.  Executa o `terraform plan` para validar a sintaxe e o plano de execução.
        2.  Se a validação for bem-sucedida, um Pull Request é criado automaticamente para a branch `main`.

-   **CD Pipeline (`cd-pipeline.yml`)**:
    -   **Gatilho**: Push (merge) na branch `main`.
    -   **Ação**: Executa o `terraform apply -auto-approve`, aplicando as alterações e provisionando a infraestrutura no ambiente.

## Documentação do Terraform

### Variáveis de Entrada (Inputs)

| Nome         | Descrição                          | Tipo       | Padrão                                                                                             |
| :----------- | :--------------------------------- | :--------- | :------------------------------------------------------------------------------------------------- |
| `vpc_id`     | ID da VPC onde os recursos serão criados. | `string`   | `"vpc-0fb81a0a9aea53dab"`                                                                          |
| `subnets_id` | Lista de Subnets para o RDS.       | `list(any)`| `["subnet-0fcae672ce9da5b93", "subnet-07959d6d4df3f85be", "subnet-03664783107daf27a"]` |

### Saídas (Outputs)

| Nome              | Descrição                                                                      |
| :---------------- | :----------------------------------------------------------------------------- |
| `rds_endpoint`    | Endpoint de conexão para a instância RDS.                                      |
| `rds_address`     | Endereço da instância RDS.                                                     |
| `rds_port`        | Porta de conexão da instância RDS.                                             |
| `secret_arn`      | ARN do segredo no AWS Secrets Manager que armazena as credenciais.              |
| `secret_name`     | Nome do segredo no AWS Secrets Manager.                                        |
| `database_name`   | Nome do banco de dados (`oficinadb`).                                         |
| `connection_info` | Instruções e comandos úteis para obter as credenciais e conectar ao banco de dados. |

