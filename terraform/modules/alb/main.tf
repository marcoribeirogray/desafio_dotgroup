locals {
  short_prefix = substr(var.name_prefix, 0, 20)
}

resource "aws_lb" "application_load_balancer" {
  name               = "${local.short_prefix}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]
  subnets            = var.subnet_ids

  tags = merge(
    var.tags,
    {
      Name        = "${var.name_prefix}-alb"
      Environment = var.environment
    }
  )
}

resource "aws_lb_target_group" "application_target_group" {
  name        = "${local.short_prefix}-tg"
  port        = var.container_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    enabled             = true
    interval            = 30
    matcher             = "200-399"
    path                = var.health_check_path
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = merge(
    var.tags,
    {
      Name        = "${var.name_prefix}-tg"
      Environment = var.environment
    }
  )
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.application_target_group.arn
  }
}

output "target_group_arn" {
  description = "ARN do Target Group"
  value       = aws_lb_target_group.application_target_group.arn
}

output "listener_arn" {
  description = "ARN do Listener HTTP"
  value       = aws_lb_listener.http_listener.arn
}

output "load_balancer_arn" {
  description = "ARN do Application Load Balancer"
  value       = aws_lb.application_load_balancer.arn
}

output "load_balancer_dns" {
  description = "Endpoint público do ALB"
  value       = aws_lb.application_load_balancer.dns_name
}
