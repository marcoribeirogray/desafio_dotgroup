variable "name_prefix" {
  description = "Prefixo aplicado aos recursos do ECS"
  type        = string
}

variable "environment" {
  description = "Ambiente alvo : dev, prod"
  type        = string
}

variable "aws_region" {
  description = "Região AWS utilizada pelo cluster"
  type        = string
}

variable "docker_image" {
  description = "Imagem Docker que será executada"
  type        = string
}

variable "container_port" {
  description = "Porta utilizada pelo container"
  type        = number
}

variable "task_cpu" {
  description = "Quantidade de CPU alocada para a task"
  type        = string
}

variable "task_memory" {
  description = "Memória alocada para a task"
  type        = string
}

variable "desired_count" {
  description = "Quantidade desejada de tasks"
  type        = number
}

variable "log_retention_in_days" {
  description = "Dias de retenção dos logs no cloudWatch"
  type        = number
}

variable "enable_container_insights" {
  description = "Habilita ou não o container insights"
  type        = bool
}

variable "service_security_group_id" {
  description = "Security group associado ao serviço ECS"
  type        = string
}

variable "subnet_ids" {
  description = "Sub-redes onde as tasks serão executadas"
  type        = list(string)
}

variable "target_group_arn" {
  description = "ARN do Target Group usado pelo serviço"
  type        = string
}

variable "health_check_path" {
  description = "Caminho HTTP usado na checagem de saúde interna"
  type        = string
}

variable "assign_public_ip" {
  description = "Define se as tasks recebem IP público"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Mapa de tags padrão aplicado aos recursos"
  type        = map(string)
  default     = {}
}
