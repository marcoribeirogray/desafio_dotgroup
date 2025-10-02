# desafio_dotgroup

## Aplicação e containerização
- Aplicação PHP roda com PHP-FPM e Nginx na mesma imagem baseada em `php:8.3-fpm-alpine` (`docker/Dockerfile`).
- Processo entra como usuário não root (`appuser`); healthcheck HTTP em `/:8080` garante que Nginx e PHP-FPM estão respondendo.
- `docker-compose.yml` expõe a porta `8080` para validação local rápida (`docker compose up --build`).
- Personalize:
  - `docker/Dockerfile` (labels, porta, usuário) conforme seu padrão.
  - `DOCKER_IMAGE` no workflow para apontar para o seu repositório Docker Hub.

## Pipeline CI/CD (GitHub Actions)
Workflow principal: `.github/workflows/main.yml`
- Gatilhos: `push` e `pull_request` para `main`.
- Jobs automáticos: construir imagem Docker, verificar vulnerabilidades (Trivy) e publicar a tag `latest` no Docker Hub (apenas em push).
- Segredos usados: `DOCKERHUB_USERNAME`, `DOCKERHUB_TOKEN`.

### Como estender para CD automatizado
- Adicionar um job 'deploy' no gitHub actions dependente do job 'push' para aplicar Terraform com backend remoto e variaveis protegidas.
- Para atualizacoes pontuais, executar o comando 'aws ecs update-service --force-new-deployment' usando o digest da imagem publicado, exigindo aprovacao manual via environments protegidos.

Para aplicar Terraform, recomenda-se rodar manualmente (`terraform plan/apply`).
## Infraestrutura como Código (Terraform)
- Arquivos no diretório `terraform/` usam módulos separados: `network`, `security`, `alb`, `ecs`.
- ECS Fargate foi escolhido em vez de EKS por ser totalmente gerenciado, ter custo inicial menor e permitir foco na aplicação. ECS entrega simplicidade e integração nativa com Application Load Balancer e CloudWatch.
- `terraform/locals.tf` define `common_tags` (padrão `owner=marcoribeiro-desafio-dotgroup`, `managed-by=terraform`). Ajuste conforme necessário.
- `terraform/terraform.tfvars.example` apresenta valores de exemplo (`aws_profile`, `project_name`, `environment`, CIDRs, imagem Docker). Copie para `terraform.tfvars` e customize.
- O provider aceita `aws_profile`; caso mantenha vazio, exporte `AWS_PROFILE` antes de rodar.

## Observabilidade
Stack principal sugerida para produção:
- Prometheus + Grafana: preferência para dashboards e alertas (pode usar Amazon Managed Prometheus + Grafana gerenciado).
- Amazon CloudWatch: fonte dos dados gerenciados do ALB, ECS e logs via `awslogs`.
- Amazon SNS: alertas em cima dos alarmes de CloudWatch.

Três métricas prioritárias para compor o dashboard:
1. HTTP 5xx do ALB: acompanhar falhas da aplicação e acionar investigação.
2. Utilização de CPU/Memória das tarefas ECS: prever necessidade de scale-out e ajustar limites.
3. Tempo de resposta médio do ALB (TargetResponseTime): medir a experiência do usuário final.

Com esses itens, a aplicação fica coberta do build ao deploy, mantendo o fluxo simples e eficiente para novos ambientes ou evoluções.

Passo a passo de construção do ambiente arquivo : Deploy.md