locals {
  prod = {
    ecs_desired_count                  = 2
    app_version                        = "0.1.0"
    deployment_minimum_healthy_percent = 50
  }
}
