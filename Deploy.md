# Deploy

## Pre-requisitos
- Docker e Docker Compose instalados.
- Terraform >= 1.5.
- Perfil AWS configurado com permissao para criar VPC, ALB, CloudWatch Logs, IAM e ECS.
- Variavel de ambiente `AWS_PROFILE` definida ou `terraform.tfvars` contendo `aws_profile = "desafio-dotgroup"`.
- `terraform/terraform.tfvars` preenchido com regiao, bloco CIDR, sub-redes, tag da imagem Docker e demais parametros exigidos pelos modulos.

### Como preparar as credenciais AWS
```bash
aws configure --profile desafio-dotgroup
# Depois de informar Access Key, Secret Key e regiao
$env:AWS_PROFILE = "desafio-dotgroup"

aws sts get-caller-identity --profile desafio-dotgroup
```
> Use `unset AWS_PROFILE` / `Remove-Item Env:AWS_PROFILE` para alternar perfis quando necessario.

## Passo a passo
1. Validar localmente
   ```bash
   docker compose up --build
   ```
   A aplicacao responde em `http://localhost:8080`.

2. Executar o workflow da aplicacao (`main.yml`)
   - Push ou PR para `main` roda build, scan Trivy e publica a imagem `latest` no Docker Hub.
   - Depois da publicacao, siga para o provisionamento via Terraform (manual ou automatizado).

3. Provisionar infraestrutura manualmente
   ```bash
   cd terraform
   terraform init
   terraform plan -out=plano.tfplan
   terraform apply plano.tfplan
   ```

4. Limpeza
   ```bash
   terraform destroy
   ```
   Remove todos os recursos criados pela stack.

## Personalizacoes rapidas
- Ajuste `terraform.tfvars` para alterar nomes `project_name`, `environment`, ranges de rede e tag da imagem.
- Modifique `DOCKER_IMAGE` no workflow caso utilize outro repositorio Docker Hub.
- Para backends remotos (S3 + DynamoDB), inclua o bloco `backend` no `terraform {}` antes de rodar o `init`.
