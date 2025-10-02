variable "name_prefix" {
  description = "Prefixo aplicado aos nomes dos recursos de rede"
  type        = string
}

variable "environment" {
  description = "Ambiente alvo : dev, prod"
  type        = string
}

variable "vpc_cidr" {
  description = "Bloco CIDR principal da VPC"
  type        = string
}

variable "public_subnets" {
  description = "Lista de sub-redes públicas"
  type        = list(string)
}

variable "tags" {
  description = "Mapa de tags padrão aplicado aos recursos"
  type        = map(string)
  default     = {}
}
