variable "aws_region" {
  description = "Região AWS utilizada no deploy"
  type        = string
}

variable "aws_profile" {
  description = "Perfil de credenciais AWS (opcional)"
  type        = string
  default     = ""
}

variable "project_name" {
  description = "Nome do projeto aplicado nas tags"
  type        = string
}

variable "environment" {
  description = "Nome do ambiente :dev, prod"
  type        = string
}

variable "vpc_cidr" {
  description = "Bloco CIDR principal da VPC"
  type        = string
}

variable "public_subnets" {
  description = "Lista de CIDRs das sub-redes públicas"
  type        = list(string)

  validation {
    condition     = length(var.public_subnets) >= 2
    error_message = "Informe ao menos duas sub-redes públicas."
  }
}

variable "allowed_ingress_cidrs" {
  description = "Faixas de IP autorizadas a acessar o App load balancer "
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "egress_cidrs" {
  description = "Faixas de IP permitidas para saída"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "docker_image" {
  description = "Imagem Docker usada pelo serviço"
  type        = string
}

variable "container_port" {
  description = "Porta exposta pelo container"
  type        = number
  default     = 8080
}

variable "health_check_path" {
  description = "Caminho HTTP utilizado na checagem de saúde"
  type        = string
  default     = "/"
}

variable "task_cpu" {
  description = "CPU alocada por task unidades Fargate"
  type        = string
  default     = "256"
}

variable "task_memory" {
  description = "Memória alocada por task"
  type        = string
  default     = "512"
}

variable "desired_count" {
  description = "Quantidade desejada de tasks ativas"
  type        = number
  default     = 1
}

variable "log_retention_in_days" {
  description = "Dias de retenção dos logs no CloudWatch"
  type        = number
  default     = 7
}

variable "enable_container_insights" {
  description = "Ativa o Container Insights no cluster"
  type        = bool
  default     = true
}

variable "assign_public_ip" {
  description = "Define se as tasks recebem IP público"
  type        = bool
  default     = true
}
