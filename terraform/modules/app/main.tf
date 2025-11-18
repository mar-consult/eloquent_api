locals {
  health_check_timeout             = 10
  health_check_interval            = 30
  health_check_path                = "/health"
  health_check_healthy_threshold   = 2
  health_check_unhealthy_threshold = 5

  log_config_cloudwatch = {
    logDriver = "awslogs"

    options = {
      "awslogs-region"        = var.region
      "awslogs-group"         = aws_cloudwatch_log_group.ecs_log_group.name
      "awslogs-stream-prefix" = var.service_name
    }
  }

}

resource "aws_ecs_task_definition" "task" {
  family                   = var.service_name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.mem
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  container_definitions = jsonencode([{
    name      = var.service_name
    image     = var.ecr_url
    essential = true

    volumesFrom = [],
    portMappings = [
      {
        protocol      = "tcp",
        containerPort = var.service_port,
        hostPort      = var.service_port
      }
    ],
    dependsOn = [],
    logConfiguration = {
      logDriver = "awslogs"

      options = {
        "awslogs-region"        = var.region
        "awslogs-group"         = aws_cloudwatch_log_group.ecs_log_group.name
        "awslogs-stream-prefix" = var.service_name
      }
    }

  }])

  tags = {
    name = "${var.service_name}-task-definition"
  }
}

resource "aws_ecs_service" "service" {
  name            = var.service_name
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.task.arn
  launch_type     = "FARGATE"

  desired_count                      = var.replica_count
  deployment_minimum_healthy_percent = var.min_healthy_percent
  deployment_maximum_percent         = var.max_healthy_percent

  load_balancer {
    target_group_arn = aws_lb_target_group.eloquent.arn
    container_name   = var.service_name
    container_port   = var.service_port
  }

   service_registries {
    registry_arn   = aws_service_discovery_service.eloquent.arn
    container_name = var.service_name
  }

  network_configuration {
    security_groups  = [aws_security_group.sg_service.id]
    subnets          = var.private_subnet_ids
    assign_public_ip = false
  }

  lifecycle {
    ignore_changes = [task_definition]
  }

  tags = {
    name = "${var.service_name}-service"
  }
}
