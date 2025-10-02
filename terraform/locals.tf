locals {
  base_name = "${var.project_name}-${var.environment}"

  common_tags = {
    owner      = "marcoribeiro-desafio-dotgroup"
    managed-by = "terraform"
  }
}
