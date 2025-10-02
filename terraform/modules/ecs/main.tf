resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.name_prefix}-cluster"

  setting {
    name  = "containerInsights"
    value = var.enable_container_insights ? "enabled" : "disabled"
  }

  tags = merge(
    var.tags,
    {
      Name        = "${var.name_prefix}-cluster"
      Environment = var.environment
    }
  )
}

resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/${var.name_prefix}"
  retention_in_days = var.log_retention_in_days

  tags = merge(
    var.tags,
    {
      Name        = "${var.name_prefix}-logs"
      Environment = var.environment
    }
  )
}

data "aws_iam_policy_document" "ecs_task_execution" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "task_execution_role" {
  name               = "${var.name_prefix}-task-exec"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution.json

  tags = merge(
    var.tags,
    {
      Name        = "${var.name_prefix}-task-exec"
      Environment = var.environment
    }
  )
}

resource "aws_iam_role_policy_attachment" "task_execution_role_attachment" {
  role       = aws_iam_role.task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_task_definition" "task_definition" {
  family                   = "${var.name_prefix}-task"
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "app"
      image     = var.docker_image
      essential = true
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_log_group.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "app"
        }
      }
      environment = [
        {
          name  = "APP_ENVIRONMENT"
          value = var.environment
        }
      ]
      healthCheck = {
        command     = ["CMD-SHELL", "wget -q -O - http://localhost:${var.container_port}${var.health_check_path} > /dev/null 2>&1"]
        interval    = 30
        retries     = 3
        startPeriod = 10
        timeout     = 5
      }
    }
  ])
}

resource "aws_ecs_service" "ecs_service" {
  name            = "${var.name_prefix}-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    assign_public_ip = var.assign_public_ip
    security_groups  = [var.service_security_group_id]
    subnets          = var.subnet_ids
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "app"
    container_port   = var.container_port
  }

  lifecycle {
    ignore_changes = [desired_count]
  }

  tags = merge(
    var.tags,
    {
      Name        = "${var.name_prefix}-service"
      Environment = var.environment
    }
  )
}

output "cluster_name" {
  description = "Nome do cluster ECS"
  value       = aws_ecs_cluster.ecs_cluster.name
}

output "service_name" {
  description = "Nome do serviço ECS"
  value       = aws_ecs_service.ecs_service.name
}
