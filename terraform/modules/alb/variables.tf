variable "name_prefix" {
  description = "Prefixo aplicado aos componentes do App load balancer"
  type        = string
}

variable "environment" {
  description = "Ambiente alvo : dev, prod"
  type        = string
}

variable "subnet_ids" {
  description = "Lista de sub-redes onde o App load balancer será criado"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security Group associado ao App load balancer "
  type        = string
}

variable "container_port" {
  description = "Porta utilizada pelas tasks no Target Group"
  type        = number
}

variable "health_check_path" {
  description = "Caminho HTTP para checagem de saúde"
  type        = string
}

variable "vpc_id" {
  description = "Identificador da VPC onde o App load balancer será provisionado"
  type        = string
}

variable "tags" {
  description = "Mapa de tags padrão aplicado aos recursos"
  type        = map(string)
  default     = {}
}
