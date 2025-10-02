# Deploy

## Pré-requisitos
- Docker e Docker Compose instalados.
- Terraform >= 1.5.
- Credenciais AWS configuradas via `aws configure --profile desafio-dotgroup` 
- `terraform/terraform.tfvars` preenchido com região, VPC, sub-redes, imagem Docker e, se desejar, nome do perfil.

## Passo a passo
1. Validar localmente
   ```bash
   docker compose up --build
   ```
   A aplicação responde em `http://localhost:8080`.

2. Executar o workflow da aplicação (`main.yml`)
   - Push ou PR para `main` roda build, scan Trivy e publica a imagem `latest` no Docker Hub.
   - Após validar, execute `terraform plan`/`apply` manualmente ou adapte o pipeline futuramente para automatizar essa etapa com aprovação.

3. Provisionar infraestrutura manualmente
   ```bash
   cd terraform
   terraform init
   terraform plan
   terraform apply
   ```
   Use esse passo apenas se precisar aplicar fora da esteira. Os outputs mostram o nome do cluster ECS e o DNS público do Application Load Balancer.

4. Atualizar serviço se executar manualmente.
   - Execute `terraform apply` localmente ou use `aws ecs update-service` para forçar a nova imagem.

5. Limpeza
   ```bash
   terraform destroy
   ```
   Remove todos os recursos criados pela stack.

## Personalizações rápidas
- Ajuste `terraform.tfvars` para alterar nomes (`project_name`, `environment`), ranges de rede e tag da imagem.
- Modifique `DOCKER_IMAGE` no workflow caso o repositório Docker Hub seja outro.
