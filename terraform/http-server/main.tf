resource "aws_cloudwatch_log_group" "http_server" {
  name              = "http_server"
  retention_in_days = 1
}

resource "aws_ecs_task_definition" "http_server" {
  family = "http_server"

  container_definitions = <<EOF
[
  {
    "name": "http_server",
    "image": "chrisduong/http-server:${var.app_version}",
    "cpu": 0,
    "memory": 128,
    portMappings = [
      {
        containerPort = 8080
      }
    ]
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
  name            = "http_server"
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.http_server.arn

  desired_count = 1

  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0
}
