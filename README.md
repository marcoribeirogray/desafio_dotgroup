# desafio_dotgroup

## Aplicação e containerização
- Aplicação PHP roda com PHP-FPM e Nginx na mesma imagem baseada em `php:8.3-fpm-alpine` (`docker/Dockerfile`).
- Processo entra como usuário não root (`appuser`); healthcheck HTTP em `/:8080` garante que Nginx e PHP-FPM estão respondendo.
- `docker-compose.yml` expõe a porta `8080` para validação local rápida (`docker compose up --build`).
- Personalize:
  - `docker/Dockerfile` (labels, porta, usuário) conforme seu padrão.
  - `DOCKER_IMAGE` no workflow para apontar para o seu repositório Docker Hub.

## Pipeline CI/CD (GitHub Actions)
Workflow em `.github/workflows/ci-cd-desafio-dotgroup.yml` com as etapas abaixo:

**Automático em push/pull request para `main`:**
1. Construir imagem Docker – checkout, configura `buildx` e gera a imagem localmente.
2. Verificar vulnerabilidades – baixa o artefato e roda o Trivy (SARIF + tabela).
3. Publicar imagem Docker – recompila usando cache e envia apenas a tag `latest` para o Docker Hub.
4. Gerar plano Terraform – roda `terraform plan` e publica o plano como artefato.

**Manual via `Run workflow`:**
- Aplicar Terraform – disponível apenas em `workflow_dispatch`. Exige inserir `sim` no input `aprovar_deploy`, reaplica o plan e executa `terraform apply` no ambiente `infraestrutura` (pode configurar aprovadores nesse environment).

Segredos necessários:
- `DOCKERHUB_USERNAME` e `DOCKERHUB_TOKEN` para publicar a imagem.
- `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION` para os jobs Terraform.

O nome da imagem vem de `env.DOCKER_IMAGE`. Ajuste o environment `infraestrutura` e os aprovadores conforme sua política.

## Infraestrutura como Código (Terraform)
- Arquivos no diretório `terraform/` usam módulos separados: `network`, `security`, `alb`, `ecs`.
- ECS Fargate foi escolhido em vez de EKS por ser totalmente gerenciado, ter custo inicial menor e permitir foco na aplicação. ECS entrega simplicidade e integração nativa com app load balancer e cloudwatch.
- `terraform/locals.tf` define `common_tags` (padrão `owner=marcoribeiro-desafio-dotgroup`, `managed-by=terraform`). Ajuste conforme necessário.
- `terraform/terraform.tfvars.example` apresenta valores de exemplo (`aws_profile`, `project_name`, `environment`, CIDRs, imagem Docker). Copie para `terraform.tfvars` e customize.
- O provider aceita `aws_profile`; caso mantenha vazio, exporte `AWS_PROFILE` antes de rodar.

## Observabilidade
Stack principal sugerida para produção:
- Prometheus + Grafana: preferência para dashboards e alertas (pode usar Amazon Managed Prometheus + Grafana gerenciado).
- Amazon CloudWatch: fonte dos dados gerenciados do ALB, ECS e logs via `awslogs`.
- Amazon SNS: alertas em cima dos alarmes de CloudWatch.

Três métricas prioritárias para compor o dashboard:
1. HTTP 5xx do ALB : acompanhar falhas da aplicação e acionar investigação.
2. Utilização de CPU/Memória das tarefas ECS : prever necessidade de scale-out e ajustar limites.
3. Tempo de resposta médio do ALB (TargetResponseTime): medir a experiência do usuário final.

Com esses itens, a aplicação fica coberta do build ao deploy, mantendo o fluxo simples e eficiente para novos ambientes ou evoluções.
