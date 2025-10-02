terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "network" {
  source         = "./modules/network"
  name_prefix    = local.base_name
  environment    = var.environment
  vpc_cidr       = var.vpc_cidr
  public_subnets = var.public_subnets
  tags           = local.common_tags
}

module "security" {
  source                = "./modules/security"
  name_prefix           = local.base_name
  environment           = var.environment
  vpc_id                = module.network.vpc_id
  container_port        = var.container_port
  allowed_ingress_cidrs = var.allowed_ingress_cidrs
  egress_cidrs          = var.egress_cidrs
  tags                  = local.common_tags
}

module "alb" {
  source            = "./modules/alb"
  name_prefix       = local.base_name
  environment       = var.environment
  subnet_ids        = module.network.public_subnet_ids
  security_group_id = module.security.alb_security_group_id
  container_port    = var.container_port
  health_check_path = var.health_check_path
  vpc_id            = module.network.vpc_id
  tags              = local.common_tags
}

module "ecs" {
  source                    = "./modules/ecs"
  name_prefix               = local.base_name
  environment               = var.environment
  aws_region                = var.aws_region
  docker_image              = var.docker_image
  container_port            = var.container_port
  task_cpu                  = var.task_cpu
  task_memory               = var.task_memory
  desired_count             = var.desired_count
  log_retention_in_days     = var.log_retention_in_days
  enable_container_insights = var.enable_container_insights
  service_security_group_id = module.security.service_security_group_id
  subnet_ids                = module.network.public_subnet_ids
  target_group_arn          = module.alb.target_group_arn
  health_check_path         = var.health_check_path
  assign_public_ip          = var.assign_public_ip
  tags                      = local.common_tags

  depends_on = [module.alb]
}
