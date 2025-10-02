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

2. Executar o pipeline (CI/CD)
   - Faça push na branch `main`.
   - O GitHub Actions executa build, scan Trivy, push da imagem `latest` e gera o plano Terraform como artefato.
   - Para aplicar, acesse GitHub Actions → workflow "CI/CD Pipeline" → botão `Run workflow`, informe `sim` no campo `aprovar_deploy` e execute. Esse job manual usa os segredos AWS para rodar `terraform apply` no ambiente `infraestrutura`.

3. Provisionar infraestrutura manualmente 
   ```bash
   cd terraform
   terraform init
   terraform plan
   terraform apply
   ```
   Use esse passo apenas se precisar aplicar fora da esteira. Os outputs mostram o nome do cluster ECS e o DNS público do application load balancer.

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
