variable "name_prefix" {
  description = "Prefixo aplicado aos nomes dos recursos de segurança"
  type        = string
}

variable "environment" {
  description = "Ambiente alvo : dev, prod"
  type        = string
}

variable "vpc_id" {
  description = "Identificador da VPC onde os grupos de segurança serão criados"
  type        = string
}

variable "container_port" {
  description = "Porta exposta pelo container"
  type        = number
}

variable "allowed_ingress_cidrs" {
  description = "Faixas de IP autorizadas a acessar o App load balancer "
  type        = list(string)
}

variable "egress_cidrs" {
  description = "Faixas de IP permitidas para saída"
  type        = list(string)
}

variable "tags" {
  description = "Mapa de tags padrão aplicado aos recursos"
  type        = map(string)
  default     = {}
}
