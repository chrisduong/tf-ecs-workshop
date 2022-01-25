resource "aws_cloudwatch_log_group" "http_server" {
  name              = "http_server"
  retention_in_days = 1
}

resource "aws_ecs_task_definition" "http_server" {
  family = "http_server"

  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  cpu    = 256
  memory = 512

  container_definitions = <<EOF
[
  {
    "name": "http_server",
    "image": "chrisduong/http-server:${var.app_version}",
    "portMappings": [
      {
        "containerPort": 8080
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-region": "eu-central-1",
        "awslogs-group": "http_server",
        "awslogs-stream-prefix": "complete-ecs"
      }
    }
  }
]
EOF
}

resource "aws_ecs_service" "http_server" {
  name                = "http_server"
  cluster             = var.cluster_id
  launch_type         = "FARGATE"
  scheduling_strategy = "REPLICA"

  task_definition = aws_ecs_task_definition.http_server.arn

  desired_count = var.desired_count

  deployment_maximum_percent         = var.deployment_maximum_percent # 100
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent

  network_configuration {
    subnets         = var.subnets
    security_groups = var.security_groups
  }

  load_balancer {
    container_name   = "http_server"
    container_port   = 8080
    target_group_arn = var.target_group_arn
  }

  # lifecycle {
  #   ignore_changes = [desired_count]
  # }

}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${terraform.workspace}-ecsTaskExecutionRole"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
