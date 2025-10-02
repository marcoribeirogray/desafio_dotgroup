resource "aws_security_group" "alb_security_group" {
  name        = "${var.name_prefix}-alb-sg"
  description = "Acesso público ao ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allowed_ingress_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.egress_cidrs
  }

  tags = merge(
    var.tags,
    {
      Name        = "${var.name_prefix}-alb-sg"
      Environment = var.environment
    }
  )
}

resource "aws_security_group" "service_security_group" {
  name        = "${var.name_prefix}-svc-sg"
  description = "Tráfego do ALB para as tasks"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = var.container_port
    to_port         = var.container_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_security_group.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.egress_cidrs
  }

  tags = merge(
    var.tags,
    {
      Name        = "${var.name_prefix}-svc-sg"
      Environment = var.environment
    }
  )
}

output "alb_security_group_id" {
  description = "ID do Security Group do App load balancer "
  value       = aws_security_group.alb_security_group.id
}

output "service_security_group_id" {
  description = "ID do Security Group das tasks ECS"
  value       = aws_security_group.service_security_group.id
}
