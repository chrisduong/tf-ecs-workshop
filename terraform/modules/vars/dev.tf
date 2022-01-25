locals {
  dev = {
    # ecs_desired_count                  = 1
    ecs_desired_count = 2
    # app_version       = "0.1.0"
    app_version = "0.1.1"
    # deployment_minimum_healthy_percent = 0 # we don't care if there's no running containers
    deployment_minimum_healthy_percent = 50 # here that we want to make sure there's always 50% capacity during the deployment
  }
}
